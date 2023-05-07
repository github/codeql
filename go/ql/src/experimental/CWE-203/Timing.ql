/**
 * @name Timing attacks due to comparision of sensitive secrets
 * @description using a non-constant time comparision method to comapre secrets can lead to authoriztion vulnerabilities
 * @kind path-problem
 * @problem.severity warning
 * @id go/timing-attack
 * @tags security
 *       experimental
 *       external/cwe/cwe-203
 */

import go
import DataFlow::PathGraph
import semmle.go.security.SensitiveActions

private predicate isBadResult(DataFlow::Node e) {
  exists(string path | path = e.asExpr().getFile().getAbsolutePath().toLowerCase() |
    path.matches(["%fake%", "%dummy%", "%test%", "%example%"]) and not path.matches("%ql/test%")
  )
}

/**
 * A data flow source for timing attack vulnerabilities.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A data flow sink for timing attack vulnerabilities.
 */
abstract class Sink extends DataFlow::Node { }

/**
 * A sanitizer for timing attack vulnerabilities.
 */
abstract class Sanitizer extends DataFlow::Node { }

/** A taint-tracking sink which models comparisions of sensitive variables. */
private class SensitiveCompareSink extends Sink {
  ComparisonExpr c;

  SensitiveCompareSink() {
    // We select a comparision where a secret or password is tested.
    exists(SensitiveVariableAccess op1, Expr op2 |
      op1.getClassification() = [SensitiveExpr::secret(), SensitiveExpr::password()] and
      // exclude grant to avoid FP from OAuth
      not op1.getClassification().matches("%grant%") and
      op1 = c.getAnOperand() and
      op2 = c.getAnOperand() and
      not op1 = op2 and
      not (
        // Comparisions with `nil` should be excluded.
        op2 = Builtin::nil().getAReference()
        or
        // Comparisions with empty string should also be excluded.
        op2.getStringValue().length() = 0
      )
    |
      // It is important to note that the name of both the operands need not be
      // `sensitive`. Even if one of the operands appears to be sensitive, we consider it a potential sink.
      c.getAnOperand() = this.asExpr()
    )
  }

  DataFlow::Node getOtherOperand() { result.asExpr() = c.getAnOperand() and not result = this }
}

class SecretTracking extends TaintTracking::Configuration {
  SecretTracking() { this = "SecretTracking" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof UntrustedFlowSource and not isBadResult(source)
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink and not isBadResult(sink) }
}

from SecretTracking cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  cfg.hasFlowPath(source, sink) and
  not cfg.hasFlowTo(sink.getNode().(SensitiveCompareSink).getOtherOperand())
select sink.getNode(), source, sink, "$@ may be vulnerable to timing attacks.", source.getNode(),
  "Hardcoded String"
