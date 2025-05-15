/**
 * Provides classes and predicates for determining "guard-controls"
 * relationships.
 *
 * In their most general form, these relate a guard expression, a value, and a
 * basic block, and state that execution of the basic block implies that
 * control flow must have passed through the guard in order to reach the basic
 * block, and when it did, the guard evaluated to the given value.
 *
 * For example, in `if (x == 0) { A }`, the guard `x == 0` evaluating to `true`
 * controls the basic block `A`, in this case because the true branch dominates
 * `A`, but more elaborate controls-relationships may also hold.
 * For example, in
 * ```
 * int sz = a != null ? a.length : 0;
 * if (sz != 0) {
 *   // this block is controlled by:
 *   // sz != 0   evaluating to true
 *   // sz        evaluating to not 0
 *   // a.length  evaluating to not 0
 *   // a != null evaluating to true
 *   // a         evaluating to not null
 * }
 * ```
 *
 * The implementation is nested in two parameterized modules intended to
 * facilitate multiple instantiations of the nested module with different
 * precision levels
 */

private import codeql.util.Boolean
private import codeql.util.Location

signature module InputSig<LocationSig Location> {
  class SuccessorType {
    /** Gets a textual representation of this successor type. */
    string toString();
  }

  class ExceptionSuccessor extends SuccessorType;

  class ConditionalSuccessor extends SuccessorType {
    /** Gets the Boolean value of this successor. */
    boolean getValue();
  }

  class BooleanSuccessor extends ConditionalSuccessor;

  class NullnessSuccessor extends ConditionalSuccessor;

  /** A control flow node. */
  class ControlFlowNode {
    /** Gets a textual representation of this control flow node. */
    string toString();

    /** Gets the location of this control flow node. */
    Location getLocation();
  }

  /**
   * A basic block, that is, a maximal straight-line sequence of control flow nodes
   * without branches or joins.
   */
  class BasicBlock {
    /** Gets a textual representation of this basic block. */
    string toString();

    /** Gets the `i`th node in this basic block. */
    ControlFlowNode getNode(int i);

    /** Gets the last control flow node in this basic block. */
    ControlFlowNode getLastNode();

    /** Gets the length of this basic block. */
    int length();

    /** Gets the location of this basic block. */
    Location getLocation();

    BasicBlock getASuccessor(SuccessorType t);

    predicate dominates(BasicBlock bb);

    predicate strictlyDominates(BasicBlock bb);
  }

  predicate dominatingEdge(BasicBlock bb1, BasicBlock bb2);

  class Expr {
    /** Gets a textual representation of this expression. */
    string toString();

    /** Gets the location of this expression. */
    Location getLocation();

    /** Gets the associated control flow node. */
    ControlFlowNode getControlFlowNode();

    /** Gets the basic block containing this expression. */
    BasicBlock getBasicBlock();
  }

  class ConstantValue {
    /** Gets a textual representation of this constant value. */
    string toString();
  }

  class ConstantExpr extends Expr {
    predicate isNull();

    boolean asBooleanValue();

    int asIntegerValue();

    ConstantValue asConstantValue();
  }

  class NonNullExpr extends Expr;

  class Case {
    /** Gets a textual representation of this switch case. */
    string toString();

    Location getLocation();

    Expr getSwitchExpr();

    predicate isDefaultCase();

    ConstantExpr asConstantCase();

    predicate matchEdge(BasicBlock bb1, BasicBlock bb2);

    predicate nonMatchEdge(BasicBlock bb1, BasicBlock bb2);
  }

  class AndExpr extends Expr {
    /** Gets an operand of this expression. */
    Expr getAnOperand();
  }

  class OrExpr extends Expr {
    /** Gets an operand of this expression. */
    Expr getAnOperand();
  }

  class NotExpr extends Expr {
    /** Gets the operand of this expression. */
    Expr getOperand();
  }

  /**
   * An expression that has the same value as a specific sub-expression.
   *
   * For example, in Java, the assignment `x = rhs` has the same value as `rhs`.
   */
  class IdExpr extends Expr {
    Expr getEqualChildExpr();
  }

  class EqualityTest extends Expr {
    /** Gets an operand of this expression. */
    Expr getAnOperand();

    /** Gets a boolean indicating whether this test is equality (true) or inequality (false). */
    boolean polarity();
  }

  class ConditionalExpr extends Expr {
    /** Gets the condition of this expression. */
    Expr getCondition();

    /** Gets the true branch of this expression. */
    Expr getThen();

    /** Gets the false branch of this expression. */
    Expr getElse();
  }
}

