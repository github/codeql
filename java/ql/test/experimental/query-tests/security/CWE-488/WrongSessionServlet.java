import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.util.StringUtils;

public class WrongSessionServlet extends HttpServlet {

    private String key;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        test(req,resp);
    }

    protected void test(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String greetee = req.getParameter("greetee");

        if (!StringUtils.isEmpty(greetee)) {
            key = greetee;
        }

        PrintWriter pw = resp.getWriter();
        pw.println("test " + key);
    }
}
