/**
 * Simple range analysis library. Range analysis is usually done as an
 * abstract interpretation over the lattice of range values. (A range is a
 * pair, containing a lower and upper bound for the value.) The problem
 * with this approach is that the lattice is very tall, which means it can
 * take an extremely large number of iterations to find the least fixed
 * point. This example illustrates the problem:
 *
 *    int count = 0;
 *    for (; p; p = p->next) {
 *      count = count+1;
 *    }
 *
 * The range of 'count' is initially (0,0), then (0,1) on the second
 * iteration, (0,2) on the third iteration, and so on until we eventually
 * reach maxInt.
 *
 * This library uses a crude solution to the problem described above: if
 * the upper (or lower) bound of an expression might depend recursively on
 * itself then we round it up (down for lower bounds) to one of a fixed set
 * of values, such as 0, 1, 2, 256, and +Inf. This limits the height of the
 * lattice which ensures that the analysis will terminate in a reasonable
 * amount of time. This solution is similar to the abstract interpretation
 * technique known as 'widening', but it is less precise because we are
 * unable to inspect the bounds from the previous iteration of the fixed
 * point computation. For example, widening might be able to deduce that
 * the lower bound is -11 but we would approximate it to -16.
 *
 * QL does not allow us to compute an aggregate over a recursive
 * sub-expression, so we cannot compute the minimum lower bound and maximum
 * upper bound during the recursive phase of the query. Instead, the
 * recursive phase computes a set of lower bounds and a set of upper bounds
 * for each expression. We compute the minimum lower bound and maximum
 * upper bound after the recursion is finished. This is another reason why
 * we need to limit the number of bounds per expression, because they will
 * all be stored until the recursive phase is finished.
 *
 * The ranges are represented using a pair of floating point numbers. This
 * is simpler than using integers because floating point numbers cannot
 * overflow and wrap. It is also convenient because we can detect overflow
 * and negative overflow by looking for bounds that are outside the range
 * of the type.
 */

import cpp
private import RangeAnalysisUtils
private import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisExpr
private import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisDefinition
import RangeSSA
import SimpleRangeAnalysisCached
private import NanAnalysis

/**
 * This fixed set of lower bounds is used when the lower bounds of an
 * expression are recursively defined. The inferred lower bound is rounded
 * down to the nearest lower bound in the fixed set. This restricts the
 * height of the lattice, which prevents the analysis from exploding.
 *
 * Note: these bounds were chosen fairly arbitrarily. Feel free to add more
 * bounds to the set if it helps on specific examples and does not make
 * performance dramatically worse on large codebases, such as libreoffice.
 */
private float wideningLowerBounds(ArithmeticType t) {
  result = 2.0 or
  result = 1.0 or
  result = 0.0 or
  result = -1.0 or
  result = -2.0 or
  result = -8.0 or
  result = -16.0 or
  result = -128.0 or
  result = -256.0 or
  result = -32768.0 or
  result = -65536.0 or
  result = typeLowerBound(t) or
  result = -(1.0 / 0.0) // -Inf
}

/** See comment for `wideningLowerBounds`, above. */
private float wideningUpperBounds(ArithmeticType t) {
  result = -2.0 or
  result = -1.0 or
  result = 0.0 or
  result = 1.0 or
  result = 2.0 or
  result = 7.0 or
  result = 15.0 or
  result = 127.0 or
  result = 255.0 or
  result = 32767.0 or
  result = 65535.0 or
  result = typeUpperBound(t) or
  result = 1.0 / 0.0 // +Inf
}

/**
 * Gets the value of the expression `e`, if it is a constant.
 * This predicate also handles the case of constant variables initialized in different
 * compilation units, which doesn't necessarily have a getValue() result from the extractor.
 */
private string getValue(Expr e) {
  if exists(e.getValue())
  then result = e.getValue()
  else
    /*
     * It should be safe to propagate the initialization value to a variable if:
     * The type of v is const, and
     * The type of v is not volatile, and
     * Either:
     *   v is a local/global variable, or
     *   v is a static member variable
     */

    exists(VariableAccess access, StaticStorageDurationVariable v |
      not v.getUnderlyingType().isVolatile() and
      v.getUnderlyingType().isConst() and
      e = access and
      v = access.getTarget() and
      result = getValue(v.getAnAssignedValue())
    )
}

/**
 * A bitwise `&` expression in which both operands are unsigned, or are effectively
 * unsigned due to being a non-negative constant.
 */
private class UnsignedBitwiseAndExpr extends BitwiseAndExpr {
  UnsignedBitwiseAndExpr() {
    (
      this.getLeftOperand()
          .getFullyConverted()
          .getType()
          .getUnderlyingType()
          .(IntegralType)
          .isUnsigned() or
      getValue(this.getLeftOperand().getFullyConverted()).toInt() >= 0
    ) and
    (
      this.getRightOperand()
          .getFullyConverted()
          .getType()
          .getUnderlyingType()
          .(IntegralType)
          .isUnsigned() or
      getValue(this.getRightOperand().getFullyConverted()).toInt() >= 0
    )
  }
}

/**
 * Gets the floor of `v`, with additional logic to work around issues with
 * large numbers.
 */
bindingset[v]
float safeFloor(float v) {
  // return the floor of v
  v.abs() < 2.pow(31) and
  result = v.floor()
  or
  // `floor()` doesn't work correctly on large numbers (since it returns an integer),
  // so fall back to unrounded numbers at this scale.
  not v.abs() < 2.pow(31) and
  result = v
}

/** A `MulExpr` where exactly one operand is constant. */
private class MulByConstantExpr extends MulExpr {
  float constant;
  Expr operand;

  MulByConstantExpr() {
    exists(Expr constantExpr |
      this.hasOperands(constantExpr, operand) and
      constant = getValue(constantExpr.getFullyConverted()).toFloat() and
      not exists(getValue(operand.getFullyConverted()).toFloat())
    )
  }

  /** Gets the value of the constant operand. */
  float getConstant() { result = constant }

  /** Gets the non-constant operand. */
  Expr getOperand() { result = operand }
}

private class UnsignedMulExpr extends MulExpr {
  UnsignedMulExpr() {
    this.getType().(IntegralType).isUnsigned() and
    // Avoid overlap. It should be slightly cheaper to analyze
    // `MulByConstantExpr`.
    not this instanceof MulByConstantExpr
  }
}

/**
 * Holds if `expr` is effectively a multiplication of `operand` with the
 * positive constant `positive`.
 */
private predicate effectivelyMultipliesByPositive(Expr expr, Expr operand, float positive) {
  operand = expr.(MulByConstantExpr).getOperand() and
  positive = expr.(MulByConstantExpr).getConstant() and
  positive >= 0.0 // includes positive zero
  or
  operand = expr.(UnaryPlusExpr).getOperand() and
  positive = 1.0
  or
  operand = expr.(CommaExpr).getRightOperand() and
  positive = 1.0
  or
  operand = expr.(StmtExpr).getResultExpr() and
  positive = 1.0
}

/**
 * Holds if `expr` is effectively a multiplication of `operand` with the
 * negative constant `negative`.
 */
private predicate effectivelyMultipliesByNegative(Expr expr, Expr operand, float negative) {
  operand = expr.(MulByConstantExpr).getOperand() and
  negative = expr.(MulByConstantExpr).getConstant() and
  negative < 0.0 // includes negative zero
  or
  operand = expr.(UnaryMinusExpr).getOperand() and
  negative = -1.0
}

private class AssignMulByConstantExpr extends AssignMulExpr {
  float constant;

  AssignMulByConstantExpr() { constant = getValue(this.getRValue().getFullyConverted()).toFloat() }

  float getConstant() { result = constant }
}

private class AssignMulByPositiveConstantExpr extends AssignMulByConstantExpr {
  AssignMulByPositiveConstantExpr() { constant >= 0.0 }
}

private class AssignMulByNegativeConstantExpr extends AssignMulByConstantExpr {
  AssignMulByNegativeConstantExpr() { constant < 0.0 }
}

private class UnsignedAssignMulExpr extends AssignMulExpr {
  UnsignedAssignMulExpr() {
    this.getType().(IntegralType).isUnsigned() and
    // Avoid overlap. It should be slightly cheaper to analyze
    // `AssignMulByConstantExpr`.
    not this instanceof AssignMulByConstantExpr
  }
}