module Make<LocationSig Location, InputSig<Location> Input> {
  private import Input

  private newtype TAbstractSingleValue =
    TValueNull() or
    TValueTrue() or
    TValueInt(int i) { exists(ConstantExpr c | c.asIntegerValue() = i) or i = 0 } or
    TValueConstant(ConstantValue c) { exists(ConstantExpr ce | ce.asConstantValue() = c) }

  private newtype TGuardValue =
    TValue(TAbstractSingleValue val, Boolean isVal) or
    TCaseMatch(Case c, Boolean match) or
    TException(Boolean throws)

  private class AbstractSingleValue extends TAbstractSingleValue {
    /** Gets a textual representation of this value. */
    string toString() {
      result = "null" and this instanceof TValueNull
      or
      result = "true" and this instanceof TValueTrue
      or
      exists(int i | result = i.toString() and this = TValueInt(i))
      or
      exists(ConstantValue c | result = c.toString() and this = TValueConstant(c))
    }
  }

  /** An abstract value that a `Guard` may evaluate to. */
  class GuardValue extends TGuardValue {
    /**
     * Gets the dual value. Examples of dual values include:
     * - null vs. not null
     * - true vs. false
     * - evaluating to a specific value vs. evaluating to any other value
     * - matching a specific case vs. not matching that case
     */
    GuardValue getDualValue() {
      exists(AbstractSingleValue val, boolean isVal |
        this = TValue(val, isVal) and
        result = TValue(val, isVal.booleanNot())
      )
      or
      exists(Case c, boolean match |
        this = TCaseMatch(c, match) and
        result = TCaseMatch(c, match.booleanNot())
      )
      or
      exists(boolean throws |
        this = TException(throws) and
        result = TException(throws.booleanNot())
      )
    }

    /** Holds if this value represents `null`. */
    predicate isNullValue() { this = TValue(TValueNull(), true) }

    /** Gets the integer that this value represents, if any. */
    int asIntValue() { this = TValue(TValueInt(result), true) }

    /** Gets the boolean that this value represents, if any. */
    boolean asBooleanValue() { this = TValue(TValueTrue(), result) }

    /** Gets the constant that this value represents, if any. */
    ConstantValue asConstantValue() { this = TValue(TValueConstant(result), true) }

    /** Holds if this value represents throwing an exception. */
    predicate isThrowsException() { this = TException(true) }

    /** Gets a textual representation of this value. */
    string toString() {
      result = this.asBooleanValue().toString()
      or
      exists(AbstractSingleValue val | not val instanceof TValueTrue |
        this = TValue(val, true) and result = val.toString()
        or
        this = TValue(val, false) and result = "not " + val.toString()
      )
      or
      exists(Case c, boolean match, string s | this = TCaseMatch(c, match) |
        (
          exists(ConstantExpr ce | c.asConstantCase() = ce and s = ce.toString())
          or
          not exists(c.asConstantCase()) and s = c.toString()
        ) and
        (
          match = true and result = "match " + s
          or
          match = false and result = "non-match " + s
        )
      )
      or
      exists(boolean throws | this = TException(throws) |
        throws = true and result = "exception"
        or
        throws = false and result = "no exception"
      )
    }
  }

  bindingset[a, b]
  pragma[inline_late]
  private predicate disjointValues(GuardValue a, GuardValue b) {
    a = b.getDualValue()
    or
    exists(AbstractSingleValue a1, AbstractSingleValue b1 |
      a = TValue(a1, true) and
      b = TValue(b1, true) and
      a1 != b1
    )
  }

  private predicate constantHasValue(ConstantExpr c, GuardValue v) {
    c.isNull() and v = TValue(TValueNull(), true)
    or
    v = TValue(TValueTrue(), c.asBooleanValue())
    or
    v = TValue(TValueInt(c.asIntegerValue()), true)
    or
    v = TValue(TValueConstant(c.asConstantValue()), true)
  }

