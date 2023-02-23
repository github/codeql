<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


Set some value :
<form method="get" action="">
<input type="text" name="value" value="1+1"> <input type="submit" value="test">
</form>

Evaluating ("param.value") : <c:out value="${param.value}" /><br/>
<br/>


<c:if test="${param.value != null}">
Output:
<pre style="background-color:#CCC">
<spring:eval expression="param.value" var="results" />
<c:out value="${results}" />
</pre>
</c:if>