/** Set of expressions which we know how to analyze. */
private predicate analyzableExpr(Expr e) {
  // The type of the expression must be arithmetic. We reuse the logic in
  // `exprMinVal` to check this.
  exists(exprMinVal(e)) and
  (
    exists(getValue(e).toFloat())
    or
    effectivelyMultipliesByPositive(e, _, _)
    or
    effectivelyMultipliesByNegative(e, _, _)
    or
    e instanceof MinExpr
    or
    e instanceof MaxExpr
    or
    e instanceof ConditionalExpr
    or
    e instanceof AddExpr
    or
    e instanceof SubExpr
    or
    e instanceof UnsignedMulExpr
    or
    e instanceof AssignExpr
    or
    e instanceof AssignAddExpr
    or
    e instanceof AssignSubExpr
    or
    e instanceof UnsignedAssignMulExpr
    or
    e instanceof AssignMulByConstantExpr
    or
    e instanceof CrementOperation
    or
    e instanceof RemExpr
    or
    // A conversion is analyzable, provided that its child has an arithmetic
    // type. (Sometimes the child is a reference type, and so does not get
    // any bounds.) Rather than checking whether the type of the child is
    // arithmetic, we reuse the logic that is already encoded in
    // `exprMinVal`.
    exists(exprMinVal(e.(Conversion).getExpr()))
    or
    // Also allow variable accesses, provided that they have SSA
    // information.
    exists(RangeSsaDefinition def, StackVariable v | e = def.getAUse(v))
    or
    e instanceof UnsignedBitwiseAndExpr
    or
    // `>>` by a constant
    exists(getValue(e.(RShiftExpr).getRightOperand()))
    or
    // A modeled expression for range analysis
    e instanceof SimpleRangeAnalysisExpr
  )
}

/**
 * Set of definitions that this definition depends on. The transitive
 * closure of this relation is used to detect definitions which are
 * recursively defined, so that we can prevent the analysis from exploding.
 *
 * The structure of `defDependsOnDef` and its helper predicates matches the
 * structure of `getDefLowerBoundsImpl` and
 * `getDefUpperBoundsImpl`. Therefore, if changes are made to the structure
 * of the main analysis algorithm then matching changes need to be made
 * here.
 */
private predicate defDependsOnDef(
  RangeSsaDefinition def, StackVariable v, RangeSsaDefinition srcDef, StackVariable srcVar
) {
  // Definitions with a defining value.
  exists(Expr expr | assignmentDef(def, v, expr) | exprDependsOnDef(expr, srcDef, srcVar))
  or
  // Assignment operations with a defining value
  exists(AssignOperation assignOp |
    analyzableExpr(assignOp) and
    def = assignOp and
    def.getAVariable() = v and
    exprDependsOnDef(assignOp, srcDef, srcVar)
  )
  or
  exists(CrementOperation crem |
    def = crem and
    def.getAVariable() = v and
    exprDependsOnDef(crem.getOperand(), srcDef, srcVar)
  )
  or
  // Phi nodes.
  phiDependsOnDef(def, v, srcDef, srcVar)
  or
  // Extensions
  exists(Expr expr | def.(SimpleRangeAnalysisDefinition).dependsOnExpr(v, expr) |
    exprDependsOnDef(expr, srcDef, srcVar)
  )
}

/**
 * Helper predicate for `defDependsOnDef`. This predicate matches
 * the structure of `getLowerBoundsImpl` and `getUpperBoundsImpl`.
 */
private predicate exprDependsOnDef(Expr e, RangeSsaDefinition srcDef, StackVariable srcVar) {
  exists(Expr operand |
    effectivelyMultipliesByNegative(e, operand, _) and
    exprDependsOnDef(operand, srcDef, srcVar)
  )
  or
  exists(Expr operand |
    effectivelyMultipliesByPositive(e, operand, _) and
    exprDependsOnDef(operand, srcDef, srcVar)
  )
  or
  exists(MinExpr minExpr | e = minExpr | exprDependsOnDef(minExpr.getAnOperand(), srcDef, srcVar))
  or
  exists(MaxExpr maxExpr | e = maxExpr | exprDependsOnDef(maxExpr.getAnOperand(), srcDef, srcVar))
  or
  exists(ConditionalExpr condExpr | e = condExpr |
    exprDependsOnDef(condExpr.getAnOperand(), srcDef, srcVar)
  )
  or
  exists(AddExpr addExpr | e = addExpr | exprDependsOnDef(addExpr.getAnOperand(), srcDef, srcVar))
  or
  exists(SubExpr subExpr | e = subExpr | exprDependsOnDef(subExpr.getAnOperand(), srcDef, srcVar))
  or
  exists(UnsignedMulExpr mulExpr | e = mulExpr |
    exprDependsOnDef(mulExpr.getAnOperand(), srcDef, srcVar)
  )
  or
  exists(AssignExpr addExpr | e = addExpr | exprDependsOnDef(addExpr.getRValue(), srcDef, srcVar))
  or
  exists(AssignAddExpr addExpr | e = addExpr |
    exprDependsOnDef(addExpr.getAnOperand(), srcDef, srcVar)
  )
  or
  exists(AssignSubExpr subExpr | e = subExpr |
    exprDependsOnDef(subExpr.getAnOperand(), srcDef, srcVar)
  )
  or
  exists(UnsignedAssignMulExpr mulExpr | e = mulExpr |
    exprDependsOnDef(mulExpr.getAnOperand(), srcDef, srcVar)
  )
  or
  exists(AssignMulByConstantExpr mulExpr | e = mulExpr |
    exprDependsOnDef(mulExpr.getLValue(), srcDef, srcVar)
  )
  or
  exists(CrementOperation crementExpr | e = crementExpr |
    exprDependsOnDef(crementExpr.getOperand(), srcDef, srcVar)
  )
  or
  exists(RemExpr remExpr | e = remExpr | exprDependsOnDef(remExpr.getAnOperand(), srcDef, srcVar))
  or
  exists(Conversion convExpr | e = convExpr | exprDependsOnDef(convExpr.getExpr(), srcDef, srcVar))
  or
  // unsigned `&`
  exists(UnsignedBitwiseAndExpr andExpr |
    andExpr = e and
    exprDependsOnDef(andExpr.getAnOperand(), srcDef, srcVar)
  )
  or
  // `>>` by a constant
  exists(RShiftExpr rs |
    rs = e and
    exists(getValue(rs.getRightOperand())) and
    exprDependsOnDef(rs.getLeftOperand(), srcDef, srcVar)
  )
  or
  e = srcDef.getAUse(srcVar)
  or
  // A modeled expression for range analysis
  exists(SimpleRangeAnalysisExpr rae | rae = e |
    rae.dependsOnDef(srcDef, srcVar)
    or
    exists(Expr child |
      rae.dependsOnChild(child) and
      exprDependsOnDef(child, srcDef, srcVar)
    )
  )
}

/**
 * Helper predicate for `defDependsOnDef`. This predicate matches
 * the structure of `getPhiLowerBounds` and `getPhiUpperBounds`.
 */
private predicate phiDependsOnDef(
  RangeSsaDefinition phi, StackVariable v, RangeSsaDefinition srcDef, StackVariable srcVar
) {
  exists(VariableAccess access, Expr guard | phi.isGuardPhi(v, access, guard, _) |
    exprDependsOnDef(guard.(ComparisonOperation).getAnOperand(), srcDef, srcVar) or
    exprDependsOnDef(access, srcDef, srcVar)
  )
  or
  srcDef = phi.getAPhiInput(v) and srcVar = v
}

/** The transitive closure of `defDependsOnDef`. */
private predicate defDependsOnDefTransitively(
  RangeSsaDefinition def, StackVariable v, RangeSsaDefinition srcDef, StackVariable srcVar
) {
  defDependsOnDef(def, v, srcDef, srcVar)
  or
  exists(RangeSsaDefinition midDef, StackVariable midVar | defDependsOnDef(def, v, midDef, midVar) |
    defDependsOnDefTransitively(midDef, midVar, srcDef, srcVar)
  )
}

/** The set of definitions that depend recursively on themselves. */
private predicate isRecursiveDef(RangeSsaDefinition def, StackVariable v) {
  defDependsOnDefTransitively(def, v, def, v)
}

/**
 * Holds if the bounds of `e` depend on a recursive definition, meaning that
 * `e` is likely to have many candidate bounds during the main recursion.
 */
private predicate isRecursiveExpr(Expr e) {
  exists(RangeSsaDefinition def, StackVariable v | exprDependsOnDef(e, def, v) |
    isRecursiveDef(def, v)
  )
}

