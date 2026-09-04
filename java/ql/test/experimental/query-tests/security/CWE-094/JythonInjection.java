import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.python.core.BytecodeLoader;
import org.python.core.Py;
import org.python.core.PyCode;
import org.python.core.PyException;
import org.python.core.PyObject;
import org.python.util.InteractiveInterpreter;
import org.python.util.PythonInterpreter;

public class JythonInjection extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public JythonInjection() {
        super();
    }

    // BAD: allow execution of arbitrary Python code
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        String code = request.getParameter("code"); // $ Source[java/jython-injection]
        PythonInterpreter interpreter = null;
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            interpreter = new PythonInterpreter();
            interpreter.setOut(out);
            interpreter.setErr(out);
            interpreter.exec(code); // $ Alert[java/jython-injection]
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

    // BAD: allow execution of arbitrary Python code
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        String code = request.getParameter("code"); // $ Source[java/jython-injection]
        PythonInterpreter interpreter = null;

        try {
            interpreter = new PythonInterpreter();
            PyObject py = interpreter.eval(code); // $ Alert[java/jython-injection]

            response.getWriter().print(py.toString());
        } catch(PyException ex) {
            response.getWriter().println(ex.getMessage());
        } finally {
            if (interpreter != null) {
                interpreter.close();
            }
        }
    }

    // BAD: allow arbitrary Jython expression to run
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        String code = request.getParameter("code"); // $ Source[java/jython-injection]
        InteractiveInterpreter interpreter = null;
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            interpreter = new InteractiveInterpreter();
            interpreter.setOut(out);
            interpreter.setErr(out);
            interpreter.runsource(code); // $ Alert[java/jython-injection]
            out.flush();

            response.getWriter().print(out.toString());
        } catch(PyException ex) {
            response.getWriter().println(ex.getMessage());
        } finally {
            if (interpreter != null) {
                interpreter.close();
            }
        }
    }

    // BAD: load arbitrary class file to execute
    protected void doTrace(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        String code = request.getParameter("code"); // $ Source[java/jython-injection]
        PythonInterpreter interpreter = null;
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            interpreter = new PythonInterpreter();
            interpreter.setOut(out);
            interpreter.setErr(out);
          
            PyCode pyCode = BytecodeLoader.makeCode("test", code.getBytes(), getServletContext().getRealPath("/com/example/test.pyc")); // $ Alert[java/jython-injection]
            interpreter.exec(pyCode);
            out.flush();

            response.getWriter().print(out.toString());
        } catch(PyException ex) {
            response.getWriter().println(ex.getMessage());
        } finally {
            if (interpreter != null) {
                interpreter.close();
            }
        }
    }

    // BAD: Compile Python code to execute
    protected void doHead(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        PythonInterpreter interpreter = null;
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            interpreter = new PythonInterpreter();
            interpreter.setOut(out);
            interpreter.setErr(out);
        
            PyCode pyCode = Py.compile(request.getInputStream(), "Test.py", org.python.core.CompileMode.eval); // $ Alert[java/jython-injection]
            interpreter.exec(pyCode);
            out.flush();

            response.getWriter().print(out.toString());
        } catch(PyException ex) {
            response.getWriter().println(ex.getMessage());
        } finally {
            if (interpreter != null) {
                interpreter.close();
            }
        }
    }
}
