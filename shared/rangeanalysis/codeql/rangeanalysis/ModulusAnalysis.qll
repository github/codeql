/**
 * Provides inferences of the form: `e` equals `b + v` modulo `m` where `e` is
 * an expression, `b` is a `Bound` (typically zero or the value of an SSA
 * variable), and `v` is an integer in the range `[0 .. m-1]`.
 */

/*
 * The main recursion has base cases in both `ssaModulus` (for guarded reads) and `exprModulus`
 * (for constant values). The most interesting recursive case is `phiModulusRankStep`, which
 * handles phi inputs.
 */

private import codeql.util.Location
private import RangeAnalysis

module ModulusAnalysis<
  LocationSig Location, Semantic<Location> Sem, DeltaSig D, BoundSig<Location, Sem, D> Bounds>
{
  private import internal.RangeUtils::MakeUtils<Location, Sem, D>

  bindingset[pos, v]
  pragma[inline_late]
  private predicate hasReadOfVarInlineLate(SsaReadPosition pos, Sem::SsaVariable v) {
    pos.hasReadOfVar(v)
  }

  /**
   * Holds if `e + delta` equals `v` at `pos`.
   */
  pragma[nomagic]
  private predicate valueFlowStepSsa(Sem::SsaVariable v, SsaReadPosition pos, Sem::Expr e, int delta) {
    ssaUpdateStep(v, e, D::fromInt(delta)) and pos.hasReadOfVar(v)
    or
    exists(Sem::Guard guard, boolean testIsTrue |
      hasReadOfVarInlineLate(pos, v) and
      guard = eqFlowCond(v, e, D::fromInt(delta), true, testIsTrue) and
      guardDirectlyControlsSsaRead(guard, pos, testIsTrue)
    )
  }

  /**
   * Holds if `add` is the addition of `larg` and `rarg`, neither of which are
   * `ConstantIntegerExpr`s.
   */
  private predicate nonConstAddition(Sem::Expr add, Sem::Expr larg, Sem::Expr rarg) {
    exists(Sem::AddExpr a | a = add |
      larg = a.getLeftOperand() and
      rarg = a.getRightOperand()
    ) and
    not larg instanceof Sem::ConstantIntegerExpr and
    not rarg instanceof Sem::ConstantIntegerExpr
  }

  /**
   * Holds if `sub` is the subtraction of `larg` and `rarg`, where `rarg` is not
   * a `ConstantIntegerExpr`.
   */
  private predicate nonConstSubtraction(Sem::Expr sub, Sem::Expr larg, Sem::Expr rarg) {
    exists(Sem::SubExpr s | s = sub |
      larg = s.getLeftOperand() and
      rarg = s.getRightOperand()
    ) and
    not rarg instanceof Sem::ConstantIntegerExpr
  }

  /** Gets an expression that is the remainder modulo `mod` of `arg`. */
  private Sem::Expr modExpr(Sem::Expr arg, int mod) {
    exists(Sem::RemExpr rem |
      result = rem and
      arg = rem.getLeftOperand() and
      rem.getRightOperand().(Sem::ConstantIntegerExpr).getIntValue() = mod and
      mod >= 2
    )
    or
    exists(Sem::ConstantIntegerExpr c |
      mod = 2.pow([1 .. 30]) and
      c.getIntValue() = mod - 1 and
      result.(Sem::BitAndExpr).hasOperands(arg, c)
    )
  }

  /**
   * Gets a guard that tests whether `v` is congruent with `val` modulo `mod` on
   * its `testIsTrue` branch.
   */
  private Sem::Guard moduloCheck(Sem::SsaVariable v, int val, int mod, boolean testIsTrue) {
    exists(Sem::Expr rem, Sem::ConstantIntegerExpr c, int r, boolean polarity |
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
  private predicate moduloGuardedRead(Sem::SsaVariable v, SsaReadPosition pos, int val, int mod) {
    exists(Sem::Guard guard, boolean testIsTrue |
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
  private predicate evenlyDivisibleExpr(Sem::Expr e, int factor) {
    exists(Sem::ConstantIntegerExpr c, int k | k = c.getIntValue() |
      e.(Sem::MulExpr).getAnOperand() = c and factor = k.abs() and factor >= 2
      or
      e.(Sem::ShiftLeftExpr).getRightOperand() = c and factor = 2.pow(k) and k > 0
      or
      e.(Sem::BitAndExpr).getAnOperand() = c and factor = max(int f | andmaskFactor(k, f))
    )
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
    Sem::SsaPhiNode phi, Sem::SsaVariable inp, SsaReadPositionPhiInputEdge edge, int mod
  ) {
    exists(Bounds::SemSsaBound phibound, int v, int m |
      edge.phiInput(phi, inp) and
      phibound.getVariable() = phi and
      ssaModulus(inp, edge, phibound, v, m) and
      mod = m.gcd(v) and
      mod != 1
    )
  }

  /**
   * Holds if `b + val` modulo `mod` is a candidate congruence class for `phi`.
   */
  private predicate phiModulusInit(Sem::SsaPhiNode phi, Bounds::SemBound b, int val, int mod) {
    exists(Sem::SsaVariable inp, SsaReadPositionPhiInputEdge edge |
      edge.phiInput(phi, inp) and
      ssaModulus(inp, edge, b, val, mod)
    )
  }

  /**
   * Holds if all inputs to `phi` numbered `1` to `rix` are equal to `b + val` modulo `mod`.
   */
  pragma[nomagic]
  private predicate phiModulusRankStep(
    Sem::SsaPhiNode phi, Bounds::SemBound b, int val, int mod, int rix
  ) {
    // Base case. If any phi input is equal to `b + val` modulo `mod`, that's a
    // potential congruence class for the phi node.
    rix = 0 and
    phiModulusInit(phi, b, val, mod)
    or
    exists(Sem::SsaVariable inp, SsaReadPositionPhiInputEdge edge, int v1, int m1 |
      mod != 1 and
      val = remainder(v1, mod)
    |
      // Recursive case. If `inp` = `b + v2` modulo `m2`, we combine that with
      // the preceding potential congruence class `b + v1` modulo `m1`. In order
      // to represent the result as a single congruence class `b + v` modulo
      // `mod`, we must have that `mod` divides both `m1` and `m2` and that `v1`
      // equals `v2` modulo `mod`. The largest value of `mod` that satisfies
      // this is the greatest common divisor of `m1`, `m2`, and `v1 - v2`.
      exists(int v2, int m2 |
        rankedPhiInput(phi, inp, edge, rix) and
        phiModulusRankStep(phi, b, v1, m1, rix - 1) and
        ssaModulus(inp, edge, b, v2, m2) and
        mod = m1.gcd(m2).gcd(v1 - v2)
      )
      or
      // Recursive case. If `inp` = `phi` mod `m2`, we combine that with the
      // preceding potential congruence class `b + v1` mod `m1`. The result will be
      // the congruence class modulo the greatest common divisor of `m1` and `m2`.
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
  private predicate phiModulus(Sem::SsaPhiNode phi, Bounds::SemBound b, int val, int mod) {
    exists(int r |
      maxPhiInputRank(phi, r) and
      phiModulusRankStep(phi, b, val, mod, r)
    )
  }

  /**
   * Holds if `v` at `pos` is equal to `b + val` modulo `mod`.
   */
  private predicate ssaModulus(
    Sem::SsaVariable v, SsaReadPosition pos, Bounds::SemBound b, int val, int mod
  ) {
    phiModulus(v, b, val, mod) and pos.hasReadOfVar(v)
    or
    b.(Bounds::SemSsaBound).getVariable() = v and pos.hasReadOfVar(v) and val = 0 and mod = 0
    or
    exists(Sem::Expr e, int val0, int delta |
      exprModulus(e, b, val0, mod) and
      valueFlowStepSsa(v, pos, e, delta) and
      val = remainder(val0 + delta, mod)
    )
    or
    moduloGuardedRead(v, pos, val, mod) and b instanceof Bounds::SemZeroBound
  }

  /**
   * Holds if `e` is equal to `b + val` modulo `mod`.
   *
   * There are two cases for the modulus:
   * - `mod = 0`: The equality `e = b + val` is an ordinary equality.
   * - `mod > 1`: `val` lies within the range `[0 .. mod-1]`.
   */
  cached
  predicate exprModulus(Sem::Expr e, Bounds::SemBound b, int val, int mod) {
    e = b.getExpr(D::fromInt(val)) and mod = 0
    or
    evenlyDivisibleExpr(e, mod) and
    val = 0 and
    b instanceof Bounds::SemZeroBound
    or
    exists(Sem::SsaVariable v, SsaReadPositionBlock bb |
      ssaModulus(v, bb, b, val, mod) and
      bb.getAnSsaRead(v) = e
    )
    or
    exists(Sem::Expr mid, int val0, int delta |
      exprModulus(mid, b, val0, mod) and
      valueFlowStep(e, mid, D::fromInt(delta)) and
      val = remainder(val0 + delta, mod)
    )
    or
    exists(Sem::Expr mid, int v, int m1, int m2 |
      exprModulus(mid, b, v, m1) and
      e = modExpr(mid, m2) and
      mod = m1.gcd(m2) and
      mod != 1 and
      val = remainder(v, mod)
    )
    or
    exists(Sem::ConditionalExpr cond, int v1, int v2, int m1, int m2 |
      cond = e and
      condExprBranchModulus(cond, true, b, v1, m1) and
      condExprBranchModulus(cond, false, b, v2, m2) and
      mod = m1.gcd(m2).gcd(v1 - v2) and
      mod != 1 and
      val = remainder(v1, mod)
    )
    or
    exists(Bounds::SemBound b1, Bounds::SemBound b2, int v1, int v2, int m1, int m2 |
      addModulus(e, true, b1, v1, m1) and
      addModulus(e, false, b2, v2, m2) and
      mod = m1.gcd(m2) and
      mod != 1 and
      val = remainder(v1 + v2, mod)
    |
      b = b1 and b2 instanceof Bounds::SemZeroBound
      or
      b = b2 and b1 instanceof Bounds::SemZeroBound
    )
    or
    exists(int v1, int v2, int m1, int m2 |
      subModulus(e, true, b, v1, m1) and
      subModulus(e, false, any(Bounds::SemZeroBound zb), v2, m2) and
      mod = m1.gcd(m2) and
      mod != 1 and
      val = remainder(v1 - v2, mod)
    )
  }

  private predicate condExprBranchModulus(
    Sem::ConditionalExpr cond, boolean branch, Bounds::SemBound b, int val, int mod
  ) {
    exprModulus(cond.getBranchExpr(branch), b, val, mod)
  }

  private predicate addModulus(Sem::Expr add, boolean isLeft, Bounds::SemBound b, int val, int mod) {
    exists(Sem::Expr larg, Sem::Expr rarg | nonConstAddition(add, larg, rarg) |
      exprModulus(larg, b, val, mod) and isLeft = true
      or
      exprModulus(rarg, b, val, mod) and isLeft = false
    )
  }

  private predicate subModulus(Sem::Expr sub, boolean isLeft, Bounds::SemBound b, int val, int mod) {
    exists(Sem::Expr larg, Sem::Expr rarg | nonConstSubtraction(sub, larg, rarg) |
      exprModulus(larg, b, val, mod) and isLeft = true
      or
      exprModulus(rarg, b, val, mod) and isLeft = false
    )
  }
}