/**
 * Holds if `binop` is a binary operation that's likely to be assigned a
 * quadratic (or more) number of candidate bounds during the analysis. This can
 * happen when two conditions are satisfied:
 * 1. It is likely there are many more candidate bounds for `binop` than for
 *    its operands. For example, the number of candidate bounds for `x + y`,
 *    denoted here nbounds(`x + y`), will be O(nbounds(`x`) * nbounds(`y`)).
 *    In contrast, nbounds(`b ? x : y`) is only O(nbounds(`x`) + nbounds(`y`)).
 * 2. Both operands of `binop` are recursively determined and are therefore
 *    likely to have a large number of candidate bounds.
 */
private predicate isRecursiveBinary(BinaryOperation binop) {
  (
    binop instanceof UnsignedMulExpr
    or
    binop instanceof AddExpr
    or
    binop instanceof SubExpr
  ) and
  isRecursiveExpr(binop.getLeftOperand()) and
  isRecursiveExpr(binop.getRightOperand())
}

/**
 * We distinguish 3 kinds of RangeSsaDefinition:
 *
 * 1. Definitions with a defining value.
 *    For example: x = y+3 is a definition of x with defining value y+3.
 *
 * 2. Phi nodes: x3 = phi(x0,x1,x2)
 *
 * 3. Unanalyzable definitions.
 *    For example: a parameter is unanalyzable because we know nothing
 *    about its value.
 *
 * This predicate finds all the definitions in the first set.
 */
private predicate assignmentDef(RangeSsaDefinition def, StackVariable v, Expr expr) {
  getVariableRangeType(v) instanceof ArithmeticType and
  (
    def = v.getInitializer().getExpr() and def = expr
    or
    exists(AssignExpr assign |
      def = assign and
      assign.getLValue() = v.getAnAccess() and
      expr = assign.getRValue()
    )
  )
}

/** See comment above assignmentDef. */
private predicate analyzableDef(RangeSsaDefinition def, StackVariable v) {
  assignmentDef(def, v, _)
  or
  analyzableExpr(def.(AssignOperation)) and
  v = def.getAVariable()
  or
  analyzableExpr(def.(CrementOperation)) and
  v = def.getAVariable()
  or
  phiDependsOnDef(def, v, _, _)
  or
  // A modeled def for range analysis
  def.(SimpleRangeAnalysisDefinition).hasRangeInformationFor(v)
}

/**
 * Computes a normal form of `x` where -0.0 has changed to +0.0. This can be
 * needed on the lesser side of a floating-point comparison or on both sides of
 * a floating point equality because QL does not follow IEEE in floating-point
 * comparisons but instead defines -0.0 to be less than and distinct from 0.0.
 */
bindingset[x]
private float normalizeFloatUp(float x) { result = x + 0.0 }

/**
 * Computes `x + y`, rounded towards +Inf. This is the general case where both
 * `x` and `y` may be large numbers.
 */
bindingset[x, y]
private float addRoundingUp(float x, float y) {
  if normalizeFloatUp((x + y) - x) < y or normalizeFloatUp((x + y) - y) < x
  then result = (x + y).nextUp()
  else result = (x + y)
}

/**
 * Computes `x + y`, rounded towards -Inf. This is the general case where both
 * `x` and `y` may be large numbers.
 */
bindingset[x, y]
private float addRoundingDown(float x, float y) {
  if (x + y) - x > normalizeFloatUp(y) or (x + y) - y > normalizeFloatUp(x)
  then result = (x + y).nextDown()
  else result = (x + y)
}

/**
 * Computes `x + small`, rounded towards +Inf, where `small` is a small
 * constant.
 */
bindingset[x, small]
private float addRoundingUpSmall(float x, float small) {
  if (x + small) - x < small then result = (x + small).nextUp() else result = (x + small)
}

/**
 * Computes `x + small`, rounded towards -Inf, where `small` is a small
 * constant.
 */
bindingset[x, small]
private float addRoundingDownSmall(float x, float small) {
  if (x + small) - x > small then result = (x + small).nextDown() else result = (x + small)
}

private predicate lowerBoundableExpr(Expr expr) {
  analyzableExpr(expr) and
  getUpperBoundsImpl(expr) <= exprMaxVal(expr) and
  not exists(getValue(expr).toFloat())
}

/**
 * Gets the lower bounds of the expression.
 *
 * Most of the work of computing the lower bounds is done by
 * `getLowerBoundsImpl`. However, the lower bounds computed by
 * `getLowerBoundsImpl` may not be representable by the result type of the
 * expression. For example, if `x` and `y` are of type `int32` and each
 * have lower bound -2147483648, then getLowerBoundsImpl` will compute a
 * lower bound -4294967296 for the expression `x+y`, even though
 * -4294967296 cannot be represented as an `int32`. Such unrepresentable
 * bounds are replaced with `exprMinVal(expr)`. This predicate also adds
 * `exprMinVal(expr)` as a lower bound if the expression might overflow
 * positively, or if it is unanalyzable.
 *
 * Note: most callers should use `getFullyConvertedLowerBounds` rather than
 * this predicate.
 */
private float getTruncatedLowerBounds(Expr expr) {
  // If the expression evaluates to a constant, then there is no
  // need to call getLowerBoundsImpl.
  analyzableExpr(expr) and
  result = getValue(expr).toFloat()
  or
  // Some of the bounds computed by getLowerBoundsImpl might
  // overflow, so we replace invalid bounds with exprMinVal.
  exists(float newLB | newLB = normalizeFloatUp(getLowerBoundsImpl(expr)) |
    if exprMinVal(expr) <= newLB and newLB <= exprMaxVal(expr)
    then
      // Apply widening where we might get a combinatorial explosion.
      if isRecursiveBinary(expr)
      then
        result =
          max(float widenLB |
            widenLB = wideningLowerBounds(expr.getUnspecifiedType()) and
            not widenLB > newLB
          )
      else result = newLB
    else result = exprMinVal(expr)
  ) and
  lowerBoundableExpr(expr)
  or
  // The expression might overflow and wrap. If so, the
  // lower bound is exprMinVal.
  analyzableExpr(expr) and
  exprMightOverflowPositively(expr) and
  not result = getValue(expr).toFloat() and
  result = exprMinVal(expr)
  or
  // The expression is not analyzable, so its lower bound is
  // unknown. Note that the call to exprMinVal restricts the
  // expressions to just those with arithmetic types. There is no
  // need to return results for non-arithmetic expressions.
  not analyzableExpr(expr) and
  result = exprMinVal(expr)
}

/**
 * Gets the upper bounds of the expression.
 *
 * Most of the work of computing the upper bounds is done by
 * `getUpperBoundsImpl`. However, the upper bounds computed by
 * `getUpperBoundsImpl` may not be representable by the result type of the
 * expression. For example, if `x` and `y` are of type `int32` and each
 * have upper bound 2147483647, then getUpperBoundsImpl` will compute an
 * upper bound 4294967294 for the expression `x+y`, even though 4294967294
 * cannot be represented as an `int32`. Such unrepresentable bounds are
 * replaced with `exprMaxVal(expr)`.  This predicate also adds
 * `exprMaxVal(expr)` as an upper bound if the expression might overflow
 * negatively, or if it is unanalyzable.
 *
 * Note: most callers should use `getFullyConvertedUpperBounds` rather than
 * this predicate.
 */
private float getTruncatedUpperBounds(Expr expr) {
  if analyzableExpr(expr)
  then
    // If the expression evaluates to a constant, then there is no
    // need to call getUpperBoundsImpl.
    if exists(getValue(expr).toFloat())
    then result = getValue(expr).toFloat()
    else (
      // Some of the bounds computed by `getUpperBoundsImpl`
      // might overflow, so we replace invalid bounds with
      // `exprMaxVal`.
      exists(float newUB | newUB = normalizeFloatUp(getUpperBoundsImpl(expr)) |
        if exprMinVal(expr) <= newUB and newUB <= exprMaxVal(expr)
        then
          // Apply widening where we might get a combinatorial explosion.
          if isRecursiveBinary(expr)
          then
            result =
              min(float widenUB |
                widenUB = wideningUpperBounds(expr.getUnspecifiedType()) and
                not widenUB < newUB
              )
          else result = newUB
        else result = exprMaxVal(expr)
      )
      or
      // The expression might overflow negatively and wrap. If so,
      // the upper bound is `exprMaxVal`.
      exprMightOverflowNegatively(expr) and
      result = exprMaxVal(expr)
    )
  else
    // The expression is not analyzable, so its upper bound is
    // unknown. Note that the call to exprMaxVal restricts the
    // expressions to just those with arithmetic types. There is no
    // need to return results for non-arithmetic expressions.
    result = exprMaxVal(expr)
}

