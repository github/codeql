import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.regex.RegexFlowConfigs

/** The Java class `java.util.regex.Pattern`. */
private class RegexPattern extends RefType {
  RegexPattern() { this.hasQualifiedName("java.util.regex", "Pattern") }
}

/** The Java class `java.util.regex.Matcher`. */
private class RegexMatcher extends RefType {
  RegexMatcher() { this.hasQualifiedName("java.util.regex", "Matcher") }
}

/** The Java class `org.apache.commons.lang3.RegExUtils`. */
private class ApacheRegExUtils extends RefType {
  ApacheRegExUtils() { this.hasQualifiedName("java.util.regex", "Matcher") }
}

// TODO: Look for above in pre-existing regex libraries again.
// TODO: look into further: Pattern.matcher, .pattern() and .toString() as taint steps, .split and .splitAsStream
/**
 * A data flow sink for untrusted user input used to construct regular expressions.
 */
class RegexSink extends DataFlow::ExprNode {
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
        m.getParameterType(1) instanceof TypeString and // only does String here because other option is Pattern, but that's already handled by `java.util.regex.Pattern` above
        m.hasName([
            "removeAll", "removeFirst", "removePattern", "replaceAll", "replaceFirst",
            "replacePattern"
          ])
      )
    )
  }
}

// ! keep and rename to RegexInjectionSanitizer IF makes sense to have two sanitizers extending it?;
// ! else, ask Tony/others about if stylistically better to keep it (see default example in LogInjection.qll, etc.)
// ! maybe make abstract classes for source and sink as well (if you do this, mention it in PR description as an attempt to be similar to the other languages' implementations)
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A call to a function whose name suggests that it escapes regular
 * expression meta-characters.
 */
// ! rename as DefaultRegexInjectionSanitizer?
class RegExpSanitizationCall extends Sanitizer {
  RegExpSanitizationCall() {
    exists(string calleeName, string sanitize, string regexp |
      calleeName = this.asExpr().(Call).getCallee().getName() and
      // ! add test case for sanitize? I think current tests only check escape
      sanitize = "(?:escape|saniti[sz]e)" and // TODO: confirm this is sufficient
      regexp = "regexp?" // TODO: confirm this is sufficient
    |
      calleeName
          .regexpMatch("(?i)(" + sanitize + ".*" + regexp + ".*)" + "|(" + regexp + ".*" + sanitize +
              ".*)") // TODO: confirm this is sufficient
    )
    or
    // adds Pattern.quote() as a sanitizer
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

/**
 * A taint-tracking configuration for untrusted user input used to construct regular expressions.
 */
class RegexInjectionConfiguration extends TaintTracking::Configuration {
  RegexInjectionConfiguration() { this = "RegexInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RegexSink }

  // ! testing below RegexFlowSink from RegexFlowConfigs.qll
  // ! extra results from jfinal with this... look into further...
  // override predicate isSink(DataFlow::Node sink) { sink instanceof RegexFlowSink }
  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}
