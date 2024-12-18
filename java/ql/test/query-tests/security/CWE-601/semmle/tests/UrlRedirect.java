// Test case for
// CWE-601: URL Redirection to Untrusted Site ('Open Redirect')
// http://cwe.mitre.org/data/definitions/601.html

package test.cwe601.cwe.examples;




import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UrlRedirect extends HttpServlet {
	private static final String VALID_REDIRECT = "http://cwe.mitre.org/data/definitions/601.html";
	private static final String LOCATION_HEADER_KEY = "Location";

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		// BAD: a request parameter is incorporated without validation into a URL redirect
		response.sendRedirect(request.getParameter("target"));

		// GOOD: the request parameter is validated against a known fixed string
		if (VALID_REDIRECT.equals(request.getParameter("target"))) {
			response.sendRedirect(VALID_REDIRECT);
		}
		
		// BAD: the user attempts to clean the string, but this will fail
		// if the argument is "hthttp://tp://malicious.com"
		response.sendRedirect(weakCleanup(request.getParameter("target")));
		
		// GOOD: the user input is not used in a position that allows it to dictate
		// the target of the redirect
		response.sendRedirect("http://example.com?username=" + request.getParameter("username"));
		
		// BAD: set the "Location" header
		response.setHeader("Location", request.getParameter("target"));

		// BAD: set the "Location" header
		response.addHeader(LOCATION_HEADER_KEY, request.getParameter("target"));
	}
	
	public String weakCleanup(String input) {
		return input.replaceAll("http://", "");
	}
}
