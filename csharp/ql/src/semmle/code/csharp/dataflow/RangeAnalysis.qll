import csharp
import Ssa
import Bound
import SignAnalysis
import semmle.code.csharp.dataflow.internal.rangeanalysis.SsaReadPositionCommon
import semmle.code.csharp.dataflow.internal.rangeanalysis.ConstantUtils
import semmle.code.csharp.dataflow.internal.rangeanalysis.SsaUtils
import semmle.code.csharp.dataflow.internal.rangeanalysis.SignAnalysisSpecific::Private as SignPrivate
import semmle.code.csharp.controlflow.Guards as G
import semmle.code.csharp.commons.ComparisonTest

private module RangeAnalysisCache {
  cached
  module RangeAnalysisPublic {
    /**
     * Holds if `b + delta` is a valid bound for `e`.
     * - `upper = true`  : `e <= b + delta`
     * - `upper = false` : `e >= b + delta`
     */
    cached
    predicate bounded(Expr e, Bound b, int delta, boolean upper) {
      bounded(e, b, delta, upper, _, _) and
      bestBound(e, b, delta, upper)
    }
  }

  /**
   * Holds if `guard = boundFlowCond(_, _, _, _, _) or guard = eqFlowCond(_, _, _, _, _)`.
   */
  cached
  predicate possibleReason(G::Guard guard) {
    guard = boundFlowCond(_, _, _, _, _) or guard = eqFlowCond(_, _, _, _, _)
  }
}

private import RangeAnalysisCache
import RangeAnalysisPublic

/**
 * Holds if `b + delta` is a valid bound for `e` and this is the best such delta.
 * - `upper = true`  : `e <= b + delta`
 * - `upper = false` : `e >= b + delta`
 */
private predicate bestBound(Expr e, Bound b, int delta, boolean upper) {
  delta = min(int d | bounded(e, b, d, upper, _, _)) and upper = true
  or
  delta = max(int d | bounded(e, b, d, upper, _, _)) and upper = false
}

/**
 * Holds if `comp` corresponds to:
 * - `upper = true`  : `v <= e + delta` or `v < e + delta`
 * - `upper = false` : `v >= e + delta` or `v > e + delta`
 */
private predicate boundCondition(
  RelationalOperation comp, Definition v, Expr e, int delta, boolean upper
) {
  comp.getLesserOperand() = ssaRead(v, delta) and e = comp.getGreaterOperand() and upper = true
  or
  comp.getGreaterOperand() = ssaRead(v, delta) and e = comp.getLesserOperand() and upper = false
  // todo: other cases: // (v - d) - e < c, ...
}

/**
 * Gets a condition that tests whether `v` equals `e + delta`.
 *
 * If the condition evaluates to `testIsTrue`:
 * - `isEq = true`  : `v == e + delta`
 * - `isEq = false` : `v != e + delta`
 */
G::Guard eqFlowCond(Definition v, Expr e, int delta, boolean isEq, boolean testIsTrue) {
  exists(boolean eqpolarity |
    result.isEquality(ssaRead(v, delta), e, eqpolarity) and
    (testIsTrue = true or testIsTrue = false) and
    eqpolarity.booleanXor(testIsTrue).booleanNot() = isEq
  )
  or
  exists(
    boolean testIsTrue0, G::AbstractValues::BooleanValue b0, G::AbstractValues::BooleanValue b1
  |
    b1.getValue() = testIsTrue and b0.getValue() = testIsTrue0
  |
    G::Internal::impliesSteps(result, b1, eqFlowCond(v, e, delta, isEq, testIsTrue0), b0)
  )
}

/**
 * Gets a condition that tests whether `v` is bounded by `e + delta`.
 *
 * If the condition evaluates to `testIsTrue`:
 * - `upper = true`  : `v <= e + delta`
 * - `upper = false` : `v >= e + delta`
 */
