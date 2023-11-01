/**
 * @name Improper validation of user-provided array index
 * @description Using external input as an index to an array, without proper validation, can lead to index out of bound exceptions.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.8
 * @precision medium
 * @id java/improper-validation-of-array-index
 * @tags security
 *       external/cwe/cwe-129
 */

import java
import semmle.code.java.security.internal.ArraySizing
import semmle.code.java.security.ImproperValidationOfArrayIndexQuery
import ImproperValidationOfArrayIndexFlow::PathGraph

from
  ImproperValidationOfArrayIndexFlow::PathNode source,
  ImproperValidationOfArrayIndexFlow::PathNode sink, CheckableArrayAccess arrayAccess
where
  arrayAccess.canThrowOutOfBounds(sink.getNode().asExpr()) and
  ImproperValidationOfArrayIndexFlow::flowPath(source, sink)
select arrayAccess.getIndexExpr(), source, sink,
  "This index depends on a $@ which can cause an ArrayIndexOutOfBoundsException.", source.getNode(),
  "user-provided value"
