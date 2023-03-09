<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<html>
  <head>
  </head>
  <body>
    <h1>FOO Example</h1>
    <hr>
    <p>A trivial FOO example
    <hr>
    <c:forEach var="i" begin="1" end="10" step="1">
      <c:out value="${i}" />
      <br />
    </c:forEach>
  </body>
</html>
