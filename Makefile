all : index.html v1.html

index.html : index.xml WebIDL.xsl
	xsltproc --nodtdattr --param now `date +%Y%m%d` WebIDL.xsl index.xml >index.html

v1.html : v1.xml WebIDL.xsl
	xsltproc --nodtdattr --param now `date +%Y%m%d` WebIDL.xsl v1.xml >v1.html

index.ids : index.xml
	./xref.pl -d index.xml http://heycam.github.io/webidl/ > index.ids

java.html : java.xml WebIDL.xsl index.ids
	xsltproc --nodtdattr --param now `date +%Y%m%d` WebIDL.xsl java.xml | ./xref.pl -t - index.ids > java.html

clean :
	rm -f index.html v1.html java.html index.ids

.PHONY : all clean
