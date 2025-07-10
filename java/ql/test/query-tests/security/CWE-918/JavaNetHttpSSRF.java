import java.io.IOException;
import java.net.Proxy;
import java.net.SocketAddress;
import java.net.URI;
import java.net.URL;
import java.net.URLConnection;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.Proxy.Type;
import java.io.InputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class JavaNetHttpSSRF extends HttpServlet {
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

        } catch (Exception e) {
            // TODO: handle exception
        }
    }
}
