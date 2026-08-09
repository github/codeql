<%@ Page Language="C#" Inherits="Test.XSSPage" %>

<script>
<%= someJavascript() %>
</script>

<script>
<%= Field %>
</script>

<script>
<%= Request %> <%-- $ Alert[cs/web/xss]=r12 $ Alert[cs/web/xss]=r12 --%>
</script>

<script>
<%= Request.QueryString["name"] %> <%-- $ Alert[cs/web/xss]=r13 $ Alert[cs/web/xss]=r13 --%>
</script>

<script>
<%= Request.QueryString["name"].Trim() %> <%-- $ Alert[cs/web/xss]=r14 $ Alert[cs/web/xss]=r14 --%>
</script>
