<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<p>
Client message:<br/>
<c:out value="${param.test}" escapeXml="false"/>
</p>