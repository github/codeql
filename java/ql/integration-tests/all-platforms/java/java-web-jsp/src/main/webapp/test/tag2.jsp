<html>
<body>

<%@ taglib uri="http://www.acme.com/taglib2" prefix="acme" %>

<acme:date2 format="long">
  On ${day} of ${month} in the year ${year}
</acme:date2>

<br/>

<acme:date2 format="short">
  ${day} - ${month} - ${year}
</acme:date2>

<br/>

</body>
</html>