  private predicate exprHasValue(Expr e, GuardValue v) {
    constantHasValue(e, v)
    or
    e instanceof NonNullExpr and v = TValue(TValueNull(), false)
  }

  private predicate exceptionBranchPoint(BasicBlock bb1, BasicBlock normalSucc, BasicBlock excSucc) {
    exists(SuccessorType norm, ExceptionSuccessor exc |
      bb1.getASuccessor(norm) = normalSucc and
      bb1.getASuccessor(exc) = excSucc and
      normalSucc != excSucc and
      not norm instanceof ExceptionSuccessor
    )
  }

  private predicate branchEdge(BasicBlock bb1, BasicBlock bb2, GuardValue v) {
    exists(ConditionalSuccessor s |
      bb1.getASuccessor(s) = bb2 and
      exists(AbstractSingleValue val |
        s instanceof NullnessSuccessor and val = TValueNull()
        or
        s instanceof BooleanSuccessor and val = TValueTrue()
      |
        v = TValue(val, s.getValue())
      )
    )
    or
    exists(Case c |
      v = TCaseMatch(c, true) and
      c.matchEdge(bb1, bb2)
      or
      v = TCaseMatch(c, false) and
      c.nonMatchEdge(bb1, bb2)
    )
    or
    exceptionBranchPoint(bb1, bb2, _) and v = TException(false)
    or
    exceptionBranchPoint(bb1, _, bb2) and v = TException(true)
  }

  pragma[nomagic]
  private predicate eqtestHasOperands(EqualityTest eqtest, Expr e1, Expr e2, boolean polarity) {
    eqtest.getAnOperand() = e1 and
    eqtest.getAnOperand() = e2 and
    e1 != e2 and
    eqtest.polarity() = polarity
  }

  private predicate caseGuard(PreGuard g, Case c, Expr switchExpr) {
    g.hasValueBranchEdge(_, _, TCaseMatch(c, _)) and
    switchExpr = c.getSwitchExpr()
  }

  private predicate constcaseEquality(PreGuard g, Expr e1, ConstantExpr e2, GuardValue eqval) {
    exists(Case c |
      caseGuard(g, c, e1) and
      c.asConstantCase() = e2 and
      eqval = TCaseMatch(c, true)
    )
  }

  final private class ExprFinal = Expr;

  /**
   * A guard. This may be any expression whose value determines subsequent
   * control flow.
   */
  final class PreGuard extends ExprFinal {
    /**
     * Holds if this guard is the last node in `bb1` and that its successor is
     * `bb2` exactly when evaluating to `v`.
     */
    predicate hasValueBranchEdge(BasicBlock bb1, BasicBlock bb2, GuardValue v) {
      bb1.getLastNode() = this.getControlFlowNode() and
      branchEdge(bb1, bb2, v)
    }

    /**
     * Holds if this guard evaluating to `v` directly controls the basic block `bb`.
     *
     * That is, `bb` is dominated by the `v`-successor edge of this guard.
     */
    predicate directlyValueControls(BasicBlock bb, GuardValue v) {
      exists(BasicBlock guard, BasicBlock succ |
        this.hasValueBranchEdge(guard, succ, v) and
        dominatingEdge(guard, succ) and
        succ.dominates(bb)
      )
    }

    /**
     * Holds if this guard is the last node in `bb1` and that its successor is
     * `bb2` exactly when evaluating to `branch`.
     */
    predicate hasBranchEdge(BasicBlock bb1, BasicBlock bb2, boolean branch) {
      this.hasValueBranchEdge(bb1, bb2, TValue(TValueTrue(), branch))
    }

    /**
     * Holds if this guard evaluating to `branch` directly controls the basic
     * block `bb`.
     *
     * That is, `bb` is dominated by the `branch`-successor edge of this guard.
     */
    predicate directlyControls(BasicBlock bb, boolean branch) {
      this.directlyValueControls(bb, TValue(TValueTrue(), branch))
    }

    /**
     * Holds if this guard tests equality between `e1` and `e2` upon evaluating
     * to `eqval`.
     */
    predicate isEquality(Expr e1, Expr e2, GuardValue eqval) {
      eqtestHasOperands(this, e1, e2, eqval.asBooleanValue())
      or
      constcaseEquality(this, e1, e2, eqval)
      or
      constcaseEquality(this, e2, e1, eqval)
    }
  }

