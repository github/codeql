import java.io.IOException;
import java.net.URI;

import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.Method;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// org.apache.hc.client5.http.async.methods
import org.apache.hc.client5.http.async.methods.BasicHttpRequests;
import org.apache.hc.client5.http.async.methods.ConfigurableHttpRequest;
import org.apache.hc.client5.http.async.methods.SimpleHttpRequest;
import org.apache.hc.client5.http.async.methods.SimpleHttpRequests;
import org.apache.hc.client5.http.async.methods.SimpleRequestBuilder;

// org.apache.hc.client5.http.classic.methods
import org.apache.hc.client5.http.classic.methods.ClassicHttpRequests;
import org.apache.hc.client5.http.classic.methods.HttpDelete;
import org.apache.hc.client5.http.classic.methods.HttpGet;
import org.apache.hc.client5.http.classic.methods.HttpHead;
import org.apache.hc.client5.http.classic.methods.HttpOptions;
import org.apache.hc.client5.http.classic.methods.HttpPatch;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.classic.methods.HttpPut;
import org.apache.hc.client5.http.classic.methods.HttpTrace;
import org.apache.hc.client5.http.classic.methods.HttpUriRequestBase;

import org.apache.hc.client5.http.fluent.Request;
// import org.apache.hc.client5.http.protocol.RedirectLocations;
// import org.apache.hc.client5.http.utils.URIUtils;

public class ApacheHttp5SSRF extends HttpServlet {

