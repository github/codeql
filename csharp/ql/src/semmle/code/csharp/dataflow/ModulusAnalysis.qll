/**
 * Provides inferences of the form: `e` equals `b + v` modulo `m` where `e` is
 * an expression, `b` is a `Bound` (typically zero or the value of an SSA
 * variable), and `v` is an integer in the range `[0 .. m-1]`.
 */

private import internal.rangeanalysis.ModulusAnalysisSpecific::Private
private import Bound
private import internal.rangeanalysis.SsaReadPositionCommon

/**
 * Holds if `e + delta` equals `v` at `pos`.
 */
private predicate valueFlowStepSsa(SsaVariable v, SsaReadPosition pos, Expr e, int delta) {
  ssaUpdateStep(v, e, delta) and pos.hasReadOfVar(v)
  or
  exists(Guard guard, boolean testIsTrue |
    pos.hasReadOfVar(v) and
    guard = eqFlowCond(v, e, delta, true, testIsTrue) and
    guardDirectlyControlsSsaRead(guard, pos, testIsTrue)
  )
}

/**
 * Holds if `add` is the addition of `larg` and `rarg`, neither of which are
 * `ConstantIntegerExpr`s.
 */
private predicate nonConstAddition(Expr add, Expr larg, Expr rarg) {
  exists(AddExpr a | a = add |
    larg = a.getLhs() and
    rarg = a.getRhs()
  ) and
  not larg instanceof ConstantIntegerExpr and
  not rarg instanceof ConstantIntegerExpr
}

/**
 * Holds if `sub` is the subtraction of `larg` and `rarg`, where `rarg` is not
 * a `ConstantIntegerExpr`.
 */
private predicate nonConstSubtraction(Expr sub, Expr larg, Expr rarg) {
  exists(SubExpr s | s = sub |
    larg = s.getLhs() and
    rarg = s.getRhs()
  ) and
  not rarg instanceof ConstantIntegerExpr
}

/** Gets an expression that is the remainder modulo `mod` of `arg`. */
private Expr modExpr(Expr arg, int mod) {
  exists(RemExpr rem |
    result = rem and
    arg = rem.getLeftOperand() and
    rem.getRightOperand().(ConstantIntegerExpr).getIntValue() = mod and
    mod >= 2
  )
  or
  exists(ConstantIntegerExpr c |
    mod = 2.pow([1 .. 30]) and
    c.getIntValue() = mod - 1 and
    result.(BitwiseAndExpr).hasOperands(arg, c)
  )
}

/**
 * Gets a guard that tests whether `v` is congruent with `val` modulo `mod` on
 * its `testIsTrue` branch.
 */
private Guard moduloCheck(SsaVariable v, int val, int mod, boolean testIsTrue) {
  exists(Expr rem, ConstantIntegerExpr c, int r, boolean polarity |
    result.isEquality(rem, c, polarity) and
    c.getIntValue() = r and
    rem = modExpr(v.getAUse(), mod) and
    (
      testIsTrue = polarity and val = r
      or
      testIsTrue = polarity.booleanNot() and
      mod = 2 and
      val = 1 - r and
      (r = 0 or r = 1)
    )
  )
}

/**
 * Holds if a guard ensures that `v` at `pos` is congruent with `val` modulo `mod`.
 */
private predicate moduloGuardedRead(SsaVariable v, SsaReadPosition pos, int val, int mod) {
  exists(Guard guard, boolean testIsTrue |
    pos.hasReadOfVar(v) and
    guard = moduloCheck(v, val, mod, testIsTrue) and
    guardControlsSsaRead(guard, pos, testIsTrue)
  )
}

/** Holds if `factor` is a power of 2 that divides `mask`. */
bindingset[mask]
private predicate andmaskFactor(int mask, int factor) {
  mask % factor = 0 and
  factor = 2.pow([1 .. 30])
}

/** Holds if `e` is evenly divisible by `factor`. */
private predicate evenlyDivisibleExpr(Expr e, int factor) {
  exists(ConstantIntegerExpr c, int k | k = c.getIntValue() |
    e.(MulExpr).getAnOperand() = c and factor = k.abs() and factor >= 2
    or
    e.(LShiftExpr).getRhs() = c and factor = 2.pow(k) and k > 0
    or
    e.(BitwiseAndExpr).getAnOperand() = c and factor = max(int f | andmaskFactor(k, f))
  )
}

/**
 * Holds if `inp` is an input to `phi` along `edge` and this input has index `r`
 * in an arbitrary 1-based numbering of the input edges to `phi`.
 */
private predicate rankedPhiInput(
  SsaPhiNode phi, SsaVariable inp, SsaReadPositionPhiInputEdge edge, int r
) {
  edge.phiInput(phi, inp) and
  edge =
    rank[r](SsaReadPositionPhiInputEdge e | e.phiInput(phi, _) | e order by getId(e.getOrigBlock()))
}

/**
 * Holds if `rix` is the number of input edges to `phi`.
 */
private predicate maxPhiInputRank(SsaPhiNode phi, int rix) {
  rix = max(int r | rankedPhiInput(phi, _, _, r))
}

/**
 * Gets the remainder of `val` modulo `mod`.
 *
 * For `mod = 0` the result equals `val` and for `mod > 1` the result is within
 * the range `[0 .. mod-1]`.
 */
bindingset[val, mod]
private int remainder(int val, int mod) {
  mod = 0 and result = val
  or
  mod > 1 and result = ((val % mod) + mod) % mod
}

/**
 * Holds if `inp` is an input to `phi` and equals `phi` modulo `mod` along `edge`.
 */
