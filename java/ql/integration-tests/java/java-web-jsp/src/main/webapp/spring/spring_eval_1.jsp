<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<form method="get" action="">
<input type="text" name="expression" value="1+1"> <input type="submit" value="test">
</form>


<c:set var="expression" value="${param.expression}" scope="request"  />
Evaluating ("&#36;{expression}") : <c:out value="${expression}" /><br/>
<br/>

<c:if test="${expression != null}">
Output:
<pre style="background-color:#CCC">
<spring:eval expression="${expression}" var="results" />
<c:out value="${results}" />
</pre>
</c:if>