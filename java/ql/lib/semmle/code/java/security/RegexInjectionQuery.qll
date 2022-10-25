import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

/**
 * A data flow sink for untrusted user input used to construct regular expressions.
 */
class RegexSink extends DataFlow::ExprNode {
  RegexSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      (
        m.getDeclaringType() instanceof TypeString and
        (
          ma.getArgument(0) = this.asExpr() and // ! combine this line with the below at least? e.g. TypeString and TypePattern both use it
          // ! test below more?
          // ! (are there already classes for these methods in a regex library?)
          m.hasName(["matches", "split", "replaceFirst", "replaceAll"])
        )
        or
        // ! make class for the below? (is there already a class for this and its methods in a regex library?)
        m.getDeclaringType().hasQualifiedName("java.util.regex", "Pattern") and
        (
          ma.getArgument(0) = this.asExpr() and
          // ! look into further: Pattern.matcher, .pattern() and .toString() as taint steps, .split and .splitAsStream
          m.hasName(["compile", "matches"])
        )
        or
        // ! make class for the below? (is there already a class for this and its methods in a regex library?)
        m.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "RegExUtils") and
        (
          ma.getArgument(1) = this.asExpr() and
          m.getParameterType(1) instanceof TypeString and
          // ! test below more?
          m.hasName([
              "removeAll", "removeFirst", "removePattern", "replaceAll", "replaceFirst",
              "replacePattern"
            ])
        )
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
      m.getDeclaringType().hasQualifiedName("java.util.regex", "Pattern") and
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

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}
