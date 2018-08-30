/**
 * @name Improper validation of local user-provided array index
 * @description Using local user input as an index to an array, without
 *              proper validation, can lead to index out of bound exceptions.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/improper-validation-of-array-index-local
 * @tags security
 *       external/cwe/cwe-129
 */

import java
import ArraySizing
import semmle.code.java.dataflow.FlowSources

class Conf extends TaintTracking::Configuration {
  Conf() { this = "LocalUserInputTocanThrowOutOfBoundsDueToEmptyArrayConfig" }
  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }
  override predicate isSink(DataFlow::Node sink) {
    any(CheckableArrayAccess caa).canThrowOutOfBounds(sink.asExpr())
  }
}

from LocalUserInput source, Expr index, CheckableArrayAccess arrayAccess
where
  arrayAccess.canThrowOutOfBounds(index) and
  any(Conf conf).hasFlow(source, DataFlow::exprNode(index))
select arrayAccess.getIndexExpr(),
  "$@ flows to here and is used as an index causing an ArrayIndexOutOfBoundsException.",
  source, "User-provided value"
