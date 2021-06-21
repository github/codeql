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
import DataFlow::PathGraph

class Conf extends TaintTracking::Configuration {
  Conf() { this = "RemoteUserInputTocanThrowOutOfBoundsDueToEmptyArrayConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    any(CheckableArrayAccess caa).canThrowOutOfBoundsDueToEmptyArray(sink.asExpr(), _)
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, Expr sizeExpr,
  ArrayCreationExpr arrayCreation, CheckableArrayAccess arrayAccess
where
  arrayAccess.canThrowOutOfBoundsDueToEmptyArray(sizeExpr, arrayCreation) and
  sizeExpr = sink.getNode().asExpr() and
  any(Conf conf).hasFlowPath(source, sink)
select arrayAccess.getIndexExpr(), source, sink,
  "The $@ is accessed here, but the array is initialized using $@ which may be zero.",
  arrayCreation, "array", source.getNode(), "User-provided value"
