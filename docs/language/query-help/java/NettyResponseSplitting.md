# Disabled Netty HTTP header validation

```
ID: java/netty-http-response-splitting
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-113

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-113/NettyResponseSplitting.ql)

Directly writing user input (for example, an HTTP request parameter) to an HTTP header can lead to an HTTP response-splitting vulnerability. If the user input includes blank lines in it, and if the servlet container does not itself escape the blank lines, then a remote user can cause the response to turn into two separate responses, one of which is controlled by the remote user.


## Recommendation
Guard against HTTP header splitting in the same way as guarding against cross-site scripting. Before passing any data into HTTP headers, either check the data for special characters, or escape any special characters that are present.


## Example
The following example shows the 'name' parameter being written to a cookie in two different ways. The first way writes it directly to the cookie, and thus is vulnerable to response-splitting attacks. The second way first removes all special characters, thus avoiding the potential problem.


```java
public class ResponseSplitting extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		// BAD: setting a cookie with an unvalidated parameter
		Cookie cookie = new Cookie("name", request.getParameter("name"));
		response.addCookie(cookie);

		// GOOD: remove special characters before putting them in the header
		String name = removeSpecial(request.getParameter("name"));
		Cookie cookie2 = new Cookie("name", name);
		response.addCookie(cookie2);
	}

	private static String removeSpecial(String str) {
		return str.replaceAll("[^a-zA-Z ]", "");
	}
}

```

## Example
The following example shows the use of the library 'netty' with HTTP response-splitting verification configurations. The second way will verify the parameters before using them to build the HTTP response.


```java
import io.netty.handler.codec.http.DefaultHttpHeaders;

public class ResponseSplitting {
    // BAD: Disables the internal response splitting verification
    private final DefaultHttpHeaders badHeaders = new DefaultHttpHeaders(false);

    // GOOD: Verifies headers passed don't contain CRLF characters
    private final DefaultHttpHeaders goodHeaders = new DefaultHttpHeaders();

    // BAD: Disables the internal response splitting verification
    private final DefaultHttpResponse badResponse = new DefaultHttpResponse(version, httpResponseStatus, false);

    // GOOD: Verifies headers passed don't contain CRLF characters
    private final DefaultHttpResponse goodResponse = new DefaultHttpResponse(version, httpResponseStatus);
}

```

## References
* InfosecWriters: [HTTP response splitting](http://www.infosecwriters.com/Papers/DCrab_HTTP_Response.pdf).
* OWASP: [HTTP Response Splitting](https://www.owasp.org/index.php/HTTP_Response_Splitting).
* Wikipedia: [HTTP response splitting](http://en.wikipedia.org/wiki/HTTP_response_splitting).
* Common Weakness Enumeration: [CWE-113](https://cwe.mitre.org/data/definitions/113.html).