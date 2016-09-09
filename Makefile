bs := $(shell command -v bikeshed 2> /dev/null)

all : index.html

index.html : index.bs
ifdef bs
	bikeshed spec index.bs
else
	@echo Cannot find a local version of Bikeshed. To install it, visit:
	@echo
	@echo https://github.com/tabatkins/bikeshed/blob/master/docs/install.md
	@echo
	@echo Trying to build the spec using the online API at: https://api.csswg.org/bikeshed/
	@echo This will fail if you are not connected to the network.
	curl https://api.csswg.org/bikeshed/ -F file=@index.bs > index.html
endif

clean :
	rm -f index.html

.PHONY : all clean
