<%@ Page Language="VB" %>

<html>
<body>
<% If ShouldWarn() Then %> <%-- $ Alert[cs/asp/split-control-structure] --%>
<p>WARNING: <%=warning()%></p>
<% End If %>
</body>
</html>