/** Only to be called by `getTruncatedLowerBounds`. */
private float getLowerBoundsImpl(Expr expr) {
  (
    exists(Expr operand, float operandLow, float positive |
      effectivelyMultipliesByPositive(expr, operand, positive) and
      operandLow = getFullyConvertedLowerBounds(operand) and
      result = positive * operandLow
    )
    or
    exists(Expr operand, float operandHigh, float negative |
      effectivelyMultipliesByNegative(expr, operand, negative) and
      operandHigh = getFullyConvertedUpperBounds(operand) and
      result = negative * operandHigh
    )
    or
    exists(MinExpr minExpr |
      expr = minExpr and
      // Return the union of the lower bounds from both children.
      result = getFullyConvertedLowerBounds(minExpr.getAnOperand())
    )
    or
    exists(MaxExpr maxExpr |
      expr = maxExpr and
      // Compute the cross product of the bounds from both children.  We are
      // using this mathematical property:
      //
      //    max (minimum{X}, minimum{Y})
      //  = minimum { max(x,y) | x in X, y in Y }
      exists(float x, float y |
        x = getFullyConvertedLowerBounds(maxExpr.getLeftOperand()) and
        y = getFullyConvertedLowerBounds(maxExpr.getRightOperand()) and
        if x >= y then result = x else result = y
      )
    )
    or
    // ConditionalExpr (true branch)
    exists(ConditionalExpr condExpr |
      expr = condExpr and
      // Use `boolConversionUpperBound` to determine whether the condition
      // might evaluate to `true`.
      boolConversionUpperBound(condExpr.getCondition().getFullyConverted()) = 1 and
      result = getFullyConvertedLowerBounds(condExpr.getThen())
    )
    or
    // ConditionalExpr (false branch)
    exists(ConditionalExpr condExpr |
      expr = condExpr and
      // Use `boolConversionLowerBound` to determine whether the condition
      // might evaluate to `false`.
      boolConversionLowerBound(condExpr.getCondition().getFullyConverted()) = 0 and
      result = getFullyConvertedLowerBounds(condExpr.getElse())
    )
    or
    exists(AddExpr addExpr, float xLow, float yLow |
      expr = addExpr and
      xLow = getFullyConvertedLowerBounds(addExpr.getLeftOperand()) and
      yLow = getFullyConvertedLowerBounds(addExpr.getRightOperand()) and
      result = addRoundingDown(xLow, yLow)
    )
    or
    exists(SubExpr subExpr, float xLow, float yHigh |
      expr = subExpr and
      xLow = getFullyConvertedLowerBounds(subExpr.getLeftOperand()) and
      yHigh = getFullyConvertedUpperBounds(subExpr.getRightOperand()) and
      result = addRoundingDown(xLow, -yHigh)
    )
    or
    exists(UnsignedMulExpr mulExpr, float xLow, float yLow |
      expr = mulExpr and
      xLow = getFullyConvertedLowerBounds(mulExpr.getLeftOperand()) and
      yLow = getFullyConvertedLowerBounds(mulExpr.getRightOperand()) and
      result = xLow * yLow
    )
    or
    exists(AssignExpr assign |
      expr = assign and
      result = getFullyConvertedLowerBounds(assign.getRValue())
    )
    or
    exists(AssignAddExpr addExpr, float xLow, float yLow |
      expr = addExpr and
      xLow = getFullyConvertedLowerBounds(addExpr.getLValue()) and
      yLow = getFullyConvertedLowerBounds(addExpr.getRValue()) and
      result = addRoundingDown(xLow, yLow)
    )
    or
    exists(AssignSubExpr subExpr, float xLow, float yHigh |
      expr = subExpr and
      xLow = getFullyConvertedLowerBounds(subExpr.getLValue()) and
      yHigh = getFullyConvertedUpperBounds(subExpr.getRValue()) and
      result = addRoundingDown(xLow, -yHigh)
    )
    or
    exists(UnsignedAssignMulExpr mulExpr, float xLow, float yLow |
      expr = mulExpr and
      xLow = getFullyConvertedLowerBounds(mulExpr.getLValue()) and
      yLow = getFullyConvertedLowerBounds(mulExpr.getRValue()) and
      result = xLow * yLow
    )
    or
    exists(AssignMulByPositiveConstantExpr mulExpr, float xLow |
      expr = mulExpr and
      xLow = getFullyConvertedLowerBounds(mulExpr.getLValue()) and
      result = xLow * mulExpr.getConstant()
    )
    or
    exists(AssignMulByNegativeConstantExpr mulExpr, float xHigh |
      expr = mulExpr and
      xHigh = getFullyConvertedUpperBounds(mulExpr.getLValue()) and
      result = xHigh * mulExpr.getConstant()
    )
    or
    exists(PrefixIncrExpr incrExpr, float xLow |
      expr = incrExpr and
      xLow = getFullyConvertedLowerBounds(incrExpr.getOperand()) and
      result = xLow + 1
    )
    or
    exists(PrefixDecrExpr decrExpr, float xLow |
      expr = decrExpr and
      xLow = getFullyConvertedLowerBounds(decrExpr.getOperand()) and
      result = addRoundingDownSmall(xLow, -1)
    )
    or
    // `PostfixIncrExpr` and `PostfixDecrExpr` return the value of their
    // operand. The incrementing/decrementing behavior is handled in
    // `getDefLowerBoundsImpl`.
    exists(PostfixIncrExpr incrExpr |
      expr = incrExpr and
      result = getFullyConvertedLowerBounds(incrExpr.getOperand())
    )
    or
    exists(PostfixDecrExpr decrExpr |
      expr = decrExpr and
      result = getFullyConvertedLowerBounds(decrExpr.getOperand())
    )
    or
    exists(RemExpr remExpr | expr = remExpr |
      // If both inputs are positive then the lower bound is zero.
      result = 0
      or
      // If either input could be negative then the output could be
      // negative. If so, the lower bound of `x%y` is `-abs(y) + 1`, which is
      // equal to `min(-y + 1,y - 1)`.
      exists(float childLB |
        childLB = getFullyConvertedLowerBounds(remExpr.getAnOperand()) and
        not childLB >= 0
      |
        result = getFullyConvertedLowerBounds(remExpr.getRightOperand()) - 1
        or
        exists(float rhsUB | rhsUB = getFullyConvertedUpperBounds(remExpr.getRightOperand()) |
          result = -rhsUB + 1
        )
      )
    )
    or
    // If the conversion is to an arithmetic type then we just return the
    // lower bound of the child. We do not need to handle truncation and
    // overflow here, because that is done in `getTruncatedLowerBounds`.
    // Conversions to `bool` need to be handled specially because they test
    // whether the value of the expression is equal to 0.
    exists(Conversion convExpr | expr = convExpr |
      if convExpr.getUnspecifiedType() instanceof BoolType
      then result = boolConversionLowerBound(convExpr.getExpr())
      else result = getTruncatedLowerBounds(convExpr.getExpr())
    )
    or
    // Use SSA to get the lower bounds for a variable use.
    exists(RangeSsaDefinition def, StackVariable v | expr = def.getAUse(v) |
      result = getDefLowerBounds(def, v)
    )
    or
    // unsigned `&` (tighter bounds may exist)
    exists(UnsignedBitwiseAndExpr andExpr |
      andExpr = expr and
      result = 0.0
    )
    or
    // `>>` by a constant
    exists(RShiftExpr rsExpr, float left, int right |
      rsExpr = expr and
      left = getFullyConvertedLowerBounds(rsExpr.getLeftOperand()) and
      right = getValue(rsExpr.getRightOperand().getFullyConverted()).toInt() and
      result = safeFloor(left / 2.pow(right))
    )
    // Not explicitly modeled by a SimpleRangeAnalysisExpr
  ) and
  not expr instanceof SimpleRangeAnalysisExpr
  or
  // A modeled expression for range analysis
  exists(SimpleRangeAnalysisExpr rangeAnalysisExpr |
    rangeAnalysisExpr = expr and
    result = rangeAnalysisExpr.getLowerBounds()
  )
}

