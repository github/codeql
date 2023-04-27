<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
    function hello(param1,param2) {
        console.info(param1+" "+param2);
    }
    var test = hello('<c:out value="${param.test1}"/>','<c:out value="${param.test2}"/>');
</script>