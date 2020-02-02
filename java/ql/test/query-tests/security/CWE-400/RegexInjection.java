import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.web.bind.annotation.RequestParam;

public class RegexInjection {
  public void testPatternCompileMatcherBad1(@RequestParam String rPatternCompileMatcherBad1, @RequestParam String iPatternCompileMatcherBad1) {
    Pattern.compile(rPatternCompileMatcherBad1).matcher(iPatternCompileMatcherBad1).matches();
  }

  public void testPatternCompileMatcherBad2(@RequestParam String rPatternCompileMatcherBad2, @RequestParam String iPatternCompileMatcherBad2) {
    Pattern p = Pattern.compile(rPatternCompileMatcherBad2);
    Matcher m = p.matcher(iPatternCompileMatcherBad2);
    m.matches();
  }

  public void testPatternMatchesBad1(@RequestParam String rPatternMatchesBad1, @RequestParam String iPatternMatchesBad1) {
    Pattern.matches(rPatternMatchesBad1, iPatternMatchesBad1);
  }

  public void testStringMatchesBad1(@RequestParam String rStringMatchesBad1, @RequestParam String iStringMatchesBad1) {
    iStringMatchesBad1.matches(rStringMatchesBad1);
  }

  // OK - safe regex
  public void testPatternCompileMatcherOk1(@RequestParam String iPatternCompileMatcherOk1) {
    Pattern.compile(".*").matcher(iPatternCompileMatcherOk1).matches();
  }

  // OK - safe input
  public void testPatternCompileMatcherOk2(@RequestParam String rPatternCompileMatcherOk2) {
    Pattern.compile(rPatternCompileMatcherOk2).matcher("input").matches();
  }
}
