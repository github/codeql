import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URI;
import java.net.URL;
import java.net.URLClassLoader;
import java.net.URLStreamHandlerFactory;

public class URLClassLoaderSSRF extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String url = request.getParameter("uri");
            URI uri = new URI(url);
            URLClassLoader urlClassLoader = new URLClassLoader(new URL[]{uri.toURL()}); // $ SSRF
            Class<?> test = urlClassLoader.loadClass("test");
        } catch (Exception e) {
            // Ignore
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String url = request.getParameter("uri");
            URI uri = new URI(url);
            URLClassLoader urlClassLoader = new URLClassLoader(new URL[]{uri.toURL()}, URLClassLoaderSSRF.class.getClassLoader()); // $ SSRF
            Class<?> test = urlClassLoader.loadClass("test");
        } catch (Exception e) {
            // Ignore
        }
    }

    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String url = request.getParameter("uri");
            URI uri = new URI(url);

            URLStreamHandlerFactory urlStreamHandlerFactory = null;
            URLClassLoader urlClassLoader = new URLClassLoader(new URL[]{uri.toURL()}, URLClassLoaderSSRF.class.getClassLoader(), urlStreamHandlerFactory); // $ SSRF
            urlClassLoader.findResource("test");
        } catch (Exception e) {
            // Ignore
        }
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String url = request.getParameter("uri");
            URI uri = new URI(url);
            URLClassLoader urlClassLoader = URLClassLoader.newInstance(new URL[]{uri.toURL()}); // $ SSRF
            urlClassLoader.getResourceAsStream("test");
        } catch (Exception e) {
            // Ignore
        }
    }

    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String url = request.getParameter("uri");
            URI uri = new URI(url);
            URLClassLoader urlClassLoader =
                new URLClassLoader("testClassLoader",
                    new URL[]{uri.toURL()}, // $ SSRF
                    URLClassLoaderSSRF.class.getClassLoader()
                );

            Class<?> rceTest = urlClassLoader.loadClass("RCETest");
        } catch (Exception e) {
            // Ignore
        }
    }

    protected void doTrace(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String url = request.getParameter("uri");
            URI uri = new URI(url);
            URLStreamHandlerFactory urlStreamHandlerFactory = null;

            URLClassLoader urlClassLoader =
                new URLClassLoader("testClassLoader",
                    new URL[]{uri.toURL()}, // $ SSRF
                    URLClassLoaderSSRF.class.getClassLoader(),
                    urlStreamHandlerFactory
                );

            Class<?> rceTest = urlClassLoader.loadClass("RCETest");
        } catch (Exception e) {
            // Ignore
        }
    }
}