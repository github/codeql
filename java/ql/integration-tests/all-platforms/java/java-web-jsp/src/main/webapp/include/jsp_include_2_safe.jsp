<i>Psst <a href="?secret_param=../WEB-INF/secret.jsp">click me</a> or <a href="?secret_param=../WEB-INF/web.xml">click me</a>!</i>
<br/><br/>


<%@include file="${param.secret_param}.jsp"%> <!-- Safe will be evaluate as literal -->
<%-- This line doesn't compile in weblogic --%>