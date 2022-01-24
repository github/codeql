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

        // "groovy.lang;GroovyShell;false;evaluate;(GroovyCodeSource);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
            shell.evaluate(gcs); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;evaluate;(Reader);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            Reader reader = new StringReader(script);
            shell.evaluate(reader); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;evaluate;(Reader,String);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            Reader reader = new StringReader(script);
            shell.evaluate(reader, "_"); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;evaluate;(String);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            shell.evaluate(script); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;evaluate;(String,String);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            shell.evaluate(script, "test"); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;evaluate;(String,String,String);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            shell.evaluate(script, "test", "test2"); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;evaluate;(URI);;Argument[0];groovy",
        try {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            shell.parse(new URI(script)); // $hasGroovyInjection
        } catch (URISyntaxException e) {
        }
        // "groovy.lang;GroovyShell;false;parse;(Reader);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            Reader reader = new StringReader(script);
            shell.parse(reader); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;parse;(Reader,String);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            Reader reader = new StringReader(script);
            shell.parse(reader, "_"); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;parse;(String);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            shell.parse(script); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;parse;(String,String);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            shell.parse(script, "_"); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;parse;(URI);;Argument[0];groovy",
        try {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            shell.parse(new URI(script)); // $hasGroovyInjection
        } catch (URISyntaxException e) {
        }
        // "groovy.lang;GroovyShell;false;run;(GroovyCodeSource,String[]);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
            shell.run(gcs, new String[] {}); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;run;(GroovyCodeSource,List);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
            shell.run(gcs, new ArrayList<String>()); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;run;(Reader,String,String[]);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            Reader reader = new StringReader(script);
            shell.run(reader, "test", new String[] {}); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;run;(Reader,String,List);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            Reader reader = new StringReader(script);
            shell.run(reader, "test", new ArrayList<String>()); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;run;(String,String,String[]);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            shell.run(script, "_", new String[] {}); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;run;(String,String,List);;Argument[0];groovy",
        {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            shell.run(script, "_", new ArrayList<String>()); // $hasGroovyInjection
        }
        // "groovy.lang;GroovyShell;false;run;(URI,String[]);;Argument[0];groovy",
        try {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            shell.run(new URI(script), new String[] {}); // $hasGroovyInjection
        } catch (URISyntaxException e) {
        }
        // "groovy.lang;GroovyShell;false;run;(URI,List);;Argument[0];groovy",
        try {
            GroovyShell shell = new GroovyShell();
            String script = request.getParameter("script");
            shell.run(new URI(script), new ArrayList<String>()); // $hasGroovyInjection
        } catch (URISyntaxException e) {
        }
    }
}

