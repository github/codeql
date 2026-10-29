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
import semmle.code.java.security.internal.ArraySizing
import semmle.code.java.security.ImproperValidationOfArrayConstructionCodeSpecifiedQuery
import BoundedFlowSourceFlow::PathGraph

from
  BoundedFlowSourceFlow::PathNode source, BoundedFlowSourceFlow::PathNode sink,
  BoundedFlowSource boundedsource, Expr sizeExpr, ArrayCreationExpr arrayCreation,
  CheckableArrayAccess arrayAccess
where
  arrayAccess.canThrowOutOfBoundsDueToEmptyArray(sizeExpr, arrayCreation) and
  sizeExpr = sink.getNode().asExpr() and
  boundedsource = source.getNode() and
  BoundedFlowSourceFlow::flowPath(source, sink)
select arrayAccess.getIndexExpr(), source, sink,
  "This accesses the $@, but the array is initialized using $@ which may be zero.", arrayCreation,
  "array", boundedsource, boundedsource.getDescription().toLowerCase()