/** Only to be called by `getTruncatedUpperBounds`. */
private float getUpperBoundsImpl(Expr expr) {
  (
    exists(Expr operand, float operandHigh, float positive |
      effectivelyMultipliesByPositive(expr, operand, positive) and
      operandHigh = getFullyConvertedUpperBounds(operand) and
      result = positive * operandHigh
    )
    or
    exists(Expr operand, float operandLow, float negative |
      effectivelyMultipliesByNegative(expr, operand, negative) and
      operandLow = getFullyConvertedLowerBounds(operand) and
      result = negative * operandLow
    )
    or
    exists(MaxExpr maxExpr |
      expr = maxExpr and
      // Return the union of the upper bounds from both children.
      result = getFullyConvertedUpperBounds(maxExpr.getAnOperand())
    )
    or
    exists(MinExpr minExpr |
      expr = minExpr and
      // Compute the cross product of the bounds from both children.  We are
      // using this mathematical property:
      //
      //    min (maximum{X}, maximum{Y})
      //  = maximum { min(x,y) | x in X, y in Y }
      exists(float x, float y |
        x = getFullyConvertedUpperBounds(minExpr.getLeftOperand()) and
        y = getFullyConvertedUpperBounds(minExpr.getRightOperand()) and
        if x <= y then result = x else result = y
      )
    )
    or
    // ConditionalExpr (true branch)
    exists(ConditionalExpr condExpr |
      expr = condExpr and
      // Use `boolConversionUpperBound` to determine whether the condition
      // might evaluate to `true`.
      boolConversionUpperBound(condExpr.getCondition().getFullyConverted()) = 1 and
      result = getFullyConvertedUpperBounds(condExpr.getThen())
    )
    or
    // ConditionalExpr (false branch)
    exists(ConditionalExpr condExpr |
      expr = condExpr and
      // Use `boolConversionLowerBound` to determine whether the condition
      // might evaluate to `false`.
      boolConversionLowerBound(condExpr.getCondition().getFullyConverted()) = 0 and
      result = getFullyConvertedUpperBounds(condExpr.getElse())
    )
    or
    exists(AddExpr addExpr, float xHigh, float yHigh |
      expr = addExpr and
      xHigh = getFullyConvertedUpperBounds(addExpr.getLeftOperand()) and
      yHigh = getFullyConvertedUpperBounds(addExpr.getRightOperand()) and
      result = addRoundingUp(xHigh, yHigh)
    )
    or
    exists(SubExpr subExpr, float xHigh, float yLow |
      expr = subExpr and
      xHigh = getFullyConvertedUpperBounds(subExpr.getLeftOperand()) and
      yLow = getFullyConvertedLowerBounds(subExpr.getRightOperand()) and
      result = addRoundingUp(xHigh, -yLow)
    )
    or
    exists(UnsignedMulExpr mulExpr, float xHigh, float yHigh |
      expr = mulExpr and
      xHigh = getFullyConvertedUpperBounds(mulExpr.getLeftOperand()) and
      yHigh = getFullyConvertedUpperBounds(mulExpr.getRightOperand()) and
      result = xHigh * yHigh
    )
    or
    exists(AssignExpr assign |
      expr = assign and
      result = getFullyConvertedUpperBounds(assign.getRValue())
    )
    or
    exists(AssignAddExpr addExpr, float xHigh, float yHigh |
      expr = addExpr and
      xHigh = getFullyConvertedUpperBounds(addExpr.getLValue()) and
      yHigh = getFullyConvertedUpperBounds(addExpr.getRValue()) and
      result = addRoundingUp(xHigh, yHigh)
    )
    or
    exists(AssignSubExpr subExpr, float xHigh, float yLow |
      expr = subExpr and
      xHigh = getFullyConvertedUpperBounds(subExpr.getLValue()) and
      yLow = getFullyConvertedLowerBounds(subExpr.getRValue()) and
      result = addRoundingUp(xHigh, -yLow)
    )
    or
    exists(UnsignedAssignMulExpr mulExpr, float xHigh, float yHigh |
      expr = mulExpr and
      xHigh = getFullyConvertedUpperBounds(mulExpr.getLValue()) and
      yHigh = getFullyConvertedUpperBounds(mulExpr.getRValue()) and
      result = xHigh * yHigh
    )
    or
    exists(AssignMulByPositiveConstantExpr mulExpr, float xHigh |
      expr = mulExpr and
      xHigh = getFullyConvertedUpperBounds(mulExpr.getLValue()) and
      result = xHigh * mulExpr.getConstant()
    )
    or
    exists(AssignMulByNegativeConstantExpr mulExpr, float xLow |
      expr = mulExpr and
      xLow = getFullyConvertedLowerBounds(mulExpr.getLValue()) and
      result = xLow * mulExpr.getConstant()
    )
    or
    exists(PrefixIncrExpr incrExpr, float xHigh |
      expr = incrExpr and
      xHigh = getFullyConvertedUpperBounds(incrExpr.getOperand()) and
      result = addRoundingUpSmall(xHigh, 1)
    )
    or
    exists(PrefixDecrExpr decrExpr, float xHigh |
      expr = decrExpr and
      xHigh = getFullyConvertedUpperBounds(decrExpr.getOperand()) and
      result = xHigh - 1
    )
    or
    // `PostfixIncrExpr` and `PostfixDecrExpr` return the value of their operand.
    // The incrementing/decrementing behavior is handled in
    // `getDefUpperBoundsImpl`.
    exists(PostfixIncrExpr incrExpr |
      expr = incrExpr and
      result = getFullyConvertedUpperBounds(incrExpr.getOperand())
    )
    or
    exists(PostfixDecrExpr decrExpr |
      expr = decrExpr and
      result = getFullyConvertedUpperBounds(decrExpr.getOperand())
    )
    or
    exists(RemExpr remExpr, float rhsUB |
      expr = remExpr and
      rhsUB = getFullyConvertedUpperBounds(remExpr.getRightOperand())
    |
      result = rhsUB - 1
      or
      // If the right hand side could be negative then we need to take its
      // absolute value. Since `abs(x) = max(-x,x)` this is equivalent to
      // adding `-rhsLB` to the set of upper bounds.
      exists(float rhsLB |
        rhsLB = getFullyConvertedLowerBounds(remExpr.getRightOperand()) and
        not rhsLB >= 0
      |
        result = -rhsLB + 1
      )
    )
    or
    // If the conversion is to an arithmetic type then we just return the
    // upper bound of the child. We do not need to handle truncation and
    // overflow here, because that is done in `getTruncatedUpperBounds`.
    // Conversions to `bool` need to be handled specially because they test
    // whether the value of the expression is equal to 0.
    exists(Conversion convExpr | expr = convExpr |
      if convExpr.getUnspecifiedType() instanceof BoolType
      then result = boolConversionUpperBound(convExpr.getExpr())
      else result = getTruncatedUpperBounds(convExpr.getExpr())
    )
    or
    // Use SSA to get the upper bounds for a variable use.
    exists(RangeSsaDefinition def, StackVariable v | expr = def.getAUse(v) |
      result = getDefUpperBounds(def, v)
    )
    or
    // unsigned `&` (tighter bounds may exist)
    exists(UnsignedBitwiseAndExpr andExpr, float left, float right |
      andExpr = expr and
      left = getFullyConvertedUpperBounds(andExpr.getLeftOperand()) and
      right = getFullyConvertedUpperBounds(andExpr.getRightOperand()) and
      result = left.minimum(right)
    )
    or
    // `>>` by a constant
    exists(RShiftExpr rsExpr, float left, int right |
      rsExpr = expr and
      left = getFullyConvertedUpperBounds(rsExpr.getLeftOperand()) and
      right = getValue(rsExpr.getRightOperand().getFullyConverted()).toInt() and
      result = safeFloor(left / 2.pow(right))
    )
    // Not explicitly modeled by a SimpleRangeAnalysisExpr
  ) and
  not expr instanceof SimpleRangeAnalysisExpr
  or
  // A modeled expression for range analysis
  exists(SimpleRangeAnalysisExpr rangeAnalysisExpr |
    rangeAnalysisExpr = expr and
    result = rangeAnalysisExpr.getUpperBounds()
  )
}

/**
 * Holds if `expr` is converted to `bool` or if it is the child of a
 * logical operation.
 *
 * The purpose of this predicate is to optimize `boolConversionLowerBound`
 * and `boolConversionUpperBound` by preventing them from computing
 * unnecessary results. In other words, `exprIsUsedAsBool(expr)` holds if
 * `expr` is an expression that might be passed as an argument to
 * `boolConversionLowerBound` or `boolConversionUpperBound`.
 */
private predicate exprIsUsedAsBool(Expr expr) {
  expr = any(BinaryLogicalOperation op).getAnOperand().getFullyConverted()
  or
  expr = any(UnaryLogicalOperation op).getOperand().getFullyConverted()
  or
  expr = any(ConditionalExpr c).getCondition().getFullyConverted()
  or
  exists(Conversion cast | cast.getUnspecifiedType() instanceof BoolType | expr = cast.getExpr())
}

/**
 * Gets the lower bound of the conversion `(bool)expr`. If we can prove that
 * the value of `expr` is never 0 then `lb = 1`. Otherwise `lb = 0`.
 */
