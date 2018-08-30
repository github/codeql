/**
 * @name Improper validation of user-provided array index
 * @description Using external input as an index to an array, without proper validation, can lead to index out of bound exceptions.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/improper-validation-of-array-index
 * @tags security
 *       external/cwe/cwe-129
 */

import java
import ArraySizing
import semmle.code.java.dataflow.FlowSources

class Conf extends TaintTracking::Configuration {
  Conf() { this = "RemoteUserInputTocanThrowOutOfBoundsDueToEmptyArrayConfig" }
  override predicate isSource(DataFlow::Node source) { source instanceof RemoteUserInput }
  override predicate isSink(DataFlow::Node sink) {
    any(CheckableArrayAccess caa).canThrowOutOfBounds(sink.asExpr())
  }
  override predicate isSanitizer(DataFlow::Node node) { node.getType() instanceof BooleanType }
}

from RemoteUserInput source, Expr index, CheckableArrayAccess arrayAccess
where
  arrayAccess.canThrowOutOfBounds(index) and
  any(Conf conf).hasFlow(source, DataFlow::exprNode(index))
select arrayAccess.getIndexExpr(),
  "$@ flows to here and is used as an index causing an ArrayIndexOutOfBoundsException.",
  source, "User-provided value"
