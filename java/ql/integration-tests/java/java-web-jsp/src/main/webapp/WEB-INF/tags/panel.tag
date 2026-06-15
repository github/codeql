<%-- 
   - Copyright (c) 2002 The Apache Software Foundation.  All rights 
   - reserved.
--%>
<%@ attribute name="color" %>
<%@ attribute name="bgcolor" %>
<%@ attribute name="title" %>
<table border="1" bgcolor="${color}">
  <tr>
    <td><b>${title}</b></td>
  </tr>
  <tr>
    <td bgcolor="${bgcolor}">
      <jsp:doBody/>
    </td>
  </tr>
</table>
