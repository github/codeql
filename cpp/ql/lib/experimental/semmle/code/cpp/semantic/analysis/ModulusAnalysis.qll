/**
 * Provides inferences of the form: `e` equals `b + v` modulo `m` where `e` is
 * an expression, `b` is a `Bound` (typically zero or the value of an SSA
 * variable), and `v` is an integer in the range `[0 .. m-1]`.
 */

private import ModulusAnalysisSpecific::Private
private import experimental.semmle.code.cpp.semantic.Semantic
private import ConstantAnalysis
private import RangeUtils

/**
 * Holds if `e + delta` equals `v` at `pos`.
 */
private predicate valueFlowStepSsa(SemSsaVariable v, SemSsaReadPosition pos, SemExpr e, int delta) {
  semSsaUpdateStep(v, e, delta) and pos.hasReadOfVar(v)
  or
  exists(SemGuard guard, boolean testIsTrue |
    pos.hasReadOfVar(v) and
    guard = semEqFlowCond(v, e, delta, true, testIsTrue) and
    semGuardDirectlyControlsSsaRead(guard, pos, testIsTrue)
  )
}

/**
 * Holds if `add` is the addition of `larg` and `rarg`, neither of which are
 * `ConstantIntegerExpr`s.
 */
private predicate nonConstAddition(SemExpr add, SemExpr larg, SemExpr rarg) {
  exists(SemAddExpr a | a = add |
    larg = a.getLeftOperand() and
    rarg = a.getRightOperand()
  ) and
  not larg instanceof SemConstantIntegerExpr and
  not rarg instanceof SemConstantIntegerExpr
}

/**
 * Holds if `sub` is the subtraction of `larg` and `rarg`, where `rarg` is not
 * a `ConstantIntegerExpr`.
 */
private predicate nonConstSubtraction(SemExpr sub, SemExpr larg, SemExpr rarg) {
  exists(SemSubExpr s | s = sub |
    larg = s.getLeftOperand() and
    rarg = s.getRightOperand()
  ) and
  not rarg instanceof SemConstantIntegerExpr
}

/** Gets an expression that is the remainder modulo `mod` of `arg`. */
private SemExpr modExpr(SemExpr arg, int mod) {
  exists(SemRemExpr rem |
    result = rem and
    arg = rem.getLeftOperand() and
    rem.getRightOperand().(SemConstantIntegerExpr).getIntValue() = mod and
    mod >= 2
  )
  or
  exists(SemConstantIntegerExpr c |
    mod = 2.pow([1 .. 30]) and
    c.getIntValue() = mod - 1 and
    result.(SemBitAndExpr).hasOperands(arg, c)
  )
}

/**
 * Gets a guard that tests whether `v` is congruent with `val` modulo `mod` on
 * its `testIsTrue` branch.
 */
