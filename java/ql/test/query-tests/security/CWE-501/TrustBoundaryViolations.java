import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.owasp.esapi.Validator;

public class TrustBoundaryViolations extends HttpServlet {
    Validator validator;

    public void doGet(HttpServletRequest request, HttpServletResponse response) {
        String input = request.getParameter("input"); // $ Source

        // BAD: The input is written to the session without being sanitized.
        request.getSession().setAttribute("input", input); // $ Alert

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

        // GOOD: A direct String.matches(...) regex check constrains the input before it is written to the session.
        String input4 = request.getParameter("input4");
        if (input4.matches("[a-zA-Z0-9]+")) {
            request.getSession().setAttribute("input4", input4);
        }
    }

    @javax.validation.constraints.Pattern(regexp = "^[a-zA-Z0-9]+$")
    String validatedField;

    public void doPost(HttpServletRequest request, HttpServletResponse response) {
        // GOOD: The field is constrained by a @Pattern annotation.
        request.getSession().setAttribute("validated", validatedField);
    }
}
