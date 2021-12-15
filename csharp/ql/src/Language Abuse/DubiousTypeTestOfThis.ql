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

from IsExpr ie, ValueOrRefType t, ValueOrRefType ct
where
  ie.getExpr() instanceof ThisAccess and
  t = ie.getExpr().getType() and
  ct = ie.getPattern().(TypePatternExpr).getCheckedType() and
  ct.getABaseType*() = t and
  not isExprInAssertion(ie)
select ie,
  "Testing whether 'this' is an instance of $@ in $@ introduces a dependency cycle between the two types.",
  ct, ct.getName(), t, t.getName()
