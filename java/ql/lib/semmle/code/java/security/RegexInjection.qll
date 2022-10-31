/** Provides classes and predicates related to regex injection in Java. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.regex.RegexFlowConfigs

/**
 * A data flow sink for untrusted user input used to construct regular expressions.
 */
abstract class Sink extends DataFlow::ExprNode { }

/**
 * A sanitizer for untrusted user input used to construct regular expressions.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

// TODO: look into further: Pattern.matcher, .pattern() and .toString() as taint steps, .split and .splitAsStream
/**
 * A data flow sink for untrusted user input used to construct regular expressions.
 */
private class RegexSink extends Sink {
  RegexSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      ma.getArgument(0) = this.asExpr() and
      (
        m.getDeclaringType() instanceof TypeString and
        m.hasName(["matches", "split", "replaceFirst", "replaceAll"])
        or
        m.getDeclaringType() instanceof RegexPattern and
        m.hasName(["compile", "matches"])
      )
      or
      m.getDeclaringType() instanceof ApacheRegExUtils and
      (
        ma.getArgument(1) = this.asExpr() and
        // only handles String param here because the other param option, Pattern, is already handled by `java.util.regex.Pattern` above
        m.getParameterType(1) instanceof TypeString and
        m.hasName([
            "removeAll", "removeFirst", "removePattern", "replaceAll", "replaceFirst",
            "replacePattern"
          ])
      )
    )
  }
}

/**
 * A call to a function whose name suggests that it escapes regular
 * expression meta-characters.
 */
class RegexInjectionSanitizer extends Sanitizer {
  RegexInjectionSanitizer() {
    exists(string calleeName, string sanitize, string regexp |
      calleeName = this.asExpr().(Call).getCallee().getName() and
      // TODO: add test case for sanitize? I think current tests only check escape
      // TODO: should this be broader and only look for "escape|saniti[sz]e" and not "regexp?" as well? -- e.g. err on side of FNs?
      sanitize = "(?:escape|saniti[sz]e)" and
      regexp = "regexp?"
    |
      calleeName
          .regexpMatch("(?i)(" + sanitize + ".*" + regexp + ".*)" + "|(" + regexp + ".*" + sanitize +
              ".*)")
    )
    or
    // adds Pattern.quote() as a sanitizer
    // https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#quote-java.lang.String-: "Metacharacters or escape sequences in the input sequence will be given no special meaning."
    // see https://rules.sonarsource.com/java/RSPEC-2631 and https://sensei.securecodewarrior.com/recipes/scw:java:regex-injection
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m.getDeclaringType() instanceof RegexPattern and
      (
        ma.getArgument(0) = this.asExpr() and
        m.hasName("quote")
      )
    )
  }
}

// ******** HELPER CLASSES/METHODS (MAYBE MOVE ELSEWHERE?) ********
// TODO: move below to Regex.qll??
/** The Java class `java.util.regex.Pattern`. */
private class RegexPattern extends RefType {
  RegexPattern() { this.hasQualifiedName("java.util.regex", "Pattern") }
}

// /** The Java class `java.util.regex.Matcher`. */
// private class RegexMatcher extends RefType {
//   RegexMatcher() { this.hasQualifiedName("java.util.regex", "Matcher") }
// }
/** The Java class `org.apache.commons.lang3.RegExUtils`. */
private class ApacheRegExUtils extends RefType {
  ApacheRegExUtils() { this.hasQualifiedName("org.apache.commons.lang3", "RegExUtils") }
}