private G::Guard boundFlowCond(Definition v, Expr e, int delta, boolean upper, boolean testIsTrue) {
  exists(
    RelationalOperation comp, int d1, int d3, int strengthen, boolean compIsUpper,
    boolean resultIsStrict
  |
    result = comp and
    boundCondition(comp, v, e, d1, compIsUpper) and
    (testIsTrue = true or testIsTrue = false) and
    upper = compIsUpper.booleanXor(testIsTrue.booleanNot()) and
    (
      if comp.isStrict()
      then resultIsStrict = testIsTrue
      else resultIsStrict = testIsTrue.booleanNot()
    ) and
    (
      if v.getSourceVariable().getType() instanceof IntegralType // what else could it be?
      then
        upper = true and strengthen = -1
        or
        upper = false and strengthen = 1
      else strengthen = 0
    ) and
    // A strict inequality `x < y` can be strengthened to `x <= y - 1`.
    (
      resultIsStrict = true and d3 = strengthen
      or
      resultIsStrict = false and d3 = 0
    ) and
    delta = d1 + d3
  )
  or
  exists(
    boolean testIsTrue0, G::AbstractValues::BooleanValue b0, G::AbstractValues::BooleanValue b1
  |
    b1.getValue() = testIsTrue and b0.getValue() = testIsTrue0
  |
    G::Internal::impliesSteps(result, b1, boundFlowCond(v, e, delta, upper, testIsTrue0), b0)
  )
  or
  result = eqFlowCond(v, e, delta, true, testIsTrue) and
  (upper = true or upper = false)
}

/**
 * Holds if `e + delta` is a valid bound for `v` at `pos`.
 * - `upper = true`  : `v <= e + delta`
 * - `upper = false` : `v >= e + delta`
 */
private predicate boundFlowStepSsa(
  Definition v, SsaReadPosition pos, Expr e, int delta, boolean upper
) {
  ssaUpdateStep(v, e, delta) and
  pos.hasReadOfVar(v) and
  (upper = true or upper = false)
  or
  exists(G::Guard guard, boolean testIsTrue |
    pos.hasReadOfVar(v) and
    guard = boundFlowCond(v, e, delta, upper, testIsTrue) and
    SignPrivate::guardControlsSsaRead(guard, pos, testIsTrue)
  )
}

/**
 * Holds if `v` is an `ExplicitDefinition` that equals `e + delta`.
 */
predicate ssaUpdateStep(ExplicitDefinition v, Expr e, int delta) {
  v.getADefinition().getExpr().(Assignment).getRValue() = e and delta = 0
  or
  v.getADefinition().getExpr().(PostIncrExpr).getOperand() = e and delta = 1
  or
  v.getADefinition().getExpr().(PreIncrExpr).getOperand() = e and delta = 1
  or
  v.getADefinition().getExpr().(PostDecrExpr).getOperand() = e and delta = -1
  or
  v.getADefinition().getExpr().(PreDecrExpr).getOperand() = e and delta = -1
  or
  v.getADefinition().getExpr().(AssignOperation) = e and delta = 0
}

/**
 * Holds if `b + delta` is a valid bound for `e`.
 * - `upper = true`  : `e <= b + delta`
 * - `upper = false` : `e >= b + delta`
 */
private predicate bounded(
  Expr e, Bound b, int delta, boolean upper, boolean fromBackEdge, int origdelta
) {
  e = b.getExpr(delta) and
  (upper = true or upper = false) and
  fromBackEdge = false and
  origdelta = delta
  or
  exists(Definition v, SsaReadPositionBlock bb |
    boundedSsa(v, bb, b, delta, upper, fromBackEdge, origdelta) and
    e = v.getARead() and
    bb.getBlock().getANode().getElement() = e
  )
  or
  exists(Expr mid, int d1, int d2 |
    boundFlowStep(e, mid, d1, upper) and
    // Constants have easy, base-case bounds, so let's not infer any recursive bounds.
    not e instanceof ConstantIntegerExpr and
    bounded(mid, b, d2, upper, fromBackEdge, origdelta) and
    // upper = true:  e <= mid + d1 <= b + d1 + d2 = b + delta
    // upper = false: e >= mid + d1 >= b + d1 + d2 = b + delta
    delta = d1 + d2
  )
  or
  exists(PhiNode phi |
    boundedPhi(phi, b, delta, upper, fromBackEdge, origdelta) and
    e = phi.getARead()
  )
  or
  exists(Expr mid, int factor, int d |
    boundFlowStepMul(e, mid, factor) and
    not e instanceof ConstantIntegerExpr and
    bounded(mid, b, d, upper, fromBackEdge, origdelta) and
    b instanceof ZeroBound and
    delta = d * factor
  )
  or
  exists(Expr mid, int factor, int d |
    boundFlowStepDiv(e, mid, factor) and
    not e instanceof ConstantIntegerExpr and
    bounded(mid, b, d, upper, fromBackEdge, origdelta) and
    b instanceof ZeroBound and
    d >= 0 and
    delta = d / factor
  )
  or
  exists(ConditionalExpr cond, int d1, int d2, boolean fbe1, boolean fbe2, int od1, int od2 |
    cond = e and
    boundedConditionalExpr(cond, b, upper, true, d1, fbe1, od1) and
    boundedConditionalExpr(cond, b, upper, false, d2, fbe2, od2) and
    (
      delta = d1 and fromBackEdge = fbe1 and origdelta = od1
      or
      delta = d2 and fromBackEdge = fbe2 and origdelta = od2
    )
  |
    upper = true and delta = d1.maximum(d2)
    or
    upper = false and delta = d1.minimum(d2)
  )
}

