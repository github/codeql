import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class TestServlet extends HttpServlet {
    private static HashMap hashMap = new HashMap();

    static {
        hashMap.put("username","admin");
        hashMap.put("password","123456");
    }

    private static final long serialVersionUID = 1L;

    private String key = "test";

    @Override
    protected void doGet(
            HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String resultStr = "TestServlet";
        PrintWriter pw = resp.getWriter();
        pw.println(resultStr);
        pw.flush();
    }
}