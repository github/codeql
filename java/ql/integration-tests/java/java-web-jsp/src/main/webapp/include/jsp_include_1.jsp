
<i>Psst <a href="?secret_param=../WEB-INF/secret.jsp">click me</a> or <a href="?secret_param=../WEB-INF/web.xml">click me</a>!</i>
<br/><br/>
<jsp:include page="safe$afe.jsp" />
<jsp:include page="${param.secret_param}" /><%-- This line doesn't compile in weblogic --%>