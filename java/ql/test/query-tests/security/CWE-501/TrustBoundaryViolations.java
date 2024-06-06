import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.owasp.esapi.Validator;

public class TrustBoundaryViolations extends HttpServlet {
    Validator validator;

    public void doGet(HttpServletRequest request, HttpServletResponse response) {
        String input = request.getParameter("input");

        // BAD: The input is written to the session without being sanitized.
        request.getSession().setAttribute("input", input); // $ hasTaintFlow

        String input2 = request.getParameter("input2");

        try {
            String sanitized = validator.getValidInput("HTTP parameter", input2, "HTTPParameterValue", 100, false);
            // GOOD: The input is sanitized before being written to the session.
            request.getSession().setAttribute("input2", sanitized);

        } catch (Exception e) {
        }

        try {
            String input3 = request.getParameter("input3");
            if (validator.isValidInput("HTTP parameter", input3, "HTTPParameterValue", 100, false)) {
                // GOOD: The input is sanitized before being written to the session.
                request.getSession().setAttribute("input3", input3);
            }
        } catch (Exception e) {
        }
    }
}
