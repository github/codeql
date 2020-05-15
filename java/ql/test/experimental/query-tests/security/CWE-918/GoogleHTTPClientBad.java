// Test case for
// CWE-918: Server-Side Request Forgery (SSRF)
// https://cwe.mitre.org/data/definitions/918.html

package test.cwe918.cwe.examples;

import com.google.api.client.http.GenericUrl;
import com.google.api.client.http.HttpRequest;
import com.google.api.client.http.HttpRequestFactory;
import com.google.api.client.http.HttpTransport;

import java.io.IOException;
import java.lang.Integer;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URI;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class GoogleHTTPClientBad extends HttpServlet {
    private static final HttpTransport HTTP_TRANSPORT;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException, MalformedURLException {
        HttpRequestFactory factory = HTTP_TRANSPORT.createRequestFactory();

        GenericUrl genericUrl = new GenericUrl(request.getParameter("webhook"));
        HttpRequest httpRequest = factory.buildPostRequest(genericUrl, null);
        httpRequest.execute();

        genericUrl = new GenericUrl(request.getParameter("webhook"), true);
        httpRequest = factory.buildPostRequest(genericUrl, null);
        httpRequest.execute();

        URL url = new URL(request.getParameter("webhook"));
        genericUrl = new GenericUrl(url);
        httpRequest = factory.buildPostRequest(genericUrl, null);
        httpRequest.execute();

        url = new URL(request.getParameter("webhook"));
        genericUrl = new GenericUrl(url, false);
        httpRequest = factory.buildPostRequest(genericUrl, null);
        httpRequest.execute();

        URI uri = URI.create(request.getParameter("webhook"));
        genericUrl = new GenericUrl(uri);
        httpRequest = factory.buildPostRequest(genericUrl, null);
        httpRequest.execute();

        uri = URI.create(request.getParameter("webhook"));
        genericUrl = new GenericUrl(uri, true);
        httpRequest = factory.buildPostRequest(genericUrl, null);
        httpRequest.execute();

        genericUrl = new GenericUrl();
        genericUrl.setHost(request.getParameter("webhook"));
        httpRequest = factory.buildPostRequest(genericUrl, null);
        httpRequest.execute();

        httpRequest = factory.buildPostRequest(null, null);
        httpRequest.setUrl(genericUrl);
        httpRequest.execute();

        factory.buildRequest("GET", genericUrl, null).execute();
        factory.buildDeleteRequest(genericUrl).execute();
        factory.buildGetRequest(genericUrl).execute();
        factory.buildPostRequest(genericUrl, null).execute();
        factory.buildPutRequest(genericUrl, null).execute();
        factory.buildPatchRequest(genericUrl, null).execute();
        factory.buildHeadRequest(genericUrl).execute();
	}
}
