/**
 * @name Static array and non-empty array literal
 * @description Finds public constants that are assigned an array.
 *              Arrays are mutable and can be changed by malicious code or by accident.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/static-array
 * @tags reliability
 *       maintainability
 *       modularity
 *       external/cwe/cwe-582
 */
import csharp

predicate nonEmptyArrayLiteralOrNull(Expr e) {
  exists(ArrayCreation arr | arr = e |
    exists(arr.getInitializer().getAnElement())
    or
    not arr.getALengthArgument().getValue() = "0"
  )
  or e instanceof NullLiteral
  or
  exists(ConditionalExpr cond | cond = e |
    nonEmptyArrayLiteralOrNull(cond.getThen()) and
    nonEmptyArrayLiteralOrNull(cond.getElse())
  )
}

from Field f
where f.isPublic() and
      f.isStatic() and
      f.isReadOnly() and
      f.getType() instanceof ArrayType and
      f.fromSource() and
      forall(AssignExpr a | a.getLValue() = f.getAnAccess() | nonEmptyArrayLiteralOrNull(a.getRValue())) and
      forall(Expr e | e = f.getInitializer() | nonEmptyArrayLiteralOrNull(e))
select f, f.getName() + " is a static array vulnerable to mutation."
