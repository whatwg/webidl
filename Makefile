SHELL=/bin/bash -o pipefail
.PHONY: ci clean

bs_installed  := $(shell command -v bikeshed 2> /dev/null)
node_installed := $(shell command -v node 2> /dev/null)
npm_installed := $(shell command -v npm 2> /dev/null)
pp_webidl_installed := $(shell npm ls webidl-grammar-post-processor --parseable --depth=0 2> /dev/null)

index.html: index.bs
ifdef bs_installed
	bikeshed spec --die-on=warning index.bs
else
ifndef CI
	@echo Can\'t find a local version of Bikeshed. To install it, visit:
	@echo
	@echo https://tabatkins.github.io/bikeshed/#installing
	@echo
	@echo Trying to build the spec using the online API at: https://api.csswg.org/bikeshed/
	@echo This will fail if you are not connected to the network.
	@echo
endif
	@ (HTTP_STATUS=$$(curl https://api.csswg.org/bikeshed/ \
	                       --output index.html \
	                       --write-out "%{http_code}" \
	                       --header "Accept: text/plain, text/html" \
	                       -F die-on=warning \
	                       -F file=@index.bs) && \
	[[ "$$HTTP_STATUS" -eq "200" ]]) || ( \
		echo ""; cat index.html; echo ""; \
		rm -f index.html; \
		exit 22 \
	);
endif
ifdef node_installed
	node ./check-grammar.js index.html
else ifdef CI
	exit 1
else
	@echo You need node for grammer checking.
endif
ifdef pp_webidl_installed
	npm run pp-webidl -- --input index.html
else ifdef npm_installed
	npm install
	npm run pp-webidl -- --input index.html
else ifdef CI
	exit 1
else
	@echo You need node.js and npm to apply post-processing. To install it, visit:
	@echo
	@echo https://nodejs.org/en/download/
	@echo
	@echo Until then, post-processing will be done dynamically, in JS, on page load.
endif

ci:
	mkdir -p out
	make index.html
	mv index.html out/index.html

clean:
	rm -f index.html
