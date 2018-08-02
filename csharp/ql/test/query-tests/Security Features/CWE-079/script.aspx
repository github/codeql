<%@ Page Language="C#" Inherits="Test.XSSPage" %>

<script>
<%= someJavascript() %>
</script>

<script>
<%= Field %>
</script>

<script>
<%= Request %>
</script>

<script>
<%= Request.QueryString["name"] %>
</script>

<script>
<%= Request.QueryString["name"].Trim() %>
</script>
