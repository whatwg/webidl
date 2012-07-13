/* Testable assertions spec companion */

(function () {

    // Open a communication channel with a host that want to track and display testable
    // assertions and other relevant testing information

    // Definitions: 
    // * Host - the tool that provides the list of testable assertions
    // * Spec - the specification being tested
    
    // Expectation:
    // 1. This script is executed in the context of the Spec being tested
    // 2. This script sets up a message handler and responds to postMessage events
    //    using a specific contract.

    // Contract:
    // INIT____________________________________________
    // [in] message event to the Spec, with the following data format:
    // { message: "init", data: [ { assertId: "1", selector: "selector string" } ] }
    // The data payload is an array of assertions, where each assertion has an id (assertId)
    // and a selector string. The assertId is a string and has meaning only to the Host and must be unique.
    // (If the assertId is not unique, then initialization fails.)
    // The selector string is a selector or group of selectors used to identify the location(s)
    // in the Spec that the testable assertion relates to.
    // This message must be sent prior to any other message (or any other message sent will be
    // ignored).

    // [out] message event to the Host with the following data format:
    // { message: "initialized", data: { matched: ["1"], unmatched: ["1"] } }
    // The data payload contains two lists of strings, the matched and unmatched assertions. 
    // The contents of the lists will be strings that correspond to the assertId's provided as input.
    // If a selector for a given assertId matched at least one element in the Spec, then it will be
    // included in the list of matched assertIds, otherwise, it will be contained in the unmatched list.

    // SHOW____________________________________________
    // [in] message event to the Spec with the following data format:
    // { message: "show", data: "1" }
    // The data must be an assertId matching a previously provided (via INIT) assertId. If the assertId
    // is not recognized, this message is ignored.
    // If the assertId _is_ recognized, then the first occurance of an element that matches the selector
    // associated with that assertId is scrolled into view. If "show" is sent again, the next matching element 
    // is shown and so on. When the last element matching an assertion was previously scrolled into view and
    // "show" is called again, then the first item in the list is scrolled into view (the list wraps around).

    // [out] none

    // NOTIFY_________________________________________
    // [in] message event to the Spec with the following data format:
    // { message: "notify" }
    // This message event is a request to notify the Host whenever testable assertions are in view. This will
    // be an asynchronous notification (after the view of the spec has changed such that a matching testable
    // assertion is in view) that is sent after the view of the Spec has stabalized (e.g., the Host is not
    // notified until ongoing changes to the view of the spec have stopped).

    // [out] message event to the Host with the following data format:
    // { message: "asserts-in-view", data: [ { assertId: "1", clientTop: 1, clientBottom: 1 } ] }
    // The data payload contains an array of assertions that are now in view. All previously notified 
    // assertions will no longer be in view. Each assertion is identified by its assertId, and by a pair
    // of vertical coordinates (in client/viewport coordinate space) representing the top and bottom of the 
    // bounding box of the assertion in view. Assertions may overlap in their client bounds. If a particular
    // assertId matched multiple elements, the same assertId could be reported in the list multiple times
    // (with different client coordinates)

    // IDENTIFY________________________________________
    // [in] message event to the Spec with the following data format:
    // { message: "identify" }
    // Adds mouse handlers and click handlers (in the capture phase) to allow a user to visualize and select an 
    // element to use as an assertion. Once an element is selected, "identify mode" is disabled and an appropriate
    // selector is returned. The Esc key can also be used to cancel "identify mode"

    // [out] none OR message event to the Host with the following data format:
    // { message: "assert", data: "selector string" }
    // The data payload is a selector string that identifies the user's chosen element. Id's are preferred, but 
    // a precise selector path leading back to the root or an element with an Id may be returned given the chosen
    // element.

    var initialized = false;
    var notifying = false;
    var identifying = false;
    
    var postToHost = null;
    var origin = null;

    window.addEventListener("message", ie9CompatMessageDecoder);
    window.addEventListener("unload", function () {
        // Don't accept any new incoming messages (work around an IE-particular).
        window.removeEventListener("message", ie9CompatMessageDecoder);
    });

    // IE9 can't sent complex objects (structured clone algorithm) through postMessage. Works in IE10
    function ie9CompatMessageDecoder(messageString) {
        messageString.data2 = JSON.parse(messageString.data);
        handleMessageData(messageString);
    }
    function ie9CompatMessageEncoder(messageObject) {
        postToHost(JSON.stringify(messageObject), origin);
    }

    function handleMessageData(messageEvent) {
        var d = messageEvent.data2;
        if (validObject(d)) {
            if ((d.message == "init") && !initialized)
                handleInitialize(d.data, messageEvent.origin, messageEvent.source); // Set the "initialized" flag to true only after this is truely initialized -- otherwise early failures won't allow you to try initializing again.
            else if ((d.message == "show") && initialized) {
                if (identifying)
                    handleIdentifyModeEnd(); // Cancel identify mode.
                handleShow(d.data);
            }
            else if ((d.message == "notify") && initialized && !notifying) {
                handleNotifyStart();
                notifying = true; // Only need to process this once. (There is no "un-notify" feature, as this is likely not needed in practice.)
            }
            else if ((d.message == "identify") && initialized && !identifying)
                handleIdentifyModeStart();
        }
        // else ignore the message
    }

    // ------------------- Fast Assert management --------------------
    function Asserts() {
        this.assertIdIndex = {};
        // Assumption is that some asserts can overlap (for example spans on multiple lines)
        this.topSortedPosition = []; // Used for quickly finding the asserts whose top-portion is visible in the current viewport
        this.bottomSortedPosition = []; // Used for quicly finding the asserts whose bottom portion is visible in the current viewport
    }
    // Returns false if the id is already in use (a duplicate), otherwise returns true.
    Asserts.prototype.add = function (id, elementList) {
        if (typeof this.assertIdIndex[id] != "undefined")
            return false;
        this.assertIdIndex[id] = { elements: elementList, showIndex: 0 }; // Each index holds the list of matching elements and a show sequence
        // Index each element's top/bottom location relative to the origin of the page
        for (var i = 0, len = elementList.length; i < len; i++) {
            var element = elementList[i];
            var clientRect = element.getBoundingClientRect();
            // Algorithm...
            // Search the top list, mark the found items as found when they're in the viewport
            // Search the bottom list, collect the found items that were not already found in the top list
            var topItem = { top: (clientRect.top + window.pageYOffset), seen: false, assertId: id, bottom: (clientRect.bottom + window.pageYOffset) };
            this.topSortedPosition.push(topItem);
            this.bottomSortedPosition.push({ bottom: (clientRect.bottom + window.pageYOffset), relatedTopItem: topItem, assertId: id, top: (clientRect.top + window.pageYOffset) });
        }
        return true;
    }
    // I'm not going to add any more items. Finalize the data structures and mark them as ready.
    Asserts.prototype.finalize = function () {
        this.topSortedPosition.sort(function (x, y) { return x.top - y.top });
        this.bottomSortedPosition.sort(function (x, y) { return x.bottom - y.bottom });
        this.ready = true;
    }
    // top, and bottom should be in document (not current viewport) coordinates
    // This algorithm is 2log(n) + 2x, where n is the sum of all assertion selector matches in this document and x is a linear search to collect stragglers around the item located in the log(n) search.
    Asserts.prototype.findAssertsInViewportRange = function(top, bottom) {
        var allmatches = [];
        var topMatches = []; // These have temporary state that must be cleared...
        // Creates objects of the form: { assertId: "1", clientTop: 1, clientBottom: 1 }
        var AssertResult = function (id, t, b) { this.assertId = id; this.clientTop = t; this.clientBottom = b; }
        if (this.topSortedPosition.length > 0) { // The bottom sorted list is going to be the same length, so this check represents both.
            var item = null;
            var searchIndex = 0;
            var maxLength = this.topSortedPosition.length;
            // Conveniently creates a closure around the "top" parameter...
            var matchingIndex = binarySearch(this.topSortedPosition, function (item) { if ((item.top >= top) && (item.top <= bottom)) return 0; /* Found it.*/ else if (item.top < top) return 1; /* Need to search _after_ this item for matches*/ else return -1; }, 0);
            if (matchingIndex != null) {
                item = this.topSortedPosition[matchingIndex];
                item.seen = true; // Mark this as seen.
                topMatches.push(item);
                allmatches.push(new AssertResult(item.assertId, item.top, item.bottom));
                // Linear search up/down until all items that match are collected
                searchIndex = matchingIndex - 1; // Prepare for backward search...
                if (searchIndex >= 0) {
                    item = this.topSortedPosition[searchIndex];
                    while ((item.top >= top) && (searchIndex >= 0)) {
                        topMatches.push(item);
                        allmatches.push(new AssertResult(item.assertId, item.top, item.bottom));
                        item.seen = true;
                        item = this.topSortedPosition[--searchIndex];
                    }
                }
                searchIndex = matchingIndex + 1; // Prepare for the forward search...
                if (searchIndex < maxLength) {
                    item = this.topSortedPosition[searchIndex];
                    while ((item.top <= bottom) && (searchIndex < maxLength)) {
                        topMatches.push(item);
                        allmatches.push(new AssertResult(item.assertId, item.top, item.bottom));
                        item.seen = true;
                        item = this.topSortedPosition[++searchIndex];
                    }
                }
            }
            // Now look at the bottom-sorted list
            matchingIndex = binarySearch(this.bottomSortedPosition, function (item) { if ((item.bottom >= top) && (item.bottom <= bottom)) return 0; else if (item.bottom < top) return 1; else return -1; }, 0);
            if (matchingIndex != null) {
                item = this.bottomSortedPosition[matchingIndex];
                if (!item.relatedTopItem.seen)
                    allmatches.push(new AssertResult(item.assertId, item.top, item.bottom));
                // Linear search up/down until all items that match are collected
                searchIndex = matchingIndex - 1; // Prepare for backward search...
                if (searchIndex >= 0) {
                    item = this.bottomSortedPosition[searchIndex];
                    while ((item.bottom >= top) && (searchIndex >= 0)) {
                        if (!item.relatedTopItem.seen)
                            allmatches.push(new AssertResult(item.assertId, item.top, item.bottom));
                        item = this.bottomSortedPosition[--searchIndex];
                    }
                }
                searchIndex = matchingIndex + 1; // Prepare for the forward search...
                if (searchIndex < maxLength) {
                    item = this.bottomSortedPosition[searchIndex];
                    while ((item.bottom <= bottom) && (searchIndex < maxLength)) {
                        if (!item.relatedTopItem.seen)
                            allmatches.push(new AssertResult(item.assertId, item.top, item.bottom));
                        item = this.bottomSortedPosition[++searchIndex];
                    }
                }
            }
            // Cleanup the topMatches list for the next query...
            for (var i = 0, len = topMatches.length; i < len; i++)
                topMatches[i].seen = false;
        }
        return allmatches;
    }
    // matchCriteriaCallback is provided with an item. If the item matches the search criteria, return 0.
    // If the search should keep looking _before_ the item, return < 0.
    // If the search should keep looking _after_ the item, return > 0.
    // binary search returns null if the search criteria cannot find the item, or the index into the array for the found item otherwise.
    function binarySearch(array, matchCriteriaCallback, offsetIndex) {
        var midPointIndex = Math.floor(array.length / 2.001); // The extra precision forces the midpoint of an array of length 2 to be the 0th index (rather than the 1st index), which makes the final else case below work in all cases.
        var result = matchCriteriaCallback(array[midPointIndex]);
        if (result == 0) // Found it.
            return offsetIndex + midPointIndex;
        else if (array.length == 1) // This was the last item to search and it didn't match the criteria...
            return null;
        else if (result < 0) // There's at least 2 items in the array... look at the items before/after to check them.
            return binarySearch(array.slice(0, midPointIndex), matchCriteriaCallback, offsetIndex); // Same offset index...
        else // result > 0
            return binarySearch(array.slice(midPointIndex + 1, array.length), matchCriteriaCallback, offsetIndex + midPointIndex + 1);
    }

    var asserts = new Asserts();

    function handleInitialize(data, originStr, postBackObj) {
        // Expecting: [ { assertId: 1, selector: "selector string" } ] }
        if (!Array.isArray(data))
            return;
        var nonMatchingAsserts = [];
        var matchingAsserts = [];
        // Validate the input (its OK to pass an empty array)
        for (var i = 0, len = data.length; i < len; i++) {
            var assertOb = data[i];
            if (!validObject(assertOb)) {
                asserts = new Asserts(); // Clear this before bailing... (the local nonMatchingAsserts will collected automatically)
                return;
            }
            if (typeof assertOb.assertId != "string") {
                asserts = new Asserts();
                return;
            }
            if (typeof assertOb.selector != "string") {
                asserts = new Asserts();
                return;
            }
            // See if the selector matches anything...
            var matches = document.querySelectorAll(assertOb.selector);
            if (matches.length == 0)
                nonMatchingAsserts.push(assertOb.assertId);
            else {
                if (!asserts.add(assertOb.assertId, matches)) { // May return false on duplicate assertId.
                    asserts = new Asserts();
                    return;
                }
                matchingAsserts.push(assertOb.assertId);
            }
        }
        initialized = true;
        asserts.finalize();
        postToHost = postBackObj.postMessage.bind(postBackObj);
        origin = originStr;
        ie9CompatMessageEncoder({ message: "initialized", data: { matched: matchingAsserts, unmatched: nonMatchingAsserts } });
    }


    function handleShow(data) {
        if (typeof data != "string")
            return;
        if (typeof asserts.assertIdIndex[data] == "undefined") // Unrecognized assert id.
            return;
        var assertOb = asserts.assertIdIndex[data];
        assertOb.elements[assertOb.showIndex].scrollIntoView();
        assertOb.showIndex++;
        // Roll it over in anticipation of the next show.
        if (assertOb.showIndex == assertOb.elements.length)
            assertOb.showIndex = 0; 
    }

    function handleNotifyStart() {
        // Register for scroll events, but don't take action until scrolling has come to rest (0.5 seconds from the last scroll event)
        document.addEventListener("scroll", scrollHappened, true);
        // Trigger the first event
        scrollHappened();
    }

    var delayNotifyTimer = null;
    // scroll event handler
    function scrollHappened(e) {
        clearTimeout(delayNotifyTimer);
        delayNotifyTimer = setTimeout(doNotify, 500);
    }

    function doNotify() {
        // { message: "asserts-in-view", data: [ { assertId: "1", clientTop: 1, clientBottom: 1 } ] }
        ie9CompatMessageEncoder({ message: "asserts-in-view", data: asserts.findAssertsInViewportRange(pageYOffset, pageYOffset + innerHeight) });
    }

    function handleIdentifyModeStart() {
        identifying = true;
        // Add the event handlers...
        window.addEventListener('mousemove', highlightElementViaMouseMove, true);
        window.addEventListener('mouseover', highlightElementViaMouseOver, true);
        window.addEventListener('click', captureElementViaClick, true);
    }

    function handleIdentifyModeEnd() {
        // Remove the event handlers...
        window.removeEventListener('mousemove', highlightElementViaMouseMove, true);
        window.removeEventListener('mouseover', highlightElementViaMouseOver, true);
        window.removeEventListener('click', captureElementViaClick, true);
        if (highlightElementCache != null) {
            unhighlightElement(highlightElementCache);
            highlightElementCache = null; // Clear the cached element.
        }
        identifying = false;
    }

    var highlightElementCache = null;
    var highlightElementPriorStyleText = "";

    // The pattern here is an unhighlight followed by a highlight.
    // Cleanup should assume that there's an element highlighted in 
    // the cache and clear it.
    function highlightElementViaMouseMove(e) {
        if (e.target === highlightElementCache)
            return; // Fast return if this is a duplicate event
        highlightElementViaMouseOver(e);
    }
    function highlightElementViaMouseOver(e) {
        if (highlightElementCache != null)
            unhighlightElement(highlightElementCache);
        highlightElement(e.target);
    }
    function highlightElement(element) {
        highlightElementCache = element; // Save this for later un-doing...
        highlightElementPriorStyleText = element.getAttribute('style'); // Safe the serialized style text...
        // Set the attribute with the highlight style...
        element.setAttribute('style', "background-color:yellow;outline:2px solid red;box-shadow:2px 2px 2px yellow;transition:background-color ease 0.25s,box-shadow ease 0.25s");
    }
    function unhighlightElement(element) {
        if (highlightElementPriorStyleText == null)
            element.removeAttribute('style');
        else
            element.setAttribute('style', highlightElementPriorStyleText);
    }
    function captureElementViaClick(e) {
        // Take the last element in the cache (if there is one)
        if (highlightElementCache != null) {
            // Package this one...
            ie9CompatMessageEncoder({ message: "assert", data: getSelectorStringFromElement(highlightElementCache, "") });
        }
        // Stop identifying mode...
        handleIdentifyModeEnd();
        // Don't propagate this event (e.g., if the user clicked on a link to select an element, we don't want to navigate)
        e.preventDefault();
        e.stopPropagation();
    }

    function validObject(x) {
        return ((typeof x == "object") && (x != null));
    }

    // Finds the first element with an ID and a unique path to the target element.
    function getSelectorStringFromElement(elem, postSelectorString) {
        if (elem.getAttribute('id') != null) {
            // We've found a suitable unique path
            return "#" + elem.id + postSelectorString;
        }
        else if (elem === document.documentElement) {
            // This is the root element...
            return document.documentElement.localName + postSelectorString;
        }
        else { // This element has no id...
            // Find its position in its parent child list...
            var childCount = 0;
            var me = elem;
            do {
                me = me.previousElementSibling;
                childCount++;
            } while (me != null);
            return getSelectorStringFromElement(elem.parentNode, " > " + elem.localName + ":nth-child(" + childCount + ")" + postSelectorString);
        }
    }
})();