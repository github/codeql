/**
 * @name Improper validation of code-specified size used for array construction
 * @description Using a code-specified value that may be zero as the argument to
 *              a construction of an array can lead to index out of bound exceptions.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/improper-validation-of-array-construction-code-specified
 * @tags security
 *       external/cwe/cwe-129
 */

import java
import ArraySizing

class BoundedFlowSourceConf extends DataFlow::Configuration {
  BoundedFlowSourceConf() { this = "BoundedFlowSource" }
  override predicate isSource(DataFlow::Node source) {
    source instanceof BoundedFlowSource and
    // There is not a fixed lower bound which is greater than zero.
    not source.(BoundedFlowSource).lowerBound() > 0
  }
  override predicate isSink(DataFlow::Node sink) {
    any(CheckableArrayAccess caa).canThrowOutOfBoundsDueToEmptyArray(sink.asExpr(), _)
  }
}

from BoundedFlowSource source, Expr sizeExpr, ArrayCreationExpr arrayCreation, CheckableArrayAccess arrayAccess
where
  arrayAccess.canThrowOutOfBoundsDueToEmptyArray(sizeExpr, arrayCreation) and
  any(BoundedFlowSourceConf conf).hasFlow(source, DataFlow::exprNode(sizeExpr))
select arrayAccess.getIndexExpr(),
  "The $@ is accessed here, but the array is initialized using $@ which may be zero.",
  arrayCreation, "array",
  source, source.getDescription().toLowerCase()
