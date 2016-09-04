all : index.html

index.html : index.bs
	bikeshed spec index.bs

clean :
	rm -f index.html

.PHONY : all clean
