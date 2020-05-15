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

public class JavaURLGood extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException, MalformedURLException {
		// host of spec parameter controlled by server
		String domain;
		if (request.getParameter("webhook").equals("github")) {
			domain = "github.com";
		} else {
			domain = "fallback.com";
		}
		URL url = new URL("https://" + domain + "/webhook");
		URLConnection connection = url.openConnection();

        // only suffix of URL spec controlled by remote source
		url = new URL("https://domain.com/activate?webhook=" + request.getParameter("webhook"));
		connection = url.openConnection();

		// only prefix of URL host controlled by remote source
		url = new URL("https", request.getParameter("webhook") + ".safe.com", "webhook");
		connection = url.openConnection();
	}
}
