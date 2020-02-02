public class ReDoS {
  private static String EXPONENTIAL_REGEX = "(a+)+";

  public void regexMatchBad(HttpServletRequest request) {
    // BAD: User provided input is matched against exponential regex using standard
    // Java regular expression engine
    java.util.regex.Pattern p = java.util.regex.Pattern.compile(EXPONENTIAL_REGEX);
    java.util.regex.Matcher m = p.matcher(request.getParameter("input"));
    boolean matches = m.matches();
  }

  public void regexMatchGood(HttpServletRequest request) {
    // GOOD: RE2/J regular expression engine is being used 
    com.google.re2j.Pattern p = com.google.re2j.Pattern.compile(EXPONENTIAL_REGEX);
    com.google.re2j.Matcher m = p.matcher(request.getParameter("input"));
    boolean matches = m.matches();
  }
}