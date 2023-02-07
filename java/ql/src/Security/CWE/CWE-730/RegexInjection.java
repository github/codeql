import java.util.regex.Pattern;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;

public class RegexInjectionDemo extends HttpServlet {

  public boolean badExample(javax.servlet.http.HttpServletRequest request) {
    String regex = request.getParameter("regex");
    String input = request.getParameter("input");

    // BAD: Unsanitized user input is used to construct a regular expression
    return input.matches(regex);
  }

  public boolean goodExample(javax.servlet.http.HttpServletRequest request) {
    String regex = request.getParameter("regex");
    String input = request.getParameter("input");

    // GOOD: User input is sanitized before constructing the regex
    return input.matches(Pattern.quote(regex));
  }
}
