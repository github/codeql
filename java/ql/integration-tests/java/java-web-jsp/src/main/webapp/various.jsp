<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

JSTL

<c:out value="${param.test_param1}"/>

<c:out value="${param.test_param2}" escapeXml="true"/>

<c:out value="${param.test_param3}" escapeXml="false"/>

JSP include

<%@include file="index.jsp"%>

<c:import url="${param.secret_param}" />

Spring eval

<spring:eval expression="${param.lang}" var="results" />
<c:out value="${results}" />