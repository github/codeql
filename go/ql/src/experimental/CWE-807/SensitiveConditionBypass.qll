import go
import semmle.go.security.SensitiveActions

/**
 * Holds if `sink` is used in a context that suggests it may hold sensitive data of
 * the given `type`.
 */
predicate isSensitive(DataFlow::Node sink, SensitiveExpr::Classification type) {
  exists(Write write, string name |
    write.getRhs() = sink and
    name = write.getLhs().getName() and
    // allow obvious test password variables
    not name.regexpMatch(HeuristicNames::notSensitive())
  |
    name.regexpMatch(HeuristicNames::maybeSensitive(type))
  )
  or
  exists(SensitiveCall a | sink.asExpr() = a and a.getClassification() = type)
  or
  exists(SensitiveExpr a | sink.asExpr() = a and a.getClassification() = type)
  or
  exists(SensitiveAction a | a = sink and type = SensitiveExpr::secret())
}

private class ConstComparisonExpr extends ComparisonExpr {
  string constString;

  ConstComparisonExpr() {
    exists(DataFlow::Node n |
      n.getASuccessor*() = DataFlow::exprNode(this.getAnOperand()) and
      constString = n.getStringValue()
    )
  }

  predicate isPotentialFalsePositive() {
    // if its an empty string
    constString.length() = 0 or
    // // if it is uri path
    constString.matches("/%") or
    constString.matches("%/") or
    constString.matches("%/%")
  }
}

/**
 * A data-flow configuration for reasoning about
 * user-controlled bypassing of sensitive actions.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "Condtional Expression Check Bypass" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof UntrustedFlowSource
    or
    exists(DataFlow::FieldReadNode f |
      f.getField().hasQualifiedName("net/http", "Request", "Host")
    |
      source = f
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ConstComparisonExpr c |
      c.getAnOperand() = sink.asExpr() and
      not c.isPotentialFalsePositive()
    )
  }
}
