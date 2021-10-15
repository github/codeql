<%@ Page Language="VB" %>

<html>
<body>
<% If ShouldWarn() Then %>
<p>WARNING: <%=warning()%></p>
<% End If %>
</body>
</html>
