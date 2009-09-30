<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:h='http://www.w3.org/1999/xhtml'
                xmlns:x='http://mcc.id.au/ns/local'
                xmlns='http://www.w3.org/1999/xhtml'
                exclude-result-prefixes='h x'
                version='1.0' id='xslt'>

  <xsl:output method='xml' encoding='UTF-8'
              omit-xml-declaration='yes'
              doctype-public='-//W3C//DTD XHTML 1.0 Transitional//EN'
              doctype-system='http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'
              media-type='application/xhtml+xml; charset=UTF-8'/>

  <xsl:variable name='options' select='/*/h:head/x:options'/>
  <xsl:variable name='id' select='/*/h:head/h:meta[@name="revision"]/@content'/>
  <xsl:variable name='rev' select='substring-before(substring-after(substring-after($id, " "), " "), " ")'/>
  <xsl:variable name='tocpi' select='//processing-instruction("toc")[1]'/>

  <xsl:template match='/'>
    <xsl:text>&#xa;</xsl:text>
    <xsl:if test='$options/x:maturity="ED"'>
      <xsl:comment>
  Overview.html
  Web IDL

  Note: This file is generated from Overview.xml.  Run "make" to regenerate it.
  </xsl:comment>
      <xsl:text>&#xa;</xsl:text>
    </xsl:if>
    <xsl:apply-templates select='/*'/>
  </xsl:template>

  <xsl:template match='h:*'>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:copy-of select='@*[namespace-uri()="" or namespace-uri="http://www.w3.org/XML/1998/namespace"]'/>
      <xsl:apply-templates select='node()'/>
    </xsl:element>
  </xsl:template>

  <xsl:template match='h:head'>
    <head>
      <xsl:copy-of select='@*[namespace-uri()="" or namespace-uri="http://www.w3.org/XML/1998/namespace"]'/>
      <xsl:apply-templates select='node()'/>
      <xsl:choose>
        <xsl:when test='$options/x:maturity="FPWD" or $options/x:maturity="LCWD" or $options/x:maturity="FPWDLC"'>
          <link rel='stylesheet' href='http://www.w3.org/StyleSheets/TR/W3C-WD' type='text/css'/>
        </xsl:when>
        <xsl:otherwise>
          <link rel='stylesheet' href='http://www.w3.org/StyleSheets/TR/W3C-{$options/x:maturity}' type='text/css'/>
        </xsl:otherwise>
      </xsl:choose>
    </head>
  </xsl:template>

  <xsl:template match='h:span[@class="idltype"]'>
    <xsl:variable name='id' select='concat("idl-", translate(., " ", "-"))'/>
    <xsl:variable name='def' select='//*[@id=$id]'/>
    <xsl:choose>
      <xsl:when test='not(ancestor::h:a) and $def'>
        <a class='idltype' href='#{$id}'><xsl:apply-templates select='node()'/></a>
      </xsl:when>
      <xsl:otherwise>
        <span>
          <xsl:copy-of select='@*[namespace-uri()="" or namespace-uri="http://www.w3.org/XML/1998/namespace"]'/>
          <xsl:apply-templates select='node()'/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name='monthName'>
    <xsl:param name='n' select='1'/>
    <xsl:param name='s' select='"January February March April May June July August September October November December "'/>
    <xsl:choose>
      <xsl:when test='string(number($n))="NaN"'>@@</xsl:when>
      <xsl:when test='$n = 1'>
        <xsl:value-of select='substring-before($s, " ")'/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name='monthName'>
          <xsl:with-param name='n' select='$n - 1'/>
          <xsl:with-param name='s' select='substring-after($s, " ")'/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='processing-instruction("top")'>
    <div class='head'>
      <div><a href="http://www.w3.org/"><img src="http://www.w3.org/Icons/w3c_home" width="72" height="48" alt="W3C"></img></a></div>
      <h1><xsl:value-of select='/*/h:head/h:title'/></h1>
      <h2>
        <xsl:text>W3C </xsl:text>
        <xsl:choose>
          <xsl:when test='$options/x:maturity="WD" or $options/x:maturity="FPWD" or $options/x:maturity="LCWD" or $options/x:maturity="FPWDLC"'>Working Draft</xsl:when>
          <xsl:when test='$options/x:maturity="CR"'>Candidate Recommendation</xsl:when>
          <xsl:when test='$options/x:maturity="PR"'>Proposed Recommendation</xsl:when>
          <xsl:when test='$options/x:maturity="PER"'>Proposed Edited Recommendation</xsl:when>
          <xsl:when test='$options/x:maturity="REC"'>Recommendation</xsl:when>
          <xsl:when test='$options/x:maturity="WG-NOTE"'>Working Group Note</xsl:when>
          <xsl:otherwise>Editor’s Draft</xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <em><xsl:call-template name='date'/></em>
      </h2>

      <dl>
        <xsl:choose>
          <xsl:when test='$options/x:versions/x:cvs and $options/x:maturity="ED"'>
            <dt>Latest Editor’s Draft:</dt>
            <dd>
              <xsl:variable name='href' select='$options/x:versions/x:cvs/@href'/>
              <a href='{$href}'><xsl:value-of select='$href'/></a>
            </dd>
            <dt>Latest Published Version:</dt>
            <xsl:if test='$options/x:versions/x:latest/@href != ""'>
              <dd><a href='{$options/x:versions/x:latest/@href}'><xsl:value-of select='$options/x:versions/x:latest/@href'/></a></dd>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <dt>This Version:</dt>
            <dd>
              <a href='{$options/x:versions/x:this/@href}'><xsl:value-of select='$options/x:versions/x:this/@href'/></a>
            </dd>
            <dt>Latest Version:</dt>
            <xsl:if test='$options/x:versions/x:latest/@href != ""'>
              <dd><a href='{$options/x:versions/x:latest/@href}'><xsl:value-of select='$options/x:versions/x:latest/@href'/></a></dd>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test='$options/x:versions/x:previous[@href!=""]'>
          <dt>Previous Version<xsl:if test='count($options/x:versions/x:previous[@href!=""]) > 1'>s</xsl:if>:</dt>
          <xsl:if test='$options/x:versions/x:previous/@href != ""'>
            <xsl:for-each select='$options/x:versions/x:previous/@href'>
              <dd><a href='{$options/x:versions/x:previous/@href}'><xsl:value-of select='$options/x:versions/x:previous/@href'/></a></dd>
            </xsl:for-each>
          </xsl:if>
        </xsl:if>
        <dt>Editor<xsl:if test='count($options/x:editors/x:person) &gt; 1'>s</xsl:if>:</dt>
        <xsl:for-each select='$options/x:editors/x:person'>
          <dd>
            <xsl:choose>
              <xsl:when test='@homepage'>
                <a href='{@homepage}'><xsl:value-of select='x:name'/></a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select='x:name'/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test='x:affiliation'>
              <xsl:text>, </xsl:text>
              <xsl:choose>
                <xsl:when test='x:affiliation/@homepage'>
                  <a href='{x:affiliation/@homepage}'><xsl:value-of select='x:affiliation'/></a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select='x:affiliation'/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:if test='@email'>
              <xsl:text> &lt;</xsl:text>
              <xsl:value-of select='@email'/>
              <xsl:text>&gt;</xsl:text>
            </xsl:if>
          </dd>
        </xsl:for-each>
      </dl>
      <p class="copyright"><a href="http://www.w3.org/Consortium/Legal/ipr-notice#Copyright">Copyright</a><xsl:text disable-output-escaping='yes'> &amp;copy; </xsl:text><xsl:value-of select='concat(substring($options/x:versions/x:this/@href, string-length($options/x:versions/x:this/@href) - 8, 4), " ")'/><a href="http://www.w3.org/"><abbr title="World Wide Web Consortium">W3C</abbr></a><sup><xsl:text disable-output-escaping='yes'>&amp;reg;</xsl:text></sup> (<a href="http://www.csail.mit.edu/"><abbr title="Massachusetts Institute of Technology">MIT</abbr></a>, <a href="http://www.ercim.org/"><abbr title="European Research Consortium for Informatics and Mathematics">ERCIM</abbr></a>, <a href="http://www.keio.ac.jp/">Keio</a>), All Rights Reserved. W3C <a href="http://www.w3.org/Consortium/Legal/ipr-notice#Legal_Disclaimer">liability</a>, <a href="http://www.w3.org/Consortium/Legal/ipr-notice#W3C_Trademarks">trademark</a> and <a href="http://www.w3.org/Consortium/Legal/copyright-documents">document use</a> rules apply.</p>
    </div>
    <hr/>
  </xsl:template>

  <xsl:template name='date'>
    <xsl:variable name='date'>
      <xsl:choose>
        <xsl:when test='$options/x:maturity="ED"'>
          <xsl:value-of select='translate(substring-before(substring-after(substring-after(substring-after($id, " "), " "), " "), " "), "/", "")'/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select='substring($options/x:versions/x:this/@href, string-length($options/x:versions/x:this/@href) - 8, 8)'/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select='number(substring($date, 7))'/>
    <xsl:text> </xsl:text>
    <xsl:call-template name='monthName'>
      <xsl:with-param name='n' select='number(substring($date, 5, 2))'/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:value-of select='substring($date, 1, 4)'/>
  </xsl:template>

  <xsl:template name='maturity'>
    <xsl:choose>
      <xsl:when test='$options/x:maturity="FPWD"'>First Public Working Draft</xsl:when>
      <xsl:when test='$options/x:maturity="LCWD"'>Last Call Working Draft</xsl:when>
      <xsl:when test='$options/x:maturity="FPWDLC"'>First Public Working Draft and Last Call Working Draft</xsl:when>
      <xsl:when test='$options/x:maturity="WD"'>Working Draft</xsl:when>
      <xsl:when test='$options/x:maturity="CR"'>Candidate Recommendation</xsl:when>
      <xsl:when test='$options/x:maturity="PR"'>Proposed Recommendation</xsl:when>
      <xsl:when test='$options/x:maturity="PER"'>Proposed Edited Recommendation</xsl:when>
      <xsl:when test='$options/x:maturity="REC"'>Recommendation</xsl:when>
      <xsl:when test='$options/x:maturity="WG-NOTE"'>Working Group Note</xsl:when>
      <xsl:otherwise>Editor’s Draft</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name='maturity-short'>
    <xsl:choose>
      <xsl:when test='$options/x:maturity="FPWD"'>a Working Draft</xsl:when>
      <xsl:when test='$options/x:maturity="LCWD"'>a Working Draft</xsl:when>
      <xsl:when test='$options/x:maturity="FPWDLC"'>a Working Draft</xsl:when>
      <xsl:when test='$options/x:maturity="WD"'>a Working Draft</xsl:when>
      <xsl:when test='$options/x:maturity="CR"'>a Candidate Recommendation</xsl:when>
      <xsl:when test='$options/x:maturity="PR"'>a Proposed Recommendation</xsl:when>
      <xsl:when test='$options/x:maturity="PER"'>a Proposed Edited Recommendation</xsl:when>
      <xsl:when test='$options/x:maturity="REC"'>a Recommendation</xsl:when>
      <xsl:when test='$options/x:maturity="WG-NOTE"'>a Working Group Note</xsl:when>
      <xsl:otherwise>an Editor’s Draft</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='processing-instruction("sotd-top")'>
    <xsl:variable name='mail' select='substring-before(., " ")'/>
    <xsl:variable name='temp' select='substring-after(., " ")'/>
    <xsl:variable name='archive'>
      <xsl:choose>
        <xsl:when test='contains($temp, " ")'><xsl:value-of select='substring-before($temp, " ")'/></xsl:when>
        <xsl:otherwise><xsl:value-of select='$temp'/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name='prefix'><xsl:if test='contains($temp, " ")'><xsl:value-of select='substring-after($temp, " ")'/></xsl:if></xsl:variable>
    <p>
      <em>
        This section describes the status of this document at the time of
        its publication.  Other documents may supersede this document. A list
        of current W3C publications and the latest revision of this technical
        report can be found in the <a href="http://www.w3.org/TR/">W3C technical
          reports index</a> at http://www.w3.org/TR/.
      </em>
    </p>
    <p>
      <xsl:if test='$options/x:maturity!="REC" and $options/x:maturity!="WG-NOTE"'>
        This document is the <xsl:call-template name='date'/><xsl:text> </xsl:text>
        <b><xsl:call-template name='maturity'/></b> of the
        <cite><xsl:value-of select='/*/h:head/h:title'/></cite> specification.
      </xsl:if>
      Please send comments about this document to
      <a href='mailto:{$mail}'><xsl:value-of select='$mail'/></a>
      (<a href='{$archive}'>archived</a>)<xsl:if test='$prefix != ""'>
      with “<xsl:value-of select='$prefix'/>” at the start of the subject line</xsl:if>.
    </p>
  </xsl:template>

  <xsl:template match='processing-instruction("sotd-bottom")'>
    <xsl:variable name='ipp' select='.'/>
    <p>
      <xsl:choose>
        <xsl:when test='$options/x:maturity="REC"'>
          This document has been reviewed by W3C Members, by software developers,
          and by other W3C groups and interested parties, and is endorsed by the
          Director as a W3C Recommendation. It is a stable document and may be
          used as reference material or cited from another document. W3C’s role
          in making the Recommendation is to draw attention to the specification
          and to promote its widespread deployment. This enhances the
          functionality and interoperability of the Web.
        </xsl:when>
        <xsl:otherwise>
          Publication as <xsl:call-template name='maturity-short'/> does not imply endorsement by the
          W3C Membership.  This is a draft document and may be updated, replaced
          or obsoleted by other documents at any time. It is inappropriate to cite
          this document as other than work in progress.
        </xsl:otherwise>
      </xsl:choose>
    </p>
    <p>
      This document was produced by a group operating under the
      <a href='http://www.w3.org/Consortium/Patent-Policy-20040205/'>5 February
        2004 W3C Patent Policy</a>. W3C maintains a
      <a href='{$ipp}'>public list of
        any patent disclosures</a> made in connection with the deliverables of
      the group; that page also includes instructions for disclosing a patent.
      An individual who has actual knowledge of a patent which the individual
      believes contains
      <a href='http://www.w3.org/Consortium/Patent-Policy-20040205/#def-essential'>Essential
        Claim(s)</a> must disclose the information in accordance with
      <a href='http://www.w3.org/Consortium/Patent-Policy-20040205/#sec-Disclosure'>section
        6 of the W3C Patent Policy</a>.
    </p>
  </xsl:template>

  <xsl:template match='processing-instruction("productions")'>
    <xsl:variable name='id' select='substring-before(., " ")'/>
    <xsl:variable name='names' select='concat(" ", substring-after(., " "), " ")'/>
    <table class='grammar'>
      <xsl:apply-templates select='//*[@id=$id]/x:prod[contains($names, concat(" ", @nt, " "))]' mode='def'/>
    </table>
  </xsl:template>

  <xsl:template match='processing-instruction("toc")'>
    <xsl:variable name='sectionsID' select='substring-before(., " ")'/>
    <xsl:variable name='appendicesID' select='substring-after(., " ")'/>

    <div class='toc'>
      <xsl:for-each select='//*[@id=$sectionsID]'>
        <xsl:call-template name='toc1'/>
      </xsl:for-each>
      <xsl:for-each select='//*[@id=$appendicesID]'>
        <xsl:call-template name='toc1'>
          <xsl:with-param name='alpha' select='true()'/>
        </xsl:call-template>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match='processing-instruction("sref")'>
    <xsl:variable name='id' select='string(.)'/>
    <xsl:variable name='s' select='//*[@id=$id]/self::h:div[@class="section"]'/>
    <xsl:choose>
      <xsl:when test='$s'>
        <xsl:call-template name='section-number'>
          <xsl:with-param name='section' select='$s'/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>@@</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='processing-instruction("sdir")'>
    <xsl:variable name='id' select='string(.)'/>
    <xsl:choose>
      <xsl:when test='preceding::h:div[@id=$id][@class="section"]'>above</xsl:when>
      <xsl:when test='following::h:div[@id=$id][@class="section"]'>below</xsl:when>
      <xsl:otherwise>@@</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='processing-instruction("revision-note")'>
    <xsl:if test='$options/x:maturity="ED"'>
      <div class='ednote'>
        <div class='ednoteHeader'>Editorial note</div>
        <p>This is revision <xsl:value-of select='$id'/>.</p>
        <xsl:variable name='n' select='count(//h:div[@class="ednote"])'/>
        <xsl:if test='$n'>
          <p>There are <xsl:value-of select='$n'/> further editorial notes in the document.</p>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match='processing-instruction("stepref")'>
    <xsl:variable name='step' select='string(.)'/>
    <xsl:variable name='li' select='ancestor::*[@class="algorithm"]/*[@x:step=$step]'/>
    <xsl:choose>
      <xsl:when test='$li'>
        <xsl:value-of select='count($li/preceding-sibling::*) + 1'/>
      </xsl:when>
      <xsl:otherwise>@@</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='processing-instruction()|comment()'/>

  <xsl:template name='toc1'>
    <xsl:param name='prefix'/>
    <xsl:param name='alpha'/>

    <xsl:variable name='subsections' select='h:div[@class="section"]'/>
    <xsl:if test='$subsections'>
      <ul>
        <xsl:for-each select='h:div[@class="section"]'>
          <xsl:variable name='number'>
            <xsl:value-of select='$prefix'/>
            <xsl:if test='$prefix'>.</xsl:if>
            <xsl:choose>
              <xsl:when test='$alpha'><xsl:number value='position()' format='A'/></xsl:when>
              <xsl:otherwise><xsl:value-of select='position()'/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name='frag'>
            <xsl:choose>
              <xsl:when test='@id'><xsl:value-of select='@id'/></xsl:when>
              <xsl:otherwise><xsl:value-of select='generate-id(.)'/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <li>
            <a href='#{$frag}'>
              <xsl:value-of select='$number'/>
              <xsl:text>. </xsl:text>
              <xsl:for-each select='h:h2|h:h3|h:h4|h:h5|h:h6'>
                <xsl:call-template name='toc-entry-name'/>
              </xsl:for-each>
            </a>
            <xsl:call-template name='toc1'>
              <xsl:with-param name='prefix' select='$number'/>
            </xsl:call-template>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template name='toc-entry-name'>
    <xsl:for-each select='node()'>
      <xsl:choose>
        <xsl:when test='self::h:var'>
          <var>
            <xsl:value-of select='.'/>
          </var>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select='.'/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name='section-number'>
    <xsl:param name='section'/>
    <xsl:variable name='sections' select='//*[@id=substring-before($tocpi, " ")]'/>
    <xsl:variable name='appendices' select='//*[@id=substring-after($tocpi, " ")]'/>
    <xsl:choose>
      <xsl:when test='$section/ancestor::* = $sections'>
        <xsl:for-each select='$section/ancestor-or-self::h:div[@class="section"]'>
          <xsl:value-of select='count(preceding-sibling::h:div[@class="section"]) + 1'/>
          <xsl:if test='position() != last()'>
            <xsl:text>.</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test='$section/ancestor::* = $appendices'>
        <xsl:for-each select='$section/ancestor-or-self::h:div[@class="section"]'>
          <xsl:choose>
            <xsl:when test='position()=1'>
              <xsl:number value='count(preceding-sibling::h:div[@class="section"]) + 1' format='A'/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select='count(preceding-sibling::h:div[@class="section"]) + 1'/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test='position() != last()'>
            <xsl:text>.</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match='h:div[@class="section"]/h:h2 | h:div[@class="section"]/h:h3 | h:div[@class="section"]/h:h4 | h:div[@class="section"]/h:h5 | h:div[@class="section"]/h:h6'>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:copy-of select='@*[namespace-uri()="" or namespace-uri="http://www.w3.org/XML/1998/namespace"]'/>
      <xsl:if test='$tocpi'>
        <xsl:variable name='num'>
          <xsl:call-template name='section-number'>
            <xsl:with-param name='section' select='..'/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test='$num != ""'>
          <xsl:value-of select='$num'/>
          <xsl:text>. </xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates select='node()'/>
    </xsl:element>
  </xsl:template>

  <xsl:template match='h:div[@class="ednote"]'>
    <div>
      <xsl:copy-of select='@*[namespace-uri()="" or namespace-uri="http://www.w3.org/XML/1998/namespace"]'/>
      <div class='ednoteHeader'>Editorial note</div>
      <xsl:apply-templates select='node()'/>
    </div>
  </xsl:template>

  <xsl:template match='h:div[@class="example"]'>
    <div>
      <xsl:copy-of select='@*[namespace-uri()="" or namespace-uri="http://www.w3.org/XML/1998/namespace"]'/>
      <div class='exampleHeader'>Example</div>
      <xsl:apply-templates select='node()'/>
    </div>
  </xsl:template>

  <xsl:template match='h:div[@class="note"]'>
    <div>
      <xsl:copy-of select='@*[namespace-uri()="" or namespace-uri="http://www.w3.org/XML/1998/namespace"]'/>
      <div class='noteHeader'>Note</div>
      <xsl:apply-templates select='node()'/>
    </div>
  </xsl:template>

  <!--
  <xsl:template match='h:tr'>
    <xsl:copy>
      <xsl:attribute name='class'>
        <xsl:value-of select='@class'/>
        <xsl:if test='@class'><xsl:text> </xsl:text></xsl:if>
        <xsl:choose>
          <xsl:when test='count(preceding-sibling::h:tr) mod 2 = 0'>odd</xsl:when>
          <xsl:otherwise>even</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:copy-of select='node()[not(self::class)]'/>
    </xsl:copy>
  </xsl:template>
  -->

  <xsl:template match='x:codeblock'>
    <div class='block'>
      <div class='blockTitleDiv'>
        <span class='blockTitle'>
          <xsl:choose>
            <xsl:when test='@language="idl"'>IDL</xsl:when>
            <xsl:when test='@language="es"'>ECMAScript</xsl:when>
            <xsl:when test='@language="java"'>Java</xsl:when>
            <xsl:when test='@language="c"'>C</xsl:when>
            <xsl:otherwise>@@</xsl:otherwise>
          </xsl:choose>
        </span>
      </div>
      <div class='blockContent'>
        <pre class='code'><code class='{@language}-code'><xsl:apply-templates select='node()'/></code></pre>
      </div>
    </div>
  </xsl:template>

  <xsl:template match='x:grammar'>
    <table class='grammar'>
      <xsl:apply-templates select='x:prod'/>
    </table>
  </xsl:template>

  <xsl:template match='x:prod' mode='def'>
    <tr id='proddef-{@nt}'>
      <td><span class='prod-number'>[<xsl:value-of select='count(preceding-sibling::x:prod) + 1'/>]</span></td>
      <td>
        <a class='nt' href='#prod-{@nt}'><xsl:value-of select='@nt'/></a>
        <xsl:if test='@whitespace="explicit"'>
          <sub class='nt-attr'>explicit</sub>
        </xsl:if>
      </td>
      <td class='prod-mid'>→</td>
      <td class='prod-rhs'>
        <span class='prod-lines'>
          <xsl:call-template name='bnf'>
            <xsl:with-param name='s' select='string(.)'/>
          </xsl:call-template>
        </span>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match='x:prod'>
    <tr id='prod-{@nt}'>
      <td><span class='prod-number'>[<xsl:value-of select='count(preceding-sibling::x:prod) + 1'/>]</span></td>
      <td>
        <a class='nt' href='#proddef-{@nt}'><xsl:value-of select='@nt'/></a>
        <xsl:if test='@whitespace="explicit"'>
          <sub class='nt-attr'>explicit</sub>
        </xsl:if>
      </td>
      <td class='prod-mid'>→</td>
      <td class='prod-rhs'>
        <span class='prod-lines'>
            <xsl:call-template name='bnf'>
            <xsl:with-param name='s' select='string(.)'/>
          </xsl:call-template>
        </span>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name='bnf'>
    <xsl:param name='s'/>
    <xsl:param name='mode' select='0'/>
    <xsl:if test='$s != ""'>
      <xsl:variable name='c' select='substring($s, 1, 1)'/>
      <xsl:choose>
        <xsl:when test='$mode = 0 and contains("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", $c)'>
          <xsl:variable name='nt'>
            <xsl:value-of select='$c'/>
            <xsl:call-template name='bnf-nt'>
              <xsl:with-param name='s' select='substring($s, 2)'/>
            </xsl:call-template>
          </xsl:variable>
          <a class='nt' href='#prod-{$nt}'><xsl:value-of select='$nt'/></a>
          <xsl:call-template name='bnf'>
            <xsl:with-param name='s' select='substring($s, string-length($nt) + 1)'/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test='$mode = 0 and $c = "|"'>
          <!--div class='prod-line-subsequent'--><br/> |
            <xsl:call-template name='bnf'>
              <xsl:with-param name='s' select='substring($s, 2)'/>
            </xsl:call-template>
          <!--/div-->
        </xsl:when>
        <xsl:when test='$c = &#39;"&#39;'>
          <xsl:value-of select='$c'/>
          <xsl:variable name='newMode'>
            <xsl:choose>
              <xsl:when test='$mode = 1'>0</xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:call-template name='bnf'>
            <xsl:with-param name='s' select='substring($s, 2)'/>
            <xsl:with-param name='mode' select='$newMode'/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$c = &#34;'&#34;">
          <xsl:value-of select='$c'/>
          <xsl:variable name='newMode'>
            <xsl:choose>
              <xsl:when test='$mode = 2'>0</xsl:when>
              <xsl:otherwise>2</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:call-template name='bnf'>
            <xsl:with-param name='s' select='substring($s, 2)'/>
            <xsl:with-param name='mode' select='$newMode'/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$c = '[' and $mode = 0">
          <xsl:value-of select='$c'/>
          <xsl:choose>
            <xsl:when test='substring($s, 2, 1) = "]"'>
              <xsl:text>]</xsl:text>
              <xsl:call-template name='bnf'>
                <xsl:with-param name='s' select='substring($s, 3)'/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name='newMode'>
                <xsl:choose>
                  <xsl:when test='$mode = 3'>0</xsl:when>
                  <xsl:otherwise>3</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:call-template name='bnf'>
                <xsl:with-param name='s' select='substring($s, 2)'/>
                <xsl:with-param name='mode' select='$newMode'/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$c = ']' and $mode = 3">
          <xsl:value-of select='$c'/>
          <xsl:call-template name='bnf'>
            <xsl:with-param name='s' select='substring($s, 2)'/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select='$c'/>
          <xsl:call-template name='bnf'>
            <xsl:with-param name='s' select='substring($s, 2)'/>
            <xsl:with-param name='mode' select='$mode'/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name='bnf-nt'>
    <xsl:param name='s'/>
    <xsl:if test='$s != ""'>
      <xsl:variable name='c' select='substring($s, 1, 1)'/>
      <xsl:if test='contains("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz", $c)'>
        <xsl:value-of select='$c'/>
        <xsl:call-template name='bnf-nt'>
          <xsl:with-param name='s' select='substring($s, 2)'/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match='*'/>

  <xsl:template match='comment()'>
    <xsl:copy/>
  </xsl:template>
</xsl:stylesheet>
