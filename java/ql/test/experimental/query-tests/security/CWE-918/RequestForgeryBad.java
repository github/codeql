// Test case for
// CWE-918: Server-Side Request Forgery (SSRF)
// https://cwe.mitre.org/data/definitions/918.html

package test.cwe918.cwe.examples;

import java.io.IOException;
import java.lang.Integer;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RequestForgeryBad extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException, MalformedURLException {
        // spec parameter constructed from remote source
		URL url = new URL(request.getParameter("webhook"));
        URLConnection connection = url.openConnection();

		// host of spec parameter constructed from remote source
		url = new URL("https://" + request.getParameter("webhook") + ".domain.com/webhook");
		connection = url.openConnection();

		// spec parameter constructed from remote source with context URL
		URL context = new URL("https://safe.domain.com");
		url = new URL(context, request.getParameter("webhook"));
		connection = url.openConnection();

		// host parameter constructed from remote source
		url = new URL("https", request.getParameter("webhook"), 8080, "webhook");
		connection = url.openConnection();

		// host parameter constructed from remote source
		url = new URL("https", request.getParameter("webhook"), "webhook");
		connection = url.openConnection();
	}
}
