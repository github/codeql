import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mozilla.javascript.ClassShutter;
import org.mozilla.javascript.CompilerEnvirons;
import org.mozilla.javascript.Context;
import org.mozilla.javascript.DefiningClassLoader;
import org.mozilla.javascript.Scriptable;
import org.mozilla.javascript.RhinoException;
import org.mozilla.javascript.optimizer.ClassCompiler;

/**
 * Servlet implementation class RhinoServlet
 */
public class RhinoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public RhinoServlet() {
        super();
    }

    // BAD: allow arbitrary Java and JavaScript code to be executed
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        String code = request.getParameter("code");
        Context ctx = Context.enter();
        try {
            Scriptable scope = ctx.initStandardObjects();
            Object result = ctx.evaluateString(scope, code, "<code>", 1, null);
            response.getWriter().print(Context.toString(result));
        } catch(RhinoException ex) {
            response.getWriter().println(ex.getMessage());
        } finally {
            Context.exit();
        }
    }

    // GOOD: enable the safe mode
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        String code = request.getParameter("code");
        Context ctx = Context.enter();
        try {
            Scriptable scope = ctx.initSafeStandardObjects();
            Object result = ctx.evaluateString(scope, code, "<code>", 1, null);
            response.getWriter().print(Context.toString(result));
        } catch(RhinoException ex) {
            response.getWriter().println(ex.getMessage());
        } finally {
            Context.exit();
        }
    }

    // GOOD: enforce a constraint on allowed classes
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        String code = request.getParameter("code");
        Context ctx = Context.enter();
        try {
            Scriptable scope = ctx.initStandardObjects();
            ctx.setClassShutter(new ClassShutter() {
                public boolean visibleToScripts(String className) {
                    return className.startsWith("com.example.");
                }
            });

            Object result = ctx.evaluateString(scope, code, "<code>", 1, null);
            response.getWriter().print(Context.toString(result));
        } catch(RhinoException ex) {
            response.getWriter().println(ex.getMessage());
        } finally {
            Context.exit();
        }
    }    

    // BAD: allow arbitrary code to be compiled for subsequent execution
    protected void doGet2(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        ClassCompiler compiler = new ClassCompiler(new CompilerEnvirons());
        Object[] objs = compiler.compileToClassFiles(code, "/sourceLocation", 1, "mainClassName");
    }

    // BAD: allow arbitrary code to be loaded for subsequent execution
    protected void doPost2(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        Class clazz = new DefiningClassLoader().defineClass("Powerfunc", code.getBytes());
    }
}
