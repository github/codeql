<html>
<body>

<%@ taglib uri="http://www.acme.com/taglib" prefix="acme" %>

<small>&lt;acme:date tz="GMT"&gt;EEE, dd/MMM/yyyy HH:mm:ss ZZZ&lt;/acme:date&gt;
==&gt;</small>
<acme:date tz="GMT">EEE, dd/MMM/yyyy HH:mm:ss ZZZ</acme:date>
<br/>
<small>&lt;acme:date tz="EST"&gt;EEE, dd-MMM-yyyy HH:mm:ss ZZZ&lt;/acme:date&gt;
==&gt;</small>
<acme:date tz="EST">EEE, dd-MMM-yyyy HH:mm:ss ZZZ</acme:date>
<br/>

</body>
</html>
