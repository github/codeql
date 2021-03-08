import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = "/my/testJsonp")
public class WebServletTest extends HttpServlet {

    private static HashMap hashMap = new HashMap();

    static {
        hashMap.put("username","admin");
        hashMap.put("password","123456");
    }

    private static final long serialVersionUID = 1L;

    private String key = "test";
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String jsonpCallback = req.getParameter("jsonpCallback");

        resp.setHeader("test", req.getParameter("crlf"));

        PrintWriter pw = null;
        Gson gson = new Gson();
        String result = gson.toJson(hashMap);

        String resultStr = null;
        pw = resp.getWriter();
        resultStr = jsonpCallback + "(" + result + ")";
        pw.println(resultStr);
        pw.flush();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String jsonpCallback = req.getParameter("jsonpCallback");
        PrintWriter pw = null;
        Gson gson = new Gson();
        String result = gson.toJson(hashMap);

        String resultStr = null;
        pw = resp.getWriter();
        resultStr = jsonpCallback + "(" + result + ")";
        pw.println(resultStr);
        pw.flush();
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        this.key = config.getInitParameter("key");
        System.out.println("初始化" + this.key);
        super.init(config);
    }

}