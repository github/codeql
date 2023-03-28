<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<x:parse var="doc" xml="${param.xml}" />
You requested a quote for: <x:out select="$doc/stock/symbol" />