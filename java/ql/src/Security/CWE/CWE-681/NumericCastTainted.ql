/**
 * @name User-controlled data in numeric cast
 * @description Casting user-controlled numeric data to a narrower type without validation
 *              can cause unexpected truncation.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id java/tainted-numeric-cast
 * @tags security
 *       external/cwe/cwe-197
 *       external/cwe/cwe-681
 */

import java
import semmle.code.java.security.NumericCastTaintedQuery
import NumericCastFlow::PathGraph

from NumericCastFlow::PathNode source, NumericCastFlow::PathNode sink, NumericNarrowingCastExpr exp
where
  sink.getNode().asExpr() = exp.getExpr() and
  NumericCastFlow::flowPath(source, sink)
select exp, source, sink,
  "This cast to a narrower type depends on a $@, potentially causing truncation.", source.getNode(),
  "user-provided value"
