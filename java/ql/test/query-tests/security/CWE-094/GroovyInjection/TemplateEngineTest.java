import java.io.File;
import java.io.IOException;
import java.io.Reader;
import java.net.URL;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import groovy.text.TemplateEngine;

public class TemplateEngineTest extends HttpServlet {

    private Object source(HttpServletRequest request) {
        return request.getParameter("script"); // $ Source
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Object script = source(request);
            TemplateEngine engine = null;
            engine.createTemplate(request.getParameter("script")); // $ Alert
            engine.createTemplate((File) script); // $ Alert
            engine.createTemplate((Reader) script); // $ Alert
            engine.createTemplate((URL) script); // $ Alert
        } catch (Exception e) {
        }

    }
}
