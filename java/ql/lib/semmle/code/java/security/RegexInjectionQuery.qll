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
          ma.getArgument(0) = this.asExpr() and
          // TODO: confirm if more/less than the below need to be handled
          m.hasName(["matches", "split", "replaceFirst", "replaceAll"])
        )
        or
        // TODO: review Java Pattern API
        m.getDeclaringType().hasQualifiedName("java.util.regex", "Pattern") and
        (
          ma.getArgument(0) = this.asExpr() and
          // TODO: confirm if more/less than the below need to be handled
          m.hasName(["compile", "matches"])
        )
        or
        // TODO: read docs about regex APIs in Java
        m.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "RegExUtils") and
        (
          ma.getArgument(1) = this.asExpr() and
          m.getParameterType(1) instanceof TypeString and
          // TODO: confirm if more/less than the below need to be handled
          m.hasName([
              "removeAll", "removeFirst", "removePattern", "replaceAll", "replaceFirst",
              "replacePattern"
            ])
        )
      )
    )
  }
}

// TODO: is this abstract class needed? Are there pre-existing sanitizer classes that can be used instead?
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A call to a function whose name suggests that it escapes regular
 * expression meta-characters.
 */
class RegExpSanitizationCall extends Sanitizer {
  RegExpSanitizationCall() {
    exists(string calleeName, string sanitize, string regexp |
      calleeName = this.asExpr().(Call).getCallee().getName() and
      sanitize = "(?:escape|saniti[sz]e)" and // TODO: confirm this is sufficient
      regexp = "regexp?" // TODO: confirm this is sufficient
    |
      calleeName
          .regexpMatch("(?i)(" + sanitize + ".*" + regexp + ".*)" + "|(" + regexp + ".*" + sanitize +
              ".*)") // TODO: confirm this is sufficient
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
