import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

import org.apache.commons.lang3.RegExUtils;

public class RegexInjectionTest extends HttpServlet {
  public boolean string1(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return input.matches("^" + pattern + "=.*$");  // $ hasRegexInjection
  }

  public boolean string2(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return input.split(pattern).length > 0;  // $ hasRegexInjection
  }

  public boolean string3(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return input.replaceFirst(pattern, "").length() > 0;  // $ hasRegexInjection
  }

  public boolean string4(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return input.replaceAll(pattern, "").length() > 0;  // $ hasRegexInjection
  }

  public boolean pattern1(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    Pattern pt = Pattern.compile(pattern); // $ hasRegexInjection
    Matcher matcher = pt.matcher(input);

    return matcher.find();
  }

  public boolean pattern2(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return Pattern.compile(pattern).matcher(input).matches();  // $ hasRegexInjection
  }

  public boolean pattern3(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return Pattern.matches(pattern, input);  // $ hasRegexInjection
  }

  public boolean pattern4(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return input.matches("^" + foo(pattern) + "=.*$"); // $ hasRegexInjection
  }

  String foo(String str) {
    return str;
  }

  public boolean pattern5(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    // Safe: User input is sanitized before constructing the regex
    return input.matches("^" + escapeSpecialRegexChars(pattern) + "=.*$");
  }

  public boolean pattern6(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    // TODO: add a "Safe" test for situation when this return value is stored in a variable, then the variable is used in the regex
    escapeSpecialRegexChars(pattern);

    // BAD: the pattern is not really sanitized
    return input.matches("^" + pattern + "=.*$"); // $ hasRegexInjection
  }

  Pattern SPECIAL_REGEX_CHARS = Pattern.compile("[{}()\\[\\]><-=!.+*?^$\\\\|]");

  // TODO: check if any other inbuilt escape/sanitizers in Java APIs
  String escapeSpecialRegexChars(String str) {
    return SPECIAL_REGEX_CHARS.matcher(str).replaceAll("\\\\$0");
  }

  public boolean apache1(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return RegExUtils.removeAll(input, pattern).length() > 0;  // $ hasRegexInjection
  }

  public boolean apache2(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return RegExUtils.removeFirst(input, pattern).length() > 0;  // $ hasRegexInjection
  }

  public boolean apache3(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return RegExUtils.removePattern(input, pattern).length() > 0;  // $ hasRegexInjection
  }

  public boolean apache4(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return RegExUtils.replaceAll(input, pattern, "").length() > 0;  // $ hasRegexInjection
  }

  public boolean apache5(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return RegExUtils.replaceFirst(input, pattern, "").length() > 0;  // $ hasRegexInjection
  }

  public boolean apache6(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    Pattern pt = (Pattern)(Object) pattern;
    return RegExUtils.replaceFirst(input, pt, "").length() > 0;  // Safe: Pattern compile is the sink instead
  }

  public boolean apache7(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return RegExUtils.replacePattern(input, pattern, "").length() > 0;  // $ hasRegexInjection
  }

  // from https://rules.sonarsource.com/java/RSPEC-2631 to test for Pattern.quote as safe
  public boolean validate(javax.servlet.http.HttpServletRequest request) {
    String regex = request.getParameter("regex");
    String input = request.getParameter("input");

    return input.matches(Pattern.quote(regex));  // Safe: with Pattern.quote, metacharacters or escape sequences will be given no special meaning
  }
}

// ! see the following for potential additional test case ideas: https://www.baeldung.com/regular-expressions-java
