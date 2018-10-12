/**
 * @name Cast of 'this' to a type parameter
 * @description Casting 'this' to a type parameter of the current type masks an implicit type constraint that should be explicitly stated.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/cast-of-this-to-type-parameter
 * @tags reliability
 *       maintainability
 *       language-features
 */

import java

from Expr e, GenericType src, TypeVariable dest
where
  exists(CastExpr cse |
    cse = e and
    exists(cse.getLocation()) and
    cse.getExpr() instanceof ThisAccess and
    src = cse.getExpr().getType() and
    dest = cse.getType()
  ) and
  dest.getGenericType() = src
select e,
  "Casting 'this' to $@, a type parameter of $@, masks an implicit type constraint that should be explicitly stated.",
  dest, dest.getName(), src, src.getName()
