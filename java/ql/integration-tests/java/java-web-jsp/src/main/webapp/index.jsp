<html>
<head>
  <title>Embedded Jetty: JSP Examples</title>
</head>
<body>
  <h1>Vulnerable JSP pages</h1>

  <h2>XSS</h2>
  <ul>
  <li><a href="/xss/xss0.jsp">XSS 0</a></li>
  <li><a href="/xss/xss1.jsp">XSS 1</a></li>
  <li><a href="/xss/xss2.jsp">XSS 2</a></li>
  <li><a href="/xss/xss3.jsp">XSS 3</a></li>
  <li><a href="/xss/xss4.jsp">XSS 4</a></li>
  <li><a href="/xss/xss5.jsp">XSS 5</a></li>
  </ul>

  <h2>XML parsing</h2>
  <ul>
  <li><a href="/xml/xml1.jsp?xml=<stock><symbol>TKM%3C%2Fsymbol>%3C%2Fstock>">XML 1</a></li>
  <li><a href="/xml/xml2.jsp">XML 2</a></li>
  </ul>

  <h2>XSLT</h2>
  <ul>
  <li><a href='/xsl/xsl1.jsp?xml=<stock><symbol>TKM%3C%2Fsymbol>%3C%2Fstock>&xslt=%3Cxsl%3Astylesheet%20version%3D"1.0"%0A%20xmlns%3Axsl%3D"http%3A%2F%2Fwww.w3.org%2F1999%2FXSL%2FTransform"%20%20%20%20%20%20%20%20%20%0A%20xmlns%3Art%3D"http%3A%2F%2Fxml.apache.org%2Fxalan%2Fjava%2Fjava.lang.Runtime"%0A%20exclude-result-prefixes%3D"date">%0A%20%20%20%20%20%20%20%20%3Cxsl%3Aoutput%20method%3D"text"%2F>%0A%20%20%20%20%20%20%20%20%3Cxsl%3Atemplate%20match%3D"%2F">%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Cxsl%3Atext>Quote%20requested%20for%3A%20%3C%2Fxsl%3Atext>%3Cblink>%3Cxsl%3Avalue-of%20select%3D"stock%2Fsymbol"%2F>%3C%2Fblink>%0A%20%20%20%20%20%20%20%20%3C%2Fxsl%3Atemplate>%0A%3C%2Fxsl%3Astylesheet>'>XSL 1</a></li>
  <li><a href='/xsl/xsl2.jsp?xslt=%3Cxsl%3Astylesheet%20version%3D"1.0"%0A%20xmlns%3Axsl%3D"http%3A%2F%2Fwww.w3.org%2F1999%2FXSL%2FTransform"%20%20%20%20%20%20%20%20%20%0A%20xmlns%3Art%3D"http%3A%2F%2Fxml.apache.org%2Fxalan%2Fjava%2Fjava.lang.Runtime"%0A%20exclude-result-prefixes%3D"date">%0A%20%20%20%20%20%20%20%20%3Cxsl%3Aoutput%20method%3D"text"%2F>%0A%20%20%20%20%20%20%20%20%3Cxsl%3Atemplate%20match%3D"%2F">%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3Cxsl%3Atext>Quote%20requested%20for%3A%20%3C%2Fxsl%3Atext>%3Cblink>%3Cxsl%3Avalue-of%20select%3D"stock%2Fsymbol"%2F>%3C%2Fblink>%0A%20%20%20%20%20%20%20%20%3C%2Fxsl%3Atemplate>%0A%3C%2Fxsl%3Astylesheet>'>XSL 2</a></li>
  <li><a href='/xsl/xsl3.jsp?xml=<stock><symbol>TKM%3C%2Fsymbol>%3C%2Fstock>'>XSL 3</a></li>
  <li><a href='/xsl/xsl4.jsp'>XSL 4</a></li>
  </ul>

  <h2>Various JSP samples </h2>
  <ul>
    <li><a href="test/dump.jsp">JSP 1.2 embedded java</a></li>
    <li><a href="test/bean1.jsp">JSP 1.2 Bean demo</a></li>
    <li><a href="test/tag.jsp">JSP 1.2 BodyTag demo</a></li>
    <li><a href="test/tag2.jsp">JSP 2.0 SimpleTag demo</a></li>
    <li><a href="test/tagfile.jsp">JSP 2.0 Tag File demo</a></li>
    <li><a href="test/expr.jsp?A=1">JSP 2.0 Tag Expression</a></li>
    <li><a href="test/jstl.jsp">JSTL Expression</a></li>
    <li><a href="test/foo/">Mapping to &lt;jsp-file&gt;</a></li>
    <li><a href="date/">Servlet Forwarding to JSP demo</a></li>
  </ul>
</body>
</html>