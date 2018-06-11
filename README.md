Web IDL
=======

This is the primary repository in which the Web IDL specification is developed.

* [Latest Editor’s Draft](http://heycam.github.io/webidl/)

## Contributing

Good first bugs are marked as [short and easy](https://github.com/heycam/webidl/issues?utf8=%E2%9C%93&q=is%3Aopen+label%3A%22%E2%8C%9B+duration:short%22+label%3A%22%E2%98%95+difficulty:easy%22).

## Markup

The specification is written in [Bikeshed](https://github.com/tabatkins/bikeshed), plus the [Ecmarkup tags](https://bterlson.github.io/ecmarkup/) `<emu-val>`, `<emu-t>`, and `<emu-nt>`. 

## Filing issues elsewhere

### Breaking changes should be filed against:

*   Rendering engines
    *   [Gecko](https://bugzilla.mozilla.org/enter_bug.cgi?product=Core&component=DOM&cc=bzbarsky@mit.edu)
    *   [WebKit](https://bugs.webkit.org/enter_bug.cgi?product=WebKit&component=Bindings&short_desc=[WebIDL]%20)
    *   [Chromium](https://bugs.chromium.org/p/chromium/issues/entry?template=Defect%20report%20from%20developer&components=Blink%3EBindings&summary=[WebIDL]%20&comment&labels=Via-WebIDLRepo)
    *   [Edge](https://developer.microsoft.com/en-us/microsoft-edge/platform/issues/)
*   [web-platform-tests](https://github.com/web-platform-tests/wpt/issues/new?title=%5BWebIDL%5D%20)
*   [idlharness.js](https://github.com/web-platform-tests/wpt/issues/new?title=%5Bidlharness%5D%20) (used by testharness.js to run idl tests)

### Syntax changes should be filed against the following parsers:

*   [widlparser](https://github.com/plinss/widlparser/issues/new) (used by Bikeshed)
*   [WebIDL parser](https://github.com/w3c/webidl2.js/issues/new) (used by idlharness.js)
*   [TypeScript and JavaScript lib generator](https://github.com/Microsoft/TSJS-lib-generator/)

