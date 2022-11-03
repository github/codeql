// Test case for
// CWE-113: Improper Neutralization of CRLF Sequences in HTTP Headers ('HTTP Response Splitting')
// http://cwe.mitre.org/data/definitions/113.html

package test.cwe113.cwe.examples;



import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ResponseSplitting extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		// BAD: setting a cookie with an unvalidated parameter
		// can lead to HTTP splitting
		{
			Cookie cookie = new Cookie("name", request.getParameter("name"));
			response.addCookie(cookie);
		}

		// BAD: setting a header with an unvalidated parameter
		// can lead to HTTP splitting
		response.addHeader("Content-type", request.getParameter("contentType"));
		response.setHeader("Content-type", request.getParameter("contentType"));

		// GOOD: remove special characters before putting them in the header
		{
			String name = removeSpecial(request.getParameter("name"));
			Cookie cookie = new Cookie("name", name);
			response.addCookie(cookie);
		}

		// GOOD: Splicing headers into other headers cannot cause splitting
		response.setHeader("Access-Control-Allow-Origin", request.getHeader("Origin"));
	}

	private static String removeSpecial(String str) {
		return str.replaceAll("[^a-zA-Z ]", "");
	}

	public void addCookieName(HttpServletResponse response, Cookie cookie) {
		// GOOD: cookie.getName() cannot lead to HTTP splitting
		Cookie cookie2 = new Cookie("name", cookie.getName());
		response.addCookie(cookie2);
	}
}
