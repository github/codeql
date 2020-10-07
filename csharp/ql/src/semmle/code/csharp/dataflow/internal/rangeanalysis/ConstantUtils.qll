/**
 * Provides classes and predicates to represent constant integer expressions.
 */

private import csharp
private import Ssa

/**
 * Holds if property `p` matches `property` in `baseClass` or any overrides.
 */
predicate propertyOverrides(Property p, string baseClass, string property) {
  exists(Property p2 |
    p2.getSourceDeclaration().getDeclaringType().hasQualifiedName(baseClass) and
    p2.hasName(property)
  |
    p.overridesOrImplementsOrEquals(p2)
  )
}

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
private predicate constantIntegerExpr(Expr e, int val) {
  e.getValue().toInt() = val
  or
  exists(ExplicitDefinition v, Expr src |
    e = v.getARead() and
    src = v.getADefinition().getSource() and
    constantIntegerExpr(src, val)
  )
  or
  isArrayLengthAccess(e, val)
}

private int getArrayLength(ArrayCreation arrCreation, int index) {
  constantIntegerExpr(arrCreation.getLengthArgument(index), result)
}

private int getArrayLengthRec(ArrayCreation arrCreation, int index) {
  index = 0 and result = getArrayLength(arrCreation, 0)
  or
  index > 0 and
  result = getArrayLength(arrCreation, index) * getArrayLengthRec(arrCreation, index - 1)
}

private predicate isArrayLengthAccess(PropertyAccess pa, int length) {
  systemArrayLengthAccess(pa) and
  exists(ExplicitDefinition arr, ArrayCreation arrCreation |
    getArrayLengthRec(arrCreation, arrCreation.getNumberOfLengthArguments() - 1) = length and
    arrCreation = arr.getADefinition().getSource() and
    pa.getQualifier() = arr.getARead()
  )
}

/** An expression that always has the same integer value. */
class ConstantIntegerExpr extends Expr {
  ConstantIntegerExpr() { constantIntegerExpr(this, _) }

  /** Gets the integer value of this expression. */
  int getIntValue() { constantIntegerExpr(this, result) }
}