private float boolConversionLowerBound(Expr expr) {
  // Case 1: if the range for `expr` includes the value 0,
  // then `result = 0`.
  exprIsUsedAsBool(expr) and
  exists(float lb | lb = getTruncatedLowerBounds(expr) and not lb > 0) and
  exists(float ub | ub = getTruncatedUpperBounds(expr) and not ub < 0) and
  result = 0
  or
  // Case 2a: if the range for `expr` does not include the value 0,
  // then `result = 1`.
  exprIsUsedAsBool(expr) and getTruncatedLowerBounds(expr) > 0 and result = 1
  or
  // Case 2b: if the range for `expr` does not include the value 0,
  // then `result = 1`.
  exprIsUsedAsBool(expr) and getTruncatedUpperBounds(expr) < 0 and result = 1
  or
  // Case 3: the type of `expr` is not arithmetic. For example, it might
  // be a pointer.
  exprIsUsedAsBool(expr) and not exists(exprMinVal(expr)) and result = 0
}

/**
 * Gets the upper bound of the conversion `(bool)expr`. If we can prove that
 * the value of `expr` is always 0 then `ub = 0`. Otherwise `ub = 1`.
 */
private float boolConversionUpperBound(Expr expr) {
  // Case 1a: if the upper bound of the operand is <= 0, then the upper
  // bound might be 0.
  exprIsUsedAsBool(expr) and getTruncatedUpperBounds(expr) <= 0 and result = 0
  or
  // Case 1b: if the upper bound of the operand is not <= 0, then the upper
  // bound is 1.
  exprIsUsedAsBool(expr) and
  exists(float ub | ub = getTruncatedUpperBounds(expr) and not ub <= 0) and
  result = 1
  or
  // Case 2a: if the lower bound of the operand is >= 0, then the upper
  // bound might be 0.
  exprIsUsedAsBool(expr) and getTruncatedLowerBounds(expr) >= 0 and result = 0
  or
  // Case 2b: if the lower bound of the operand is not >= 0, then the upper
  // bound is 1.
  exprIsUsedAsBool(expr) and
  exists(float lb | lb = getTruncatedLowerBounds(expr) and not lb >= 0) and
  result = 1
  or
  // Case 3: the type of `expr` is not arithmetic. For example, it might
  // be a pointer.
  exprIsUsedAsBool(expr) and not exists(exprMaxVal(expr)) and result = 1
}

/**
 * This predicate computes the lower bounds of a phi definition. If the
 * phi definition corresponds to a guard, then the guard is used to
 * deduce a better lower bound.
 * For example:
 *
 *     def:      x = y % 10;
 *     guard:    if (x >= 2) {
 *     block:      f(x)
 *               }
 *
 * In this example, the lower bound of x is 0, but we can
 * use the guard to deduce that the lower bound is 2 inside the block.
 */
private float getPhiLowerBounds(StackVariable v, RangeSsaDefinition phi) {
  exists(VariableAccess access, Expr guard, boolean branch, float defLB, float guardLB |
    phi.isGuardPhi(v, access, guard, branch) and
    lowerBoundFromGuard(guard, access, guardLB, branch) and
    defLB = getFullyConvertedLowerBounds(access)
  |
    // Compute the maximum of `guardLB` and `defLB`.
    if guardLB > defLB then result = guardLB else result = defLB
  )
  or
  exists(VariableAccess access, float neConstant, float lower |
    isNEPhi(v, phi, access, neConstant) and
    lower = getTruncatedLowerBounds(access) and
    if lower = neConstant then result = lower + 1 else result = lower
  )
  or
  exists(VariableAccess access |
    isUnsupportedGuardPhi(v, phi, access) and
    result = getTruncatedLowerBounds(access)
  )
  or
  result = getDefLowerBounds(phi.getAPhiInput(v), v)
}

/** See comment for `getPhiLowerBounds`, above. */
private float getPhiUpperBounds(StackVariable v, RangeSsaDefinition phi) {
  exists(VariableAccess access, Expr guard, boolean branch, float defUB, float guardUB |
    phi.isGuardPhi(v, access, guard, branch) and
    upperBoundFromGuard(guard, access, guardUB, branch) and
    defUB = getFullyConvertedUpperBounds(access)
  |
    // Compute the minimum of `guardUB` and `defUB`.
    if guardUB < defUB then result = guardUB else result = defUB
  )
  or
  exists(VariableAccess access, float neConstant, float upper |
    isNEPhi(v, phi, access, neConstant) and
    upper = getTruncatedUpperBounds(access) and
    if upper = neConstant then result = upper - 1 else result = upper
  )
  or
  exists(VariableAccess access |
    isUnsupportedGuardPhi(v, phi, access) and
    result = getTruncatedUpperBounds(access)
  )
  or
  result = getDefUpperBounds(phi.getAPhiInput(v), v)
}

/** Only to be called by `getDefLowerBounds`. */
private float getDefLowerBoundsImpl(RangeSsaDefinition def, StackVariable v) {
  // Definitions with a defining value.
  exists(Expr expr | assignmentDef(def, v, expr) | result = getFullyConvertedLowerBounds(expr))
  or
  // Assignment operations with a defining value
  exists(AssignOperation assignOp |
    def = assignOp and
    assignOp.getLValue() = v.getAnAccess() and
    result = getTruncatedLowerBounds(assignOp)
  )
  or
  exists(IncrementOperation incr, float newLB |
    def = incr and
    incr.getOperand() = v.getAnAccess() and
    newLB = getFullyConvertedLowerBounds(incr.getOperand()) and
    result = newLB + 1
  )
  or
  exists(DecrementOperation decr, float newLB |
    def = decr and
    decr.getOperand() = v.getAnAccess() and
    newLB = getFullyConvertedLowerBounds(decr.getOperand()) and
    result = addRoundingDownSmall(newLB, -1)
  )
  or
  // Phi nodes.
  result = getPhiLowerBounds(v, def)
  or
  // A modeled def for range analysis
  result = def.(SimpleRangeAnalysisDefinition).getLowerBounds(v)
  or
  // Unanalyzable definitions.
  unanalyzableDefBounds(def, v, result, _)
}

/** Only to be called by `getDefUpperBounds`. */
private float getDefUpperBoundsImpl(RangeSsaDefinition def, StackVariable v) {
  // Definitions with a defining value.
  exists(Expr expr | assignmentDef(def, v, expr) | result = getFullyConvertedUpperBounds(expr))
  or
  // Assignment operations with a defining value
  exists(AssignOperation assignOp |
    def = assignOp and
    assignOp.getLValue() = v.getAnAccess() and
    result = getTruncatedUpperBounds(assignOp)
  )
  or
  exists(IncrementOperation incr, float newUB |
    def = incr and
    incr.getOperand() = v.getAnAccess() and
    newUB = getFullyConvertedUpperBounds(incr.getOperand()) and
    result = addRoundingUpSmall(newUB, 1)
  )
  or
  exists(DecrementOperation decr, float newUB |
    def = decr and
    decr.getOperand() = v.getAnAccess() and
    newUB = getFullyConvertedUpperBounds(decr.getOperand()) and
    result = newUB - 1
  )
  or
  // Phi nodes.
  result = getPhiUpperBounds(v, def)
  or
  // A modeled def for range analysis
  result = def.(SimpleRangeAnalysisDefinition).getUpperBounds(v)
  or
  // Unanalyzable definitions.
  unanalyzableDefBounds(def, v, _, result)
}

/**
 * Helper for `getDefLowerBounds` and `getDefUpperBounds`. Find the set of
 * unanalyzable definitions (such as function parameters) and make their
 * bounds unknown.
 */
private predicate unanalyzableDefBounds(RangeSsaDefinition def, StackVariable v, float lb, float ub) {
  v = def.getAVariable() and
  not analyzableDef(def, v) and
  lb = varMinVal(v) and
  ub = varMaxVal(v)
}

/**
 * Holds if in the `branch` branch of a guard `guard` involving `v`,
 * we know that `v` is not NaN, and therefore it is safe to make range
 * inferences about `v`.
 */
bindingset[guard, v, branch]
predicate nonNanGuardedVariable(Expr guard, VariableAccess v, boolean branch) {
  getVariableRangeType(v.getTarget()) instanceof IntegralType
  or
  getVariableRangeType(v.getTarget()) instanceof FloatingPointType and
  v instanceof NonNanVariableAccess
  or
  // The reason the following case is here is to ensure that when we say
  // `if (x > 5) { ...then... } else { ...else... }`
  // it is ok to conclude that `x > 5` in the `then`, (though not safe
  // to conclude that x <= 5 in `else`) even if we had no prior
  // knowledge of `x` not being `NaN`.
  nanExcludingComparison(guard, branch)
}

