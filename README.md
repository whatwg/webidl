# Web IDL

This is the repository where the [Web IDL](http://heycam.github.io/webidl/) specification is developed.

## Contributing

Good first issues are labeled as a [short good first issue](https://github.com/heycam/webidl/issues?q=is%3Aopen+label%3A%22%E2%8C%9B+duration%3Ashort%22+label%3A%22good+first+issue%22).

IDL generally follows the [WHATWG Contributor Guidelines](https://github.com/whatwg/meta/blob/master/CONTRIBUTING.md) and [WHATWG Committer Guidelines](https://github.com/whatwg/meta/blob/master/COMMITTING.md), except as otherwise noted.

## Markup

The specification is written in [Bikeshed](https://github.com/tabatkins/bikeshed), plus the [Ecmarkup tags](https://tc39.es/ecmarkup/) `<emu-val>`, `<emu-t>`, and `<emu-nt>`.

## Filing issues elsewhere

### Breaking changes should be filed against:

*   Rendering engines
    *   [Gecko](https://bugzilla.mozilla.org/enter_bug.cgi?product=Core&component=DOM&cc=bzbarsky@mit.edu)
    *   [WebKit](https://bugs.webkit.org/enter_bug.cgi?product=WebKit&component=Bindings&short_desc=[WebIDL]%20)
    *   [Chromium](https://bugs.chromium.org/p/chromium/issues/entry?template=Defect%20report%20from%20developer&components=Blink%3EBindings&summary=[WebIDL]%20&comment&labels=Via-WebIDLRepo)
*   [web-platform-tests](https://github.com/web-platform-tests/wpt/issues/new?title=%5BWebIDL%5D%20)
*   [idlharness.js](https://github.com/web-platform-tests/wpt/issues/new?title=%5Bidlharness%5D%20) (used by testharness.js to run IDL tests)
*   [Reffy](https://github.com/tidoust/reffy) (scrapes IDL from specs for [reffy-reports](https://github.com/tidoust/reffy-reports) and web-platform-tests)

### Syntax changes should be filed against the following parsers:

*   [widlparser](https://github.com/plinss/widlparser/issues/new) (used by Bikeshed)
*   [WebIDL parser](https://github.com/w3c/webidl2.js/issues/new) (used by idlharness.js)
*   [TypeScript and JavaScript lib generator](https://github.com/Microsoft/TSJS-lib-generator/)
