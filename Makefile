bs_installed  := $(shell command -v bikeshed 2> /dev/null)
npm_installed := $(shell command -v npm 2> /dev/null)
pp_webidl_installed := $(shell npm ls webidl-grammar-post-processor --parseable --depth=0 2> /dev/null)

all : index.html

index.html : index.bs
ifdef bs_installed
	bikeshed spec index.bs
else
	@echo Can\'t find a local version of Bikeshed. To install it, visit:
	@echo
	@echo https://github.com/tabatkins/bikeshed/blob/master/docs/install.md
	@echo
	@echo Trying to build the spec using the online API at: https://api.csswg.org/bikeshed/
	@echo This will fail if you are not connected to the network.
	curl https://api.csswg.org/bikeshed/ -F file=@index.bs > index.html
endif
ifdef pp_webidl_installed
	npm run pp-webidl -- --input index.html
else ifdef npm_installed
	npm install
	npm run pp-webidl -- --input index.html
else
	@echo You need node.js and npm to apply post-processing. To install it, visit:
	@echo
	@echo https://nodejs.org/en/download/
	@echo
	@echo Until then, post-processing will be done dynamically, in JS, on page load.
endif

clean :
	rm -f index.html

.PHONY : all clean
