import cpp

/**
 * Describes whether a relation is 'strict' (that is, a `<` or `>`
 * relation) or 'non-strict' (a `<=` or `>=` relation).
 */
newtype RelationStrictness =
  /**
   * Represents that a relation is 'strict' (that is, a `<` or `>` relation).
   */
  Strict() or
  /**
   * Represents that a relation is 'non-strict' (that is, a `<=` or `>=` relation)
   */
  Nonstrict()

/**
 * Describes whether a relation is 'greater' (that is, a `>` or `>=`
 * relation) or 'lesser' (a `<` or `<=` relation).
 */
newtype RelationDirection =
  /**
   * Represents that a relation is 'greater' (that is, a `>` or `>=` relation).
   */
  Greater() or
  /**
   * Represents that a relation is 'lesser' (that is, a `<` or `<=` relation).
   */
  Lesser()

private RelationStrictness negateStrictness(RelationStrictness strict) {
  strict = Strict() and result = Nonstrict()
  or
  strict = Nonstrict() and result = Strict()
}

private RelationDirection negateDirection(RelationDirection dir) {
  dir = Greater() and result = Lesser()
  or
  dir = Lesser() and result = Greater()
}

/**
 * Holds if `dir` is `Greater` (that is, a `>` or `>=` relation)
 */
boolean directionIsGreater(RelationDirection dir) {
  dir = Greater() and result = true
  or
  dir = Lesser() and result = false
}

/**
 * Holds if `dir` is `Lesser` (that is, a `<` or `<=` relation)
 */
boolean directionIsLesser(RelationDirection dir) {
  dir = Greater() and result = false
  or
  dir = Lesser() and result = true
}

/**
 * Holds if `rel` is a relational operation (`<`, `>`, `<=` or `>=`)
 * with fully-converted children `lhs` and `rhs`, described by
 * `dir` and `strict`.
 *
 * For example, if `rel` is `x < 5` then
 * `relOp(rel, x, 5, Lesser(), Strict())` holds.
 */
private predicate relOp(
  RelationalOperation rel, Expr lhs, Expr rhs, RelationDirection dir, RelationStrictness strict
) {
  lhs = rel.getLeftOperand().getFullyConverted() and
  rhs = rel.getRightOperand().getFullyConverted() and
  (
    rel instanceof LTExpr and dir = Lesser() and strict = Strict()
    or
    rel instanceof LEExpr and dir = Lesser() and strict = Nonstrict()
    or
    rel instanceof GTExpr and dir = Greater() and strict = Strict()
    or
    rel instanceof GEExpr and dir = Greater() and strict = Nonstrict()
  )
}

/**
 * Holds if `rel` is a relational operation (`<`, `>`, `<=` or `>=`)
 * with fully-converted children `a` and `b`, described by `dir` and `strict`.
 *
 * This allows for the relation to be either as written, or with its
 * arguments reversed; for example, if `rel` is `x < 5` then both
 * `relOpWithSwap(rel, x, 5, Lesser(), Strict())` and
 * `relOpWithSwap(rel, 5, x, Greater(), Strict())` hold.
 */
predicate relOpWithSwap(
  RelationalOperation rel, Expr a, Expr b, RelationDirection dir, RelationStrictness strict
) {
  relOp(rel, a, b, dir, strict) or
  relOp(rel, b, a, negateDirection(dir), strict)
}

/**
 * Holds if `rel` is a comparison operation (`<`, `>`, `<=` or `>=`)
 * with fully-converted children `a` and `b`, described by `dir` and `strict`, with
 * result `branch`.
 *
 * This allows for the relation to be either as written, or with its
 * arguments reversed; for example, if `rel` is `x < 5` then
 * `relOpWithSwapAndNegate(rel, x, 5, Lesser(), Strict(), true)`,
 * `relOpWithSwapAndNegate(rel, 5, x, Greater(), Strict(), true)`,
 * `relOpWithSwapAndNegate(rel, x, 5, Greater(), Nonstrict(), false)` and
 * `relOpWithSwapAndNegate(rel, 5, x, Lesser(), Nonstrict(), false)` hold.
 */
predicate relOpWithSwapAndNegate(
  RelationalOperation rel, Expr a, Expr b, RelationDirection dir, RelationStrictness strict,
  boolean branch
) {
  relOpWithSwap(rel, a, b, dir, strict) and branch = true
  or
  relOpWithSwap(rel, a, b, negateDirection(dir), negateStrictness(strict)) and
  branch = false
}

/**
 * Holds if `cmp` is an equality operation (`==` or `!=`) with  fully-converted
 * children `lhs` and `rhs`, and `isEQ` is true if `cmp` is an
 * `==` operation and false if it is an `!=` operation.
 *
 * For example, if `rel` is `x == 5` then
 * `eqOpWithSwap(cmp, x, 5, true)` holds.
 */
