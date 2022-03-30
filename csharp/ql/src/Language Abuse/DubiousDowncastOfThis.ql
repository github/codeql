/**
 * @name Dubious downcast of 'this'
 * @description Casting 'this' to a derived type introduces a dependency cycle between the type of 'this' and the target type.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/downcast-of-this
 * @tags testability
 *       maintainability
 *       language-features
 */

import csharp

from ExplicitCast c, ValueOrRefType src, ValueOrRefType dest
where
  c.getExpr() instanceof ThisAccess and
  src = c.getExpr().getType() and
  dest = c.getTargetType() and
  src = dest.getABaseType+()
select c, "Downcasting 'this' from $@ to $@ introduces a dependency cycle between the two types.",
  src, src.getName(), dest, dest.getName()