  private Expr getBranchExpr(ConditionalExpr cond, boolean branch) {
    branch = true and result = cond.getThen()
    or
    branch = false and result = cond.getElse()
  }

  bindingset[g1, v1]
  pragma[inline_late]
  private predicate unboundBaseImpliesStep(PreGuard g1, GuardValue v1, PreGuard g2, GuardValue v2) {
    g1.(IdExpr).getEqualChildExpr() = g2 and v1 = v2 and not v1 instanceof TException
    or
    exists(ConditionalExpr cond, boolean branch, Expr e, GuardValue ev |
      cond = g1 and
      e = getBranchExpr(cond, branch) and
      exprHasValue(e, ev) and
      disjointValues(v1, ev)
    |
      // g1 === g2 ? e : ...;
      // g1 === g2 ? ... : e;
      g2 = cond.getCondition() and
      v2 = TValue(TValueTrue(), branch.booleanNot())
      or
      // g1 === ... ? g2 : e
      // g1 === ... ? e : g2
      g2 = getBranchExpr(cond, branch.booleanNot()) and
      v2 = v1 and
      not exprHasValue(g2, v2) // disregard trivial guard
    )
  }

  private predicate baseImpliesStep(PreGuard g1, GuardValue v1, PreGuard g2, GuardValue v2) {
    g1.(AndExpr).getAnOperand() = g2 and v1 = TValue(TValueTrue(), true) and v2 = v1
    or
    g1.(OrExpr).getAnOperand() = g2 and v1 = TValue(TValueTrue(), false) and v2 = v1
    or
    g1.(NotExpr).getOperand() = g2 and v1.asBooleanValue().booleanNot() = v2.asBooleanValue()
    or
    exists(GuardValue eqval, ConstantExpr constant, GuardValue cv |
      g1.isEquality(g2, constant, eqval) and
      constantHasValue(constant, cv)
    |
      v1 = eqval and v2 = cv
      or
      v1 = eqval.getDualValue() and v2 = cv.getDualValue()
    )
    or
    exists(NonNullExpr nonnull |
      eqtestHasOperands(g1, g2, nonnull, v1.asBooleanValue()) and
      v2 = TValue(TValueNull(), false)
    )
    or
    exists(Case c1, Case c2, Expr switchExpr |
      caseGuard(g1, c1, switchExpr) and
      v1 = TCaseMatch(c1, true) and
      c1.isDefaultCase() and
      caseGuard(g2, c2, switchExpr) and
      v2 = TCaseMatch(c2, false) and
      c1 != c2
    )
  }

  signature module LogicInputSig {
    class SsaDefinition {
      /** Gets the basic block to which this SSA definition belongs. */
      BasicBlock getBasicBlock();

      Expr getARead();
    }

    class SsaWriteDefinition extends SsaDefinition {
      Expr getDefinition();
    }

    class SsaPhiNode extends SsaDefinition {
      /** Holds if `inp` is an input to the phi node along the edge originating in `bb`. */
      predicate hasInputFromBlock(SsaDefinition inp, BasicBlock bb);
    }

    /**
     * Holds if `guard` evaluating to `val` ensures that:
     * `e <= k` when `upper = true`
     * `e >= k` when `upper = false`
     */
    default predicate rangeGuard(PreGuard guard, GuardValue val, Expr e, int k, boolean upper) {
      none()
    }

    /**
     * Holds if `guard` evaluating to `val` ensures that:
     * `e == null` when `isNull = true`
     * `e != null` when `isNull = false`
     */
    default predicate additionalNullCheck(PreGuard guard, GuardValue val, Expr e, boolean isNull) {
      none()
    }

    /**
     * Holds if the assumption that `g1` has been evaluated to `v1` implies that
     * `g2` has been evaluated to `v2`, that is, the evaluation of `g2` to `v2`
     * dominates the evaluation of `g1` to `v1`.
     *
     * This predicate can be instantiated with `CustomGuard<..>::additionalImpliesStep`.
     */
    default predicate additionalImpliesStep(PreGuard g1, GuardValue v1, PreGuard g2, GuardValue v2) {
      none()
    }
  }

