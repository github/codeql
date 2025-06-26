import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import groovy.util.Eval;

public class GroovyEvalTest extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // "groovy.util;Eval;false;me;(String);;Argument[0];groovy;manual",
        {
            String script = request.getParameter("script"); // $ Source
            Eval.me(script); // $ Alert
        }
        // "groovy.util;Eval;false;me;(String,Object,String);;Argument[2];groovy;manual",
        {
            String script = request.getParameter("script"); // $ Source
            Eval.me("test", "result", script); // $ Alert
        }
        // "groovy.util;Eval;false;x;(Object,String);;Argument[1];groovy;manual",
        {
            String script = request.getParameter("script"); // $ Source
            Eval.x("result2", script); // $ Alert

        }
        // "groovy.util;Eval;false;xy;(Object,Object,String);;Argument[2];groovy;manual",
        {
            String script = request.getParameter("script"); // $ Source
            Eval.xy("result3", "result4", script); // $ Alert
        }
        // "groovy.util;Eval;false;xyz;(Object,Object,Object,String);;Argument[3];groovy;manual",
        {
            String script = request.getParameter("script"); // $ Source
            Eval.xyz("result3", "result4", "aaa", script); // $ Alert
        }
    }
}
