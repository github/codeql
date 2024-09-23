<html>
<%@ page session="true"%>
<body>
<jsp:useBean id='counter' scope='session' class='com.acme.Counter' type="com.acme.Counter" />

<h1>JSP1.2 Beans: 2</h1>

Counter accessed <jsp:getProperty name="counter" property="count"/> times.<br/>
Counter last accessed by <jsp:getProperty name="counter" property="last"/><br/>
<jsp:setProperty name="counter" property="last" value="<%= request.getRequestURI()%>"/>

<a href="bean1.jsp">Goto bean1.jsp</a>

</body>
</html>
