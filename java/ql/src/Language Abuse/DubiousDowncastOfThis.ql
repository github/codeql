/**
 * @name Dubious downcast of 'this'
 * @description Casting 'this' to a derived type introduces a dependency cycle
 *              between the type of 'this' and the target type.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/downcast-of-this
 * @tags testability
 *       maintainability
 *       language-features
 */

import java

from Expr e, RefType src, RefType dest
where
  exists(CastExpr cse | cse = e |
    exists(cse.getLocation()) and
    cse.getExpr() instanceof ThisAccess and
    src = cse.getExpr().getType() and
    dest = cse.getType()
  ) and
  src.hasSubtype*(dest) and
  src != dest and
  not dest instanceof TypeVariable
select e, "Downcasting 'this' from $@ to $@ introduces a dependency cycle between the two types.",
  src, src.getName(), dest, dest.getName()
