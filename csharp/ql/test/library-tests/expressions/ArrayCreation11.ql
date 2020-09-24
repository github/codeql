/**
 * @name Test for array creations
 */

import csharp

private boolean isImplicit(Expr expr) {
  if expr.isImplicit() then result = true else result = false
}

from ArrayCreation ac, Expr expr
where ac.isImplicitlySized() and not ac.isImplicitlyTyped() and expr = ac.getALengthArgument()
select ac, expr, isImplicit(expr)
