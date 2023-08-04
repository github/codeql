/**
 * @name Local-user-controlled data in numeric cast
 * @description Casting user-controlled numeric data to a narrower type without validation
 *              can cause unexpected truncation.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 9.0
 * @precision medium
 * @id java/tainted-numeric-cast-local
 * @tags security
 *       external/cwe/cwe-197
 *       external/cwe/cwe-681
 */

import java
import semmle.code.java.security.NumericCastTaintedQuery
import NumericCastLocalFlow::PathGraph

from
  NumericCastLocalFlow::PathNode source, NumericCastLocalFlow::PathNode sink,
  NumericNarrowingCastExpr exp, VarAccess tainted
where
  exp.getExpr() = tainted and
  sink.getNode().asExpr() = tainted and
  NumericCastLocalFlow::flowPath(source, sink) and
  not exists(RightShiftOp e | e.getShiftedVariable() = tainted.getVariable())
select exp, source, sink,
  "This cast to a narrower type depends on a $@, potentially causing truncation.", source.getNode(),
  "user-provided value"
