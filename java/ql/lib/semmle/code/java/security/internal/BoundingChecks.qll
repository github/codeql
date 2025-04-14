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

/** Gets an access to `e`, which is either a variable or a method. */
pragma[nomagic]
private Expr getAnAccess(Element e) {
  result = e.(Variable).getAnAccess()
  or
  result.(MethodCall).getMethod() = e
}

pragma[nomagic]
private predicate lengthAccess(FieldAccess fa, Element qualifier) {
  fa.getQualifier() = getAnAccess(qualifier) and
  fa.getField().hasName("length")
}

/**
 * Holds if the index expression is a `VarAccess`, where the variable has been confirmed to be less
 * than the length.
 */
predicate lessthanLength(ArrayAccess a) {
  exists(ComparisonExpr lessThanLength, VarAccess va, Element qualifier |
    va = a.getIndexExpr() and
    conditionHolds(lessThanLength, va)
  |
    lengthAccess(lessThanLength.getGreaterOperand(), qualifier) and
    a.getArray() = getAnAccess(qualifier) and
    lessThanLength.getLesserOperand() = va.getVariable().getAnAccess() and
    lessThanLength.isStrict()
  )
}
