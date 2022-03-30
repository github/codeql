import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import groovy.util.Eval;

public class GroovyEvalTest extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // "groovy.util;Eval;false;me;(String);;Argument[0];groovy",
        {
            String script = request.getParameter("script");
            Eval.me(script); // $hasGroovyInjection
        }
        // "groovy.util;Eval;false;me;(String,Object,String);;Argument[2];groovy",
        {
            String script = request.getParameter("script");
            Eval.me("test", "result", script); // $hasGroovyInjection
        }
        // "groovy.util;Eval;false;x;(Object,String);;Argument[1];groovy",
        {
            String script = request.getParameter("script");
            Eval.x("result2", script); // $hasGroovyInjection

        }
        // "groovy.util;Eval;false;xy;(Object,Object,String);;Argument[2];groovy",
        {
            String script = request.getParameter("script");
            Eval.xy("result3", "result4", script); // $hasGroovyInjection
        }
        // "groovy.util;Eval;false;xyz;(Object,Object,Object,String);;Argument[3];groovy",
        {
            String script = request.getParameter("script");
            Eval.xyz("result3", "result4", "aaa", script); // $hasGroovyInjection
        }
    }
}