/**
 * Holds if `e1 + delta` equals `e2`.
 */
predicate valueFlowStep(Expr e2, Expr e1, int delta) {
  e2.(AssignExpr).getRValue() = e1 and delta = 0
  or
  e2.(UnaryPlusExpr).getOperand() = e1 and delta = 0
  or
  e2.(PostIncrExpr).getOperand() = e1 and delta = 0
  or
  e2.(PostDecrExpr).getOperand() = e1 and delta = 0
  or
  e2.(PreIncrExpr).getOperand() = e1 and delta = 1
  or
  e2.(PreDecrExpr).getOperand() = e1 and delta = -1
  or
  // exists(ArrayCreationExpr a |
  //   arrayLengthDef(e2, a) and
  //   a.getDimension(0) = e1 and
  //   delta = 0
  // )
  // or
  exists(Expr x |
    e2.(AddExpr).getAnOperand() = e1 and
    e2.(AddExpr).getAnOperand() = x and
    not e1 = x
    or
    exists(AssignAddExpr add | add = e2 |
      add.getLValue() = e1 and add.getRValue() = x
      or
      add.getLValue() = x and add.getRValue() = e1
    )
  |
    x.(ConstantIntegerExpr).getIntValue() = delta
  )
  or
  exists(Expr x |
    exists(SubExpr sub |
      e2 = sub and
      sub.getLeftOperand() = e1 and
      sub.getRightOperand() = x
    )
    or
    exists(AssignSubExpr sub |
      e2 = sub and
      sub.getLValue() = e1 and
      sub.getRValue() = x
    )
  |
    x.(ConstantIntegerExpr).getIntValue() = -delta
  )
}

/**
 * Holds if `e1 + delta` is a valid bound for `e2`.
 * - `upper = true`  : `e2 <= e1 + delta`
 * - `upper = false` : `e2 >= e1 + delta`
 */
