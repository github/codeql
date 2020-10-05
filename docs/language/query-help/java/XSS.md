# Cross-site scripting

```
ID: java/xss
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-079

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-079/XSS.ql)

Directly writing user input (for example, an HTTP request parameter) to a web page, without properly sanitizing the input first, allows for a cross-site scripting vulnerability.


## Recommendation
To guard against cross-site scripting, consider using contextual output encoding/escaping before writing user input to the page, or one of the other solutions that are mentioned in the reference.


## Example
The following example shows the page parameter being written directly to the server error page, leaving the website vulnerable to cross-site scripting.


```java
public class XSS extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		// BAD: a request parameter is written directly to an error response page
		response.sendError(HttpServletResponse.SC_NOT_FOUND,
				"The page \"" + request.getParameter("page") + "\" was not found.");
	}
}

```

## References
* OWASP: [XSS (Cross Site Scripting) Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html).
* Wikipedia: [Cross-site scripting](http://en.wikipedia.org/wiki/Cross-site_scripting).
* Common Weakness Enumeration: [CWE-79](https://cwe.mitre.org/data/definitions/79.html).