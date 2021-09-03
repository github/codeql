/** Provides logic for determining constant expressions. */

import csharp
private import semmle.code.csharp.commons.ComparisonTest
private import semmle.code.csharp.commons.StructuralComparison as StructuralComparison

pragma[noinline]
private predicate isConstantCondition0(ControlFlow::Node cfn, boolean b) {
  exists(
    cfn.getASuccessorByType(any(ControlFlow::SuccessorTypes::BooleanSuccessor t | t.getValue() = b))
  ) and
  strictcount(ControlFlow::SuccessorType t | exists(cfn.getASuccessorByType(t))) = 1
}

/**
 * Holds if `e` is a condition that always evaluates to Boolean value `b`.
 */
predicate isConstantCondition(Expr e, boolean b) {
  forex(ControlFlow::Node cfn | cfn = e.getAControlFlowNode() | isConstantCondition0(cfn, b))
}

/**
 * Holds if comparison operation `co` is constant with the Boolean value `b`.
 * For example, the comparison `x > x` is constantly `false` in
 *
 * ```csharp
 * int MaxWrong(int x, int y) => x > x ? x : y;
 * ```
 */
predicate isConstantComparison(ComparisonOperation co, boolean b) {
  co.getValue() = "true" and
  b = true
  or
  co.getValue() = "false" and
  b = false
  or
  ConstantComparisonOperation::isConstant(co, b)
}

/**
 * Provides logic for determining whether a comparison is constant.
 */
private module ConstantComparisonOperation {
  private import semmle.code.csharp.commons.ComparisonTest

  private SimpleType convertedType(Expr expr) { result = expr.stripImplicitCasts().getType() }

  private int maxValue(Expr expr) {
    if convertedType(expr) instanceof IntegralType and exists(expr.getValue())
    then result = expr.getValue().toInt()
    else result = convertedType(expr).maxValue()
  }

  private int minValue(Expr expr) {
    if convertedType(expr) instanceof IntegralType and exists(expr.getValue())
    then result = expr.getValue().toInt()
    else result = convertedType(expr).minValue()
  }

  /** Holds if the comparison test `cmp` is constant with the value `value`. */
  predicate isConstant(Expr e, boolean value) {
    exists(ComparisonTest cmp, Expr l, Expr r |
      e = cmp.getExpr() and
      l = cmp.getFirstArgument() and
      r = cmp.getSecondArgument()
    |
      cmp.getComparisonKind().isLessThan() and
      maxValue(l) < minValue(r) and
      value = true
      or
      cmp.getComparisonKind().isLessThan() and
      minValue(l) >= maxValue(r) and
      value = false
      or
      cmp.getComparisonKind().isLessThanEquals() and
      maxValue(l) <= minValue(r) and
      value = true
      or
      cmp.getComparisonKind().isLessThanEquals() and
      minValue(l) > maxValue(r) and
      value = false
      or
      // Operands are unequal
      (maxValue(l) < minValue(r) or maxValue(r) < minValue(l)) and
      (
        cmp.getComparisonKind().isInequality() and value = true
        or
        cmp.getComparisonKind().isEquality() and value = false
      )
      or
      exists(LocalScopeVariable v |
        l.(VariableRead).getTarget() = v and
        r.(VariableRead).getTarget() = v and
        not v.getType() instanceof FloatingPointType // One of the arguments may be NaN
      |
        cmp.getComparisonKind().isLessThan() and value = false
        or
        cmp.getComparisonKind().isLessThanEquals() and value = true
        or
        cmp.getComparisonKind().isEquality() and value = true
        or
        cmp.getComparisonKind().isInequality() and value = false
      )
    )
  }
}

private class StructuralComparisonConfig extends StructuralComparison::StructuralComparisonConfiguration {
  StructuralComparisonConfig() { this = "CompareIdenticalValues" }

  override predicate candidate(ControlFlowElement x, ControlFlowElement y) {
    exists(ComparisonTest ct |
      x = ct.getFirstArgument() and
      y = ct.getSecondArgument()
    )
  }

  ComparisonTest getComparisonTest() {
    exists(Element x, Element y |
      result.getFirstArgument() = x and
      result.getSecondArgument() = y and
      same(x, y)
    )
  }
}

/**
 * Holds if comparison test `ct` compares two structurally identical
 * expressions.
 */
predicate comparesIdenticalValues(ComparisonTest ct) {
  ct = any(StructuralComparisonConfig c).getComparisonTest()
}

/**
 * Holds if comparison test `ct` compares two structurally identical
 * expressions, in a way that may be used to perform a NaN-test. `builtin` is
 * the name of an equivalent built-in NaN-test method, for example
 * `double.IsNaN()`.
 */
predicate comparesIdenticalValuesNan(ComparisonTest ct, string builtin) {
  comparesIdenticalValues(ct) and
  exists(FloatingPointType fpt, string type, string neg | fpt = ct.getAnArgument().getType() |
    (
      fpt instanceof DoubleType and type = "double"
      or
      fpt instanceof FloatType and type = "float"
    ) and
    (
      ct.getComparisonKind().isEquality() and neg = "!"
      or
      ct.getComparisonKind().isInequality() and neg = ""
    ) and
    builtin = neg + type + ".IsNaN()"
  )
}
