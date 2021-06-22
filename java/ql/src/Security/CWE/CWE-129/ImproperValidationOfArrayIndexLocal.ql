/**
 * @name Improper validation of local user-provided array index
 * @description Using local user input as an index to an array, without
 *              proper validation, can lead to index out of bound exceptions.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 8.8
 * @precision medium
 * @id java/improper-validation-of-array-index-local
 * @tags security
 *       external/cwe/cwe-129
 */

import java
import ArraySizing
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class Conf extends TaintTracking::Configuration {
  Conf() { this = "LocalUserInputTocanThrowOutOfBoundsDueToEmptyArrayConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) {
    any(CheckableArrayAccess caa).canThrowOutOfBounds(sink.asExpr())
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, CheckableArrayAccess arrayAccess
where
  arrayAccess.canThrowOutOfBounds(sink.getNode().asExpr()) and
  any(Conf conf).hasFlowPath(source, sink)
select arrayAccess.getIndexExpr(), source, sink,
  "$@ flows to here and is used as an index causing an ArrayIndexOutOfBoundsException.",
  source.getNode(), "User-provided value"