private predicate eqOp(EqualityOperation cmp, Expr lhs, Expr rhs, boolean isEQ) {
  lhs = cmp.getLeftOperand().getFullyConverted() and
  rhs = cmp.getRightOperand().getFullyConverted() and
  (
    cmp instanceof EQExpr and isEQ = true
    or
    cmp instanceof NEExpr and isEQ = false
  )
}

/**
 * Holds if `cmp` is an equality operation (`==` or `!=`) with fully-converted
 * operands `a` and `b`, and `isEQ` is true if `cmp` is an `==` operation and
 * false if it is an `!=` operation.
 *
 * This allows for the equality to be either as written, or with its
 * arguments reversed; for example, if `cmp` is `x == 5` then both
 * `eqOpWithSwap(cmp, x, 5, true)` and
 * `eqOpWithSwap(cmp, 5, x, true)` hold.
 */
private predicate eqOpWithSwap(EqualityOperation cmp, Expr a, Expr b, boolean isEQ) {
  eqOp(cmp, a, b, isEQ) or
  eqOp(cmp, b, a, isEQ)
}

/**
 * Holds if `cmp` is an equality operation (`==` or `!=`) with fully-converted
 * children `a` and `b`, `isEQ` is true if `cmp` is an `==` operation and
 * false if it is an `!=` operation, and the result is `branch`.
 *
 * This allows for the comparison to be either as written, or with its
 * arguments reversed; for example, if `cmp` is `x == 5` then
 * `eqOpWithSwapAndNegate(cmp, x, 5, true, true)`,
 * `eqOpWithSwapAndNegate(cmp, 5, x, true, true)`,
 * `eqOpWithSwapAndNegate(cmp, x, 5, false, false)` and
 * `eqOpWithSwapAndNegate(cmp, 5, x, false, false)` hold.
 */
predicate eqOpWithSwapAndNegate(EqualityOperation cmp, Expr a, Expr b, boolean isEQ, boolean branch) {
  eqOpWithSwap(cmp, a, b, branch) and isEQ = true
  or
  eqOpWithSwap(cmp, a, b, branch.booleanNot()) and isEQ = false
}

/**
 * Holds if `cmp` is an unconverted conversion of `a` to a Boolean that
 * evalutes to `isEQ` iff `a` is 0.
 *
 * Note that `a` can be `cmp` itself or a conversion thereof.
 */
private predicate eqZero(Expr cmp, Expr a, boolean isEQ) {
  // The `!a` expression tests `a` equal to zero when `a` is a number converted
  // to a Boolean.
  isEQ = true and
  exists(Expr notOperand | notOperand = cmp.(NotExpr).getOperand().getFullyConverted() |
    // In C++ code there will be a BoolConversion in `!myInt`
    a = notOperand.(BoolConversion).getExpr()
    or
    // In C code there is no conversion since there was no bool type before C99
    a = notOperand and
    not a instanceof BoolConversion // avoid overlap with the case above
  )
  or
  // The `(bool)a` expression tests `a` NOT equal to zero when `a` is a number
  // converted to a Boolean. To avoid overlap with the case above, this case
  // excludes conversions that are right below a `!`.
  isEQ = false and
  linearAccess(cmp, _, _, _) and
  // This test for `isCondition` implies that `cmp` is unconverted and that the
  // parent of `cfg` is not a `NotExpr` -- the CFG doesn't do branching from
  // inside `NotExpr`.
  cmp.isCondition() and
  // The GNU two-operand conditional expression is not supported for the
  // purpose of guards, but the value of the conditional expression itself is
  // modeled in the range analysis.
  not exists(ConditionalExpr cond | cmp = cond.getCondition() and cond.isTwoOperand()) and
  (
    // In C++ code there will be a BoolConversion in `if (myInt)`
    a = cmp.getFullyConverted().(BoolConversion).getExpr()
    or
    // In C code there is no conversion since there was no bool type before C99
    a = cmp.getFullyConverted() and
    not a instanceof BoolConversion // avoid overlap with the case above
  )
}

/**
 * Holds if `branch` of `cmp` is taken when `a` compares `isEQ` to zero.
 *
 * Note that `a` can be `cmp` itself or a conversion thereof.
 */
predicate eqZeroWithNegate(Expr cmp, Expr a, boolean isEQ, boolean branch) {
  // The comparison for _equality_ to zero is on the `true` branch when `cmp`
  // compares equal to zero and on the `false` branch when `cmp` compares not
  // equal to zero.
  eqZero(cmp, a, branch) and isEQ = true
  or
  // The comparison for _inequality_ to zero is on the `false` branch when
  // `cmp` compares equal to zero and on the `true` branch when `cmp` compares
  // not equal to zero.
  eqZero(cmp, a, branch.booleanNot()) and isEQ = false
}

