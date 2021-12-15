/**
 * @name Improper validation of code-specified size used for array construction
 * @description Using a code-specified value that may be zero as the argument to
 *              a construction of an array can lead to index out of bound exceptions.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 8.8
 * @precision medium
 * @id java/improper-validation-of-array-construction-code-specified
 * @tags security
 *       external/cwe/cwe-129
 */

import java
import ArraySizing
import DataFlow::PathGraph

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

from
  DataFlow::PathNode source, DataFlow::PathNode sink, BoundedFlowSource boundedsource,
  Expr sizeExpr, ArrayCreationExpr arrayCreation, CheckableArrayAccess arrayAccess
where
  arrayAccess.canThrowOutOfBoundsDueToEmptyArray(sizeExpr, arrayCreation) and
  sizeExpr = sink.getNode().asExpr() and
  boundedsource = source.getNode() and
  any(BoundedFlowSourceConf conf).hasFlowPath(source, sink)
select arrayAccess.getIndexExpr(), source, sink,
  "The $@ is accessed here, but the array is initialized using $@ which may be zero.",
  arrayCreation, "array", boundedsource, boundedsource.getDescription().toLowerCase()
