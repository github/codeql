/**
 * @name Improper validation of user-provided size used for array construction
 * @description Using unvalidated external input as the argument to a construction of an array can lead to index out of bound exceptions.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/improper-validation-of-array-construction
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
    any(CheckableArrayAccess caa).canThrowOutOfBoundsDueToEmptyArray(sink.asExpr(), _)
  }
}

from RemoteUserInput source, Expr sizeExpr, ArrayCreationExpr arrayCreation, CheckableArrayAccess arrayAccess
where
  arrayAccess.canThrowOutOfBoundsDueToEmptyArray(sizeExpr, arrayCreation) and
  any(Conf conf).hasFlow(source, DataFlow::exprNode(sizeExpr))
select arrayAccess.getIndexExpr(),
  "The $@ is accessed here, but the array is initialized using $@ which may be zero.",
  arrayCreation, "array",
  source, "User-provided value"
