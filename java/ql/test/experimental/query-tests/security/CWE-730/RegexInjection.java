import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

import org.apache.commons.lang3.RegExUtils;

public class RegexInjection extends HttpServlet {
  public boolean string1(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return input.matches("^" + pattern + "=.*$");  // BAD
  }

  public boolean string2(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return input.split(pattern).length > 0;  // BAD
  }

  public boolean string3(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return input.replaceFirst(pattern, "").length() > 0;  // BAD
  }

  public boolean string4(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return input.replaceAll(pattern, "").length() > 0;  // BAD
  }

  public boolean pattern1(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    Pattern pt = Pattern.compile(pattern);
    Matcher matcher = pt.matcher(input);

    return matcher.find();  // BAD
  }

  public boolean pattern2(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return Pattern.compile(pattern).matcher(input).matches();  // BAD
  }

  public boolean pattern3(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return Pattern.matches(pattern, input);  // BAD
  }

  public boolean pattern4(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return input.matches("^" + foo(pattern) + "=.*$"); // BAD
  }

  String foo(String str) {
    return str;
  }

  public boolean pattern5(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    // GOOD: User input is sanitized before constructing the regex
    return input.matches("^" + escapeSpecialRegexChars(pattern) + "=.*$");
  }

  public boolean pattern6(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    escapeSpecialRegexChars(pattern);

    // BAD: the pattern is not really sanitized
    return input.matches("^" + pattern + "=.*$");
  }

  Pattern SPECIAL_REGEX_CHARS = Pattern.compile("[{}()\\[\\]><-=!.+*?^$\\\\|]");

  String escapeSpecialRegexChars(String str) {
    return SPECIAL_REGEX_CHARS.matcher(str).replaceAll("\\\\$0");
  }

  public boolean apache1(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return RegExUtils.removeAll(input, pattern).length() > 0;  // BAD
  }

  public boolean apache2(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return RegExUtils.removeFirst(input, pattern).length() > 0;  // BAD
  }

  public boolean apache3(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return RegExUtils.removePattern(input, pattern).length() > 0;  // BAD
  }

  public boolean apache4(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return RegExUtils.replaceAll(input, pattern, "").length() > 0;  // BAD
  }

  public boolean apache5(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return RegExUtils.replaceFirst(input, pattern, "").length() > 0;  // BAD
  }

  public boolean apache6(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    Pattern pt = (Pattern)(Object) pattern;
    return RegExUtils.replaceFirst(input, pt, "").length() > 0;  // GOOD, Pattern compile is the sink instead
  }

  public boolean apache7(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return RegExUtils.replacePattern(input, pattern, "").length() > 0;  // BAD
  }
}
