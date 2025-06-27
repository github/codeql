import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.StringReader;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import groovy.lang.GroovyClassLoader;
import groovy.lang.GroovyCodeSource;

public class GroovyClassLoaderTest extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // "groovy.lang;GroovyClassLoader;false;parseClass;(GroovyCodeSource);;Argument[0];groovy;manual",
        {
            String script = request.getParameter("script"); // $ Source
            final GroovyClassLoader classLoader = new GroovyClassLoader();
            GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
            classLoader.parseClass(gcs); // $ Alert
        }
        // "groovy.lang;GroovyClassLoader;false;parseClass;(GroovyCodeSource,boolean);;Argument[0];groovy;manual",
        {
            String script = request.getParameter("script"); // $ Source
            final GroovyClassLoader classLoader = new GroovyClassLoader();
            GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
            classLoader.parseClass(gcs, true); // $ Alert
        }
        // "groovy.lang;GroovyClassLoader;false;parseClass;(InputStream,String);;Argument[0];groovy;manual",
        {
            String script = request.getParameter("script"); // $ Source
            final GroovyClassLoader classLoader = new GroovyClassLoader();
            classLoader.parseClass(new ByteArrayInputStream(script.getBytes()), "test"); // $ Alert
        }
        // "groovy.lang;GroovyClassLoader;false;parseClass;(Reader,String);;Argument[0];groovy;manual",
        {
            String script = request.getParameter("script"); // $ Source
            final GroovyClassLoader classLoader = new GroovyClassLoader();
            classLoader.parseClass(new StringReader(script), "test"); // $ Alert
        }
        // "groovy.lang;GroovyClassLoader;false;parseClass;(String);;Argument[0];groovy;manual",
        {
            String script = request.getParameter("script"); // $ Source
            final GroovyClassLoader classLoader = new GroovyClassLoader();
            classLoader.parseClass(script); // $ Alert
        }
        // "groovy.lang;GroovyClassLoader;false;parseClass;(String,String);;Argument[0];groovy;manual",
        {
            String script = request.getParameter("script"); // $ Source
            final GroovyClassLoader classLoader = new GroovyClassLoader();
            classLoader.parseClass(script, "test"); // $ Alert
        }
    }
}
