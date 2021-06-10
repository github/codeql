import groovy.lang.GroovyCodeSource;
import groovy.lang.GroovyShell;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class GroovyShellTest extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GroovyShell shell = new GroovyShell();
        String script = request.getParameter("script");
        shell.evaluate(script); // $hasGroovyInjection
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GroovyShell shell = new GroovyShell();
        String script = request.getParameter("script");
        shell.evaluate(script, "test"); // $hasGroovyInjection
    }

    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GroovyShell shell = new GroovyShell();
        String script = request.getParameter("script");
        shell.evaluate(script, "test", "test2"); // $hasGroovyInjection
    }

    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GroovyShell shell = new GroovyShell();
        String script = request.getParameter("script");
        shell.run(script, "_", new String[] {}); // $hasGroovyInjection
    }

    protected void doHead(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GroovyShell shell = new GroovyShell();
        String script = request.getParameter("script");
        GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
        shell.run(gcs, new String[] {}); // $hasGroovyInjection
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GroovyShell shell = new GroovyShell();
        String script = request.getParameter("script");
        GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
        shell.evaluate(gcs); // $hasGroovyInjection
    }

    protected void doPatch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GroovyShell shell = new GroovyShell();
        String script = request.getParameter("script");
        shell.parse(script); // $hasGroovyInjection
    }
}

