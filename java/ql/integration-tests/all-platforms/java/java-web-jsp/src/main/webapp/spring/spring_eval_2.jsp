<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


Change the language:
<form method="get" action="">
<input type="text" name="lang" value="1+1"> <input type="submit" value="test">
</form>

Evaluating ("&#36;{param.lang}") : <c:out value="${param.lang}" /><br/>
<br/>


<c:if test="${param.lang != null}">
Output:
<pre style="background-color:#CCC">
<spring:eval expression="${param.lang}" var="results" />
<c:out value="${results}" />
</pre>
</c:if>