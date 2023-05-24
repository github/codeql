/**
 * @name Improper validation of local user-provided size used for array construction
 * @description Using unvalidated local input as the argument to
 *              a construction of an array can lead to index out of bound exceptions.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 8.8
 * @precision medium
 * @id java/improper-validation-of-array-construction-local
 * @tags security
 *       external/cwe/cwe-129
 */

import java
import semmle.code.java.security.internal.ArraySizing
import semmle.code.java.security.ImproperValidationOfArrayConstructionLocalQuery
import ImproperValidationOfArrayConstructionLocalFlow::PathGraph

from
  ImproperValidationOfArrayConstructionLocalFlow::PathNode source,
  ImproperValidationOfArrayConstructionLocalFlow::PathNode sink, Expr sizeExpr,
  ArrayCreationExpr arrayCreation, CheckableArrayAccess arrayAccess
where
  arrayAccess.canThrowOutOfBoundsDueToEmptyArray(sizeExpr, arrayCreation) and
  sizeExpr = sink.getNode().asExpr() and
  ImproperValidationOfArrayConstructionLocalFlow::flowPath(source, sink)
select arrayAccess.getIndexExpr(), source, sink,
  "This accesses the $@, but the array is initialized using a $@ which may be zero.", arrayCreation,
  "array", source.getNode(), "user-provided value"
