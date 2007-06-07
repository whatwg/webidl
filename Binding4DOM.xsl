<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
                xmlns:h='http://www.w3.org/1999/xhtml'
                xmlns:d='http://mcc.id.au/ns/local'
                xmlns='http://www.w3.org/1999/xhtml'
                exclude-result-prefixes='h d'
                version='1.0' id='xslt'>

  <xsl:output method='xml' encoding='UTF-8'
              doctype-public='-//W3C//DTD XHTML 1.1//EN'
              doctype-system='http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'
              media-type='application/xhtml+xml; charset=UTF-8'/>

  <xsl:variable name='options' select='/*/h:head/options'/>
  <xsl:variable name='id' select='/*/h:head/h:meta[@name="revision"]/@content'/>
  <xsl:variable name='rev' select='substring-before(substring-after(substring-after($id, " "), " "), " ")'/>
  <xsl:variable name='data' select='document("")/*/d:data'/>
  <xsl:variable name='months' select='$data/d:months'/>
  <xsl:variable name='tocpi' select='//processing-instruction("toc")[1]'/>

  <data xmlns='http://mcc.id.au/ns/local'>
    <months>
      <item>January</item>
      <item>February</item>
      <item>March</item>
      <item>April</item>
      <item>May</item>
      <item>June</item>
      <item>July</item>
      <item>August</item>
      <item>September</item>
      <item>October</item>
      <item>November</item>
      <item>December</item>
    </months>
  </data>

  <xsl:template match='/'>
    <xsl:text>&#xa;</xsl:text>
    <xsl:comment>
  Overview.html
  Language Bindings for DOM Specifications

  Note: This file is generated from Overview.xml.  Run “make” to regenerate it.
  </xsl:comment>
    <xsl:text>&#xa;</xsl:text>
    <xsl:apply-templates select='/*'/>
  </xsl:template>

  <xsl:template match='h:*'>
    <xsl:copy>
      <xsl:copy-of select='@*[namespace-uri()="" or namespace-uri="http://www.w3.org/XML/1998/namespace"]'/>
      <xsl:apply-templates select='node()'/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match='processing-instruction("top")'>
    <div><a href="http://www.w3.org/"><img src="http://www.w3.org/Icons/w3c_home" width="72" height="48" alt="W3C"></img></a></div>
    <h1><xsl:value-of select='/*/h:head/h:title'/></h1>
    <h2>
      W3C Editor’s Draft
      <em>
        <xsl:variable name='date' select='substring-before(substring-after(substring-after(substring-after($id, " "), " "), " "), " ")'/>
        <xsl:value-of select='number(substring($date, 9))'/>
        <xsl:text> </xsl:text>
        <xsl:value-of select='$months/*[number(substring($date, 6, 2))]'/>
        <xsl:text> </xsl:text>
        <xsl:value-of select='substring($date, 1, 4)'/>
      </em>
    </h2>

    <dl>
      <dt>This version:</dt>
      <dd>
        <xsl:choose>
          <xsl:when test='$options/versions/this[@cvsweb="true"]'>
            <xsl:variable name='href' select='concat(substring-before($options/versions/this/@href, "~checkout~/"), substring-after($options/versions/this/@href, "~checkout~/"))'/>
            <xsl:variable name='href2' select='concat($href, "?rev=", $rev, "&amp;content-type=text/xml")'/>
            <a id='thisVersionLink' href='{$href}'><xsl:value-of select='$href'/></a>
            <script>
              var id = "&#x24;Id$";
              var a = document.getElementById('thisVersionLink');
              var xs = id.match(/ ([0-9]\.[0-9.]+) /);
              if (xs) {
                var rev = xs[1];
                a.href = "<xsl:value-of select='$options/versions/this/@href'/>?rev=" + rev + String.fromCharCode(38) + "content-type=text/html; charset=utf-8";
                a.firstChild.data = a.href;
              }
            </script>
          </xsl:when>
          <xsl:otherwise>
            <a href='{$options/versions/this/@href}'><xsl:value-of select='$options/versions/this/@href'/></a>
          </xsl:otherwise>
        </xsl:choose>
      </dd>
      <dt>Latest version:</dt>
      <xsl:if test='$options/versions/latest/@href != ""'>
        <dd><a href='{$options/versions/latest/@href}'><xsl:value-of select='$options/versions/latest/@href'/></a></dd>
      </xsl:if>
      <dt>Previous version:</dt>
      <xsl:if test='$options/versions/previous/@href != ""'>
        <xsl:for-each select='$options/versions/previous/@href'>
          <dd><a href='{$options/versions/previous/@href}'><xsl:value-of select='$options/versions/previous/@href'/></a></dd>
        </xsl:for-each>
      </xsl:if>
      <dt>Editor<xsl:if test='count($options/editors/person) &gt; 1'>s</xsl:if>:</dt>
      <xsl:for-each select='$options/editors/person'>
        <dd>
          <xsl:choose>
            <xsl:when test='@homepage'>
              <a href='{@homepage}'><xsl:value-of select='name'/></a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select='name'/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test='affiliation'>
            <xsl:text> (</xsl:text>
            <xsl:choose>
              <xsl:when test='affiliation/@homepage'>
                <a href='{affiliation/@homepage}'><xsl:value-of select='affiliation'/></a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select='affiliation'/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>)</xsl:text>
          </xsl:if>
          <xsl:if test='@email'>
            <xsl:text> &lt;</xsl:text>
            <xsl:value-of select='@email'/>
            <xsl:text>&gt;</xsl:text>
          </xsl:if>
        </dd>
      </xsl:for-each>
    </dl>
    <p class="copyright">
      <a href="http://www.w3.org/Consortium/Legal/ipr-notice#Copyright">Copyright</a> ©<xsl:value-of select='concat($options/years, " ")'/>
      <a href="http://www.w3.org/"><acronym title="World Wide Web Consortium">W3C</acronym></a><sup>®</sup>
      (<a href="http://www.csail.mit.edu/"><acronym title="Massachusetts Institute of Technology">MIT</acronym></a>,
      <a href="http://www.ercim.org/"><acronym title="European Research Consortium for Informatics and Mathematics">ERCIM</acronym></a>,
      <a href="http://www.keio.ac.jp/">Keio</a>), All Rights Reserved. W3C
      <a href="http://www.w3.org/Consortium/Legal/ipr-notice#Legal_Disclaimer">liability</a>,
      <a href="http://www.w3.org/Consortium/Legal/ipr-notice#W3C_Trademarks">trademark</a> and 
      <a href="http://www.w3.org/Consortium/Legal/copyright-documents">document use</a> rules apply.
    </p>
    <hr/>
  </xsl:template>

  <xsl:template match='processing-instruction("toc")'>
    <xsl:variable name='sectionsID' select='substring-before(., " ")'/>
    <xsl:variable name='appendicesID' select='substring-after(., " ")'/>

    <div class='toc'>
      <xsl:for-each select='id($sectionsID)'>
        <xsl:call-template name='toc1'/>
      </xsl:for-each>
      <xsl:for-each select='id($appendicesID)'>
        <xsl:call-template name='toc1'>
          <xsl:with-param name='alpha' select='true()'/>
        </xsl:call-template>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match='processing-instruction("sref")'>
    <xsl:variable name='s' select='id(string(.))/self::h:div[@class="section"]'/>
    <xsl:choose>
      <xsl:when test='$s'>
        <xsl:call-template name='section-number'>
          <xsl:with-param name='section' select='$s'/>
        </xsl:call-template>
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
              <xsl:value-of select='h:h2|h:h3|h:h4|h:h5|h:h6'/>
            </a>
            <xsl:call-template name='toc1'>
              <xsl:with-param name='prefix' select='$number'/>
            </xsl:call-template>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template name='section-number'>
    <xsl:param name='section'/>
    <xsl:variable name='sections' select='id(substring-before($tocpi, " "))'/>
    <xsl:variable name='appendices' select='id(substring-after($tocpi, " "))'/>
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
    <xsl:copy>
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
    </xsl:copy>
  </xsl:template>

  <xsl:template match='h:div[@class="ednote"]'>
    <xsl:copy>
      <xsl:copy-of select='@*[namespace-uri()="" or namespace-uri="http://www.w3.org/XML/1998/namespace"]'/>
      <div class='ednoteHeader'>Editorial note</div>
      <xsl:apply-templates select='node()'/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match='grammar'>
    <table class='grammar'>
      <xsl:apply-templates select='prod'/>
    </table>
  </xsl:template>

  <xsl:template match='prod'>
    <tr id='prod-{@nt}'>
      <td class='prod-number'>[<xsl:value-of select='position()'/>]</td>
      <td class='prod-lhs'><a class='nt' href='#proddef-{@nt}'><xsl:value-of select='@nt'/></a></td>
      <td class='prod-mid'>::=</td>
      <td class='prod-rhs'>
        <xsl:call-template name='bnf'>
          <xsl:with-param name='s' select='string(.)'/>
        </xsl:call-template>
      </td>
      <td class='prod-notes'>
        <xsl:if test='@whitespace="explicit"'>
          /* ws: explicit */
        </xsl:if>
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
        <xsl:when test="$c = '['">
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
</xsl:stylesheet>
