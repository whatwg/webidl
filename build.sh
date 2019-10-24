#!/bin/bash
set -e # Exit with nonzero exit code if anything fails
set -x # Turn on logging

mkdir out
curl https://api.csswg.org/bikeshed/ -f -F file=@index.bs > out/index.html
node ./check-grammar.js ./out/index.html
npm run pp-webidl -- --input ./out/index.html
