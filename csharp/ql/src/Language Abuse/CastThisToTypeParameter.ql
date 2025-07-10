/**
 * @name Cast of 'this' to a type parameter
 * @description Casting 'this' to a type parameter of the current type masks an implicit type constraint that should be explicitly stated.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/cast-of-this-to-type-parameter
 * @tags reliability
 *       maintainability
 *       language-features
 */

import csharp

from ExplicitCast c, ConstructedType src, TypeParameter dest
where
  c.getExpr() instanceof ThisAccess and
  src = c.getExpr().getType() and
  dest = c.getTargetType() and
  dest = src.getUnboundGeneric().getATypeParameter()
select c,
  "Casting 'this' to $@, a type parameter of $@, masks an implicit type constraint that should be explicitly stated.",
  dest, dest.getName(), src, src.getName()
