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
        queryString = request.getQueryString();
        if (queryString.matches("save_query_0")) {
            throw new RuntimeException(queryString);
        } else if(queryString.matches("save_query_1")) {
            System.out.println(queryString);
        } else if(queryString.matches("save_query_2")) {
            System.out.print(queryString);
        }
        saveQuery(queryString);

        out.println("<html>");
        out.println("<head><title>Simple Servlet</title></head>");
        out.println("<body>");
        out.println("Hello, World!");
        out.println(queryString);
        out.println("</body></html>");
    }
    public void saveQuery(String queryString) {
        queryList.add(queryString);
    }
}