/**
 * Holds if `expr` is equivalent to `p*v + q`, where `p` is a non-zero
 * number. This takes into account the associativity, commutativity and
 * distributivity of arithmetic operations.
 */
predicate linearAccess(Expr expr, VariableAccess v, float p, float q) {
  // Exclude 0 and NaN.
  (p < 0 or p > 0) and
  linearAccessImpl(expr, v, p, q)
}

/**
 * Holds if `expr` is equivalent to `p*v + q`.
 * This takes into account the associativity, commutativity and
 * distributivity of arithmetic operations.
 */
private predicate linearAccessImpl(Expr expr, VariableAccess v, float p, float q) {
  // Base case
  expr = v and p = 1.0 and q = 0.0
  or
  expr.(ReferenceDereferenceExpr).getExpr() = v and p = 1.0 and q = 0.0
  or
  // a+(p*v+b) == p*v + (a+b)
  exists(AddExpr addExpr, float a, float b |
    addExpr.getLeftOperand().isConstant() and
    a = addExpr.getLeftOperand().getFullyConverted().getValue().toFloat() and
    linearAccess(addExpr.getRightOperand(), v, p, b) and
    expr = addExpr and
    q = a + b
  )
  or
  // (p*v+a)+b == p*v + (a+b)
  exists(AddExpr addExpr, float a, float b |
    addExpr.getRightOperand().isConstant() and
    b = addExpr.getRightOperand().getFullyConverted().getValue().toFloat() and
    linearAccess(addExpr.getLeftOperand(), v, p, a) and
    expr = addExpr and
    q = a + b
  )
  or
  // a-(m*v+b) == -m*v + (a-b)
  exists(SubExpr subExpr, float a, float b, float m |
    subExpr.getLeftOperand().isConstant() and
    a = subExpr.getLeftOperand().getFullyConverted().getValue().toFloat() and
    linearAccess(subExpr.getRightOperand(), v, m, b) and
    expr = subExpr and
    p = -m and
    q = a - b
  )
  or
  // (p*v+a)-b == p*v + (a-b)
  exists(SubExpr subExpr, float a, float b |
    subExpr.getRightOperand().isConstant() and
    b = subExpr.getRightOperand().getFullyConverted().getValue().toFloat() and
    linearAccess(subExpr.getLeftOperand(), v, p, a) and
    expr = subExpr and
    q = a - b
  )
  or
  // +(p*v+q) == p*v + q
  exists(UnaryPlusExpr unaryPlusExpr |
    linearAccess(unaryPlusExpr.getOperand().getFullyConverted(), v, p, q) and
    expr = unaryPlusExpr
  )
  or
  // (larger_type)(p*v+q) == p*v + q
  exists(Cast cast, ArithmeticType sourceType, ArithmeticType targetType |
    linearAccess(cast.getExpr(), v, p, q) and
    sourceType = cast.getExpr().getUnspecifiedType() and
    targetType = cast.getUnspecifiedType() and
    // This allows conversion between signed and unsigned, which is technically
    // lossy but common enough that we'll just have to assume the user knows
    // what they're doing.
    targetType.getSize() >= sourceType.getSize() and
    expr = cast
  )
  or
  // (p*v+q) == p*v + q
  exists(ParenthesisExpr paren |
    linearAccess(paren.getExpr(), v, p, q) and
    expr = paren
  )
  or
  // -(a*v+b) == -a*v + (-b)
  exists(UnaryMinusExpr unaryMinusExpr, float a, float b |
    linearAccess(unaryMinusExpr.getOperand().getFullyConverted(), v, a, b) and
    expr = unaryMinusExpr and
    p = -a and
    q = -b
  )
  or
  // m*(a*v+b) == (m*a)*v + (m*b)
  exists(MulExpr mulExpr, float a, float b, float m |
    mulExpr.getLeftOperand().isConstant() and
    m = mulExpr.getLeftOperand().getFullyConverted().getValue().toFloat() and
    linearAccess(mulExpr.getRightOperand(), v, a, b) and
    expr = mulExpr and
    p = m * a and
    q = m * b
  )
  or
  // (a*v+b)*m == (m*a)*v + (m*b)
  exists(MulExpr mulExpr, float a, float b, float m |
    mulExpr.getRightOperand().isConstant() and
    m = mulExpr.getRightOperand().getFullyConverted().getValue().toFloat() and
    linearAccess(mulExpr.getLeftOperand(), v, a, b) and
    expr = mulExpr and
    p = m * a and
    q = m * b
  )
}