  module Logic<LogicInputSig LogicInput> {
    private import LogicInput

    private predicate guardControlsPhiBranch(
      Guard guard, GuardValue v, SsaPhiNode phi, Expr input, BasicBlock bbInput, BasicBlock bbPhi
    ) {
      exists(SsaWriteDefinition inp |
        phi.hasInputFromBlock(inp, bbInput) and
        phi.getBasicBlock() = bbPhi and
        inp.getDefinition() = input and
        guard.directlyValueControls(bbInput, v) and
        guard.getBasicBlock().strictlyDominates(bbPhi) and
        not guard.directlyValueControls(bbPhi, _)
      )
    }

    /**
     * Holds if `phi` takes `input` exactly when `guard` is `v`. That is,
     * `guard == v` directly controls `input` and `guard == v.getDualValue()`
     * directly controls all other inputs to `phi`.
     *
     * This makes `phi` similar to the conditional `phi = guard==v ? input : ...`.
     */
    private predicate guardDeterminesPhiInput(Guard guard, GuardValue v, SsaPhiNode phi, Expr input) {
      exists(GuardValue dv, BasicBlock bbInput, BasicBlock bbPhi |
        guardControlsPhiBranch(guard, v, phi, input, bbInput, bbPhi) and
        dv = v.getDualValue() and
        forall(BasicBlock other | phi.hasInputFromBlock(_, other) and other != bbInput |
          guard.directlyValueControls(other, dv)
          or
          guard.hasValueBranchEdge(other, bbPhi, dv)
        )
      )
    }

    pragma[nomagic]
    private predicate guardChecksEqualVars(
      Guard guard, SsaDefinition v1, SsaDefinition v2, boolean branch
    ) {
      eqtestHasOperands(guard, v1.getARead(), v2.getARead(), branch)
    }

    private predicate guardReadsSsaVar(Guard guard, SsaDefinition def) {
      def.getARead() = guard
      or
      exists(Guard eqtest, SsaDefinition other, boolean branch |
        guardChecksEqualVars(eqtest, def, other, branch) and
        other.getARead() = guard and
        eqtest.directlyControls(guard.getBasicBlock(), branch)
      )
    }

    private predicate valueStep(Expr e1, Expr e2) {
      e2.(ConditionalExpr).getThen() = e1 or
      e2.(ConditionalExpr).getElse() = e1 or
      e2.(IdExpr).getEqualChildExpr() = e1
    }

    /**
     * Gets a sub-expression of `e` whose value can flow to `e` through
     * `valueStep`s
     */
    private Expr possibleValue(Expr e) {
      result = possibleValue(any(Expr e1 | valueStep(e1, e)))
      or
      result = e and not valueStep(_, e)
    }

    /**
     * Gets an ultimate definition of `v` that is not itself a phi node. The
     * boolean `fromBackEdge` indicates whether the flow from `result` to `v` goes
     * through a back edge.
     */
    private SsaDefinition getADefinition(SsaDefinition v, boolean fromBackEdge) {
      result = v and not v instanceof SsaPhiNode and fromBackEdge = false
      or
      exists(SsaDefinition inp, BasicBlock bb, boolean fbe |
        v.(SsaPhiNode).hasInputFromBlock(inp, bb) and
        result = getADefinition(inp, fbe) and
        (if v.getBasicBlock().dominates(bb) then fromBackEdge = true else fromBackEdge = fbe)
      )
    }

    /**
     * Holds if `v` can have a value that is not representable as an `GuardValue`.
     */
    private predicate hasPossibleUnknownValue(SsaDefinition v) {
      exists(SsaDefinition def | def = getADefinition(v, _) |
        not exists(def.(SsaWriteDefinition).getDefinition())
        or
        exists(Expr e | e = possibleValue(def.(SsaWriteDefinition).getDefinition()) |
          not constantHasValue(e, _)
        )
      )
    }

