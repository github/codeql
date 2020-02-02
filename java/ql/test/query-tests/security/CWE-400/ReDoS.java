import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.web.bind.annotation.RequestParam;

public class ReDoS {
  private static final String PATTERN_BAD1 = "([a-z]+)+";
  private static final String PATTERN_BAD2 = "((a+)*)+";
  private static final String PATTERN_BAD3 = "((((a+)+)+)+)+";
  private static final String PATTERN_BAD4 = "(([a-z])?([a-z]+))+";
  private static final String PATTERN_BAD5 = "(([a-zA-Z])+)+";
  private static final String PATTERN_BAD6 = "([a-zA-Z]+)*";
  private static final String PATTERN_BAD7 = "(a|aa)+";
  private static final String PATTERN_BAD8 = "([a-z]|[a-z]?)+";
  private static final String PATTERN_BAD9 = "(.*a){10}";
  private static final String PATTERN_BAD10 = "(.*[a-z]){10,11}";
  private static final String PATTERN_OK1 = "a.*";
  private static final String PATTERN_OK2 = "(a|ab)+";
  private static final String PATTERN_OK3 = "(a|b?)+";
  private static final String PATTERN_OK4 = "(.*a){9}";

  private Pattern pattern = Pattern.compile(PATTERN_BAD1);

  public void testPatternCompileMatcherBad1(@RequestParam String patternCompileMatcherBad1) {
    Pattern.compile(PATTERN_BAD2).matcher(patternCompileMatcherBad1).matches();
  }

  public void testPatternCompileMatcherBad2(@RequestParam String patternCompileMatcherBad2) {
    Pattern p = Pattern.compile(PATTERN_BAD3);
    Matcher m = p.matcher(patternCompileMatcherBad2);
    m.matches();
  }

  public void testPatternCompileMatcherBad3(@RequestParam String patternCompileMatcherBad3) {
    Matcher m = this.pattern.matcher(patternCompileMatcherBad3);
    m.matches();
  }

  public void testPatternMatchesBad1(@RequestParam String patternMatchesBad1) {
    Pattern.matches(PATTERN_BAD4, patternMatchesBad1);
  }

  public void testStringMatchesBad1(@RequestParam String stringMatchesBad1) {
    stringMatchesBad1.matches(PATTERN_BAD5);
  }

  public void testStringMatchesBad2(@RequestParam String stringMatchesBad2) {
    stringMatchesBad2.matches(PATTERN_BAD6);
  }

  public void testStringMatchesBad3(@RequestParam String stringMatchesBad3) {
    stringMatchesBad3.matches(PATTERN_BAD7);
  }

  public void testStringMatchesBad4(@RequestParam String stringMatchesBad4) {
    stringMatchesBad4.matches(PATTERN_BAD8);
  }

  public void testStringMatchesBad5(@RequestParam String stringMatchesBad5) {
    stringMatchesBad5.matches(PATTERN_BAD9);
  }

  public void testStringMatchesBad6(@RequestParam String stringMatchesBad6) {
    stringMatchesBad6.matches(PATTERN_BAD10);
  }

  // OK - safe regex
  public void testPatternCompileMatcherOk1(@RequestParam String patternCompileMatcherOk1) {
    Pattern.compile(PATTERN_OK1).matcher(patternCompileMatcherOk1).matches();
  }

  // OK - safe regex
  public void testPatternCompileMatcherOk2(@RequestParam String patternCompileMatcherOk2) {
    Pattern.compile(PATTERN_OK2).matcher(patternCompileMatcherOk2).matches();
  }

  // OK - safe regex
  public void testPatternCompileMatcherOk3(@RequestParam String patternCompileMatcherOk3) {
    Pattern.compile(PATTERN_OK3).matcher(patternCompileMatcherOk3).matches();
  }

  // OK - safe regex
  public void testPatternCompileMatcherOk4(@RequestParam String patternCompileMatcherOk4) {
    Pattern.compile(PATTERN_OK4).matcher(patternCompileMatcherOk4).matches();
  }

  // OK - safe input
  public void testPatternCompileMatcherOk2() {
    Pattern.compile(PATTERN_BAD1).matcher("input").matches();
  }
}