private predicate boundFlowStep(Expr e2, Expr e1, int delta, boolean upper) {
  valueFlowStep(e2, e1, delta) and
  (upper = true or upper = false)
  or
  //   or
  //   e2.(SafeCastExpr).getExpr() = e1 and
  //   delta = 0 and
  //   (upper = true or upper = false)
  exists(Expr x |
    e2.(AddExpr).getAnOperand() = e1 and e2.(AddExpr).getAnOperand() = x and not e1 = x
    or
    exists(AssignAddExpr add | add = e2 |
      add.getLValue() = e1 and add.getRValue() = x
      or
      add.getLValue() = x and add.getRValue() = e1
    )
  |
    // `x instanceof ConstantIntegerExpr` is covered by valueFlowStep
    not x instanceof ConstantIntegerExpr and
    not e1 instanceof ConstantIntegerExpr and
    if strictlyPositiveIntegralExpr(x)
    then upper = false and delta = 1
    else
      if positive(x)
      then upper = false and delta = 0
      else
        if strictlyNegativeIntegralExpr(x)
        then upper = true and delta = -1
        else
          if negative(x)
          then upper = true and delta = 0
          else none()
  )
  or
  exists(Expr x |
    exists(SubExpr sub |
      e2 = sub and
      sub.getLeftOperand() = e1 and
      sub.getRightOperand() = x
    )
    or
    exists(AssignSubExpr sub |
      e2 = sub and
      sub.getLValue() = e1 and
      sub.getRValue() = x
    )
  |
    // `x instanceof ConstantIntegerExpr` is covered by valueFlowStep
    not x instanceof ConstantIntegerExpr and
    if strictlyPositiveIntegralExpr(x)
    then upper = true and delta = -1
    else
      if positive(x)
      then upper = true and delta = 0
      else
        if strictlyNegativeIntegralExpr(x)
        then upper = false and delta = 1
        else
          if negative(x)
          then upper = false and delta = 0
          else none()
  )
  or
  e2.(RemExpr).getRightOperand() = e1 and positive(e1) and delta = -1 and upper = true
  or
  e2.(RemExpr).getLeftOperand() = e1 and positive(e1) and delta = 0 and upper = true
  or
  e2.(AssignRemExpr).getRValue() = e1 and positive(e1) and delta = -1 and upper = true
  or
  e2.(AssignRemExpr).getLValue() = e1 and positive(e1) and delta = 0 and upper = true
  or
  e2.(BitwiseAndExpr).getAnOperand() = e1 and positive(e1) and delta = 0 and upper = true
  or
  e2.(AssignAndExpr).getRValue() = e1 and positive(e1) and delta = 0 and upper = true
  or
  e2.(BitwiseOrExpr).getAnOperand() = e1 and positive(e2) and delta = 0 and upper = false
  or
  e2.(AssignOrExpr).getRValue() = e1 and positive(e2) and delta = 0 and upper = false
  //or
  //   exists(MethodAccess ma, Method m |
  //     e2 = ma and
  //     ma.getMethod() = m and
  //     m.hasName("nextInt") and
  //     m.getDeclaringType().hasQualifiedName("java.util", "Random") and
  //     e1 = ma.getAnArgument() and
  //     delta = -1 and
  //     upper = true
  //   )
  //   or
  //   exists(MethodAccess ma, Method m |
  //     e2 = ma and
  //     ma.getMethod() = m and
  //     (
  //       m.hasName("max") and upper = false
  //       or
  //       m.hasName("min") and upper = true
  //     ) and
  //     m.getDeclaringType().hasQualifiedName("java.lang", "Math") and
  //     e1 = ma.getAnArgument() and
  //     delta = 0
  //  )
}

/** Holds if `e >= 1` as determined by sign analysis. */
private predicate strictlyPositiveIntegralExpr(Expr e) {
  strictlyPositive(e) and e.getType() instanceof IntegralType
}

/** Holds if `e <= -1` as determined by sign analysis. */
private predicate strictlyNegativeIntegralExpr(Expr e) {
  strictlyNegative(e) and e.getType() instanceof IntegralType
}

/**
 * Holds if `b + delta` is a valid bound for `v` at `pos`.
 * - `upper = true`  : `v <= b + delta`
 * - `upper = false` : `v >= b + delta`
 */
private predicate boundedSsa(
  Definition v, SsaReadPosition pos, Bound b, int delta, boolean upper, boolean fromBackEdge,
  int origdelta
) {
  exists(Expr mid, int d1, int d2 |
    boundFlowStepSsa(v, pos, mid, d1, upper) and
    bounded(mid, b, d2, upper, fromBackEdge, origdelta) and
    // upper = true:  v <= mid + d1 <= b + d1 + d2 = b + delta
    // upper = false: v >= mid + d1 >= b + d1 + d2 = b + delta
    delta = d1 + d2
  )
  or
  exists(int d |
    boundedSsa(v, pos, b, d, upper, fromBackEdge, origdelta) or
    boundedPhi(v, b, d, upper, fromBackEdge, origdelta)
  |
    unequalIntegralSsa(v, pos, b, d) and
    (
      upper = true and delta = d - 1
      or
      upper = false and delta = d + 1
    )
  )
}

private predicate boundedConditionalExpr(
  ConditionalExpr cond, Bound b, boolean upper, boolean branch, int delta, boolean fromBackEdge,
  int origdelta
) {
  branch = true and bounded(cond.getThen(), b, delta, upper, fromBackEdge, origdelta)
  or
  branch = false and bounded(cond.getElse(), b, delta, upper, fromBackEdge, origdelta)
}

/**
 * Holds if `v != b + delta` at `pos` and `v` is of integral type.
 */