    /**
     * Holds if `e` equals `k` and may be assigned to `v`. The boolean
     * `fromBackEdge` indicates whether the flow from `e` to `v` goes through a
     * back edge.
     */
    private predicate possibleValue(SsaDefinition v, boolean fromBackEdge, Expr e, GuardValue k) {
      not hasPossibleUnknownValue(v) and
      exists(SsaWriteDefinition def |
        def = getADefinition(v, fromBackEdge) and
        e = possibleValue(def.getDefinition()) and
        constantHasValue(e, k)
      )
    }

    /**
     * Holds if `e` equals `k` and may be assigned to `v` without going through
     * back edges, and all other possible ultimate definitions of `v` are different
     * from `k`. The trivial case where `v` is an `SsaWriteDefinition` with `e` as
     * the only possible value is excluded.
     */
    private predicate uniqueValue(SsaDefinition v, Expr e, GuardValue k) {
      possibleValue(v, false, e, k) and
      forex(Expr other, GuardValue otherval | possibleValue(v, _, other, otherval) and other != e |
        disjointValues(otherval, k)
      )
    }

    /**
     * Holds if `phi` has exactly two inputs, `def1` and `e2`, and that `def1`
     * does not come from a back-edge into `phi`.
     */
    private predicate phiWithTwoInputs(SsaPhiNode phi, SsaDefinition def1, Expr e2) {
      exists(SsaWriteDefinition def2, BasicBlock bb1 |
        2 = strictcount(SsaDefinition inp, BasicBlock bb | phi.hasInputFromBlock(inp, bb)) and
        phi.hasInputFromBlock(def1, bb1) and
        phi.hasInputFromBlock(def2, _) and
        def1 != def2 and
        not phi.getBasicBlock().dominates(bb1) and
        def2.getDefinition() = e2
      )
    }

    /** Holds if `e` may take the value `k` */
    private predicate relevantInt(Expr e, int k) {
      e.(ConstantExpr).asIntegerValue() = k
      or
      relevantInt(any(Expr e1 | valueStep(e1, e)), k)
      or
      exists(SsaDefinition def |
        guardReadsSsaVar(e, def) and
        relevantInt(getADefinition(def, _).(SsaWriteDefinition).getDefinition(), k)
      )
    }

    private predicate impliesStep(Guard g1, GuardValue v1, Guard g2, GuardValue v2) {
      baseImpliesStep(g1, v1, g2, v2)
      or
      exists(SsaDefinition def, Expr e |
        // If `def = g2 ? v1 : ...` and all other assignments to `def` are different from
        // `v1` then a guard proving `def == v1` ensures that `g2` evaluates to `v2`.
        uniqueValue(def, e, v1) and
        guardReadsSsaVar(g1, def) and
        g2.directlyValueControls(e.getBasicBlock(), v2) and
        not g2.directlyValueControls(g1.getBasicBlock(), v2)
      )
      or
      exists(int k1, int k2, boolean upper |
        rangeGuard(g1, v1, g2, k1, upper) and
        relevantInt(g2, k2) and
        v2 = TValue(TValueInt(k2), false)
      |
        upper = true and k1 < k2 // g2 <= k1 < k2  ==>  g2 != k2
        or
        upper = false and k1 > k2 // g2 >= k1 > k2  ==>  g2 != k2
      )
      or
      exists(boolean isNull |
        additionalNullCheck(g1, v1, g2, isNull) and
        v2 = TValue(TValueNull(), isNull)
      )
    }

    bindingset[g1, v1]
    pragma[inline_late]
    private predicate unboundImpliesStep(Guard g1, GuardValue v1, Guard g2, GuardValue v2) {
      unboundBaseImpliesStep(g1, v1, g2, v2)
    }

    bindingset[def1, v1]
    pragma[inline_late]
    private predicate impliesStepSsaGuard(SsaDefinition def1, GuardValue v1, Guard g2, GuardValue v2) {
      def1.(SsaWriteDefinition).getDefinition() = g2 and
      v1 = v2 and
      not exprHasValue(g2, v2) // disregard trivial guard
      or
      exists(Expr e, GuardValue ev |
        guardDeterminesPhiInput(g2, v2.getDualValue(), def1, e) and
        exprHasValue(e, ev) and
        disjointValues(v1, ev)
      )
    }

    bindingset[def1, v]
    pragma[inline_late]
    private predicate impliesStepSsa(SsaDefinition def1, GuardValue v, SsaDefinition def2) {
      exists(Expr e, GuardValue ev |
        phiWithTwoInputs(def1, def2, e) and
        exprHasValue(e, ev) and
        disjointValues(v, ev)
      )
    }

