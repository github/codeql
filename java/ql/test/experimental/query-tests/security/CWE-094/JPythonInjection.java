import java.io.ByteArrayOutputStream;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.python.core.PyObject;
import org.python.core.PyException;
import org.python.util.PythonInterpreter;

public class JPythonInjection extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public JPythonInjection() {
        super();
    }

    // BAD: allow arbitrary JPython expression to execute
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        String code = request.getParameter("code");
        PythonInterpreter interpreter = null;
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
          interpreter = new PythonInterpreter();
          interpreter.setOut(out);
          interpreter.setErr(out);
          interpreter.exec(code);
          out.flush();

          response.getWriter().print(out.toString());
        } catch(PyException ex) {
            response.getWriter().println(ex.getMessage());
        } finally {
            if (interpreter != null) {
              interpreter.close();
            }
            out.close();
        }
    }

    // BAD: allow arbitrary JPython expression to evaluate
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      response.setContentType("text/plain");
      String code = request.getParameter("code");
      PythonInterpreter interpreter = null;

      try {
        interpreter = new PythonInterpreter();
        PyObject py = interpreter.eval(code);

        response.getWriter().print(py.toString());
      } catch(PyException ex) {
          response.getWriter().println(ex.getMessage());
      } finally {
          if (interpreter != null) {
            interpreter.close();
          }
      }
  }
}

