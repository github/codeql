import java.io.IOException;
import java.io.InputStream;
import java.net.Proxy;
import java.net.SocketAddress;
import java.net.URI;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLStreamHandler;
import java.net.Proxy.Type;
import org.apache.http.client.methods.HttpGet;
// import java.net.http.HttpClient;
// import java.net.http.HttpRequest;

public class Sinks {
    public static void main(String[] args) throws Exception {
        // URI(String str)
        URI uri = new URI("uri1");

        // URI(String scheme, String ssp, String fragment)
        URI uri2 = new URI("http", "ssp", "fragement");

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
        URL url1 = new URL("spec");
        // URL(String protocol, String host, int port, String file)
        URL url2 = new URL("http", "host", 1, "file");
        // URL(String protocol, String host, String file)
        URL url3 = new URL("http", "host", "file");
        // URL(URL context, String spec)
        URL url4 = new URL(url3, "http");
        // URL(String protocol, String host, int port, String file, URLStreamHandler
        // handler)
        URL url5 = new URL("http", "host", 1, "file", new Helper());

        // URL(URL context, String spec, URLStreamHandler handler)
        URL url6 = new URL(url3, "spec", new Helper());

        URLConnection c1 = url1.openConnection();
        SocketAddress sa = new SocketAddress() {
        };
        URLConnection c2 = url1.openConnection(new Proxy(Type.HTTP, sa));
        InputStream c3 = url1.openStream();

        // java.net.http
        // HttpClient client = HttpClient.newHttpClient();
        // HttpRequest request2 = HttpRequest.newBuilder().uri(uri2).build();
        // HttpRequest request3 = HttpRequest.newBuilder(uri).build();

        // Apache HTTPlib
        HttpGet httpGet = new HttpGet(uri);
        HttpGet httpGet2 = new HttpGet();
        httpGet2.setURI(uri2);

    }

}

class Helper extends URLStreamHandler {
    @Override
    protected URLConnection openConnection(URL arg0) throws IOException {
        return null;
    }
}