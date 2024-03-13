// Test case for
// CWE-601: URL Redirection to Untrusted Site ('Open Redirect')
// http://cwe.mitre.org/data/definitions/601.html

package test.cwe601.cwe.examples;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.net.URI;
import java.net.URISyntaxException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UrlRedirect2 extends HttpServlet {
  private static final List<String> VALID_REDIRECTS = Arrays.asList(
    "http://cwe.mitre.org/data/definitions/601.html",
    "http://cwe.mitre.org/data/definitions/79.html"
  );

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		// BAD: a request parameter is incorporated without validation into a URL redirect
		response.sendRedirect(request.getParameter("target"));

    // GOOD: the request parameter is validated against a known list of strings
    String target = request.getParameter("target");
    if (VALID_REDIRECTS.contains(target)) {
        response.sendRedirect(target);
    }

    try {
      String urlString = request.getParameter("page");
      URI url = new URI(urlString);

      if (!url.isAbsolute()) {
        // GOOD: The redirect is to a relative URL
        response.sendRedirect(url.toString());
      }

      if ("example.org".equals(url.getHost())) {
        // GOOD: The redirect is to a known host
        response.sendRedirect(url.toString());
      }
    } catch (URISyntaxException e) {
        // handle exception
    }
	}
}
