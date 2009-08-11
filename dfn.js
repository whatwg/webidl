/*
 * Taken from http://www.whatwg.org/specs/web-apps/current-work/dfn.js
 * as of Wed Dec 10 13:08:00 Australia/Melbourne 2008.
 *
 * With modifications to make it work with the Web IDL section structure.
 */

// dfn.js
// makes <dfn> elements link back to all uses of the term
// no copyright is asserted on this file

var dfnMapTarget = -1;
var dfnMapDone = 0;
var dfnMap = {};
document.addEventListener('DOMContentLoaded', function (event) {
  var links = [];
  dfnMapTarget = document.links.length;
  for (var i = 0; i < dfnMapTarget; i += 1)
    links[i] = document.links[i];
  var inc = 100;
  for (var i = 0; i < dfnMapTarget; i += inc) {
    setTimeout(function (j) {
      for (var k = j; k < j+inc && k < dfnMapTarget; k += 1) {
        if (links[k].href.indexOf('#') >= 0) {
          if (links[k].className != "no-backref" &&
              links[k].parentNode.className != "no-backref") {
            var s = links[k].href.substr(links[k].href.indexOf('#') + 1);
            if (!(s in dfnMap))
              dfnMap[s] = [];
            dfnMap[s].push(links[k]);
          }
        }
        dfnMapDone += 1;
      }
    }, 0, i);
  }
  document.body.className += " dfnEnabled";
}, false);

var dfnPanel;
var dfnUniqueId = 0;
var dfnTimeout;
document.addEventListener('click', dfnShow, false);
function dfnShow(event) {
  if (dfnTimeout) {
    clearTimeout(dfnTimeout);
    dfnTimeout = null;
  }
  if (dfnPanel) {
    dfnPanel.parentNode.removeChild(dfnPanel);
    dfnPanel = null;
  }
  if (dfnMapDone == dfnMapTarget) {
    var node = event.target;
    while (node && (node.nodeType != event.target.ELEMENT_NODE || node.tagName != "DFN"))
      node = node.parentNode;
    if (node) {
      var panel = document.createElement('div');
      panel.className = 'dfnPanel';
      if (node.id) {
        var permalinkP = document.createElement('p');
        var permalinkA = document.createElement('a');
        permalinkA.href = '#' + node.id;
        permalinkA.textContent = '#' + node.id;
        permalinkP.appendChild(permalinkA);
        panel.appendChild(permalinkP);
      }
      var p = document.createElement('p');
      panel.appendChild(p);
      if (node.id in dfnMap || node.parentNode.id in dfnMap) {
        p.textContent = 'Referenced in:';
        var ul = document.createElement('ul');
        var lastHeader;
        var lastLi;
        var n;
        var sourceLinks = [];
        if (node.id in dfnMap)
          for (var i = 0; i < dfnMap[node.id].length; i += 1)
            sourceLinks.push(dfnMap[node.id][i]);
        if (node.parentNode.id in dfnMap)
          for (var i = 0; i < dfnMap[node.parentNode.id].length; i += 1)
            sourceLinks.push(dfnMap[node.parentNode.id][i]);
        for (var i = 0; i < sourceLinks.length; i += 1) {
          var link = sourceLinks[i];
          var header = dfnGetCaption(link);
          var a = document.createElement('a');
          if (!link.id)
            link.id = 'dfnReturnLink-' + dfnUniqueId++;
          a.href = '#' + link.id;
          if (header != lastHeader) {
            lastHeader = header;
            n = 1;
            var li = document.createElement('li');
            var cloneHeader = header.cloneNode(true);
            while (cloneHeader.hasChildNodes())
              if (cloneHeader.firstChild.className == 'section-link')
                cloneHeader.removeChild(cloneHeader.firstChild);
              else
                a.appendChild(cloneHeader.firstChild);
            lastLi = li;
            li.appendChild(a);
            ul.appendChild(li);
          } else {
            n += 1;
            a.appendChild(document.createTextNode('(' + n + ')'));
            lastLi.appendChild(document.createTextNode(' '));
            lastLi.appendChild(a);
          }
        }
        panel.appendChild(ul);
      } else {
        p.textContent = 'No references in this file.';
      }
      node.appendChild(panel);
      dfnPanel = panel;
    }
  } else {
    dfnTimeout = setTimeout(dfnShow, 250, event);
  }
}

function dfnGetCaption(link) {
  var node = link;
  while (node && !(node.parentNode.tagName == "DIV" && node.parentNode.className == "section"))
    node = node.parentNode;
  while (node && (node.nodeType != node.ELEMENT_NODE || !node.tagName.match(/^H[1-6]$/)))
    node = node.previousSibling;
  return node;
}
