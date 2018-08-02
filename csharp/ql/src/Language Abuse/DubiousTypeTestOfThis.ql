/**
 * @name Dubious type test of 'this'
 * @description Testing whether 'this' is an instance of a derived type introduces a dependency cycle between the type of 'this' and the target type.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/type-test-of-this
 * @tags testability
 *       maintainability
 *       language-features
 */

import csharp
import semmle.code.csharp.commons.Assertions

from IsTypeExpr ise, ValueOrRefType t, ValueOrRefType ct
where
  ise.getExpr() instanceof ThisAccess
  and t = ise.getExpr().getType()
  and ct = ise.getCheckedType()
  and ct.getABaseType*() = t
  and not isExprInAssertion(ise)
select ise, "Testing whether 'this' is an instance of $@ in $@ introduces a dependency cycle between the two types.",
  ct, ct.getName(),
  t, t.getName()
