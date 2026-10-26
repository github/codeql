import org.mozilla.javascript.ClassShutter;
import org.mozilla.javascript.Context;
import org.mozilla.javascript.Scriptable;

public class RhinoInjection extends HttpServlet {

  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    response.setContentType("text/plain");
    String code = request.getParameter("code");
    Context ctx = Context.enter();
    try {
      {
        // BAD: allow arbitrary Java and JavaScript code to be executed
        Scriptable scope = ctx.initStandardObjects();
      }

      {
        // GOOD: enable the safe mode
        Scriptable scope = ctx.initSafeStandardObjects();
      }

      {
        // GOOD: enforce a constraint on allowed classes
        Scriptable scope = ctx.initStandardObjects();
        ctx.setClassShutter(new ClassShutter() {
            public boolean visibleToScripts(String className) {
              return className.startsWith("com.example.");
            }
        });
      }

      Object result = ctx.evaluateString(scope, code, "<code>", 1, null);
      response.getWriter().print(Context.toString(result));
    } catch(RhinoException ex) {
      response.getWriter().println(ex.getMessage());
    } finally {
      Context.exit();
    }
  }
}
