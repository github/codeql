import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import groovy.lang.GroovyCodeSource;
import groovy.lang.GroovyShell;

public class GroovyShellTest extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // "groovy.lang;GroovyShell;false;evaluate;(GroovyCodeSource);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
            shell.evaluate(gcs); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;evaluate;(Reader);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            Reader reader = new StringReader(script);
            shell.evaluate(reader); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;evaluate;(Reader,String);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            Reader reader = new StringReader(script);
            shell.evaluate(reader, "_"); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;evaluate;(String);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            shell.evaluate(script); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;evaluate;(String,String);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            shell.evaluate(script, "test"); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;evaluate;(String,String,String);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            shell.evaluate(script, "test", "test2"); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;evaluate;(URI);;Argument[0];groovy;manual",
        try {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            shell.parse(new URI(script)); // $ Alert[java/groovy-injection]
        } catch (URISyntaxException e) {
        }
        // "groovy.lang;GroovyShell;false;parse;(Reader);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            Reader reader = new StringReader(script);
            shell.parse(reader); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;parse;(Reader,String);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            Reader reader = new StringReader(script);
            shell.parse(reader, "_"); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;parse;(String);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            shell.parse(script); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;parse;(String,String);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            shell.parse(script, "_"); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;parse;(URI);;Argument[0];groovy;manual",
        try {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            shell.parse(new URI(script)); // $ Alert[java/groovy-injection]
        } catch (URISyntaxException e) {
        }
        // "groovy.lang;GroovyShell;false;run;(GroovyCodeSource,String[]);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
            shell.run(gcs, new String[] {}); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;run;(GroovyCodeSource,List);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
            shell.run(gcs, new ArrayList<String>()); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;run;(Reader,String,String[]);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            Reader reader = new StringReader(script);
            shell.run(reader, "test", new String[] {}); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;run;(Reader,String,List);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            Reader reader = new StringReader(script);
            shell.run(reader, "test", new ArrayList<String>()); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;run;(String,String,String[]);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            shell.run(script, "_", new String[] {}); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;run;(String,String,List);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            shell.run(script, "_", new ArrayList<String>()); // $ Alert[java/groovy-injection]
        }
        // "groovy.lang;GroovyShell;false;run;(URI,String[]);;Argument[0];groovy;manual",
        try {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            shell.run(new URI(script), new String[] {}); // $ Alert[java/groovy-injection]
        } catch (URISyntaxException e) {
        }
        // "groovy.lang;GroovyShell;false;run;(URI,List);;Argument[0];groovy;manual",
        try {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source[java/groovy-injection]
            shell.run(new URI(script), new ArrayList<String>()); // $ Alert[java/groovy-injection]
        } catch (URISyntaxException e) {
        }
    }
}
