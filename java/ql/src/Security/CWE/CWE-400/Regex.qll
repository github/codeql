import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.TaintTracking2

/**
 * A taint-tracking configuration for unvalidated user input that is used to match against
 * malicious regex.
 */
class RegexInputFlowConfig extends TaintTracking::Configuration {
  RegexInputFlowConfig() { this = "RegexInputFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RegexInputSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

/**
 * Holds if method call `ma` matches against the regex `regexExpr`. For example, method `matches`
 * matches against regex `regex` in `Pattern.matches(regex, input)`.
 */
predicate matchesAgainstRegex(MethodAccess ma, Expr regexExpr) {
  // `Pattern.matches(regex, input)`
  ma.getMethod() instanceof MethodPatternMatches and
  regexExpr.getParent() = ma
  or
  // `Pattern.compile(regex).matcher(input)` or
  // `Pattern p = Pattern.compile(regex); p.matcher(input);` or
  // `private Pattern p = Pattern.compile(regex); public void foo() { p.matcher(input); }`
  ma.getMethod() instanceof MethodPatternMatcher and
  (
    DataFlow::localFlow(DataFlow::exprNode(regexExpr.getParent()),
      DataFlow::exprNode(ma.getQualifier())) or
    ma.getQualifier().(FieldAccess).getField().getInitializer() = regexExpr.getParent()
  )
  or
  // `input.matches(pattern)`
  ma.getMethod() instanceof MethodStringMatches and
  regexExpr = ma.getAnArgument()
}

/** A data flow sink for unvalidated user input that is used to match against malicious regex. */
class RegexInputSink extends DataFlow::ExprNode {
  RegexInputSink() {
    exists(MethodAccess ma, RegexPatternFlowConfig cfg, DataFlow::ExprNode regexSink |
      ma.getAnArgument() = this.getExpr() or ma.getQualifier() = this.getExpr()
    |
      cfg.hasFlow(_, regexSink) and
      matchesAgainstRegex(ma, regexSink.getExpr()) and
      this != regexSink
    )
  }
}

/** A data flow source for malicious regex. */
abstract class RegexPatternSource extends DataFlow::Node { }

/**
 * A taint-tracking configuration for regex pattern that is used to create `Pattern` or is used
 * as an argument to `matches` method.
 */
class RegexPatternFlowConfig extends TaintTracking2::Configuration {
  RegexPatternFlowConfig() { this = "RegexPatternFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RegexPatternSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma | ma.getAnArgument() = sink.asExpr() |
      ma.getMethod() instanceof MethodPatternCompile or
      ma.getMethod() instanceof MethodPatternMatches or
      ma.getMethod() instanceof MethodStringMatches
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

/**
 * An expression that represents a regular expression with potential exponential behavior.
 */
predicate isExponentialRegex(StringLiteral s) {
  /*
   * Detect three variants of a common pattern that leads to exponential blow-up.
   */

  // Example: ([a-z]+.)+
  s.getValue().regexpMatch(".*\\([^()*+\\]]+\\]?(\\*|\\+)\\.?\\)(\\*|\\+).*")
  or
  // Example: (([a-z])?([a-z]+.))+
  s
      .getValue()
      .regexpMatch(".*\\((\\([^()]+\\)\\?)?\\([^()*+\\]]+\\]?(\\*|\\+)\\.?\\)\\)(\\*|\\+).*")
  or
  // Example: (([a-z])+.)+
  s.getValue().regexpMatch(".*\\(\\([^()*+\\]]+\\]?\\)(\\*|\\+)\\.?\\)(\\*|\\+).*")
}