private predicate phiSelfModulus(
  SsaPhiNode phi, SsaVariable inp, SsaReadPositionPhiInputEdge edge, int mod
) {
  exists(SsaBound phibound, int v, int m |
    edge.phiInput(phi, inp) and
    phibound.getSsa() = phi and
    ssaModulus(inp, edge, phibound, v, m) and
    mod = m.gcd(v) and
    mod != 1
  )
}

/**
 * Holds if `b + val` modulo `mod` is a candidate congruence class for `phi`.
 */
private predicate phiModulusInit(SsaPhiNode phi, Bound b, int val, int mod) {
  exists(SsaVariable inp, SsaReadPositionPhiInputEdge edge |
    edge.phiInput(phi, inp) and
    ssaModulus(inp, edge, b, val, mod)
  )
}

/**
 * Holds if all inputs to `phi` numbered `1` to `rix` are equal to `b + val` modulo `mod`.
 */
private predicate phiModulusRankStep(SsaPhiNode phi, Bound b, int val, int mod, int rix) {
  rix = 0 and
  phiModulusInit(phi, b, val, mod)
  or
  exists(SsaVariable inp, SsaReadPositionPhiInputEdge edge, int v1, int m1 |
    mod != 1 and
    val = remainder(v1, mod)
  |
    exists(int v2, int m2 |
      rankedPhiInput(phi, inp, edge, rix) and
      phiModulusRankStep(phi, b, v1, m1, rix - 1) and
      ssaModulus(inp, edge, b, v2, m2) and
      mod = m1.gcd(m2).gcd(v1 - v2)
    )
    or
    exists(int m2 |
      rankedPhiInput(phi, inp, edge, rix) and
      phiModulusRankStep(phi, b, v1, m1, rix - 1) and
      phiSelfModulus(phi, inp, edge, m2) and
      mod = m1.gcd(m2)
    )
  )
}

/**
 * Holds if `phi` is equal to `b + val` modulo `mod`.
 */
private predicate phiModulus(SsaPhiNode phi, Bound b, int val, int mod) {
  exists(int r |
    maxPhiInputRank(phi, r) and
    phiModulusRankStep(phi, b, val, mod, r)
  )
}

/**
 * Holds if `v` at `pos` is equal to `b + val` modulo `mod`.
 */
private predicate ssaModulus(SsaVariable v, SsaReadPosition pos, Bound b, int val, int mod) {
  phiModulus(v, b, val, mod) and pos.hasReadOfVar(v)
  or
  b.(SsaBound).getSsa() = v and pos.hasReadOfVar(v) and val = 0 and mod = 0
  or
  exists(Expr e, int val0, int delta |
    exprModulus(e, b, val0, mod) and
    valueFlowStepSsa(v, pos, e, delta) and
    val = remainder(val0 + delta, mod)
  )
  or
  moduloGuardedRead(v, pos, val, mod) and b instanceof ZeroBound
}

/**
 * Holds if `e` is equal to `b + val` modulo `mod`.
 *
 * There are two cases for the modulus:
 * - `mod = 0`: The equality `e = b + val` is an ordinary equality.
 * - `mod > 1`: `val` lies within the range `[0 .. mod-1]`.
 */
cached
predicate exprModulus(Expr e, Bound b, int val, int mod) {
  e = b.getExpr(val) and mod = 0
  or
  evenlyDivisibleExpr(e, mod) and val = 0 and b instanceof ZeroBound
  or
  exists(SsaVariable v, SsaReadPositionBlock bb |
    ssaModulus(v, bb, b, val, mod) and
    e = v.getAUse() and
    getABasicBlockExpr(bb.getBlock()) = e
  )
  or
  exists(Expr mid, int val0, int delta |
    exprModulus(mid, b, val0, mod) and
    valueFlowStep(e, mid, delta) and
    val = remainder(val0 + delta, mod)
  )
  or
  exists(ConditionalExpr cond, int v1, int v2, int m1, int m2 |
    cond = e and
    condExprBranchModulus(cond, true, b, v1, m1) and
    condExprBranchModulus(cond, false, b, v2, m2) and
    mod = m1.gcd(m2).gcd(v1 - v2) and
    mod != 1 and
    val = remainder(v1, mod)
  )
  or
  exists(Bound b1, Bound b2, int v1, int v2, int m1, int m2 |
    addModulus(e, true, b1, v1, m1) and
    addModulus(e, false, b2, v2, m2) and
    mod = m1.gcd(m2) and
    mod != 1 and
    val = remainder(v1 + v2, mod)
  |
    b = b1 and b2 instanceof ZeroBound
    or
    b = b2 and b1 instanceof ZeroBound
  )
  or
  exists(int v1, int v2, int m1, int m2 |
    subModulus(e, true, b, v1, m1) and
    subModulus(e, false, any(ZeroBound zb), v2, m2) and
    mod = m1.gcd(m2) and
    mod != 1 and
    val = remainder(v1 - v2, mod)
  )
}

private predicate condExprBranchModulus(
  ConditionalExpr cond, boolean branch, Bound b, int val, int mod
) {
  exprModulus(cond.getTrueExpr(), b, val, mod) and branch = true
  or
  exprModulus(cond.getFalseExpr(), b, val, mod) and branch = false
}

private predicate addModulus(Expr add, boolean isLeft, Bound b, int val, int mod) {
  exists(Expr larg, Expr rarg | nonConstAddition(add, larg, rarg) |
    exprModulus(larg, b, val, mod) and isLeft = true
    or
    exprModulus(rarg, b, val, mod) and isLeft = false
  )
}

private predicate subModulus(Expr sub, boolean isLeft, Bound b, int val, int mod) {
  exists(Expr larg, Expr rarg | nonConstSubtraction(sub, larg, rarg) |
    exprModulus(larg, b, val, mod) and isLeft = true
    or
    exprModulus(rarg, b, val, mod) and isLeft = false
  )
}