private predicate unequalIntegralSsa(Definition v, SsaReadPosition pos, Bound b, int delta) {
  exists(Expr e, int d1, int d2 |
    unequalFlowStepIntegralSsa(v, pos, e, d1) and
    bounded(e, b, d2, true, _, _) and
    bounded(e, b, d2, false, _, _) and
    delta = d2 + d1
  )
}

/** Holds if `v != e + delta` at `pos` and `v` is of integral type. */
private predicate unequalFlowStepIntegralSsa(Definition v, SsaReadPosition pos, Expr e, int delta) {
  v.getSourceVariable().getType() instanceof IntegralType and
  exists(G::Guard guard, boolean testIsTrue |
    pos.hasReadOfVar(v) and
    guard = eqFlowCond(v, e, delta, false, testIsTrue) and
    SignPrivate::guardControlsSsaRead(guard, pos, testIsTrue)
  )
}

/** Holds if `e2 = e1 * factor` and `factor > 0`. */
private predicate boundFlowStepMul(Expr e2, Expr e1, int factor) {
  exists(ConstantIntegerExpr c, int k | k = c.getIntValue() and k > 0 |
    e2.(MulExpr).getAnOperand() = e1 and e2.(MulExpr).getAnOperand() = c and factor = k
    or
    exists(AssignMulExpr e | e = e2 and e.getLValue() = e1 and e.getRValue() = c and factor = k)
    or
    exists(AssignMulExpr e | e = e2 and e.getLValue() = c and e.getRValue() = e1 and factor = k)
    or
    exists(LShiftExpr e |
      e = e2 and e.getLeftOperand() = e1 and e.getRightOperand() = c and factor = 2.pow(k)
    )
    or
    exists(AssignLShiftExpr e |
      e = e2 and e.getLValue() = e1 and e.getRValue() = c and factor = 2.pow(k)
    )
  )
}

/**
 * Holds if `e2 = e1 / factor` and `factor > 0`.
 *
 * This conflates division, and right shift, and is
 * therefore only valid for non-negative numbers.
 */
private predicate boundFlowStepDiv(Expr e2, Expr e1, int factor) {
  exists(ConstantIntegerExpr c, int k | k = c.getIntValue() and k > 0 |
    exists(DivExpr e |
      e = e2 and e.getLeftOperand() = e1 and e.getRightOperand() = c and factor = k
    )
    or
    exists(AssignDivExpr e | e = e2 and e.getLValue() = e1 and e.getRValue() = c and factor = k)
    or
    exists(RShiftExpr e |
      e = e2 and e.getLeftOperand() = e1 and e.getRightOperand() = c and factor = 2.pow(k)
    )
    or
    exists(AssignRShiftExpr e |
      e = e2 and e.getLValue() = e1 and e.getRValue() = c and factor = 2.pow(k)
    )
  )
}

/**
 * Holds if `b + delta` is a valid bound for `phi`.
 * - `upper = true`  : `phi <= b + delta`
 * - `upper = false` : `phi >= b + delta`
 */
private predicate boundedPhi(
  PhiNode phi, Bound b, int delta, boolean upper, boolean fromBackEdge, int origdelta
) {
  forex(Definition inp, SsaReadPositionPhiInputEdge edge | edge.phiInput(phi, inp) |
    boundedPhiCandValidForEdge(phi, b, delta, upper, fromBackEdge, origdelta, inp, edge)
  )
}

/**
 * Holds if the candidate bound `b + delta` for `phi` is valid for the phi input
 * `inp` along `edge`.
 */
private predicate boundedPhiCandValidForEdge(
  PhiNode phi, Bound b, int delta, boolean upper, boolean fromBackEdge, int origdelta,
  Definition inp, SsaReadPositionPhiInputEdge edge
) {
  boundedPhiCand(phi, upper, b, delta, fromBackEdge, origdelta) and
  (
    exists(int d | boundedPhiInp1(phi, b, upper, inp, edge, d) | upper = true and d <= delta)
    or
    exists(int d | boundedPhiInp1(phi, b, upper, inp, edge, d) | upper = false and d >= delta)
    or
    selfBoundedPhiInp(phi, inp, edge, upper)
  )
}