/**
 * If the guard is a comparison of the form `p*v + q <CMP> r`, then this
 * predicate uses the bounds information for `r` to compute a lower bound
 * for `v`.
 */
private predicate lowerBoundFromGuard(Expr guard, VariableAccess v, float lb, boolean branch) {
  exists(float childLB, RelationStrictness strictness |
    boundFromGuard(guard, v, childLB, true, strictness, branch)
  |
    if nonNanGuardedVariable(guard, v, branch)
    then
      if
        strictness = Nonstrict() or
        not getVariableRangeType(v.getTarget()) instanceof IntegralType
      then lb = childLB
      else lb = childLB + 1
    else lb = varMinVal(v.getTarget())
  )
}

/**
 * If the guard is a comparison of the form `p*v + q <CMP> r`, then this
 * predicate uses the bounds information for `r` to compute a upper bound
 * for `v`.
 */
private predicate upperBoundFromGuard(Expr guard, VariableAccess v, float ub, boolean branch) {
  exists(float childUB, RelationStrictness strictness |
    boundFromGuard(guard, v, childUB, false, strictness, branch)
  |
    if nonNanGuardedVariable(guard, v, branch)
    then
      if
        strictness = Nonstrict() or
        not getVariableRangeType(v.getTarget()) instanceof IntegralType
      then ub = childUB
      else ub = childUB - 1
    else ub = varMaxVal(v.getTarget())
  )
}

/**
 * This predicate simplifies the results returned by
 * `linearBoundFromGuard`.
 */
private predicate boundFromGuard(
  Expr guard, VariableAccess v, float boundValue, boolean isLowerBound,
  RelationStrictness strictness, boolean branch
) {
  exists(float p, float q, float r, boolean isLB |
    linearBoundFromGuard(guard, v, p, q, r, isLB, strictness, branch) and
    boundValue = (r - q) / p
  |
    // If the multiplier is negative then the direction of the comparison
    // needs to be flipped.
    p > 0 and isLowerBound = isLB
    or
    p < 0 and isLowerBound = isLB.booleanNot()
  )
  or
  // When `!e` is true, we know that `0 <= e <= 0`
  exists(float p, float q, Expr e |
    linearAccess(e, v, p, q) and
    eqZeroWithNegate(guard, e, true, branch) and
    boundValue = (0.0 - q) / p and
    isLowerBound = [false, true] and
    strictness = Nonstrict()
  )
}

/**
 * This predicate finds guards of the form `p*v + q < r or p*v + q == r`
 * and decomposes them into a tuple of values which can be used to deduce a
 * lower or upper bound for `v`.
 */
private predicate linearBoundFromGuard(
  ComparisonOperation guard, VariableAccess v, float p, float q, float boundValue,
  boolean isLowerBound, // Is this a lower or an upper bound?
  RelationStrictness strictness, boolean branch // Which control-flow branch is this bound valid on?
) {
  // For the comparison x < RHS, we create two bounds:
  //
  //   1. x < upperbound(RHS)
  //   2. x >= typeLowerBound(RHS.getUnspecifiedType())
  //
  exists(Expr lhs, Expr rhs, RelationDirection dir, RelationStrictness st |
    linearAccess(lhs, v, p, q) and
    relOpWithSwapAndNegate(guard, lhs, rhs, dir, st, branch)
  |
    isLowerBound = directionIsGreater(dir) and
    strictness = st and
    getBounds(rhs, boundValue, isLowerBound)
    or
    isLowerBound = directionIsLesser(dir) and
    strictness = Nonstrict() and
    exprTypeBounds(rhs, boundValue, isLowerBound)
  )
  or
  // For x == RHS, we create the following bounds:
  //
  //   1. x <= upperbound(RHS)
  //   2. x >= lowerbound(RHS)
  //
  exists(Expr lhs, Expr rhs |
    linearAccess(lhs, v, p, q) and
    eqOpWithSwapAndNegate(guard, lhs, rhs, true, branch) and
    getBounds(rhs, boundValue, isLowerBound) and
    strictness = Nonstrict()
  )
  // x != RHS and !x are handled elsewhere
}

/** Utility for `linearBoundFromGuard`. */
private predicate getBounds(Expr expr, float boundValue, boolean isLowerBound) {
  isLowerBound = true and boundValue = getFullyConvertedLowerBounds(expr)
  or
  isLowerBound = false and boundValue = getFullyConvertedUpperBounds(expr)
}

/** Utility for `linearBoundFromGuard`. */
private predicate exprTypeBounds(Expr expr, float boundValue, boolean isLowerBound) {
  isLowerBound = true and boundValue = exprMinVal(expr.getFullyConverted())
  or
  isLowerBound = false and boundValue = exprMaxVal(expr.getFullyConverted())
}

/**
 * Holds if `(v, phi)` ensures that `access` is not equal to `neConstant`. For
 * example, the condition `if (x + 1 != 3)` ensures that `x` is not equal to 2.
 * Only integral types are supported.
 */
private predicate isNEPhi(
  Variable v, RangeSsaDefinition phi, VariableAccess access, float neConstant
) {
  exists(
    ComparisonOperation cmp, boolean branch, Expr linearExpr, Expr rExpr, float p, float q, float r
  |
    phi.isGuardPhi(v, access, cmp, branch) and
    eqOpWithSwapAndNegate(cmp, linearExpr, rExpr, false, branch) and
    v.getUnspecifiedType() instanceof IntegralOrEnumType and // Float `!=` is too imprecise
    r = getValue(rExpr).toFloat() and
    linearAccess(linearExpr, access, p, q) and
    neConstant = (r - q) / p
  )
  or
  exists(Expr op, boolean branch, Expr linearExpr, float p, float q |
    phi.isGuardPhi(v, access, op, branch) and
    eqZeroWithNegate(op, linearExpr, false, branch) and
    v.getUnspecifiedType() instanceof IntegralOrEnumType and // Float `!` is too imprecise
    linearAccess(linearExpr, access, p, q) and
    neConstant = (0.0 - q) / p
  )
}

/**
 * Holds if `(v, phi)` constrains the value of `access` but in a way that
 * doesn't allow this library to constrain the upper or lower bounds of
 * `access`. An example is `if (x != y)` if neither `x` nor `y` is a
 * compile-time constant.
 */
private predicate isUnsupportedGuardPhi(Variable v, RangeSsaDefinition phi, VariableAccess access) {
  exists(Expr cmp, boolean branch |
    eqOpWithSwapAndNegate(cmp, _, _, false, branch)
    or
    eqZeroWithNegate(cmp, _, false, branch)
  |
    phi.isGuardPhi(v, access, cmp, branch) and
    not isNEPhi(v, phi, access, _)
  )
}

/**
 * Gets the upper bound of the expression, if the expression is guarded.
 * An upper bound can only be found, if a guard phi node can be found, and the
 * expression has only one immediate predecessor.
 */
private float getGuardedUpperBound(VariableAccess guardedAccess) {
  exists(
    RangeSsaDefinition def, StackVariable v, VariableAccess guardVa, Expr guard, boolean branch
  |
    def.isGuardPhi(v, guardVa, guard, branch) and
    // If the basic block for the variable access being examined has
    // more than one predecessor, the guard phi node could originate
    // from one of the predecessors. This is because the guard phi
    // node is attached to the block at the end of the edge and not on
    // the actual edge. It is therefore not possible to determine which
    // edge the guard phi node belongs to. The predicate below ensures
    // that there is one predecessor, albeit somewhat conservative.
    exists(unique(BasicBlock b | b = def.(BasicBlock).getAPredecessor())) and
    guardedAccess = def.getAUse(v) and
    result = max(float ub | upperBoundFromGuard(guard, guardVa, ub, branch)) and
    not convertedExprMightOverflow(guard.getAChild+())
  )
}

cached
private module SimpleRangeAnalysisCached {
  /**
   * Gets the lower bound of the expression.
   *
   * Note: expressions in C/C++ are often implicitly or explicitly cast to a
   * different result type. Such casts can cause the value of the expression
   * to overflow or to be truncated. This predicate computes the lower bound
   * of the expression without including the effect of the casts. To compute
   * the lower bound of the expression after all the casts have been applied,
   * call `lowerBound` like this:
   *
   *    `lowerBound(expr.getFullyConverted())`
   */
  cached
  float lowerBound(Expr expr) {
    // Combine the lower bounds returned by getTruncatedLowerBounds into a
    // single minimum value.
    result = min(float lb | lb = getTruncatedLowerBounds(expr) | lb)
  }

