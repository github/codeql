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
            String script = request.getParameter("script"); // $ Source
            GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
            shell.evaluate(gcs); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;evaluate;(Reader);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            Reader reader = new StringReader(script);
            shell.evaluate(reader); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;evaluate;(Reader,String);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            Reader reader = new StringReader(script);
            shell.evaluate(reader, "_"); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;evaluate;(String);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            shell.evaluate(script); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;evaluate;(String,String);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            shell.evaluate(script, "test"); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;evaluate;(String,String,String);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            shell.evaluate(script, "test", "test2"); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;evaluate;(URI);;Argument[0];groovy;manual",
        try {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            shell.parse(new URI(script)); // $ Alert
        } catch (URISyntaxException e) {
        }
        // "groovy.lang;GroovyShell;false;parse;(Reader);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            Reader reader = new StringReader(script);
            shell.parse(reader); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;parse;(Reader,String);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            Reader reader = new StringReader(script);
            shell.parse(reader, "_"); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;parse;(String);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            shell.parse(script); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;parse;(String,String);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            shell.parse(script, "_"); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;parse;(URI);;Argument[0];groovy;manual",
        try {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            shell.parse(new URI(script)); // $ Alert
        } catch (URISyntaxException e) {
        }
        // "groovy.lang;GroovyShell;false;run;(GroovyCodeSource,String[]);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
            shell.run(gcs, new String[] {}); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;run;(GroovyCodeSource,List);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
            shell.run(gcs, new ArrayList<String>()); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;run;(Reader,String,String[]);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            Reader reader = new StringReader(script);
            shell.run(reader, "test", new String[] {}); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;run;(Reader,String,List);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            Reader reader = new StringReader(script);
            shell.run(reader, "test", new ArrayList<String>()); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;run;(String,String,String[]);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            shell.run(script, "_", new String[] {}); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;run;(String,String,List);;Argument[0];groovy;manual",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            shell.run(script, "_", new ArrayList<String>()); // $ Alert
        }
        // "groovy.lang;GroovyShell;false;run;(URI,String[]);;Argument[0];groovy;manual",
        try {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            shell.run(new URI(script), new String[] {}); // $ Alert
        } catch (URISyntaxException e) {
        }
        // "groovy.lang;GroovyShell;false;run;(URI,List);;Argument[0];groovy;manual",
        try {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script"); // $ Source
            shell.run(new URI(script), new ArrayList<String>()); // $ Alert
        } catch (URISyntaxException e) {
        }
    }
}
