import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import groovy.util.Eval;

public class GroovyEvalTest extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String script = request.getParameter("script");
        Eval.me(script); // $hasGroovyInjection
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String script = request.getParameter("script");
        Eval.me("test", "result", script); // $hasGroovyInjection
    }

    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String script = request.getParameter("script");
        Eval.x("result2", script); // $hasGroovyInjection

    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String script = request.getParameter("script");
        Eval.xy("result3", "result4", script); // $hasGroovyInjection
    }

    protected void doPatch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String script = request.getParameter("script");
        Eval.xyz("result3", "result4", "aaa", script); // $hasGroovyInjection
    }
}

