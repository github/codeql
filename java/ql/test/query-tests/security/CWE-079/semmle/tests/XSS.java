// Test case for
// CWE-079: Improper Neutralization of Input During Web Page Generation ('Cross-site Scripting')
// http://cwe.mitre.org/data/definitions/79.html

package test.cwe079.cwe.examples;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class XSS extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// BAD: a request parameter is written directly to the Servlet response stream
		response.getWriter()
				.print("The page \"" + request.getParameter("page") + "\" was not found."); // $xss

		// GOOD: servlet API encodes the error message HTML for the HTML context
		response.sendError(HttpServletResponse.SC_NOT_FOUND,
				"The page \"" + request.getParameter("page") + "\" was not found.");

		// GOOD: escape HTML characters first
		response.sendError(HttpServletResponse.SC_NOT_FOUND,
				"The page \"" + encodeForHtml(request.getParameter("page")) + "\" was not found.");

		// GOOD: servlet API encodes the error message HTML for the HTML context
		response.sendError(HttpServletResponse.SC_NOT_FOUND,
				"The page \"" + capitalizeName(request.getParameter("page")) + "\" was not found.");

		// BAD: outputting the path of the resource
		response.getWriter().print("The path section of the URL was " + request.getPathInfo()); // $xss

		// BAD: typical XSS, this time written to an OutputStream instead of a Writer
		response.getOutputStream().write(request.getPathInfo().getBytes()); // $xss

		// GOOD: sanitizer
		response.getOutputStream().write(hudson.Util.escape(request.getPathInfo()).getBytes()); // safe
	}

	/**
	 * Replace special characters in the given text such that it can be inserted into an HTML file
	 * and not be interpreted as including any HTML tags.
	 */
	static String encodeForHtml(String text) {
		// This is just a stub. For an example of a real implementation, see
		// the OWASP Java Encoder Project.
		return text.replace("<", "&lt;");
	}

	static String capitalizeName(String text) {
		return text.replace("foo inc", "Foo, Inc.");
	}
}
