<%@ Page Language="VB" %>

<html>
<body>
<p>2 + 3 = <%
  If Something() Then
    Response.write(2 + 3);
  } else {
    Response.write(3 + 2);
  }
  End If
%></p>
<p>2 + 3 = <%=2 + 3%></p>
</body>
</html>
