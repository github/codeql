import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class SimpleServlet extends HttpServlet {
    private static List<String> queryList = new ArrayList<>();
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");

        PrintWriter out = response.getWriter();
        String queryString = "";
        try{
            queryString = request.getQueryString();
            saveQuery(queryString);
        } catch (Exception e) {
            System.out.println(queryString);
        }

        // 输出HTML页面
        out.println("<html>");
        out.println("<head><title>Simple Servlet</title></head>");
        out.println("<body>");
        out.println("Hello, World!");
        out.println("</body></html>");
    }
    public void saveQuery(String queryString) {
        queryList.add(queryString);
    }
}