/**
 * Holds if `guard` is a comparison operation (`<`, `<=`, `>`, `>=`,
 * `==` or `!=`), one of its arguments is equivalent (up to
 * associativity, commutativity and distributivity or the simple
 * arithmetic operations) to `p*v + q` (for some `p` and `q`),
 * `direction` describes whether `guard` give an upper or lower bound
 * on `v`, and `branch` indicates which control-flow branch this
 * bound is valid on.
 *
 * For example, if `guard` is `2*v + 3 > 10` then
 * `cmpWithLinearBound(guard, v, Greater(), true)` and
 * `cmpWithLinearBound(guard, v, Lesser(),  false)` hold.
 * If `guard` is `4 - v > 5` then
 * `cmpWithLinearBound(guard, v, Lesser(),  false)` and
 * `cmpWithLinearBound(guard, v, Greater(), true)` hold.
 *
 * A more sophisticated predicate, such as `boundFromGuard`, is needed
 * to compute an actual bound for `v`. This predicate can be used if
 * you just want to check whether a variable is bounded, or to restrict
 * a more expensive analysis to just guards that bound a variable.
 */
predicate cmpWithLinearBound(
  ComparisonOperation guard, VariableAccess v,
  RelationDirection direction, // Is this a lower or an upper bound?
  boolean branch // Which control-flow branch is this bound valid on?
) {
  exists(Expr lhs, float p, RelationDirection dir |
    linearAccess(lhs, v, p, _) and
    relOpWithSwapAndNegate(guard, lhs, _, dir, _, branch) and
    (
      p > 0 and direction = dir
      or
      p < 0 and direction = negateDirection(dir)
    )
  )
  or
  exists(Expr lhs |
    linearAccess(lhs, v, _, _) and
    eqOpWithSwap(guard, lhs, _, branch)
  )
}

/**
 * Holds if `lb` and `ub` are the lower and upper bounds of the unspecified
 * type `t`.
 *
 * For example, if `t` is a signed 32-bit type then holds if `lb` is
 * `-2^31` and `ub` is `2^31 - 1`.
 */
private predicate typeBounds(ArithmeticType t, float lb, float ub) {
  exists(IntegralType integralType, float limit |
    integralType = t and limit = 2.pow(8 * integralType.getSize())
  |
    if integralType instanceof BoolType
    then lb = 0 and ub = 1
    else
      if integralType.isSigned()
      then (
        lb = -(limit / 2) and ub = (limit / 2) - 1
      ) else (
        lb = 0 and ub = limit - 1
      )
  )
  or
  // This covers all floating point types. The range is (-Inf, +Inf).
  t instanceof FloatingPointType and lb = -(1.0 / 0.0) and ub = 1.0 / 0.0
}

private Type stripReference(Type t) {
  if t instanceof ReferenceType then result = t.(ReferenceType).getBaseType() else result = t
}

/** Gets the type used by range analysis for the given `StackVariable`. */
Type getVariableRangeType(StackVariable v) { result = stripReference(v.getUnspecifiedType()) }

/**
 * Gets the lower bound for the unspecified type `t`.
 *
 * For example, if `t` is a signed 32-bit type then the result is
 * `-2^31`.
 */
float typeLowerBound(Type t) { typeBounds(stripReference(t), result, _) }

/**
 * Gets the upper bound for the unspecified type `t`.
 *
 * For example, if `t` is a signed 32-bit type then the result is
 * `2^31 - 1`.
 */
float typeUpperBound(Type t) { typeBounds(stripReference(t), _, result) }

/**
 * Gets the minimum value that this expression could represent, based on
 * its type.
 *
 * For example, if `expr` has a signed 32-bit type then the result is
 * `-2^31`.
 *
 * Note: Due to the way casts are represented, rather than calling
 * `exprMinVal(expr)` you will normally want to call
 * `exprMinVal(expr.getFullyConverted())`.
 */
float exprMinVal(Expr expr) { result = typeLowerBound(expr.getUnspecifiedType()) }

/**
 * Gets the maximum value that this expression could represent, based on
 * its type.
 *
 * For example, if `expr` has a signed 32-bit type then the result is
 * `2^31 - 1`.
 *
 * Note: Due to the way casts are represented, rather than calling
 * `exprMaxVal(expr)` you will normally want to call
 * `exprMaxVal(expr.getFullyConverted())`.
 */
float exprMaxVal(Expr expr) { result = typeUpperBound(expr.getUnspecifiedType()) }

/**
 * Gets the minimum value that this variable could represent, based on
 * its type.
 *
 * For example, if `v` has a signed 32-bit type then the result is
 * `-2^31`.
 */
float varMinVal(Variable v) { result = typeLowerBound(v.getUnspecifiedType()) }

/**
 * Gets the maximum value that this variable could represent, based on
 * its type.
 *
 * For example, if `v` has a signed 32-bit type then the result is
 * `2^31 - 1`.
 */
float varMaxVal(Variable v) { result = typeUpperBound(v.getUnspecifiedType()) }
