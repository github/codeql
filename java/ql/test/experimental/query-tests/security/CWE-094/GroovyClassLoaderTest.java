import groovy.lang.GroovyClassLoader;
import groovy.lang.GroovyCodeSource;
import groovy.lang.GroovyObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class GroovyClassLoaderTest extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String script = request.getParameter("script");
            final GroovyClassLoader classLoader = new GroovyClassLoader();
            Class groovy = classLoader.parseClass(script);
            GroovyObject groovyObj = (GroovyObject) groovy.newInstance();

        } catch (Exception e) {
            // Ignore
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String script = request.getParameter("script");
            final GroovyClassLoader classLoader = new GroovyClassLoader();
            GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
            Class groovy = classLoader.parseClass(gcs);
            GroovyObject groovyObj = (GroovyObject) groovy.newInstance();
        } catch (Exception e) {
            // Ignore
        }
    }
}