/** Holds if `boundedPhiInp(phi, inp, edge, b, delta, upper, _, _, _)`. */
pragma[noinline]
private predicate boundedPhiInp1(
  PhiNode phi, Bound b, boolean upper, Definition inp, SsaReadPositionPhiInputEdge edge, int delta
) {
  boundedPhiInp(phi, inp, edge, b, delta, upper, _, _)
}

/**
 * Holds if `b + delta` is a valid bound for `inp` when used as an input to
 * `phi` along `edge`.
 * - `upper = true`  : `inp <= b + delta`
 * - `upper = false` : `inp >= b + delta`
 */
private predicate boundedPhiInp(
  PhiNode phi, Definition inp, SsaReadPositionPhiInputEdge edge, Bound b, int delta, boolean upper,
  boolean fromBackEdge, int origdelta
) {
  edge.phiInput(phi, inp) and
  exists(int d, boolean fromBackEdge0 |
    boundedSsa(inp, edge, b, d, upper, fromBackEdge0, origdelta)
    or
    boundedPhi(inp, b, d, upper, fromBackEdge0, origdelta)
    or
    b.(SsaBound).getSsa() = inp and
    d = 0 and
    (upper = true or upper = false) and
    fromBackEdge0 = false and
    origdelta = 0
  |
    if backEdge(phi, inp, edge)
    then
      fromBackEdge = true and
      (
        fromBackEdge0 = true and delta = weakenDelta(upper, d - origdelta) + origdelta
        or
        fromBackEdge0 = false and delta = d
      )
    else (
      delta = d and fromBackEdge = fromBackEdge0
    )
  )
}

/** Weakens a delta to lie in the range `[-1..1]`. */
bindingset[delta, upper]
private int weakenDelta(boolean upper, int delta) {
  delta in [-1 .. 1] and result = delta
  or
  upper = true and result = -1 and delta < -1
  or
  upper = false and result = 1 and delta > 1
}

/**
 * Holds if `b + delta` is a valid bound for some input, `inp`, to `phi`, and
 * thus a candidate bound for `phi`.
 * - `upper = true`  : `inp <= b + delta`
 * - `upper = false` : `inp >= b + delta`
 */
pragma[noinline]
private predicate boundedPhiCand(
  PhiNode phi, boolean upper, Bound b, int delta, boolean fromBackEdge, int origdelta
) {
  exists(Definition inp, SsaReadPositionPhiInputEdge edge |
    boundedPhiInp(phi, inp, edge, b, delta, upper, fromBackEdge, origdelta)
  )
}

/**
 * Holds if `inp` is an input to `phi` along a back edge.
 */
predicate backEdge(PhiNode phi, Definition inp, SsaReadPositionPhiInputEdge edge) {
  edge.phiInput(phi, inp) and
  // Conservatively assume that every edge is a back edge if we don't have dominance information.
  (
    phi.getBasicBlock().dominates(edge.getOrigBlock()) or
    not hasDominanceInformation(edge.getOrigBlock())
  )
}

/** Holds if the dominance relation is calculated for `bb`. */
predicate hasDominanceInformation(BasicBlock bb) {
  exists(BasicBlock entry | flowEntry(entry.getANode().getElement()) and bbSucc*(entry, bb))
}

/** Entry points for control-flow. */
private predicate flowEntry(Stmt entry) {
  exists(Callable c | entry = c.getBody())
  or
  // This disjunct is technically superfluous, but safeguards against extractor problems.
  entry instanceof BlockStmt and
  not exists(entry.getEnclosingCallable()) and
  not entry.getParent() instanceof Stmt
}

/** The successor relation for basic blocks. */
private predicate bbSucc(BasicBlock pre, BasicBlock post) { post = pre.getASuccessor() }

/**
 * Holds if `phi` is a valid bound for `inp` when used as an input to `phi`
 * along `edge`.
 * - `upper = true`  : `inp <= phi`
 * - `upper = false` : `inp >= phi`
 */
private predicate selfBoundedPhiInp(
  PhiNode phi, Definition inp, SsaReadPositionPhiInputEdge edge, boolean upper
) {
  exists(int d, SsaBound phibound |
    phibound.getSsa() = phi and
    boundedPhiInp(phi, inp, edge, phibound, d, upper, _, _) and
    (
      upper = true and d <= 0
      or
      upper = false and d >= 0
    )
  )
}
