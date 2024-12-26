/**
 * Provides classes and predicates to represent constant integer expressions.
 */

private import csharp
private import Ssa
private import SsaUtils
private import RangeUtils

private class ExprNode = ControlFlow::Nodes::ExprNode;

/**
 * Holds if `pa` is an access to the `Length` property of an array.
 */
predicate systemArrayLengthAccess(PropertyAccess pa) {
  propertyOverrides(pa.getTarget(), "System", "Array", "Length")
}

/**
 * Holds if expression `e` is either
 * - a compile time constant with integer value `val`, or
 * - a read of a compile time constant with integer value `val`, or
 * - a read of the `Length` of an array with `val` lengths.
 */
private predicate constantIntegerExpr(ExprNode e, QlBuiltins::BigInt val) {
  e.getValue().toBigInt() = val
  or
  exists(ExprNode src |
    e = getAnExplicitDefinitionRead(src) and
    constantIntegerExpr(src, val)
  )
  or
  isArrayLengthAccess(e, val)
}

private QlBuiltins::BigInt getArrayLength(ExprNode e, QlBuiltins::BigInt index) {
  exists(ArrayCreation arrCreation, ExprNode length |
    hasChild(arrCreation, arrCreation.getLengthArgument(any(int i | i.toBigInt() = index)), e,
      length) and
    constantIntegerExpr(length, result)
  )
}

private QlBuiltins::BigInt getArrayLengthRec(ExprNode arrCreation, QlBuiltins::BigInt index) {
  index = 0.toBigInt() and result = getArrayLength(arrCreation, 0.toBigInt())
  or
  index > 0.toBigInt() and
  result = getArrayLength(arrCreation, index) * getArrayLengthRec(arrCreation, index - 1.toBigInt())
}

private predicate isArrayLengthAccess(ExprNode e, QlBuiltins::BigInt length) {
  exists(PropertyAccess pa, ExprNode arrCreation |
    systemArrayLengthAccess(pa) and
    getArrayLengthRec(arrCreation,
      (arrCreation.getExpr().(ArrayCreation).getNumberOfLengthArguments() - 1).toBigInt()) = length and
    hasChild(pa, pa.getQualifier(), e, getAnExplicitDefinitionRead(arrCreation))
  )
}

/** An expression that always has the same integer value. */
class ConstantIntegerExpr extends ExprNode {
  ConstantIntegerExpr() { constantIntegerExpr(this, _) }

  /** Gets the integer value of this expression. */
  QlBuiltins::BigInt getIntValue() { constantIntegerExpr(this, result) }
}
