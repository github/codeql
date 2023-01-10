<html>
<h1>JSP2.0 Expressions</h1>

<table border="1">
  <tr><th>Expression</th><th>Result</th></tr>      
  <tr>
    <td>\${param["A"]}</td>
    <td>${param["A"]}&nbsp;</td>
  </tr><tr>
    <td>\${header["host"]}</td>
    <td>${header["host"]}</td>
  </tr><tr>
    <td>\${header["user-agent"]}</td>
    <td>${header["user-agent"]}</td>
  </tr><tr>
    <td>\${1+1}</td>
    <td>${1+1}</td>
  </tr><tr>
    <td>\${param["A"] * 2}</td>
    <td>${param["A"] * 2}&nbsp;</td>
  </tr>
</table>
</html>