    // org.apache.hc.client5.http.async.methods
    protected void doGet1(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String uriSink = request.getParameter("uri");
            URI uri = new URI(uriSink);

            String hostSink = request.getParameter("host");
            HttpHost host = new HttpHost(hostSink);

            // org.apache.hc.client5.http.async.methods.BasicHttpRequests
            BasicHttpRequests.create(Method.CONNECT, host, "path"); // $ SSRF
            BasicHttpRequests.create(Method.CONNECT, uri.toString()); // $ SSRF
            BasicHttpRequests.create(Method.CONNECT, uri); // $ SSRF
            BasicHttpRequests.create("method", uri.toString()); // $ SSRF
            BasicHttpRequests.create("method", uri); // $ SSRF

            BasicHttpRequests.delete(host, "path"); // $ SSRF
            BasicHttpRequests.delete(uri.toString()); // $ SSRF
            BasicHttpRequests.delete(uri); // $ SSRF

            BasicHttpRequests.get(host, "path"); // $ SSRF
            BasicHttpRequests.get(uri.toString()); // $ SSRF
            BasicHttpRequests.get(uri); // $ SSRF

            BasicHttpRequests.head(host, "path"); // $ SSRF
            BasicHttpRequests.head(uri.toString()); // $ SSRF
            BasicHttpRequests.head(uri); // $ SSRF

            BasicHttpRequests.options(host, "path"); // $ SSRF
            BasicHttpRequests.options(uri.toString()); // $ SSRF
            BasicHttpRequests.options(uri); // $ SSRF

            BasicHttpRequests.patch(host, "path"); // $ SSRF
            BasicHttpRequests.patch(uri.toString()); // $ SSRF
            BasicHttpRequests.patch(uri); // $ SSRF

            BasicHttpRequests.post(host, "path"); // $ SSRF
            BasicHttpRequests.post(uri.toString()); // $ SSRF
            BasicHttpRequests.post(uri); // $ SSRF

            BasicHttpRequests.put(host, "path"); // $ SSRF
            BasicHttpRequests.put(uri.toString()); // $ SSRF
            BasicHttpRequests.put(uri); // $ SSRF

            BasicHttpRequests.trace(host, "path"); // $ SSRF
            BasicHttpRequests.trace(uri.toString()); // $ SSRF
            BasicHttpRequests.trace(uri); // $ SSRF

            // org.apache.hc.client5.http.async.methods.ConfigurableHttpRequest
            new ConfigurableHttpRequest("method", host, "path"); // $ SSRF
            new ConfigurableHttpRequest("method", uri); // $ SSRF

            // org.apache.hc.client5.http.async.methods.SimpleHttpRequest
            new SimpleHttpRequest(Method.CONNECT, host, "path"); // $ SSRF
            new SimpleHttpRequest(Method.CONNECT, uri); // $ SSRF
            new SimpleHttpRequest("method", host, "path"); // $ SSRF
            new SimpleHttpRequest("method", uri); // $ SSRF

            SimpleHttpRequest.create(Method.CONNECT, host, "path"); // $ SSRF
            SimpleHttpRequest.create(Method.CONNECT, uri); // $ SSRF
            SimpleHttpRequest.create("method", uri.toString()); // $ SSRF
            SimpleHttpRequest.create("method", uri); // $ SSRF

            // org.apache.hc.client5.http.async.methods.SimpleHttpRequests
            SimpleHttpRequests.create(Method.CONNECT, host, "path"); // $ SSRF
            SimpleHttpRequests.create(Method.CONNECT, uri.toString()); // $ SSRF
            SimpleHttpRequests.create(Method.CONNECT, uri); // $ SSRF
            SimpleHttpRequests.create("method", uri.toString()); // $ SSRF
            SimpleHttpRequests.create("method", uri); // $ SSRF

            SimpleHttpRequests.delete(host, "path"); // $ SSRF
            SimpleHttpRequests.delete(uri.toString()); // $ SSRF
            SimpleHttpRequests.delete(uri); // $ SSRF

            SimpleHttpRequests.get(host, "path"); // $ SSRF
            SimpleHttpRequests.get(uri.toString()); // $ SSRF
            SimpleHttpRequests.get(uri); // $ SSRF

            SimpleHttpRequests.head(host, "path"); // $ SSRF
            SimpleHttpRequests.head(uri.toString()); // $ SSRF
            SimpleHttpRequests.head(uri); // $ SSRF

            SimpleHttpRequests.options(host, "path"); // $ SSRF
            SimpleHttpRequests.options(uri.toString()); // $ SSRF
            SimpleHttpRequests.options(uri); // $ SSRF

            SimpleHttpRequests.patch(host, "path"); // $ SSRF
            SimpleHttpRequests.patch(uri.toString()); // $ SSRF
            SimpleHttpRequests.patch(uri); // $ SSRF

            SimpleHttpRequests.post(host, "path"); // $ SSRF
            SimpleHttpRequests.post(uri.toString()); // $ SSRF
            SimpleHttpRequests.post(uri); // $ SSRF

            SimpleHttpRequests.put(host, "path"); // $ SSRF
            SimpleHttpRequests.put(uri.toString()); // $ SSRF
            SimpleHttpRequests.put(uri); // $ SSRF

            SimpleHttpRequests.trace(host, "path"); // $ SSRF
            SimpleHttpRequests.trace(uri.toString()); // $ SSRF
            SimpleHttpRequests.trace(uri); // $ SSRF

            // org.apache.hc.client5.http.async.methods.SimpleRequestBuilder
            SimpleRequestBuilder.delete(uri.toString()); // $ SSRF
            SimpleRequestBuilder.delete(uri); // $ SSRF

            SimpleRequestBuilder.get(uri.toString()); // $ SSRF
            SimpleRequestBuilder.get(uri); // $ SSRF

            SimpleRequestBuilder.head(uri.toString()); // $ SSRF
            SimpleRequestBuilder.head(uri); // $ SSRF

            SimpleRequestBuilder.options(uri.toString()); // $ SSRF
            SimpleRequestBuilder.options(uri); // $ SSRF

            SimpleRequestBuilder.patch(uri.toString()); // $ SSRF
            SimpleRequestBuilder.patch(uri); // $ SSRF

            SimpleRequestBuilder.post(uri.toString()); // $ SSRF
            SimpleRequestBuilder.post(uri); // $ SSRF

            SimpleRequestBuilder.put(uri.toString()); // $ SSRF
            SimpleRequestBuilder.put(uri); // $ SSRF

            SimpleRequestBuilder.get().setHttpHost(host); // $ SSRF

            SimpleRequestBuilder.get().setUri(uri.toString()); // $ SSRF
            SimpleRequestBuilder.get().setUri(uri); // $ SSRF

            SimpleRequestBuilder.trace(uri.toString()); // $ SSRF
            SimpleRequestBuilder.trace(uri); // $ SSRF

        } catch (Exception e) {
            // TODO: handle exception
        }
    }

    // org.apache.hc.client5.http.classic.methods
    protected void doGet2(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String uriSink = request.getParameter("uri");
            URI uri = new URI(uriSink);

            // org.apache.hc.client5.http.classic.methods.ClassicHttpRequests
            ClassicHttpRequests.create(Method.CONNECT, uri.toString()); // $ SSRF
            ClassicHttpRequests.create(Method.CONNECT, uri); // $ SSRF
            ClassicHttpRequests.create("method", uri.toString()); // $ SSRF
            ClassicHttpRequests.create("method", uri); // $ SSRF

            ClassicHttpRequests.delete(uri.toString()); // $ SSRF
            ClassicHttpRequests.delete(uri); // $ SSRF

            ClassicHttpRequests.get(uri.toString()); // $ SSRF
            ClassicHttpRequests.get(uri); // $ SSRF

            ClassicHttpRequests.head(uri.toString()); // $ SSRF
            ClassicHttpRequests.head(uri); // $ SSRF

            ClassicHttpRequests.options(uri.toString()); // $ SSRF
            ClassicHttpRequests.options(uri); // $ SSRF

            ClassicHttpRequests.patch(uri.toString()); // $ SSRF
            ClassicHttpRequests.patch(uri); // $ SSRF

            ClassicHttpRequests.post(uri.toString()); // $ SSRF
            ClassicHttpRequests.post(uri); // $ SSRF

            ClassicHttpRequests.put(uri.toString()); // $ SSRF
            ClassicHttpRequests.put(uri); // $ SSRF

            ClassicHttpRequests.trace(uri.toString()); // $ SSRF
            ClassicHttpRequests.trace(uri); // $ SSRF

            // org.apache.hc.client5.http.classic.methods.HttpDelete through HttpTrace
            new HttpDelete(uri.toString()); // $ SSRF
            new HttpDelete(uri); // $ SSRF

            new HttpGet(uri.toString()); // $ SSRF
            new HttpGet(uri); // $ SSRF

            new HttpHead(uri.toString()); // $ SSRF
            new HttpHead(uri); // $ SSRF

            new HttpOptions(uri.toString()); // $ SSRF
            new HttpOptions(uri); // $ SSRF

            new HttpPatch(uri.toString()); // $ SSRF
            new HttpPatch(uri); // $ SSRF

            new HttpPost(uri.toString()); // $ SSRF
            new HttpPost(uri); // $ SSRF

            new HttpPut(uri.toString()); // $ SSRF
            new HttpPut(uri); // $ SSRF

            new HttpTrace(uri.toString()); // $ SSRF
            new HttpTrace(uri); // $ SSRF

            // org.apache.hc.client5.http.classic.methods.HttpUriRequestBase
            new HttpUriRequestBase("method", uri); // $ SSRF

        } catch (Exception e) {
            // TODO: handle exception
        }
    }

    // org.apache.hc.client5.http.fluent
    protected void doGet3(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String uriSink = request.getParameter("uri");
            URI uri = new URI(uriSink);

            // org.apache.hc.client5.http.fluent.Request
            Request.create(Method.CONNECT, uri); // $ SSRF
            Request.create("method", uri.toString()); // $ SSRF
            Request.create("method", uri); // $ SSRF

            Request.delete(uri.toString()); // $ SSRF
            Request.delete(uri); // $ SSRF

            Request.get(uri.toString()); // $ SSRF
            Request.get(uri); // $ SSRF

            Request.head(uri.toString()); // $ SSRF
            Request.head(uri); // $ SSRF

            Request.options(uri.toString()); // $ SSRF
            Request.options(uri); // $ SSRF

            Request.patch(uri.toString()); // $ SSRF
            Request.patch(uri); // $ SSRF

            Request.post(uri.toString()); // $ SSRF
            Request.post(uri); // $ SSRF

            Request.put(uri.toString()); // $ SSRF
            Request.put(uri); // $ SSRF

            Request.trace(uri.toString()); // $ SSRF
            Request.trace(uri); // $ SSRF

        } catch (Exception e) {
            // TODO: handle exception
        }
    }
}
