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
            // URI(String str)
            URI uri = new URI(sink);

            // URI(String scheme, String ssp, String fragment)
            URI uri2 = new URI("http", sink, "fragement");

            // URI(String scheme, String userInfo, String host, int port, String path,
            // String query, String fragment)
            URI uri3 = new URI("http", "userinfo", "host", 1, "path", "query", "fragment");
            // URI(String scheme, String host, String path, String fragment)
            URI uri4 = new URI("http", "host", "path", "fragment");
            // URI(String scheme, String authority, String path, String query, String
            // fragment)
            URI uri5 = new URI("http", "authority", "path", "query", "fragment");
            URI uri6 = URI.create("http://foo.com/");

            // URL(String spec)
            URL url1 = new URL(sink);
            // URL(String protocol, String host, int port, String file)
            URL url2 = new URL("http", "host", 1, "file");
            // URL(String protocol, String host, String file)
            URL url3 = new URL("http", "host", "file");
            // URL(URL context, String spec)
            URL url4 = new URL(url3, "http");
            // URL(String protocol, String host, int port, String file, URLStreamHandler
            // handler)
            URL url5 = new URL("http", "host", 1, "file", new Helper2());

            // URL(URL context, String spec, URLStreamHandler handler)
            URL url6 = new URL(url3, "spec", new Helper2());

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


class Helper2 extends URLStreamHandler {
    Helper2() {
    }

    protected URLConnection openConnection(URL u) throws IOException {
        return null;
    }
}
