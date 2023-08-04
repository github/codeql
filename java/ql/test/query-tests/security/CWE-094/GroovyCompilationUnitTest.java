import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.net.URL;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.codehaus.groovy.control.CompilationUnit;
import org.codehaus.groovy.control.SourceUnit;
import org.codehaus.groovy.control.io.ReaderSource;
import org.codehaus.groovy.control.io.StringReaderSource;
import org.codehaus.groovy.tools.javac.JavaAwareCompilationUnit;
import org.codehaus.groovy.tools.javac.JavaStubCompilationUnit;

public class GroovyCompilationUnitTest extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // "org.codehaus.groovy.control;CompilationUnit;false;compile;;;Argument[this];groovy;manual"
        {
            CompilationUnit cu = new CompilationUnit();
            cu.addSource("test", request.getParameter("source"));
            cu.compile(); // $hasGroovyInjection
        }
        {
            CompilationUnit cu = new CompilationUnit();
            cu.addSource(request.getParameter("source"), "safe");
            cu.compile(); // Safe
        }
        {
            CompilationUnit cu = new CompilationUnit();
            cu.addSource("test",
                    new ByteArrayInputStream(request.getParameter("source").getBytes()));
            cu.compile(); // $hasGroovyInjection
        }
        {
            CompilationUnit cu = new CompilationUnit();
            cu.addSource(new URL(request.getParameter("source")));
            cu.compile(); // $hasGroovyInjection
        }
        {
            CompilationUnit cu = new CompilationUnit();
            SourceUnit su =
                    new SourceUnit("test", request.getParameter("source"), null, null, null);
            cu.addSource(su);
            cu.compile(); // $hasGroovyInjection
        }
        {
            CompilationUnit cu = new CompilationUnit();
            SourceUnit su =
                    new SourceUnit(request.getParameter("source"), "safe", null, null, null);
            cu.addSource(su);
            cu.compile(); // Safe
        }
        {
            CompilationUnit cu = new CompilationUnit();
            StringReaderSource rs = new StringReaderSource(request.getParameter("source"), null);
            SourceUnit su = new SourceUnit("test", rs, null, null, null);
            cu.addSource(su);
            cu.compile(); // $hasGroovyInjection
        }
        {
            CompilationUnit cu = new CompilationUnit();
            SourceUnit su =
                    new SourceUnit(new URL(request.getParameter("source")), null, null, null);
            cu.addSource(su);
            cu.compile(); // $hasGroovyInjection
        }
        {
            CompilationUnit cu = new CompilationUnit();
            SourceUnit su = SourceUnit.create("test", request.getParameter("source"));
            cu.addSource(su);
            cu.compile(); // $hasGroovyInjection
        }
        {
            CompilationUnit cu = new CompilationUnit();
            SourceUnit su = SourceUnit.create("test", request.getParameter("source"), 0);
            cu.addSource(su);
            cu.compile(); // $hasGroovyInjection
        }
        {
            CompilationUnit cu = new CompilationUnit();
            SourceUnit su = SourceUnit.create(request.getParameter("source"), "safe", 0);
            cu.addSource(su);
            cu.compile(); // Safe
        }
        {
            JavaAwareCompilationUnit cu = new JavaAwareCompilationUnit();
            cu.addSource("test", request.getParameter("source"));
            cu.compile(); // $hasGroovyInjection
        }
        {
            JavaStubCompilationUnit cu = new JavaStubCompilationUnit(null, null);
            cu.addSource("test", request.getParameter("source"));
            cu.compile(); // Safe - JavaStubCompilationUnit only creates stubs
        }
    }
}
