/**
 * @name Dubious type test of 'this'
 * @description Testing whether 'this' is an instance of a derived type introduces
 *              a dependency cycle between the type of 'this' and the target type.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/type-test-of-this
 * @tags testability
 *       maintainability
 *       language-features
 */

import java

from InstanceOfExpr ioe, RefType t, RefType ct
where
  ioe.getExpr() instanceof ThisAccess and
  t = ioe.getExpr().getType() and
  ct = ioe.getTypeName().getType() and
  ct.getASupertype*() = t
select ioe,
  "Testing whether 'this' is an instance of $@ in $@ introduces a dependency cycle between the two types.",
  ct, ct.getName(), t, t.getName()