  /**
   * Gets the upper bound of the expression.
   *
   * Note: expressions in C/C++ are often implicitly or explicitly cast to a
   * different result type. Such casts can cause the value of the expression
   * to overflow or to be truncated. This predicate computes the upper bound
   * of the expression without including the effect of the casts. To compute
   * the upper bound of the expression after all the casts have been applied,
   * call `upperBound` like this:
   *
   *    `upperBound(expr.getFullyConverted())`
   */
  cached
  float upperBound(Expr expr) {
    // Combine the upper bounds returned by getTruncatedUpperBounds and
    // getGuardedUpperBound into a single maximum value
    result = min([max(getTruncatedUpperBounds(expr)), getGuardedUpperBound(expr)])
  }

  /** Holds if the upper bound of `expr` may have been widened. This means the the upper bound is in practice likely to be overly wide. */
  cached
  predicate upperBoundMayBeWidened(Expr e) {
    isRecursiveExpr(e) and
    // Widening is not a problem if the post-analysis in `getGuardedUpperBound` has overridden the widening.
    // Note that the RHS of `<` may be multi-valued.
    not getGuardedUpperBound(e) < getTruncatedUpperBounds(e)
  }

  /**
   * Holds if `expr` has a provably empty range. For example:
   *
   *   10 < expr and expr < 5
   *
   * The range of an expression can only be empty if it can never be
   * executed. For example:
   *
   *   if (10 < x) {
   *     if (x < 5) {
   *       // Unreachable code
   *       return x; // x has an empty range: 10 < x && x < 5
   *     }
   *   }
   */
  cached
  predicate exprWithEmptyRange(Expr expr) {
    analyzableExpr(expr) and
    (
      not exists(lowerBound(expr)) or
      not exists(upperBound(expr)) or
      lowerBound(expr) > upperBound(expr)
    )
  }

  /** Holds if the definition might overflow negatively. */
  cached
  predicate defMightOverflowNegatively(RangeSsaDefinition def, StackVariable v) {
    getDefLowerBoundsImpl(def, v) < varMinVal(v)
  }

  /** Holds if the definition might overflow positively. */
  cached
  predicate defMightOverflowPositively(RangeSsaDefinition def, StackVariable v) {
    getDefUpperBoundsImpl(def, v) > varMaxVal(v)
  }

  /**
   * Holds if the definition might overflow (either positively or
   * negatively).
   */
  cached
  predicate defMightOverflow(RangeSsaDefinition def, StackVariable v) {
    defMightOverflowNegatively(def, v) or
    defMightOverflowPositively(def, v)
  }

  /**
   * Holds if `e` is an expression where the concept of overflow makes sense.
   * This predicate is used to filter out some of the unanalyzable expressions
   * from `exprMightOverflowPositively` and `exprMightOverflowNegatively`.
   */
  pragma[inline]
  private predicate exprThatCanOverflow(Expr e) {
    e instanceof UnaryArithmeticOperation or
    e instanceof BinaryArithmeticOperation or
    e instanceof AssignArithmeticOperation or
    e instanceof LShiftExpr or
    e instanceof AssignLShiftExpr
  }

  /**
   * Holds if the expression might overflow negatively. This predicate
   * does not consider the possibility that the expression might overflow
   * due to a conversion.
   */
  cached
  predicate exprMightOverflowNegatively(Expr expr) {
    getLowerBoundsImpl(expr) < exprMinVal(expr)
    or
    // The lower bound of the expression `x--` is the same as the lower
    // bound of `x`, so the standard logic (above) does not work for
    // detecting whether it might overflow.
    getLowerBoundsImpl(expr.(PostfixDecrExpr)) = exprMinVal(expr)
    or
    // We can't conclude that any unanalyzable expression might overflow. This
    // is because there are many expressions that the range analysis doesn't
    // handle, but where the concept of overflow doesn't make sense.
    exprThatCanOverflow(expr) and not analyzableExpr(expr)
  }

  /**
   * Holds if the expression might overflow negatively. Conversions
   * are also taken into account. For example the expression
   * `(int16)(x+y)` might overflow due to the `(int16)` cast, rather than
   * due to the addition.
   */
  cached
  predicate convertedExprMightOverflowNegatively(Expr expr) {
    exprMightOverflowNegatively(expr) or
    convertedExprMightOverflowNegatively(expr.getConversion())
  }

  /**
   * Holds if the expression might overflow positively. This predicate
   * does not consider the possibility that the expression might overflow
   * due to a conversion.
   */
  cached
  predicate exprMightOverflowPositively(Expr expr) {
    getUpperBoundsImpl(expr) > exprMaxVal(expr)
    or
    // The upper bound of the expression `x++` is the same as the upper
    // bound of `x`, so the standard logic (above) does not work for
    // detecting whether it might overflow.
    getUpperBoundsImpl(expr.(PostfixIncrExpr)) = exprMaxVal(expr)
    or
    // We can't conclude that any unanalyzable expression might overflow. This
    // is because there are many expressions that the range analysis doesn't
    // handle, but where the concept of overflow doesn't make sense.
    exprThatCanOverflow(expr) and not analyzableExpr(expr)
  }

  /**
   * Holds if the expression might overflow positively. Conversions
   * are also taken into account. For example the expression
   * `(int16)(x+y)` might overflow due to the `(int16)` cast, rather than
   * due to the addition.
   */
  cached
  predicate convertedExprMightOverflowPositively(Expr expr) {
    exprMightOverflowPositively(expr) or
    convertedExprMightOverflowPositively(expr.getConversion())
  }

  /**
   * Holds if the expression might overflow (either positively or
   * negatively). The possibility that the expression might overflow
   * due to an implicit or explicit cast is also considered.
   */
  cached
  predicate convertedExprMightOverflow(Expr expr) {
    convertedExprMightOverflowNegatively(expr) or
    convertedExprMightOverflowPositively(expr)
  }
}

/**
 * INTERNAL: do not use. This module contains utilities for use in the
 * experimental `SimpleRangeAnalysisExpr` module.
 */
module SimpleRangeAnalysisInternal {
  /**
   * Gets the truncated lower bounds of the fully converted expression.
   */
  float getFullyConvertedLowerBounds(Expr expr) {
    result = getTruncatedLowerBounds(expr.getFullyConverted())
  }

  /**
   * Gets the truncated upper bounds of the fully converted expression.
   */
  float getFullyConvertedUpperBounds(Expr expr) {
    result = getTruncatedUpperBounds(expr.getFullyConverted())
  }

  /**
   * Get the lower bounds for a `RangeSsaDefinition`. Most of the work is
   * done by `getDefLowerBoundsImpl`, but this is where widening is applied
   * to prevent the analysis from exploding due to a recursive definition.
   */
  float getDefLowerBounds(RangeSsaDefinition def, StackVariable v) {
    exists(float newLB, float truncatedLB |
      newLB = getDefLowerBoundsImpl(def, v) and
      if varMinVal(v) <= newLB and newLB <= varMaxVal(v)
      then truncatedLB = newLB
      else truncatedLB = varMinVal(v)
    |
      // Widening: check whether the new lower bound is from a source which
      // depends recursively on the current definition.
      if isRecursiveDef(def, v)
      then
        // The new lower bound is from a recursive source, so we round
        // down to one of a limited set of values to prevent the
        // recursion from exploding.
        result =
          max(float widenLB |
            widenLB = wideningLowerBounds(getVariableRangeType(v)) and
            not widenLB > truncatedLB
          |
            widenLB
          )
      else result = truncatedLB
    )
    or
    // The definition might overflow positively and wrap. If so, the lower
    // bound is `typeLowerBound`.
    defMightOverflowPositively(def, v) and result = varMinVal(v)
  }

  /** See comment for `getDefLowerBounds`, above. */
  float getDefUpperBounds(RangeSsaDefinition def, StackVariable v) {
    exists(float newUB, float truncatedUB |
      newUB = getDefUpperBoundsImpl(def, v) and
      if varMinVal(v) <= newUB and newUB <= varMaxVal(v)
      then truncatedUB = newUB
      else truncatedUB = varMaxVal(v)
    |
      // Widening: check whether the new upper bound is from a source which
      // depends recursively on the current definition.
      if isRecursiveDef(def, v)
      then
        // The new upper bound is from a recursive source, so we round
        // up to one of a fixed set of values to prevent the recursion
        // from exploding.
        result =
          min(float widenUB |
            widenUB = wideningUpperBounds(getVariableRangeType(v)) and
            not widenUB < truncatedUB
          |
            widenUB
          )
      else result = truncatedUB
    )
    or
    // The definition might overflow negatively and wrap. If so, the upper
    // bound is `typeUpperBound`.
    defMightOverflowNegatively(def, v) and result = varMaxVal(v)
  }
}

private import SimpleRangeAnalysisInternal
