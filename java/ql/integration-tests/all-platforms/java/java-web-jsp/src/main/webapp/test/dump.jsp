<html><head>
<%@ page import="java.util.Enumeration" %>
</head><body>
<h1>JSP Dump</h1>

<table border="1">
<tr><th>Request URI:</th><td><%= request.getRequestURI() %></td></tr>
<tr><th>ServletPath:</th><td><%= request.getServletPath() %></td></tr>
<tr><th>PathInfo:</th><td><%= request.getPathInfo() %></td></tr>

<%
   Enumeration e =request.getParameterNames();
   while(e.hasMoreElements())
   {
       String name = (String)e.nextElement();
%>
<tr>
  <th>getParameter("<%= name %>")</th>
  <td><%= request.getParameter(name) %></td></tr>
<% } %>

</table>
</body></html>
