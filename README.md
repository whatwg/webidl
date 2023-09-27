This repository hosts the [Web IDL Standard](https://webidl.spec.whatwg.org/).

## Code of conduct

We are committed to providing a friendly, safe, and welcoming environment for all. Please read and respect the [Code of Conduct](https://whatwg.org/code-of-conduct).

## Contribution opportunities

Folks notice minor and larger issues with the Web IDL Standard all the time and we'd love your help fixing those. Pull requests for typographical and grammar errors are also most welcome.

Issues labeled ["good first issue"](https://github.com/whatwg/webidl/labels/good%20first%20issue) are a good place to get a taste for editing the Web IDL Standard. Note that we don't assign issues and there's no reason to ask for availability either, just provide a pull request.

If you are thinking of suggesting a new feature, read through the [FAQ](https://whatwg.org/faq) and [Working Mode](https://whatwg.org/working-mode) documents to get yourself familiarized with the process.

We'd be happy to help you with all of this [on Chat](https://whatwg.org/chat).

## Pull requests

In short, change `index.bs` and submit your patch, with a [good commit message](https://github.com/whatwg/meta/blob/main/COMMITTING.md).

Please add your name to the Acknowledgments section in your first pull request, even for trivial fixes. The names are sorted lexicographically.

To ensure your patch meets all the necessary requirements, please also see the [Contributor Guidelines](https://github.com/whatwg/meta/blob/main/CONTRIBUTING.md). Editors of the Web IDL Standard are expected to follow the [Maintainer Guidelines](https://github.com/whatwg/meta/blob/main/MAINTAINERS.md).

## Tests

Tests are an essential part of the standardization process and will need to be created or adjusted as changes to the standard are made. Tests for the Web IDL Standard can be found in the `webidl/` directory of [`web-platform-tests/wpt`](https://github.com/web-platform-tests/wpt).

A dashboard showing the tests running against browser engines can be seen at [wpt.fyi/results/webidl](https://wpt.fyi/results/webidl).

## Building "locally"

For quick local iteration, run `make`; this will use a web service to build the standard, so that you don't have to install anything. See more in the [Contributor Guidelines](https://github.com/whatwg/meta/blob/main/CONTRIBUTING.md#building).
