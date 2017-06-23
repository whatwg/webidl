Web IDL
=======

This is the primary repository in which the Web IDL specification is developed.

* [Latest Editor’s Draft](http://heycam.github.io/webidl/)

## Contributing

In our issues, we use the following labels: 

 * ☕ — not too hard
 * ☕☕ — hard
 * ☕☕☕ — excruciating

 * ⌛ — should be short to fix
 * ⌛⌛ — shouldn't be too long
 * ⌛⌛⌛ — there goes your week-end

Thus, good first bugs are [short and sweet](https://github.com/heycam/webidl/issues?utf8=✓&q=is%3Aissue%20is%3Aopen%20label%3A⌛%20%20label%3A☕).

## Markup

The specification is written in [Bikeshed](https://github.com/tabatkins/bikeshed), plus the [Ecmarkup tags](https://bterlson.github.io/ecmarkup/) `<emu-val>`, `<emu-t>`, and `<emu-nt>`. 

## Filing issues elsewhere

### Breaking changes should be filed against:

*   Rendering engines
    *   [Gecko](https://bugzilla.mozilla.org/enter_bug.cgi?product=Core&component=DOM&cc=bzbarsky@mit.edu)
    *   [WebKit](https://bugs.webkit.org/enter_bug.cgi?product=WebKit&component=Bindings&short_desc=[WebIDL]%20)
    *   [Chromium](https://crbug.com)
    *   [Edge](https://developer.microsoft.com/en-us/microsoft-edge/platform/issues/)
*   [web-platform-tests](https://github.com/w3c/web-platform-tests/issues/new)
*   [idlharness.js](https://github.com/w3c/testharness.js/issues/new?title=%5Bidlharness%5D%20) (used by testharness.js to run idl tests)

### Syntax changes should be filed against the following parsers:

*   [widlparser](https://github.com/plinss/widlparser/issues/new) (used by Bikeshed)
*   [WebIDL parser](https://github.com/w3c/webidl2.js/issues/new) (used by idlharness.js)
