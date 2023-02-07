<%@ taglib prefix="acme" tagdir="/WEB-INF/tags" %>
<html>
  <head>
  </head>
  <body>
    <h1>JSP 2.0 Tag File Example</h1>
    <hr>
    <p>Panel tag created from JSP fragment file in WEB-INF/tags
    <hr>
    <table border="0">
      <tr valign="top">
        <td>
          <acme:panel color="#ff8080" bgcolor="#ffc0c0" title="Panel 1">
            First panel.<br/>
          </acme:panel>
        </td>
        <td>
          <acme:panel color="#80ff80" bgcolor="#c0ffc0" title="Panel 2">
            Second panel.<br/>
            Second panel.<br/>
            Second panel.<br/>
            Second panel.<br/>
          </acme:panel>
        </td>
        <td>
          <acme:panel color="#8080ff" bgcolor="#c0c0ff" title="Panel 3">
            Third panel.<br/>
            <acme:panel color="#ff80ff" bgcolor="#ffc0ff" title="Inner">
              A panel in a panel.
            </acme:panel>
            Third panel.<br/>
          </acme:panel>
        </td>
      </tr>
    </table>
  </body>
</html>
