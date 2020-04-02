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

/** Set of expressions which we know how to analyze. */
private predicate analyzableExpr(Expr e) {
  // The type of the expression must be arithmetic. We reuse the logic in
  // `exprMinVal` to check this.
  exists(exprMinVal(e)) and
  (
    exists(getValue(e).toFloat()) or
    e instanceof UnaryPlusExpr or
    e instanceof UnaryMinusExpr or
    e instanceof MinExpr or
    e instanceof MaxExpr or
    e instanceof ConditionalExpr or
    e instanceof AddExpr or
    e instanceof SubExpr or
    e instanceof AssignExpr or
    e instanceof AssignAddExpr or
    e instanceof AssignSubExpr or
    e instanceof CrementOperation or
    e instanceof RemExpr or
    e instanceof CommaExpr or
    e instanceof StmtExpr or
    // A conversion is analyzable, provided that its child has an arithmetic
    // type. (Sometimes the child is a reference type, and so does not get
    // any bounds.) Rather than checking whether the type of the child is
    // arithmetic, we reuse the logic that is already encoded in
    // `exprMinVal`.
    exists(exprMinVal(e.(Conversion).getExpr())) or
    // Also allow variable accesses, provided that they have SSA
    // information.
    exists(RangeSsaDefinition def, StackVariable v | e = def.getAUse(v))
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
  exists(AssignAddExpr assignAdd, RangeSsaDefinition nextDef |
    def = assignAdd and
    assignAdd.getLValue() = nextDef.getAUse(v)
  |
    defDependsOnDef(nextDef, v, srcDef, srcVar) or
    exprDependsOnDef(assignAdd.getRValue(), srcDef, srcVar)
  )
  or
  exists(AssignSubExpr assignSub, RangeSsaDefinition nextDef |
    def = assignSub and
    assignSub.getLValue() = nextDef.getAUse(v)
  |
    defDependsOnDef(nextDef, v, srcDef, srcVar) or
    exprDependsOnDef(assignSub.getRValue(), srcDef, srcVar)
  )
  or
  exists(CrementOperation crem |
    def = crem and
    crem.getOperand() = v.getAnAccess() and
    exprDependsOnDef(crem.getOperand(), srcDef, srcVar)
  )
  or
  // Phi nodes.
  phiDependsOnDef(def, v, srcDef, srcVar)
}

/**
 * Helper predicate for `defDependsOnDef`. This predicate matches
 * the structure of `getLowerBoundsImpl` and `getUpperBoundsImpl`.
 */
private predicate exprDependsOnDef(Expr e, RangeSsaDefinition srcDef, StackVariable srcVar) {
  exists(UnaryMinusExpr negateExpr | e = negateExpr |
    exprDependsOnDef(negateExpr.getOperand(), srcDef, srcVar)
  )
  or
  exists(UnaryPlusExpr plusExpr | e = plusExpr |
    exprDependsOnDef(plusExpr.getOperand(), srcDef, srcVar)
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
  exists(CrementOperation crementExpr | e = crementExpr |
    exprDependsOnDef(crementExpr.getOperand(), srcDef, srcVar)
  )
  or
  exists(RemExpr remExpr | e = remExpr | exprDependsOnDef(remExpr.getAnOperand(), srcDef, srcVar))
  or
  exists(CommaExpr commaExpr | e = commaExpr |
    exprDependsOnDef(commaExpr.getRightOperand(), srcDef, srcVar)
  )
  or
  exists(StmtExpr stmtExpr | e = stmtExpr |
    exprDependsOnDef(stmtExpr.getResultExpr(), srcDef, srcVar)
  )
  or
  exists(Conversion convExpr | e = convExpr | exprDependsOnDef(convExpr.getExpr(), srcDef, srcVar))
  or
  e = srcDef.getAUse(srcVar)
}

/**
 * Helper predicate for `defDependsOnDef`. This predicate matches
 * the structure of `getPhiLowerBounds` and `getPhiUpperBounds`.
 */
private predicate phiDependsOnDef(
  RangeSsaDefinition phi, StackVariable v, RangeSsaDefinition srcDef, StackVariable srcVar
) {
  exists(VariableAccess access, ComparisonOperation guard |
    access = v.getAnAccess() and
    phi.isGuardPhi(access, guard, _)
  |
    exprDependsOnDef(guard.getAnOperand(), srcDef, srcVar) or
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
  v.getUnspecifiedType() instanceof ArithmeticType and
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

/** See comment above sourceDef. */
private predicate analyzableDef(RangeSsaDefinition def, StackVariable v) {
  assignmentDef(def, v, _) or defDependsOnDef(def, v, _, _)
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

/**
 * Gets the truncated lower bounds of the fully converted expression.
 */
private float getFullyConvertedLowerBounds(Expr expr) {
  result = getTruncatedLowerBounds(expr.getFullyConverted())
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
  if analyzableExpr(expr)
  then
    // If the expression evaluates to a constant, then there is no
    // need to call getLowerBoundsImpl.
    if exists(getValue(expr).toFloat())
    then result = getValue(expr).toFloat()
    else (
      // Some of the bounds computed by getLowerBoundsImpl might
      // overflow, so we replace invalid bounds with exprMinVal.
      exists(float newLB | newLB = getLowerBoundsImpl(expr) |
        if exprMinVal(expr) <= newLB and newLB <= exprMaxVal(expr)
        then result = newLB
        else result = exprMinVal(expr)
      )
      or
      // The expression might overflow and wrap. If so, the
      // lower bound is exprMinVal.
      exprMightOverflowPositively(expr) and
      result = exprMinVal(expr)
    )
  else
    // The expression is not analyzable, so its lower bound is
    // unknown. Note that the call to exprMinVal restricts the
    // expressions to just those with arithmetic types. There is no
    // need to return results for non-arithmetic expressions.
    result = exprMinVal(expr)
}

/**
 * Gets the truncated upper bounds of the fully converted expression.
 */
private float getFullyConvertedUpperBounds(Expr expr) {
  result = getTruncatedUpperBounds(expr.getFullyConverted())
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
      exists(float newUB | newUB = getUpperBoundsImpl(expr) |
        if exprMinVal(expr) <= newUB and newUB <= exprMaxVal(expr)
        then result = newUB
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

/**
 * Holds if the expression might overflow negatively. This predicate
 * does not consider the possibility that the expression might overflow
 * due to a conversion.
 *
 * DEPRECATED: use `exprMightOverflowNegatively` instead.
 */
deprecated predicate negative_overflow(Expr expr) { exprMightOverflowNegatively(expr) }

/**
 * Holds if the expression might overflow positively. This predicate
 * does not consider the possibility that the expression might overflow
 * due to a conversion.
 *
 * DEPRECATED: use `exprMightOverflowPositively` instead.
 */
deprecated predicate positive_overflow(Expr expr) { exprMightOverflowPositively(expr) }

/** Only to be called by `getTruncatedLowerBounds`. */
private float getLowerBoundsImpl(Expr expr) {
  exists(UnaryPlusExpr plusExpr |
    expr = plusExpr and
    result = getFullyConvertedLowerBounds(plusExpr.getOperand())
  )
  or
  exists(UnaryMinusExpr negateExpr, float xHigh |
    expr = negateExpr and
    xHigh = getFullyConvertedUpperBounds(negateExpr.getOperand()) and
    result = -xHigh
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
    // negative. If so, the lower bound of `x%y` is `-abs(y)`, which is
    // equal to `min(-y,y)`.
    exists(float childLB |
      childLB = getFullyConvertedLowerBounds(remExpr.getAnOperand()) and
      not childLB >= 0
    |
      result = getFullyConvertedLowerBounds(remExpr.getRightOperand())
      or
      exists(float rhsUB | rhsUB = getFullyConvertedUpperBounds(remExpr.getRightOperand()) |
        result = -rhsUB
      )
    )
  )
  or
  exists(CommaExpr commaExpr |
    expr = commaExpr and
    result = getFullyConvertedLowerBounds(commaExpr.getRightOperand())
  )
  or
  exists(StmtExpr stmtExpr |
    expr = stmtExpr and
    result = getFullyConvertedLowerBounds(stmtExpr.getResultExpr())
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
}

/** Only to be called by `getTruncatedUpperBounds`. */
private float getUpperBoundsImpl(Expr expr) {
  exists(UnaryPlusExpr plusExpr |
    expr = plusExpr and
    result = getFullyConvertedUpperBounds(plusExpr.getOperand())
  )
  or
  exists(UnaryMinusExpr negateExpr, float xLow |
    expr = negateExpr and
    xLow = getFullyConvertedLowerBounds(negateExpr.getOperand()) and
    result = -xLow
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
    result = rhsUB
    or
    // If the right hand side could be negative then we need to take its
    // absolute value. Since `abs(x) = max(-x,x)` this is equivalent to
    // adding `-rhsLB` to the set of upper bounds.
    exists(float rhsLB |
      rhsLB = getFullyConvertedLowerBounds(remExpr.getAnOperand()) and
      not rhsLB >= 0
    |
      result = -rhsLB
    )
  )
  or
  exists(CommaExpr commaExpr |
    expr = commaExpr and
    result = getFullyConvertedUpperBounds(commaExpr.getRightOperand())
  )
  or
  exists(StmtExpr stmtExpr |
    expr = stmtExpr and
    result = getFullyConvertedUpperBounds(stmtExpr.getResultExpr())
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
  exists(
    VariableAccess access, ComparisonOperation guard, boolean branch, float defLB, float guardLB
  |
    access = v.getAnAccess() and
    phi.isGuardPhi(access, guard, branch) and
    lowerBoundFromGuard(guard, access, guardLB, branch) and
    defLB = getFullyConvertedLowerBounds(access)
  |
    // Compute the maximum of `guardLB` and `defLB`.
    if guardLB > defLB then result = guardLB else result = defLB
  )
  or
  result = getDefLowerBounds(phi.getAPhiInput(v), v)
}

/** See comment for `getPhiLowerBounds`, above. */
private float getPhiUpperBounds(StackVariable v, RangeSsaDefinition phi) {
  exists(
    VariableAccess access, ComparisonOperation guard, boolean branch, float defUB, float guardUB
  |
    access = v.getAnAccess() and
    phi.isGuardPhi(access, guard, branch) and
    upperBoundFromGuard(guard, access, guardUB, branch) and
    defUB = getFullyConvertedUpperBounds(access)
  |
    // Compute the minimum of `guardUB` and `defUB`.
    if guardUB < defUB then result = guardUB else result = defUB
  )
  or
  result = getDefUpperBounds(phi.getAPhiInput(v), v)
}

/** Only to be called by `getDefLowerBounds`. */
private float getDefLowerBoundsImpl(RangeSsaDefinition def, StackVariable v) {
  // Definitions with a defining value.
  exists(Expr expr | assignmentDef(def, v, expr) | result = getFullyConvertedLowerBounds(expr))
  or
  exists(AssignAddExpr assignAdd, RangeSsaDefinition nextDef, float lhsLB, float rhsLB |
    def = assignAdd and
    assignAdd.getLValue() = nextDef.getAUse(v) and
    lhsLB = getDefLowerBounds(nextDef, v) and
    rhsLB = getFullyConvertedLowerBounds(assignAdd.getRValue()) and
    result = addRoundingDown(lhsLB, rhsLB)
  )
  or
  exists(AssignSubExpr assignSub, RangeSsaDefinition nextDef, float lhsLB, float rhsUB |
    def = assignSub and
    assignSub.getLValue() = nextDef.getAUse(v) and
    lhsLB = getDefLowerBounds(nextDef, v) and
    rhsUB = getFullyConvertedUpperBounds(assignSub.getRValue()) and
    result = addRoundingDown(lhsLB, -rhsUB)
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
  // Unanalyzable definitions.
  unanalyzableDefBounds(def, v, result, _)
}

/** Only to be called by `getDefUpperBounds`. */
private float getDefUpperBoundsImpl(RangeSsaDefinition def, StackVariable v) {
  // Definitions with a defining value.
  exists(Expr expr | assignmentDef(def, v, expr) | result = getFullyConvertedUpperBounds(expr))
  or
  exists(AssignAddExpr assignAdd, RangeSsaDefinition nextDef, float lhsUB, float rhsUB |
    def = assignAdd and
    assignAdd.getLValue() = nextDef.getAUse(v) and
    lhsUB = getDefUpperBounds(nextDef, v) and
    rhsUB = getFullyConvertedUpperBounds(assignAdd.getRValue()) and
    result = addRoundingUp(lhsUB, rhsUB)
  )
  or
  exists(AssignSubExpr assignSub, RangeSsaDefinition nextDef, float lhsUB, float rhsLB |
    def = assignSub and
    assignSub.getLValue() = nextDef.getAUse(v) and
    lhsUB = getDefUpperBounds(nextDef, v) and
    rhsLB = getFullyConvertedLowerBounds(assignSub.getRValue()) and
    result = addRoundingUp(lhsUB, -rhsLB)
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
  // Unanalyzable definitions.
  unanalyzableDefBounds(def, v, _, result)
}

/**
 * Get the lower bounds for a `RangeSsaDefinition`. Most of the work is
 * done by `getDefLowerBoundsImpl`, but this is where widening is applied
 * to prevent the analysis from exploding due to a recursive definition.
 */
private float getDefLowerBounds(RangeSsaDefinition def, StackVariable v) {
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
          widenLB = wideningLowerBounds(v.getUnspecifiedType()) and
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
private float getDefUpperBounds(RangeSsaDefinition def, StackVariable v) {
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
          widenUB = wideningUpperBounds(v.getUnspecifiedType()) and
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
predicate nonNanGuardedVariable(ComparisonOperation guard, VariableAccess v, boolean branch) {
  v.getUnspecifiedType() instanceof IntegralType
  or
  v.getUnspecifiedType() instanceof FloatingPointType and v instanceof NonNanVariableAccess
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
private predicate lowerBoundFromGuard(
  ComparisonOperation guard, VariableAccess v, float lb, boolean branch
) {
  exists(float childLB, RelationStrictness strictness |
    boundFromGuard(guard, v, childLB, true, strictness, branch)
  |
    if nonNanGuardedVariable(guard, v, branch)
    then
      if
        strictness = Nonstrict() or
        not v.getUnspecifiedType() instanceof IntegralType
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
private predicate upperBoundFromGuard(
  ComparisonOperation guard, VariableAccess v, float ub, boolean branch
) {
  exists(float childUB, RelationStrictness strictness |
    boundFromGuard(guard, v, childUB, false, strictness, branch)
  |
    if nonNanGuardedVariable(guard, v, branch)
    then
      if
        strictness = Nonstrict() or
        not v.getUnspecifiedType() instanceof IntegralType
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
  ComparisonOperation guard, VariableAccess v, float boundValue, boolean isLowerBound,
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
  // For x != RHS, we create trivial bounds:
  //
  //   1. x <= typeUpperBound(RHS.getUnspecifiedType())
  //   2. x >= typeLowerBound(RHS.getUnspecifiedType())
  //
  exists(Expr lhs, Expr rhs, boolean isEQ |
    linearAccess(lhs, v, p, q) and
    eqOpWithSwapAndNegate(guard, lhs, rhs, isEQ, branch) and
    strictness = Nonstrict()
  |
    // True branch
    isEQ = true and getBounds(rhs, boundValue, isLowerBound)
    or
    // False branch: set the bounds to the min/max for the type.
    isEQ = false and exprTypeBounds(rhs, boundValue, isLowerBound)
  )
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
    // Combine the upper bounds returned by getTruncatedUpperBounds into a
    // single maximum value.
    result = max(float ub | ub = getTruncatedUpperBounds(expr) | ub)
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