    private signature predicate baseGuardValueSig(Guard guard, GuardValue v);

    /**
     * Calculates the transitive closure of all the guard implication steps
     * starting from a given set of base cases.
     */
    private module ImpliesTC<baseGuardValueSig/2 baseGuardValue> {
      pragma[nomagic]
      predicate guardControls(Guard guard, GuardValue v, Guard tgtGuard, GuardValue tgtVal) {
        baseGuardValue(tgtGuard, tgtVal) and
        guard = tgtGuard and
        v = tgtVal
        or
        exists(Guard g0, GuardValue v0 |
          guardControls(g0, v0, tgtGuard, tgtVal) and
          impliesStep(g0, v0, guard, v)
        )
        or
        exists(Guard g0, GuardValue v0 |
          guardControls(g0, v0, tgtGuard, tgtVal) and
          unboundImpliesStep(g0, v0, guard, v)
        )
        or
        exists(SsaDefinition def0, GuardValue v0 |
          ssaControls(def0, v0, tgtGuard, tgtVal) and
          impliesStepSsaGuard(def0, v0, guard, v)
        )
        or
        exists(Guard g0, GuardValue v0 |
          guardControls(g0, v0, tgtGuard, tgtVal) and
          additionalImpliesStep(g0, v0, guard, v)
        )
      }

      pragma[nomagic]
      predicate ssaControls(SsaDefinition def, GuardValue v, Guard tgtGuard, GuardValue tgtVal) {
        exists(Guard g0 |
          guardControls(g0, v, tgtGuard, tgtVal) and
          guardReadsSsaVar(g0, def)
        )
        or
        exists(SsaDefinition def0 |
          ssaControls(def0, v, tgtGuard, tgtVal) and
          impliesStepSsa(def0, v, def)
        )
      }
    }

    private predicate hasAValueBranchEdge(Guard guard, GuardValue v) {
      guard.hasValueBranchEdge(_, _, v)
    }

    private module BranchImplies = ImpliesTC<hasAValueBranchEdge/2>;

    private predicate guardControlsBranchEdge(
      Guard guard, BasicBlock bb1, BasicBlock bb2, GuardValue v
    ) {
      exists(Guard g0, GuardValue v0 |
        g0.hasValueBranchEdge(bb1, bb2, v0) and
        BranchImplies::guardControls(guard, v, g0, v0)
      )
    }

    signature module CustomGuardInputSig {
      class ParameterPosition {
        /** Gets a textual representation of this element. */
        bindingset[this]
        string toString();
      }

      class ArgumentPosition {
        /** Gets a textual representation of this element. */
        bindingset[this]
        string toString();
      }

      /**
       * Holds if the parameter position `ppos` matches the argument position
       * `apos`.
       */
      predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos);

      /** A non-overridable method with a boolean return value. */
      class BooleanMethod {
        SsaDefinition getParameter(ParameterPosition ppos);

        Expr getAReturnExpr();
      }

      class BooleanMethodCall extends Expr {
        BooleanMethod getMethod();

        Expr getArgument(ArgumentPosition apos);
      }
    }

    /**
     * Provides an implementation of guard implication logic for custom
     * wrappers. This can be used to instantiate the `additionalImpliesStep`
     * predicate.
     */
    module CustomGuard<CustomGuardInputSig CustomGuardInput> {
      private import CustomGuardInput

      private class ReturnExpr extends ExprFinal {
        ReturnExpr() { any(BooleanMethod m).getAReturnExpr() = this }

        pragma[nomagic]
        BasicBlock getBasicBlock() { result = super.getBasicBlock() }
      }

      private predicate booleanReturnGuard(Guard guard, GuardValue val) {
        guard instanceof ReturnExpr and exists(val.asBooleanValue())
      }

      private module ReturnImplies = ImpliesTC<booleanReturnGuard/2>;

