all : Overview.html v1.html java.html

Overview.html : Overview.xml WebIDL.xsl
	xsltproc --nodtdattr --param now `date +%Y%m%d` WebIDL.xsl Overview.xml >Overview.html

v1.html : v1.xml WebIDL.xsl
	xsltproc --nodtdattr --param now `date +%Y%m%d` WebIDL.xsl v1.xml >v1.html

Overview.ids : Overview.xml
	./xref.pl -d Overview.xml http://dev.w3.org/2006/webapi/WebIDL/ > Overview.ids

java.html : java.xml WebIDL.xsl Overview.ids
	xsltproc --nodtdattr --param now `date +%Y%m%d` WebIDL.xsl java.xml | ./xref.pl -t - Overview.ids > java.html

clean :
	rm -f Overview.html v1.html java.html Overview.ids

.PHONY : all clean
