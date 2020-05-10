// Test case for
// CWE-918: Server-Side Request Forgery (SSRF)
// https://cwe.mitre.org/data/definitions/918.html

package test.cwe918.cwe.examples;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RequestForgery extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException, MalformedURLException {
        // BAD: openConnection called on URL constructed from remote source
		URL url = new URL(request.getParameter("webhook"));
        URLConnection connection = url.openConnection();

		// BAD: openConnection called on URL with hostname constructed from remote source
		url = new URL("https://" + request.getParameter("webhook") + ".domain.com/webhook");
		connection = url.openConnection();

		// GOOD: openConnection called on URL with hostname controlled by server
		String domain;
		if (request.getParameter("webhook") == "github") {
			domain = "github.com";
		} else {
			domain = "fallback.com";
		}
		url = new URL("https://" + domain + "/webhook");
		connection = url.openConnection();
	}
}
