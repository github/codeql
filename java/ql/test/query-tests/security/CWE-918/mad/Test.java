import java.net.DatagramSocket;
import java.net.Proxy;
import java.net.Socket;
import java.net.SocketAddress;
import java.net.URL;
import java.net.URLClassLoader;
import javax.servlet.http.HttpServletRequest;
import javafx.scene.web.WebEngine;
import org.apache.commons.jelly.JellyContext;
import org.codehaus.cargo.container.installer.ZipURLInstaller;
import org.kohsuke.stapler.HttpResponses;

public class Test {

    private static HttpServletRequest request;

    public static Object source() {
        return request.getParameter(null);
    }

    public void test(DatagramSocket socket) throws Exception {
        // "java.net;DatagramSocket;true;connect;(SocketAddress);;Argument[0];open-url;ai-generated"
        socket.connect((SocketAddress) source()); // $ SSRF
    }

    public void test(URL url) throws Exception {
        // "java.net;URL;false;openConnection;(Proxy);:Argument[-1]:open-url;manual"
        ((URL) source()).openConnection(); // $ SSRF
        // "java.net;URL;false;openConnection;(Proxy);:Argument[0]:open-url;ai-generated"
        url.openConnection((Proxy) source()); // $ SSRF
        // "java.net;URL;false;openStream;;:Argument[-1]:open-url;manual"
        ((URL) source()).openStream(); // $ SSRF
    }

    public void test(URLClassLoader cl) throws Exception {
        // "java.net;URLClassLoader;false;URLClassLoader;(String,URL[],ClassLoader);;Argument[1];open-url;manual"
        new URLClassLoader("", (URL[]) source(), null); // $ SSRF
        // "java.net;URLClassLoader;false;URLClassLoader;(String,URL[],ClassLoader,URLStreamHandlerFactory);;Argument[1];open-url;manual"
        new URLClassLoader("", (URL[]) source(), null, null); // $ SSRF
        // "java.net;URLClassLoader;false;URLClassLoader;(URL[]);;Argument[0];open-url;manual"
        new URLClassLoader((URL[]) source()); // $ SSRF
        // "java.net;URLClassLoader;false;URLClassLoader;(URL[],ClassLoader);;Argument[0];open-url;manual"
        new URLClassLoader((URL[]) source(), null); // $ SSRF
        // "java.net;URLClassLoader;false;URLClassLoader;(URL[],ClassLoader,URLStreamHandlerFactory);;Argument[0];open-url;manual"
        new URLClassLoader((URL[]) source(), null, null); // $ SSRF
        // "java.net;URLClassLoader;false;newInstance;;;Argument[0];open-url;manual"
        URLClassLoader.newInstance((URL[]) source()); // $ SSRF
        // "org.apache.commons.jelly;JellyContext;true;JellyContext;(JellyContext,URL,URL);;Argument[1];open-url;ai-generated"
        new JellyContext(null, (URL) source(), null); // $ SSRF
        // "org.apache.commons.jelly;JellyContext;true;JellyContext;(JellyContext,URL,URL);;Argument[2];open-url;ai-generated"
        new JellyContext(null, null, (URL) source()); // $ SSRF
        // "org.apache.commons.jelly;JellyContext;true;JellyContext;(JellyContext,URL);;Argument[1];open-url;ai-generated"
        new JellyContext((JellyContext) null, (URL) source()); // $ SSRF
        // "org.apache.commons.jelly;JellyContext;true;JellyContext;(URL,URL);;Argument[0];open-url;ai-generated"
        new JellyContext((URL) source(), null); // $ SSRF
        // "org.apache.commons.jelly;JellyContext;true;JellyContext;(URL,URL);;Argument[1];open-url;ai-generated"
        new JellyContext((URL) null, (URL) source()); // $ SSRF
        // "org.apache.commons.jelly;JellyContext;true;JellyContext;(URL);;Argument[0];open-url;ai-generated"
        new JellyContext((URL) source()); // $ SSRF
    }

    public void test(WebEngine webEngine) {
        // "javafx.scene.web;WebEngine;false;load;(String);;Argument[0];open-url;ai-generated"
        webEngine.load((String) source()); // $ SSRF
    }

    public void test(ZipURLInstaller zui) {
        // "org.codehaus.cargo.container.installer;ZipURLInstaller;true;ZipURLInstaller;(URL,String,String);;Argument[0];open-url:ai-generated"
        new ZipURLInstaller((URL) source(), "", ""); // $ SSRF
    }

    public void test(HttpResponses r) {
        // "org.kohsuke.stapler;HttpResponses;true;staticResource;(URL);;Argument[0];open-url;ai-generated"
        r.staticResource((URL) source()); // $ SSRF
    }

}
