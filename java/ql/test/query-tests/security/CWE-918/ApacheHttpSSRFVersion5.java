import java.io.IOException;
import java.net.URI;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.Method;
import org.apache.hc.core5.http.impl.bootstrap.HttpAsyncRequester;
import org.apache.hc.core5.http.impl.io.DefaultClassicHttpRequestFactory;
import org.apache.hc.core5.http.impl.nio.DefaultHttpRequestFactory;
import org.apache.hc.core5.http.io.support.ClassicRequestBuilder;
import org.apache.hc.core5.http.message.BasicClassicHttpRequest;
import org.apache.hc.core5.http.message.BasicHttpRequest;
import org.apache.hc.core5.http.message.HttpRequestWrapper;
import org.apache.hc.client5.http.async.methods.BasicHttpRequests;
import org.apache.hc.client5.http.async.methods.ConfigurableHttpRequest;
import org.apache.hc.client5.http.async.methods.SimpleHttpRequest;
import org.apache.hc.client5.http.async.methods.SimpleHttpRequests;
import org.apache.hc.client5.http.async.methods.SimpleRequestBuilder;
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

public class ApacheHttpSSRFVersion5 extends HttpServlet {

    // org.apache.hc.client5.http.async.methods
    protected void doGet1(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String uriSink = request.getParameter("uri"); // $ Source
            URI uri = new URI(uriSink);

            String hostSink = request.getParameter("host"); // $ Source
            HttpHost host = new HttpHost(hostSink);

            // org.apache.hc.client5.http.async.methods.BasicHttpRequests
            BasicHttpRequests.create(Method.CONNECT, host, "path"); // $ Alert
            BasicHttpRequests.create(Method.CONNECT, uri.toString()); // $ Alert
            BasicHttpRequests.create(Method.CONNECT, uri); // $ Alert
            BasicHttpRequests.create("method", uri.toString()); // $ Alert
            BasicHttpRequests.create("method", uri); // $ Alert

            BasicHttpRequests.delete(host, "path"); // $ Alert
            BasicHttpRequests.delete(uri.toString()); // $ Alert
            BasicHttpRequests.delete(uri); // $ Alert

            BasicHttpRequests.get(host, "path"); // $ Alert
            BasicHttpRequests.get(uri.toString()); // $ Alert
            BasicHttpRequests.get(uri); // $ Alert

            BasicHttpRequests.head(host, "path"); // $ Alert
            BasicHttpRequests.head(uri.toString()); // $ Alert
            BasicHttpRequests.head(uri); // $ Alert

            BasicHttpRequests.options(host, "path"); // $ Alert
            BasicHttpRequests.options(uri.toString()); // $ Alert
            BasicHttpRequests.options(uri); // $ Alert

            BasicHttpRequests.patch(host, "path"); // $ Alert
            BasicHttpRequests.patch(uri.toString()); // $ Alert
            BasicHttpRequests.patch(uri); // $ Alert

            BasicHttpRequests.post(host, "path"); // $ Alert
            BasicHttpRequests.post(uri.toString()); // $ Alert
            BasicHttpRequests.post(uri); // $ Alert

            BasicHttpRequests.put(host, "path"); // $ Alert
            BasicHttpRequests.put(uri.toString()); // $ Alert
            BasicHttpRequests.put(uri); // $ Alert

            BasicHttpRequests.trace(host, "path"); // $ Alert
            BasicHttpRequests.trace(uri.toString()); // $ Alert
            BasicHttpRequests.trace(uri); // $ Alert

            // org.apache.hc.client5.http.async.methods.ConfigurableHttpRequest
            new ConfigurableHttpRequest("method", host, "path"); // $ Alert
            new ConfigurableHttpRequest("method", uri); // $ Alert

            // org.apache.hc.client5.http.async.methods.SimpleHttpRequest
            new SimpleHttpRequest(Method.CONNECT, host, "path"); // $ Alert
            new SimpleHttpRequest(Method.CONNECT, uri); // $ Alert
            new SimpleHttpRequest("method", host, "path"); // $ Alert
            new SimpleHttpRequest("method", uri); // $ Alert

            SimpleHttpRequest.create(Method.CONNECT, host, "path"); // $ Alert
            SimpleHttpRequest.create(Method.CONNECT, uri); // $ Alert
            SimpleHttpRequest.create("method", uri.toString()); // $ Alert
            SimpleHttpRequest.create("method", uri); // $ Alert

            // org.apache.hc.client5.http.async.methods.SimpleHttpRequests
            SimpleHttpRequests.create(Method.CONNECT, host, "path"); // $ Alert
            SimpleHttpRequests.create(Method.CONNECT, uri.toString()); // $ Alert
            SimpleHttpRequests.create(Method.CONNECT, uri); // $ Alert
            SimpleHttpRequests.create("method", uri.toString()); // $ Alert
            SimpleHttpRequests.create("method", uri); // $ Alert

            SimpleHttpRequests.delete(host, "path"); // $ Alert
            SimpleHttpRequests.delete(uri.toString()); // $ Alert
            SimpleHttpRequests.delete(uri); // $ Alert

            SimpleHttpRequests.get(host, "path"); // $ Alert
            SimpleHttpRequests.get(uri.toString()); // $ Alert
            SimpleHttpRequests.get(uri); // $ Alert

            SimpleHttpRequests.head(host, "path"); // $ Alert
            SimpleHttpRequests.head(uri.toString()); // $ Alert
            SimpleHttpRequests.head(uri); // $ Alert

            SimpleHttpRequests.options(host, "path"); // $ Alert
            SimpleHttpRequests.options(uri.toString()); // $ Alert
            SimpleHttpRequests.options(uri); // $ Alert

            SimpleHttpRequests.patch(host, "path"); // $ Alert
            SimpleHttpRequests.patch(uri.toString()); // $ Alert
            SimpleHttpRequests.patch(uri); // $ Alert

            SimpleHttpRequests.post(host, "path"); // $ Alert
            SimpleHttpRequests.post(uri.toString()); // $ Alert
            SimpleHttpRequests.post(uri); // $ Alert

            SimpleHttpRequests.put(host, "path"); // $ Alert
            SimpleHttpRequests.put(uri.toString()); // $ Alert
            SimpleHttpRequests.put(uri); // $ Alert

            SimpleHttpRequests.trace(host, "path"); // $ Alert
            SimpleHttpRequests.trace(uri.toString()); // $ Alert
            SimpleHttpRequests.trace(uri); // $ Alert

            // org.apache.hc.client5.http.async.methods.SimpleRequestBuilder
            SimpleRequestBuilder.delete(uri.toString()); // $ Alert
            SimpleRequestBuilder.delete(uri); // $ Alert

            SimpleRequestBuilder.get(uri.toString()); // $ Alert
            SimpleRequestBuilder.get(uri); // $ Alert

            SimpleRequestBuilder.head(uri.toString()); // $ Alert
            SimpleRequestBuilder.head(uri); // $ Alert

            SimpleRequestBuilder.options(uri.toString()); // $ Alert
            SimpleRequestBuilder.options(uri); // $ Alert

            SimpleRequestBuilder.patch(uri.toString()); // $ Alert
            SimpleRequestBuilder.patch(uri); // $ Alert

            SimpleRequestBuilder.post(uri.toString()); // $ Alert
            SimpleRequestBuilder.post(uri); // $ Alert

            SimpleRequestBuilder.put(uri.toString()); // $ Alert
            SimpleRequestBuilder.put(uri); // $ Alert

            SimpleRequestBuilder.get().setHttpHost(host); // $ Alert

            SimpleRequestBuilder.get().setUri(uri.toString()); // $ Alert
            SimpleRequestBuilder.get().setUri(uri); // $ Alert

            SimpleRequestBuilder.trace(uri.toString()); // $ Alert
            SimpleRequestBuilder.trace(uri); // $ Alert

        } catch (Exception e) {
            // TODO: handle exception
        }
    }

    // org.apache.hc.client5.http.classic.methods
    protected void doGet2(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String uriSink = request.getParameter("uri"); // $ Source
            URI uri = new URI(uriSink);

            // org.apache.hc.client5.http.classic.methods.ClassicHttpRequests
            ClassicHttpRequests.create(Method.CONNECT, uri.toString()); // $ Alert
            ClassicHttpRequests.create(Method.CONNECT, uri); // $ Alert
            ClassicHttpRequests.create("method", uri.toString()); // $ Alert
            ClassicHttpRequests.create("method", uri); // $ Alert

            ClassicHttpRequests.delete(uri.toString()); // $ Alert
            ClassicHttpRequests.delete(uri); // $ Alert

            ClassicHttpRequests.get(uri.toString()); // $ Alert
            ClassicHttpRequests.get(uri); // $ Alert

            ClassicHttpRequests.head(uri.toString()); // $ Alert
            ClassicHttpRequests.head(uri); // $ Alert

            ClassicHttpRequests.options(uri.toString()); // $ Alert
            ClassicHttpRequests.options(uri); // $ Alert

            ClassicHttpRequests.patch(uri.toString()); // $ Alert
            ClassicHttpRequests.patch(uri); // $ Alert

            ClassicHttpRequests.post(uri.toString()); // $ Alert
            ClassicHttpRequests.post(uri); // $ Alert

            ClassicHttpRequests.put(uri.toString()); // $ Alert
            ClassicHttpRequests.put(uri); // $ Alert

            ClassicHttpRequests.trace(uri.toString()); // $ Alert
            ClassicHttpRequests.trace(uri); // $ Alert

            // org.apache.hc.client5.http.classic.methods.HttpDelete through HttpTrace
            new HttpDelete(uri.toString()); // $ Alert
            new HttpDelete(uri); // $ Alert

            new HttpGet(uri.toString()); // $ Alert
            new HttpGet(uri); // $ Alert

            new HttpHead(uri.toString()); // $ Alert
            new HttpHead(uri); // $ Alert

            new HttpOptions(uri.toString()); // $ Alert
            new HttpOptions(uri); // $ Alert

            new HttpPatch(uri.toString()); // $ Alert
            new HttpPatch(uri); // $ Alert

            new HttpPost(uri.toString()); // $ Alert
            new HttpPost(uri); // $ Alert

            new HttpPut(uri.toString()); // $ Alert
            new HttpPut(uri); // $ Alert

            new HttpTrace(uri.toString()); // $ Alert
            new HttpTrace(uri); // $ Alert

            // org.apache.hc.client5.http.classic.methods.HttpUriRequestBase
            new HttpUriRequestBase("method", uri); // $ Alert

        } catch (Exception e) {
            // TODO: handle exception
        }
    }

    // org.apache.hc.client5.http.fluent
    protected void doGet3(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String uriSink = request.getParameter("uri"); // $ Source
            URI uri = new URI(uriSink);

            // org.apache.hc.client5.http.fluent.Request
            Request.create(Method.CONNECT, uri); // $ Alert
            Request.create("method", uri.toString()); // $ Alert
            Request.create("method", uri); // $ Alert

            Request.delete(uri.toString()); // $ Alert
            Request.delete(uri); // $ Alert

            Request.get(uri.toString()); // $ Alert
            Request.get(uri); // $ Alert

            Request.head(uri.toString()); // $ Alert
            Request.head(uri); // $ Alert

            Request.options(uri.toString()); // $ Alert
            Request.options(uri); // $ Alert

            Request.patch(uri.toString()); // $ Alert
            Request.patch(uri); // $ Alert

            Request.post(uri.toString()); // $ Alert
            Request.post(uri); // $ Alert

            Request.put(uri.toString()); // $ Alert
            Request.put(uri); // $ Alert

            Request.trace(uri.toString()); // $ Alert
            Request.trace(uri); // $ Alert

        } catch (Exception e) {
            // TODO: handle exception
        }
    }

    // org.apache.hc.core5.http.impl.bootstrap
    // org.apache.hc.core5.http.impl.io
    // org.apache.hc.core5.http.impl.nio
    protected void doGet4(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String uriSink = request.getParameter("uri"); // $ Source
            URI uri = new URI(uriSink);

            String hostSink = request.getParameter("host"); // $ Source
            HttpHost host = new HttpHost(hostSink);

            // org.apache.hc.core5.http.impl.bootstrap
            HttpAsyncRequester httpAsyncReq = new HttpAsyncRequester(null, null, null, null, null, null);
            httpAsyncReq.connect(host, null); // $ Alert
            httpAsyncReq.connect(host, null, null, null); // $ Alert

            // org.apache.hc.core5.http.impl.io
            DefaultClassicHttpRequestFactory defClassicHttpReqFact = new DefaultClassicHttpRequestFactory();
            defClassicHttpReqFact.newHttpRequest("method", uri.toString()); // $ Alert
            defClassicHttpReqFact.newHttpRequest("method", uri); // $ Alert

            // org.apache.hc.core5.http.impl.nio
            DefaultHttpRequestFactory defHttpReqFact = new DefaultHttpRequestFactory();
            defHttpReqFact.newHttpRequest("method", uri.toString()); // $ Alert
            defHttpReqFact.newHttpRequest("method", uri); // $ Alert

        } catch (Exception e) {
            // TODO: handle exception
        }
    }

    // org.apache.hc.core5.http.io.support
    protected void doGet5(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String uriSink = request.getParameter("uri"); // $ Source
            URI uri = new URI(uriSink);

            String hostSink = request.getParameter("host"); // $ Source
            HttpHost host = new HttpHost(hostSink);

            // org.apache.hc.core5.http.io.support.ClassicRequestBuilder
            ClassicRequestBuilder.delete(uri.toString()); // $ Alert
            ClassicRequestBuilder.delete(uri); // $ Alert

            ClassicRequestBuilder.get(uri.toString()); // $ Alert
            ClassicRequestBuilder.get(uri); // $ Alert

            ClassicRequestBuilder.head(uri.toString()); // $ Alert
            ClassicRequestBuilder.head(uri); // $ Alert

            ClassicRequestBuilder.options(uri.toString()); // $ Alert
            ClassicRequestBuilder.options(uri); // $ Alert

            ClassicRequestBuilder.patch(uri.toString()); // $ Alert
            ClassicRequestBuilder.patch(uri); // $ Alert

            ClassicRequestBuilder.post(uri.toString()); // $ Alert
            ClassicRequestBuilder.post(uri); // $ Alert

            ClassicRequestBuilder.put(uri.toString()); // $ Alert
            ClassicRequestBuilder.put(uri); // $ Alert

            ClassicRequestBuilder.get().setHttpHost(host); // $ Alert

            ClassicRequestBuilder.get().setUri(uri.toString()); // $ Alert
            ClassicRequestBuilder.get().setUri(uri); // $ Alert

            ClassicRequestBuilder.trace(uri.toString()); // $ Alert
            ClassicRequestBuilder.trace(uri); // $ Alert

        } catch (Exception e) {
            // TODO: handle exception
        }
    }

    // org.apache.hc.core5.http.message
    protected void doGet6(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String uriSink = request.getParameter("uri"); // $ Source
            URI uri = new URI(uriSink);

            String hostSink = request.getParameter("host"); // $ Source
            HttpHost host = new HttpHost(hostSink);

            // BasicClassicHttpRequest
            new BasicClassicHttpRequest(Method.CONNECT, host, "path"); // $ Alert
            new BasicClassicHttpRequest(Method.CONNECT, uri); // $ Alert
            new BasicClassicHttpRequest("method", host, "path"); // $ Alert
            new BasicClassicHttpRequest("method", uri); // $ Alert

            // BasicHttpRequest
            new BasicHttpRequest(Method.CONNECT, host, "path"); // $ Alert
            new BasicHttpRequest(Method.CONNECT, uri); // $ Alert
            new BasicHttpRequest("method", host, "path"); // $ Alert
            new BasicHttpRequest("method", uri); // $ Alert
            BasicHttpRequest bhr = new BasicHttpRequest("method", "path");
            bhr.setUri(uri); // $ Alert

            // HttpRequestWrapper
            HttpRequestWrapper hrw = new HttpRequestWrapper(null);
            hrw.setUri(uri); // $ Alert

        } catch (Exception e) {
            // TODO: handle exception
        }
    }

}