private SemGuard moduloCheck(SemSsaVariable v, int val, int mod, boolean testIsTrue) {
  exists(SemExpr rem, SemConstantIntegerExpr c, int r, boolean polarity |
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
private predicate moduloGuardedRead(SemSsaVariable v, SemSsaReadPosition pos, int val, int mod) {
  exists(SemGuard guard, boolean testIsTrue |
    pos.hasReadOfVar(v) and
    guard = moduloCheck(v, val, mod, testIsTrue) and
    semGuardControlsSsaRead(guard, pos, testIsTrue)
  )
}

/** Holds if `factor` is a power of 2 that divides `mask`. */
bindingset[mask]
private predicate andmaskFactor(int mask, int factor) {
  mask % factor = 0 and
  factor = 2.pow([1 .. 30])
}

/** Holds if `e` is evenly divisible by `factor`. */
private predicate evenlyDivisibleExpr(SemExpr e, int factor) {
  exists(SemConstantIntegerExpr c, int k | k = c.getIntValue() |
    e.(SemMulExpr).getAnOperand() = c and factor = k.abs() and factor >= 2
    or
    e.(SemShiftLeftExpr).getRightOperand() = c and factor = 2.pow(k) and k > 0
    or
    e.(SemBitAndExpr).getAnOperand() = c and factor = max(int f | andmaskFactor(k, f))
  )
}

/**
 * Holds if `rix` is the number of input edges to `phi`.
 */
private predicate maxPhiInputRank(SemSsaPhiNode phi, int rix) {
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
  SemSsaPhiNode phi, SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge, int mod
) {
  exists(SemSsaBound phibound, int v, int m |
    edge.phiInput(phi, inp) and
    phibound.getAVariable() = phi and
    ssaModulus(inp, edge, phibound, v, m) and
    mod = m.gcd(v) and
    mod != 1
  )
}

/**
 * Holds if `b + val` modulo `mod` is a candidate congruence class for `phi`.
 */
private predicate phiModulusInit(SemSsaPhiNode phi, SemBound b, int val, int mod) {
  exists(SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge |
    edge.phiInput(phi, inp) and
    ssaModulus(inp, edge, b, val, mod)
  )
}

/**
 * Holds if all inputs to `phi` numbered `1` to `rix` are equal to `b + val` modulo `mod`.
 */
private predicate phiModulusRankStep(SemSsaPhiNode phi, SemBound b, int val, int mod, int rix) {
  rix = 0 and
  phiModulusInit(phi, b, val, mod)
  or
  exists(SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge, int v1, int m1 |
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
private predicate phiModulus(SemSsaPhiNode phi, SemBound b, int val, int mod) {
  exists(int r |
    maxPhiInputRank(phi, r) and
    phiModulusRankStep(phi, b, val, mod, r)
  )
}

/**
 * Holds if `v` at `pos` is equal to `b + val` modulo `mod`.
 */
private predicate ssaModulus(SemSsaVariable v, SemSsaReadPosition pos, SemBound b, int val, int mod) {
  phiModulus(v, b, val, mod) and pos.hasReadOfVar(v)
  or
  b.(SemSsaBound).getAVariable() = v and pos.hasReadOfVar(v) and val = 0 and mod = 0
  or
  exists(SemExpr e, int val0, int delta |
    semExprModulus(e, b, val0, mod) and
    valueFlowStepSsa(v, pos, e, delta) and
    val = remainder(val0 + delta, mod)
  )
  or
  moduloGuardedRead(v, pos, val, mod) and b instanceof SemZeroBound
}

/**
 * Holds if `e` is equal to `b + val` modulo `mod`.
 *
 * There are two cases for the modulus:
 * - `mod = 0`: The equality `e = b + val` is an ordinary equality.
 * - `mod > 1`: `val` lies within the range `[0 .. mod-1]`.
 */
cached
predicate semExprModulus(SemExpr e, SemBound b, int val, int mod) {
  not ignoreExprModulus(e) and
  (
    e = b.getExpr(val) and mod = 0
    or
    evenlyDivisibleExpr(e, mod) and
    val = 0 and
    b instanceof SemZeroBound
    or
    exists(SemSsaVariable v, SemSsaReadPositionBlock bb |
      ssaModulus(v, bb, b, val, mod) and
      e = v.getAUse() and
      bb.getAnExpr() = e
    )
    or
    exists(SemExpr mid, int val0, int delta |
      semExprModulus(mid, b, val0, mod) and
      semValueFlowStep(e, mid, delta) and
      val = remainder(val0 + delta, mod)
    )
    or
    exists(SemConditionalExpr cond, int v1, int v2, int m1, int m2 |
      cond = e and
      condExprBranchModulus(cond, true, b, v1, m1) and
      condExprBranchModulus(cond, false, b, v2, m2) and
      mod = m1.gcd(m2).gcd(v1 - v2) and
      mod != 1 and
      val = remainder(v1, mod)
    )
    or
    exists(SemBound b1, SemBound b2, int v1, int v2, int m1, int m2 |
      addModulus(e, true, b1, v1, m1) and
      addModulus(e, false, b2, v2, m2) and
      mod = m1.gcd(m2) and
      mod != 1 and
      val = remainder(v1 + v2, mod)
    |
      b = b1 and b2 instanceof SemZeroBound
      or
      b = b2 and b1 instanceof SemZeroBound
    )
    or
    exists(int v1, int v2, int m1, int m2 |
      subModulus(e, true, b, v1, m1) and
      subModulus(e, false, any(SemZeroBound zb), v2, m2) and
      mod = m1.gcd(m2) and
      mod != 1 and
      val = remainder(v1 - v2, mod)
    )
  )
}

private predicate condExprBranchModulus(
  SemConditionalExpr cond, boolean branch, SemBound b, int val, int mod
) {
  semExprModulus(cond.getBranchExpr(branch), b, val, mod)
}

private predicate addModulus(SemExpr add, boolean isLeft, SemBound b, int val, int mod) {
  exists(SemExpr larg, SemExpr rarg | nonConstAddition(add, larg, rarg) |
    semExprModulus(larg, b, val, mod) and isLeft = true
    or
    semExprModulus(rarg, b, val, mod) and isLeft = false
  )
}

private predicate subModulus(SemExpr sub, boolean isLeft, SemBound b, int val, int mod) {
  exists(SemExpr larg, SemExpr rarg | nonConstSubtraction(sub, larg, rarg) |
    semExprModulus(larg, b, val, mod) and isLeft = true
    or
    semExprModulus(rarg, b, val, mod) and isLeft = false
  )
}

/**
 * Holds if `inp` is an input to `phi` along `edge` and this input has index `r`
 * in an arbitrary 1-based numbering of the input edges to `phi`.
 */
private predicate rankedPhiInput(
  SemSsaPhiNode phi, SemSsaVariable inp, SemSsaReadPositionPhiInputEdge edge, int r
) {
  edge.phiInput(phi, inp) and
  edge =
    rank[r](SemSsaReadPositionPhiInputEdge e |
      e.phiInput(phi, _)
    |
      e order by e.getOrigBlock().getUniqueId()
    )
}
