<%@ Page Language="C#" Inherits="Test.CodeBehindPage" %>

<script runat="server">
Label1.Text = "This is a label";
</script>

<html>
<body>
<asp:Label ID="Label1"/>

<p>2 + 3 = <%=2 + 3%></p>
<p>2 + 3 = <%Response.write(2 + 3)%></p>
<img href=<%=chooseImage()%>/>
</body>
</html>
<!--client comment-->
<%--server comment--%>
