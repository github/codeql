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

import org.springframework.web.client.RestTemplate;

public class SpringRestTemplateBad extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException, MalformedURLException {
       RestTemplate template = new RestTemplate();
       template.getForEntity("", Entity.class);
	}

    static class Entity {}
}
