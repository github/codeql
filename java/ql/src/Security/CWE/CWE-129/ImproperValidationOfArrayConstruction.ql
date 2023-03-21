/**
 * @name Improper validation of user-provided size used for array construction
 * @description Using unvalidated external input as the argument to a construction of an array can lead to index out of bound exceptions.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.8
 * @precision medium
 * @id java/improper-validation-of-array-construction
 * @tags security
 *       external/cwe/cwe-129
 */

import java
import ArraySizing
import semmle.code.java.dataflow.FlowSources

private module ImproperValidationOfArrayConstructionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    any(CheckableArrayAccess caa).canThrowOutOfBoundsDueToEmptyArray(sink.asExpr(), _)
  }
}

module ImproperValidationOfArrayConstructionFlow =
  TaintTracking::Make<ImproperValidationOfArrayConstructionConfig>;

import ImproperValidationOfArrayConstructionFlow::PathGraph

from
  ImproperValidationOfArrayConstructionFlow::PathNode source,
  ImproperValidationOfArrayConstructionFlow::PathNode sink, Expr sizeExpr,
  ArrayCreationExpr arrayCreation, CheckableArrayAccess arrayAccess
where
  arrayAccess.canThrowOutOfBoundsDueToEmptyArray(sizeExpr, arrayCreation) and
  sizeExpr = sink.getNode().asExpr() and
  ImproperValidationOfArrayConstructionFlow::hasFlowPath(source, sink)
select arrayAccess.getIndexExpr(), source, sink,
  "This accesses the $@, but the array is initialized using a $@ which may be zero.", arrayCreation,
  "array", source.getNode(), "user-provided value"
