/**
 * @name Array constant vulnerable to change
 * @description Array constants are mutable and can be changed by malicious code or by accident.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cs/static-array
 * @tags reliability
 *       maintainability
 *       modularity
 *       external/cwe/cwe-582
 */

import csharp

predicate nonEmptyArrayLiteralOrNull(Expr e) {
  e =
    any(ArrayCreation arr |
      exists(arr.getInitializer().getAnElement())
      or
      not arr.getALengthArgument().getValue() = "0"
    )
  or
  e instanceof NullLiteral
  or
  e =
    any(ConditionalExpr cond |
      nonEmptyArrayLiteralOrNull(cond.getThen()) and
      nonEmptyArrayLiteralOrNull(cond.getElse())
    )
}

from Field f
where
  f.isPublic() and
  f.isStatic() and
  f.isReadOnly() and
  f.getType() instanceof ArrayType and
  f.fromSource() and
  forall(AssignableDefinition def | def.getTarget() = f |
    nonEmptyArrayLiteralOrNull(def.getSource())
  )
select f, "The array constant '" + f.getName() + "' is vulnerable to mutation."
