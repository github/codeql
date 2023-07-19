import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class TrustBoundaryViolations extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) {
        String input = request.getParameter("input");

        request.getSession().setAttribute("input", input); // $ hasTaintFlow
    }
}
