import java.io.IOException;
import java.net.URI;
import java.net.*;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.Proxy.Type;
import java.io.InputStream;

import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpHead;
import org.apache.http.client.methods.HttpOptions;
import org.apache.http.client.methods.HttpTrace;
import org.apache.http.client.methods.HttpPatch;
import org.apache.http.client.methods.RequestBuilder;
import org.apache.http.message.BasicHttpRequest;
import org.apache.http.message.BasicHttpEntityEnclosingRequest;
import org.apache.http.message.BasicRequestLine;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RequestForgery2 extends HttpServlet {
    private static final String VALID_URI = "http://lgtm.com";
    private HttpClient client = HttpClient.newHttpClient();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String sink = request.getParameter("uri");
            URI uri = new URI(sink);
            URI uri2 = new URI("http", sink, "fragement");
            URL url1 = new URL(sink);

            URLConnection c1 = url1.openConnection(); // $ SSRF
            SocketAddress sa = new SocketAddress() {
            };
            URLConnection c2 = url1.openConnection(new Proxy(Type.HTTP, sa)); // $ SSRF
            InputStream c3 = url1.openStream(); // $ SSRF

            // java.net.http
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request2 = HttpRequest.newBuilder().uri(uri2).build(); // $ SSRF
            HttpRequest request3 = HttpRequest.newBuilder(uri).build(); // $ SSRF

            // Apache HTTPlib
            HttpGet httpGet = new HttpGet(uri); // $ SSRF
            HttpGet httpGet2 = new HttpGet();
            httpGet2.setURI(uri2); // $ SSRF

            new HttpHead(uri); // $ SSRF
            new HttpPost(uri); // $ SSRF
            new HttpPut(uri); // $ SSRF
            new HttpDelete(uri); // $ SSRF
            new HttpOptions(uri); // $ SSRF
            new HttpTrace(uri); // $ SSRF
            new HttpPatch(uri); // $ SSRF

            new BasicHttpRequest(new BasicRequestLine("GET", uri2.toString(), null)); // $ SSRF
            new BasicHttpRequest("GET", uri2.toString()); // $ SSRF
            new BasicHttpRequest("GET", uri2.toString(), null); // $ SSRF

            new BasicHttpEntityEnclosingRequest(new BasicRequestLine("GET", uri2.toString(), null)); // $ SSRF
            new BasicHttpEntityEnclosingRequest("GET", uri2.toString()); // $ SSRF
            new BasicHttpEntityEnclosingRequest("GET", uri2.toString(), null); // $ SSRF

            RequestBuilder.get(uri2); // $ SSRF
            RequestBuilder.post(uri2); // $ SSRF
            RequestBuilder.put(uri2); // $ SSRF
            RequestBuilder.delete(uri2); // $ SSRF
            RequestBuilder.options(uri2); // $ SSRF
            RequestBuilder.head(uri2); // $ SSRF
            RequestBuilder.trace(uri2); // $ SSRF
            RequestBuilder.patch(uri2); // $ SSRF
            RequestBuilder.get("").setUri(uri2); // $ SSRF

        } catch (Exception e) {
            // TODO: handle exception
        }
    }
}
