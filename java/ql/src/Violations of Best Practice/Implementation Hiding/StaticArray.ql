/**
 * @name Array constant vulnerable to change
 * @description Array constants are mutable and can be changed by malicious code or by accident.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/static-array
 * @tags maintainability
 *       modularity
 *       external/cwe/cwe-582
 */

import java

predicate nonEmptyArrayLiteralOrNull(Expr e) {
  exists(ArrayCreationExpr arr | arr = e |
    // Array initializer expressions such as `{1, 2, 3}`.
    // Array is empty if the initializer expression is empty.
    exists(arr.getInit().getAnInit())
    or
    // Array creation with dimensions (but without initializers).
    // Empty if the first dimension is 0.
    exists(Expr dim | dim = arr.getDimension(0) |
      not dim.(CompileTimeConstantExpr).getIntValue() = 0
    )
  )
  or
  e instanceof NullLiteral
  or
  exists(ConditionalExpr cond | cond = e |
    nonEmptyArrayLiteralOrNull(cond.getTrueExpr()) and
    nonEmptyArrayLiteralOrNull(cond.getFalseExpr())
  )
}

from Field f
where
  f.isPublic() and
  f.isStatic() and
  f.isFinal() and
  f.getType() instanceof Array and
  f.fromSource() and
  forall(AssignExpr a | a.getDest() = f.getAnAccess() | nonEmptyArrayLiteralOrNull(a.getSource()))
select f, "The array constant " + f.getName() + " is vulnerable to mutation."
