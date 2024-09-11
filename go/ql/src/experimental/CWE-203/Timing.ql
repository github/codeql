/**
 * @name Timing attacks due to comparison of sensitive secrets
 * @description using a non-constant time comparison method to compare secrets can lead to authoriztion vulnerabilities
 * @kind path-problem
 * @problem.severity warning
 * @id go/timing-attack
 * @tags security
 *       experimental
 *       external/cwe/cwe-203
 */

import go
import semmle.go.security.SensitiveActions

private predicate isBadResult(DataFlow::Node e) {
  exists(string path | path = e.asExpr().getFile().getAbsolutePath().toLowerCase() |
    path.matches(["%fake%", "%dummy%", "%test%", "%example%"]) and not path.matches("%ql/test%")
  )
}

/**
 * A data flow sink for timing attack vulnerabilities.
 */
abstract class Sink extends DataFlow::Node { }

/** A taint-tracking sink which models comparisons of sensitive expressions using `strings.Compare` function. */
private class SensitiveStringCompareSink extends Sink {
  SensitiveStringCompareSink() {
    // We select a comparison where a secret or password is tested.
    exists(DataFlow::CallNode c, Expr op1, Expr nonSensitiveOperand |
      c.getTarget().hasQualifiedName("strings", "Compare") and
      c.getArgument(_).asExpr() = op1 and
      op1.(SensitiveVariableAccess).getClassification() =
        [SensitiveExpr::secret(), SensitiveExpr::password()] and
      c.getArgument(_).asExpr() = nonSensitiveOperand and
      not op1 = nonSensitiveOperand and
      not (
        // Comparisons with `nil` should be excluded.
        nonSensitiveOperand = Builtin::nil().getAReference()
        or
        // Comparisons with empty string should also be excluded.
        nonSensitiveOperand.getStringValue().length() = 0
      )
    |
      // It is important to note that the name of both the operands need not be
      // `sensitive`. Even if one of the operands appears to be sensitive, we consider it a potential sink.
      nonSensitiveOperand = this.asExpr()
    )
  }
}

/** A taint-tracking sink which models comparisons of sensitive expressions. */
private class SensitiveCompareSink extends Sink {
  SensitiveCompareSink() {
    // We select a comparison where a secret or password is tested.
    exists(SensitiveExpr op1, Expr op2, EqualityTestExpr c |
      op1.getClassification() = [SensitiveExpr::secret(), SensitiveExpr::password()] and
      op1 = c.getAnOperand() and
      op2 = c.getAnOperand() and
      not op1 = op2 and
      not (
        // Comparisons with `nil` should be excluded.
        op2 = Builtin::nil().getAReference()
        or
        // Comparisons with empty string should also be excluded.
        op2.getStringValue().length() = 0
      )
    |
      op2 = this.asExpr()
    )
  }
}

/** A taint-tracking sink which models comparisons of sensitive strings. */
private class SensitiveStringSink extends Sink {
  SensitiveStringSink() {
    // We select a comparison where a secret or password is tested.
    exists(StringLit op1, Expr op2, EqualityTestExpr c |
      op1.getStringValue()
          .regexpMatch(HeuristicNames::maybeSensitive([
                SensitiveExpr::secret(), SensitiveExpr::password()
              ])) and
      op1 = c.getAnOperand() and
      op2 = c.getAnOperand() and
      not op1 = op2 and
      not (
        // Comparisons with `nil` should be excluded.
        op2 = Builtin::nil().getAReference()
        or
        // Comparisons with empty string should also be excluded.
        op2.getStringValue().length() = 0
      )
    |
      op2 = this.asExpr()
    )
  }
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof ThreatModelFlowSource and not isBadResult(source)
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink and not isBadResult(sink) }
}

module Flow = TaintTracking::Global<Config>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "$@ may be vulnerable to timing attacks.", source.getNode(),
  "Hardcoded String"
