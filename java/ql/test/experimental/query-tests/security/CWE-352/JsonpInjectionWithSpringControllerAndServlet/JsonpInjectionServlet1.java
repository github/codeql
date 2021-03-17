import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class JsonpInjectionServlet1 extends HttpServlet {

    private static HashMap hashMap = new HashMap();

    static {
        hashMap.put("username","admin");
        hashMap.put("password","123456");
    }

    private static final long serialVersionUID = 1L;

    private String key = "test";
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        String jsonpCallback = req.getParameter("jsonpCallback");
        PrintWriter pw = null;
        Gson gson = new Gson();
        String jsonResult = gson.toJson(hashMap);

        String referer = req.getHeader("Referer");

        boolean result = verifReferer(referer);

        // good
        if (result){
            String resultStr = null;
            pw = resp.getWriter();
            resultStr = jsonpCallback + "(" + jsonResult + ")";
            pw.println(resultStr);
            pw.flush();
        }
    }

    public static boolean verifReferer(String referer){
        if (!referer.startsWith("http://test.com/")){
            return false;
        }
        return true;
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        this.key = config.getInitParameter("key");
        System.out.println("初始化" + this.key);
        super.init(config);
    }

}
