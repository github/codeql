import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

import org.apache.commons.lang3.RegExUtils;
import com.google.common.base.Splitter;

public class RegexInjectionTest extends HttpServlet {
  public boolean string1(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return input.matches("^" + pattern + "=.*$");  // $ Alert
  }

  public boolean string2(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return input.split(pattern).length > 0;  // $ Alert
  }

  public boolean string3(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return input.split(pattern, 0).length > 0;  // $ Alert
  }

  public boolean string4(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return input.replaceFirst(pattern, "").length() > 0;  // $ Alert
  }

  public boolean string5(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return input.replaceAll(pattern, "").length() > 0;  // $ Alert
  }

  public boolean pattern1(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    Pattern pt = Pattern.compile(pattern); // $ Alert
    Matcher matcher = pt.matcher(input);

    return matcher.find();
  }

  public boolean pattern2(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return Pattern.compile(pattern).matcher(input).matches();  // $ Alert
  }

  public boolean pattern3(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return Pattern.compile(pattern, 0).matcher(input).matches();  // $ Alert
  }

  public boolean pattern4(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return Pattern.matches(pattern, input);  // $ Alert
  }

  public boolean pattern5(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return input.matches("^" + foo(pattern) + "=.*$"); // $ Alert
  }

  String foo(String str) {
    return str;
  }

  public boolean apache1(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return RegExUtils.removeAll(input, pattern).length() > 0;  // $ Alert
  }

  public boolean apache2(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return RegExUtils.removeFirst(input, pattern).length() > 0;  // $ Alert
  }

  public boolean apache3(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return RegExUtils.removePattern(input, pattern).length() > 0;  // $ Alert
  }

  public boolean apache4(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return RegExUtils.replaceAll(input, pattern, "").length() > 0;  // $ Alert
  }

  public boolean apache5(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return RegExUtils.replaceFirst(input, pattern, "").length() > 0;  // $ Alert
  }

  public boolean apache6(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    Pattern pt = (Pattern)(Object) pattern;
    return RegExUtils.replaceFirst(input, pt, "").length() > 0;  // Safe: Pattern compile is the sink instead
  }

  public boolean apache7(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    String input = request.getParameter("input");

    return RegExUtils.replacePattern(input, pattern, "").length() > 0;  // $ Alert
  }

  // test `Pattern.quote` sanitizer
  public boolean quoteTest(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return input.matches(Pattern.quote(pattern));  // Safe
  }

  // test `Pattern.LITERAL` sanitizer
  public boolean literalTest(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern");
    String input = request.getParameter("input");

    return Pattern.compile(pattern, Pattern.LITERAL).matcher(input).matches();  // Safe
  }

  public Splitter guava1(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    return Splitter.onPattern(pattern);  // $ Alert
  }

  public Splitter guava2(javax.servlet.http.HttpServletRequest request) {
    String pattern = request.getParameter("pattern"); // $ Source
    // sink is `Pattern.compile`
    return  Splitter.on(Pattern.compile(pattern));  // $ Alert
  }
}
