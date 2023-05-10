/**
 * Provides classes and predicates for determining upper and lower bounds on a value determined by bounding checks that
 * have been made on dominant paths.
 */

import java
private import semmle.code.java.controlflow.Guards

/**
 * Holds if the given `ComparisonExpr` is thought to be true when `VarAccess` is accessed.
 */
private predicate conditionHolds(ComparisonExpr ce, VarAccess va) {
  exists(ConditionBlock cond |
    cond.getCondition() = ce and
    cond.controls(va.getBasicBlock(), true)
  )
}

/**
 * Determine an inclusive lower-bound - if possible - for the value accessed by the given `VarAccess`,
 * based upon the conditionals that hold at the point the variable is accessed.
 */
int lowerBound(VarAccess va) {
  exists(ComparisonExpr greaterThanValue |
    // This condition should hold when the variable is later accessed.
    conditionHolds(greaterThanValue, va)
  |
    greaterThanValue.getGreaterOperand() = va.getVariable().getAnAccess() and
    if greaterThanValue.isStrict()
    then
      // value > i, so value has a lower bound of i + 1
      result = greaterThanValue.getLesserOperand().(CompileTimeConstantExpr).getIntValue() + 1
    else
      // value >= i, so value has a lower bound of i
      result = greaterThanValue.getLesserOperand().(CompileTimeConstantExpr).getIntValue()
  )
}

/**
 * Holds if the index expression is a `VarAccess`, where the variable has been confirmed to be less
 * than the length.
 */
predicate lessthanLength(ArrayAccess a) {
  exists(ComparisonExpr lessThanLength, VarAccess va |
    va = a.getIndexExpr() and
    conditionHolds(lessThanLength, va)
  |
    lessThanLength.getGreaterOperand().(FieldAccess).getQualifier() = arrayReference(a) and
    lessThanLength.getGreaterOperand().(FieldAccess).getField().hasName("length") and
    lessThanLength.getLesserOperand() = va.getVariable().getAnAccess() and
    lessThanLength.isStrict()
  )
}

/**
 * Return all other references to the array accessed in the `ArrayAccess`.
 */
pragma[nomagic]
private Expr arrayReference(ArrayAccess arrayAccess) {
  // Array is stored in a variable.
  result = arrayAccess.getArray().(VarAccess).getVariable().getAnAccess()
  or
  // Array is returned from a method.
  result.(MethodAccess).getMethod() = arrayAccess.getArray().(MethodAccess).getMethod()
}
