/**
 * @name Reference equality test on System.Object
 * @description Comparisons ('==' or '!=') between something of type 'System.Object' and something of another
 *              type will use reference comparison, which may not have been what was intended.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/reference-equality-with-object
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-595
 */

import csharp
import semmle.code.csharp.frameworks.System

Expr getObjectOperand(EqualityOperation eq) {
  result = eq.getAnOperand() and
  (
    result.getType() instanceof ObjectType or
    result.getType() instanceof Interface
  )
}

class ReferenceEqualityTestOnObject extends EqualityOperation {
  ReferenceEqualityTestOnObject() {
    // One or both of the operands has type object or interface.
    exists(getObjectOperand(this)) and
    // Neither operand is 'null'.
    not getAnOperand() instanceof NullLiteral and
    not exists(Type t | t = getAnOperand().stripImplicitCasts().getType() |
      t instanceof NullType or
      t instanceof ValueType
    ) and
    // Neither operand is a constant - a reference comparison may well be intended for those.
    not getAnOperand().(FieldAccess).getTarget().isReadOnly() and
    not getAnOperand().hasValue() and
    // Not a short-cut test in a custom `Equals` method
    not exists(EqualsMethod m |
      getEnclosingCallable() = m and
      getAnOperand() instanceof ThisAccess and
      getAnOperand() = m.getParameter(0).getAnAccess()
    ) and
    // Reference comparisons in Moq methods are used to define mocks
    not exists(MethodCall mc, Namespace n |
      mc.getTarget().getDeclaringType().getNamespace().getParentNamespace*() = n and
      n.hasName("Moq") and
      not exists(n.getParentNamespace()) and
      mc.getAnArgument() = getEnclosingCallable()
    )
  }

  Expr getObjectOperand() {
    result = getObjectOperand(this) and
    // Avoid duplicate results: only include left operand if both operands
    // have object type
    (result = getRightOperand() implies not getLeftOperand() = getObjectOperand(this))
  }
}

from ReferenceEqualityTestOnObject scw, Expr operand, Type t
where
  operand = scw.getObjectOperand() and
  t = operand.getType()
select scw,
  "Reference equality for System.Object comparisons ($@ argument has type " + t.getName() + ").",
  operand, "this"