      /**
       * Holds if `ret` is a return expression in a non-overridable method that
       * on a return value of `retval` allows the conclusion that the `ppos`th
       * parameter has the value `val`.
       */
      private predicate validReturnInCustomGuard(
        ReturnExpr ret, ParameterPosition ppos, boolean retval, GuardValue val
      ) {
        exists(BooleanMethod m, SsaDefinition param |
          m.getAReturnExpr() = ret and
          m.getParameter(ppos) = param and
          not val instanceof TCaseMatch
        |
          exists(Guard g0, GuardValue v0 |
            g0.directlyValueControls(ret.getBasicBlock(), v0) and
            BranchImplies::ssaControls(param, val, g0, v0) and
            retval = [true, false]
          )
          or
          ReturnImplies::ssaControls(param, val, ret,
            any(GuardValue r | r.asBooleanValue() = retval))
        )
      }

      /**
       * Gets a non-overridable method with a boolean return value that performs a check
       * on the `ppos`th parameter. A return value equal to `retval` allows us to conclude
       * that the argument has the value `val`.
       */
      private BooleanMethod customGuard(ParameterPosition ppos, boolean retval, GuardValue val) {
        forex(ReturnExpr ret |
          result.getAReturnExpr() = ret and
          not ret.(ConstantExpr).asBooleanValue() = retval.booleanNot()
        |
          validReturnInCustomGuard(ret, ppos, retval, val)
        )
      }

      /**
       * Holds if the assumption that `g1` has been evaluated to `v1` implies that
       * `g2` has been evaluated to `v2`, that is, the evaluation of `g2` to `v2`
       * dominates the evaluation of `g1` to `v1`.
       *
       * This predicate covers the implication steps that arise from calls to
       * custom guard wrappers.
       */
      predicate additionalImpliesStep(PreGuard g1, GuardValue v1, PreGuard g2, GuardValue v2) {
        exists(BooleanMethodCall call, ParameterPosition ppos, ArgumentPosition apos |
          g1 = call and
          call.getMethod() = customGuard(ppos, v1.asBooleanValue(), v2) and
          call.getArgument(apos) = g2 and
          parameterMatch(pragma[only_bind_out](ppos), pragma[only_bind_out](apos))
        )
      }
    }

    /**
     * A guard. This may be any expression whose value determines subsequent
     * control flow.
     */
    final class Guard extends PreGuard {
      /**
       * Holds if this guard evaluating to `v` controls the control-flow branch
       * edge from `bb1` to `bb2`. That is, following the edge from `bb1` to
       * `bb2` implies that this guard evaluated to `v`.
       *
       * Note that this goes beyond mere control-flow graph dominance, as it
       * also considers additional logical reasoning.
       */
      predicate valueControlsBranchEdge(BasicBlock bb1, BasicBlock bb2, GuardValue v) {
        guardControlsBranchEdge(this, bb1, bb2, v)
      }

      /**
       * Holds if this guard evaluating to `v` controls the basic block `bb`.
       * That is, execution of `bb` implies that this guard evaluated to `v`.
       *
       * Note that this goes beyond mere control-flow graph dominance, as it
       * also considers additional logical reasoning.
       */
      predicate valueControls(BasicBlock bb, GuardValue v) {
        exists(BasicBlock guard, BasicBlock succ |
          this.valueControlsBranchEdge(guard, succ, v) and
          dominatingEdge(guard, succ) and
          succ.dominates(bb)
        )
      }

      /**
       * Holds if this guard evaluating to `branch` controls the control-flow
       * branch edge from `bb1` to `bb2`. That is, following the edge from
       * `bb1` to `bb2` implies that this guard evaluated to `branch`.
       *
       * Note that this goes beyond mere control-flow graph dominance, as it
       * also considers additional logical reasoning.
       */
      predicate controlsBranchEdge(BasicBlock bb1, BasicBlock bb2, boolean branch) {
        this.valueControlsBranchEdge(bb1, bb2, TValue(TValueTrue(), branch))
      }

      /**
       * Holds if this guard evaluating to `branch` controls the basic block
       * `bb`. That is, execution of `bb` implies that this guard evaluated to
       * `branch`.
       *
       * Note that this goes beyond mere control-flow graph dominance, as it
       * also considers additional logical reasoning.
       */
      predicate controls(BasicBlock bb, boolean branch) {
        this.valueControls(bb, TValue(TValueTrue(), branch))
      }
    }
  }
}
