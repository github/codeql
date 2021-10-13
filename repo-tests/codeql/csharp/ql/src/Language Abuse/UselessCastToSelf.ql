/**
 * @name Cast to same type
 * @description A cast to the same type as the original expression is always redundant.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/useless-cast-to-self
 * @tags maintainability
 *       language-features
 *       external/cwe/cwe-561
 */

import csharp

from ExplicitCast cast, Expr e, Type type
where
  e = cast.getExpr() and
  type = cast.getTargetType() and
  type = e.getType() and
  not type instanceof NullType and
  not e.(ImplicitDelegateCreation).getArgument() instanceof AnonymousFunctionExpr
select cast, "This cast is redundant because the expression already has type " + type + "."
