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
  propertyOverrides(pa.getTarget(), "System.Array", "Length")
}

/**
 * Holds if expression `e` is either
 * - a compile time constant with integer value `val`, or
 * - a read of a compile time constant with integer value `val`, or
 * - a read of the `Length` of an array with `val` lengths.
 */
private predicate constantIntegerExpr(ExprNode e, int val) {
  e.getValue().toInt() = val
  or
  exists(ExprNode src |
    e = getAnExplicitDefinitionRead(src) and
    constantIntegerExpr(src, val)
  )
  or
  isArrayLengthAccess(e, val)
}

private int getArrayLength(ExprNode e, int index) {
  exists(ArrayCreation arrCreation, ExprNode length |
    hasChild(arrCreation, arrCreation.getLengthArgument(index), e, length) and
    constantIntegerExpr(length, result)
  )
}

private int getArrayLengthRec(ExprNode arrCreation, int index) {
  index = 0 and result = getArrayLength(arrCreation, 0)
  or
  index > 0 and
  result = getArrayLength(arrCreation, index) * getArrayLengthRec(arrCreation, index - 1)
}

private predicate isArrayLengthAccess(ExprNode e, int length) {
  exists(PropertyAccess pa, ExprNode arrCreation |
    systemArrayLengthAccess(pa) and
    getArrayLengthRec(arrCreation,
      arrCreation.getExpr().(ArrayCreation).getNumberOfLengthArguments() - 1) = length and
    hasChild(pa, pa.getQualifier(), e, getAnExplicitDefinitionRead(arrCreation))
  )
}

/** An expression that always has the same integer value. */
class ConstantIntegerExpr extends ExprNode {
  ConstantIntegerExpr() { constantIntegerExpr(this, _) }

  /** Gets the integer value of this expression. */
  int getIntValue() { constantIntegerExpr(this, result) }
}
