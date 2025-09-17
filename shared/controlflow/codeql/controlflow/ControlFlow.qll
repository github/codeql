/**
 * Provides an implementation of local (intraprocedural) control flow reachability.
 */
overlay[local?]
module;

private import codeql.controlflow.BasicBlock as BB
private import codeql.controlflow.SuccessorType
private import codeql.util.Boolean
private import codeql.util.Location
private import codeql.util.Option

private signature class TypSig;

signature module InputSig<LocationSig Location, TypSig ControlFlowNode, TypSig BasicBlock> {
  AstNode getEnclosingAstNode(ControlFlowNode node);

  class AstNode {
    /** Gets a textual representation of this AST node. */
    string toString();

    /** Gets the location of this AST node. */
    Location getLocation();
  }

  AstNode getParent(AstNode node);

  class Expr extends AstNode;

  class FinallyBlock extends AstNode;

  /** A variable that can be SSA converted. */
  class SourceVariable {
    /** Gets a textual representation of this variable. */
    string toString();

    /** Gets the location of this variable. */
    Location getLocation();
  }

  class SsaDefinition {
    SourceVariable getSourceVariable();

    predicate definesAt(SourceVariable v, BasicBlock bb, int i);

    /** Gets the basic block to which this SSA definition belongs. */
    BasicBlock getBasicBlock();

    /** Gets a textual representation of this SSA definition. */
    string toString();

    /** Gets the location of this SSA definition. */
    Location getLocation();

    /** Holds if this SSA variable is live at the end of `b`. */
    predicate isLiveAtEndOfBlock(BasicBlock b);
  }

  class SsaWriteDefinition extends SsaDefinition {
    Expr getDefinition();
  }

  class SsaPhiNode extends SsaDefinition {
    /** Holds if `inp` is an input to the phi node along the edge originating in `bb`. */
    predicate hasInputFromBlock(SsaDefinition inp, BasicBlock bb);

    SsaDefinition getAPhiInput();
  }

  class SsaUncertainDefinition extends SsaDefinition {
    /**
     * Gets the immediately preceding definition. Since this update is uncertain,
     * the value from the preceding definition might still be valid.
     */
    SsaDefinition getPriorDefinition();
  }

  /** An abstract value that a `Guard` may evaluate to. */
  class GuardValue {
    /** Gets a textual representation of this value. */
    string toString();

    /**
     * Gets the dual value. Examples of dual values include:
     * - null vs. not null
     * - true vs. false
     * - evaluating to a specific value vs. evaluating to any other value
     * - throwing an exception vs. not throwing an exception
     */
    GuardValue getDualValue();

    /** Gets the integer that this value represents, if any. */
    int asIntValue();

    /**
     * Holds if this value represents an integer range.
     *
     * If `upper = true` the range is `(-infinity, bound]`.
     * If `upper = false` the range is `[bound, infinity)`.
     */
    predicate isIntRange(int bound, boolean upper);
  }

  /**
   * Holds if `def` evaluating to `v` controls the control-flow branch
   * edge from `bb1` to `bb2`. That is, following the edge from `bb1` to
   * `bb2` implies that `def` evaluated to `v`.
   */
  predicate ssaControlsBranchEdge(SsaDefinition def, BasicBlock bb1, BasicBlock bb2, GuardValue v);

  /**
   * Holds if `def` evaluating to `v` controls the basic block `bb`.
   * That is, execution of `bb` implies that `def` evaluated to `v`.
   */
  predicate ssaControls(SsaDefinition def, BasicBlock bb, GuardValue v);

  predicate exprHasValue(Expr e, GuardValue gv);

  bindingset[gv1, gv2]
  predicate disjointValues(GuardValue gv1, GuardValue gv2);
}

module Make<
  LocationSig Location, BB::CfgSig<Location> Cfg,
  InputSig<Location, Cfg::ControlFlowNode, Cfg::BasicBlock> Input>
{
  private module Cfg_ = Cfg;

  private import Cfg_
  private import Input

  final private class FinalAstNode = Input::AstNode;

  class AstNode extends FinalAstNode {
    AstNode getParent() { result = getParent(this) }
  }

  /**
   * Holds if `node` is enclosed by `finally`. In case of nested finally
   * blocks, this predicate only holds for the innermost block enclosing
   * `node`.
   */
  private predicate hasEnclosingFinally(AstNode node, FinallyBlock finally) {
    node = finally
    or
    not node instanceof FinallyBlock and
    hasEnclosingFinally(node.getParent(), finally)
  }

  /**
   * Holds if `inner` is nested within `outer`.
   */
  private predicate nestedFinally(FinallyBlock inner, FinallyBlock outer) {
    hasEnclosingFinally(inner.(AstNode).getParent(), outer)
  }

  /** Gets the nesting depth of `finally` in terms of number of finally blocks. */
  private int finallyNestLevel(FinallyBlock finally) {
    not nestedFinally(finally, _) and result = 1
    or
    exists(FinallyBlock outer |
      nestedFinally(finally, outer) and result = 1 + finallyNestLevel(outer)
    )
  }

  private int maxFinallyNesting() { result = max(finallyNestLevel(_)) }

  private newtype TFinallyStack =
    TNil() or
    TCons(Boolean abrupt, FinallyStack tail) { tail.length() < maxFinallyNesting() }

  /**
   * A stack of split values to track whether entered finally blocks have
   * waiting completions.
   */
  private class FinallyStack extends TFinallyStack {
    string toString() {
      result = "" and this = TNil()
      or
      exists(boolean abrupt, FinallyStack tail |
        result = abrupt + ";" + tail.toString() and this = TCons(abrupt, tail)
      )
    }

    /** Gets the length of this stack. */
    int length() {
      result = 0 and this = TNil()
      or
      exists(FinallyStack tail | result = 1 + tail.length() and this = TCons(_, tail))
    }

    /**
     * Gets the stack resulting from pushing information about entering a
     * finally block through a specific edge onto this stack.
     *
     * The `abrupt` value indicates whether the edge has an `AbruptSuccessor`
     * or not.
     */
    FinallyStack enter(boolean abrupt) { result = TCons(abrupt, this) }

    /**
     * Gets the stack resulting from popping a value, if any, consistent with
     * leaving a finally block through a specific edge.
     *
     * The `abrupt` value indicates whether the edge has an `AbruptSuccessor`
     * or not.
     */
    FinallyStack leave(Boolean abrupt) {
      this = TNil() and result = TNil() and exists(abrupt)
      or
      abrupt = false and this = TCons(false, result)
      or
      abrupt = true and this = TCons(_, result)
    }
  }

  private ControlFlowNode basicBlockEndPoint() {
    result = any(BasicBlock bb).getNode(0) or
    result = any(BasicBlock bb).getLastNode()
  }

  private predicate inFinally(AstNode node, FinallyBlock finally) {
    node = getEnclosingAstNode(basicBlockEndPoint()) and
    hasEnclosingFinally(node, finally)
    or
    exists(FinallyBlock inner | nestedFinally(inner, finally) and inFinally(node, inner))
  }

  private predicate irrelevantFinally(FinallyBlock finally) {
    exists(BasicBlock bb, AstNode n1, AstNode n2 |
      n1 = getEnclosingAstNode(bb.getNode(0)) and
      n2 = getEnclosingAstNode(bb.getLastNode())
    |
      inFinally(n1, finally) and not inFinally(n2, finally)
      or
      not inFinally(n1, finally) and inFinally(n2, finally)
    )
  }

  private predicate entersFinally(
    BasicBlock bb1, BasicBlock bb2, boolean abrupt, FinallyBlock finally
  ) {
    exists(AstNode n1, AstNode n2, SuccessorType t |
      not irrelevantFinally(finally) and
      bb1.getASuccessor(t) = bb2 and
      n1 = getEnclosingAstNode(bb1.getLastNode()) and
      n2 = getEnclosingAstNode(bb2.getNode(0)) and
      not inFinally(n1, finally) and
      inFinally(n2, finally) and
      if t instanceof AbruptSuccessor then abrupt = true else abrupt = false
    )
  }

  private predicate leavesFinally(
    BasicBlock bb1, BasicBlock bb2, boolean abrupt, FinallyBlock finally
  ) {
    exists(AstNode n1, AstNode n2, SuccessorType t |
      not irrelevantFinally(finally) and
      bb1.getASuccessor(t) = bb2 and
      n1 = getEnclosingAstNode(bb1.getLastNode()) and
      n2 = getEnclosingAstNode(bb2.getNode(0)) and
      inFinally(n1, finally) and
      not inFinally(n2, finally) and
      if t instanceof AbruptSuccessor then abrupt = true else abrupt = false
    )
  }

  /** Holds if `gv1` is a strict subset of `gv2`. */
  bindingset[gv1, gv2]
  private predicate smaller(GuardValue gv1, GuardValue gv2) {
    disjointValues(gv1, gv2.getDualValue()) and
    gv1 != gv2
  }

  /**
   * Holds if the value of `def` is `gv`.
   *
   * If multiple values apply, then we only include the most precise ones.
   */
  private predicate ssaHasValue(SsaWriteDefinition def, GuardValue gv) {
    exists(Expr e |
      def.getDefinition() = e and
      exprHasValue(e, gv) and
      not exists(GuardValue gv0 | exprHasValue(e, gv0) and smaller(gv0, gv))
    )
  }

  pragma[nomagic]
  private predicate ssaLiveAtEndOfBlock(SourceVariable var, SsaDefinition def, BasicBlock bb) {
    def.getSourceVariable() = var and
    def.isLiveAtEndOfBlock(bb)
  }

  pragma[nomagic]
  private predicate initSsaValue0(SourceVariable var, BasicBlock bb, SsaDefinition t, GuardValue val) {
    ssaLiveAtEndOfBlock(var, t, bb) and
    (
      ssaControls(t, bb, val)
      or
      ssaHasValue(t, val)
    )
  }

  /**
   * Holds if the value of `t` in `bb` is `val` and that `t` is live at the
   * end of `bb`.
   *
   * If multiple values apply, then we only include the most precise ones.
   *
   * The underlying variable of `t` is `var`.
   */
  private predicate initSsaValue(SourceVariable var, BasicBlock bb, SsaDefinition t, GuardValue val) {
    initSsaValue0(var, bb, t, val) and
    not exists(GuardValue val0 | initSsaValue0(var, bb, t, val0) and smaller(val0, val))
  }

  private predicate possibleValue(SourceVariable var, GuardValue gv) {
    exists(SsaDefinition def | def.getSourceVariable() = var |
      ssaHasValue(def, gv)
      or
      ssaControlsBranchEdge(def, _, _, gv)
    )
  }

  private predicate possibleRangeBound(SourceVariable var, int bound, boolean upper) {
    exists(GuardValue gv | possibleValue(var, gv) and gv.isIntRange(bound, upper))
  }

  private predicate possibleClosedRange(SourceVariable var, int low, int high) {
    possibleRangeBound(var, low, false) and
    possibleRangeBound(var, high, true) and
    low < high
  }

  private newtype TGuardValueExt =
    AnyValue() or
    BaseValue(GuardValue gv) { possibleValue(_, gv) } or
    IntRange(int low, int high) { possibleClosedRange(_, low, high) }

  private class GuardValueExt extends TGuardValueExt {
    string toString() {
      result = "Any" and this = AnyValue()
      or
      result = this.asBase().toString()
      or
      exists(int low, int high |
        this = IntRange(low, high) and result = "[" + low + ", " + high + "]"
      )
    }

    GuardValue asBase() { this = BaseValue(result) }
  }

  private class TGuardValueOrAny = AnyValue or BaseValue;

  private class GuardValueOrAny extends GuardValueExt, TGuardValueOrAny { }

  private GuardValueExt mkRange(int low, int high) {
    result = IntRange(low, high)
    or
    low = high and
    result.asBase().asIntValue() = low
  }

  private GuardValueExt intersectBase1(GuardValue gv1, GuardValue gv2) {
    exists(SourceVariable var |
      possibleValue(var, gv1) and
      possibleValue(var, gv2)
    |
      smaller(gv1, gv2) and result.asBase() = gv1
      or
      exists(int low, int high |
        gv1.isIntRange(low, false) and
        gv2.isIntRange(high, true) and
        result = mkRange(low, high)
      )
      or
      exists(int bound, boolean upper, int d |
        gv1.isIntRange(bound, upper) and
        gv2.getDualValue().asIntValue() = bound and
        result.asBase().isIntRange(bound + d, upper)
      |
        upper = true and d = -1
        or
        upper = false and d = 1
      )
    )
  }

  private GuardValueExt intersectBase2(GuardValueExt v1, GuardValue v2) {
    result = intersectBase1(v1.asBase(), v2)
    or
    result = intersectBase1(v2, v1.asBase())
  }

  bindingset[v1, v2]
  pragma[inline_late]
  private GuardValueExt intersectRange(GuardValueExt v1, GuardValue v2) {
    exists(int low, int high | v1 = IntRange(low, high) |
      exists(int bound, boolean upper | v2.isIntRange(bound, upper) |
        upper = true and result = mkRange(low, high.minimum(bound))
        or
        upper = false and result = mkRange(low.maximum(bound), high)
      )
      or
      exists(int k |
        v2.asIntValue() = k and
        result.asBase() = v2 and
        low <= k and
        k <= high
      )
      or
      not v2.isIntRange(_, _) and not exists(v2.asIntValue()) and result = v1
    )
  }

  bindingset[v1, v2]
  pragma[inline_late]
  private GuardValueExt intersect(GuardValueExt v1, GuardValue v2) {
    v1 = AnyValue() and result.asBase() = v2
    or
    result = intersectBase2(v1, v2)
    or
    result = v1 and
    v1 instanceof BaseValue and
    not exists(intersectBase2(v1, v2))
    or
    result = intersectRange(v1, v2)
  }

  bindingset[v1, gv2]
  private predicate disjointValuesExt(GuardValueExt v1, GuardValue gv2) {
    disjointValues(v1.asBase(), gv2)
    or
    exists(int low, int high | v1 = IntRange(low, high) |
      gv2.asIntValue() < low
      or
      high < gv2.asIntValue()
      or
      exists(int bound, boolean upper | gv2.isIntRange(bound, upper) |
        upper = true and bound < low
        or
        upper = false and high < bound
      )
    )
  }

  /** An input configuration for control flow reachability. */
  signature module ConfigSig {
    /**
     * Holds if the value of `def` at `node` is a source for the reachability
     * computation.
     */
    predicate source(ControlFlowNode node, SsaDefinition def);

    /**
     * Holds if the value of `def` at `node` is a sink for the reachability
     * computation.
     */
    predicate sink(ControlFlowNode node, SsaDefinition def);

    /**
     * Holds if the value of `gv` is a barrier for the reachability computation.
     * That is, paths where the tracked variable can be inferred to have the
     * value of `gv` are excluded from the reachability analysis.
     */
    default predicate barrierValue(GuardValue gv) { none() }

    /**
     * Holds if the edge from `bb1` to `bb2` should be excluded from the
     * reachability analysis.
     */
    default predicate barrierEdge(BasicBlock bb1, BasicBlock bb2) { none() }

    /**
     * Holds if flow through uncertain SSA updates should be included.
     */
    default predicate uncertainFlow() { any() }
  }

  /**
   * Constructs a control flow reachability computation.
   */
  module Flow<ConfigSig Config> {
    private predicate ssaRelevantAtEndOfBlock(SsaDefinition def, BasicBlock bb) {
      def.isLiveAtEndOfBlock(bb)
      or
      def.getBasicBlock().strictlyPostDominates(bb)
    }

    pragma[nomagic]
    private predicate isSource(
      ControlFlowNode src, SsaDefinition srcDef, SourceVariable var, BasicBlock bb, int i
    ) {
      Config::source(src, srcDef) and
      bb.getNode(i) = src and
      srcDef.getSourceVariable() = var
    }

    pragma[nomagic]
    private predicate isSink(
      ControlFlowNode sink, SsaDefinition sinkDef, SourceVariable var, BasicBlock bb, int i
    ) {
      Config::sink(sink, sinkDef) and
      bb.getNode(i) = sink and
      sinkDef.getSourceVariable() = var
    }

    private predicate uncertainStep(SsaDefinition def1, SsaDefinition def2) {
      def2.(SsaUncertainDefinition).getPriorDefinition() = def1 and
      Config::uncertainFlow()
    }

    private predicate intraBlockStep(SsaDefinition def1, SsaDefinition def2) {
      exists(BasicBlock bb |
        uncertainStep(def1, def2) and
        bb = def2.getBasicBlock() and
        isSource(_, _, _, bb, _) and
        isSink(_, _, _, bb, _)
      )
    }

    private predicate intraBlockFlowAll(
      ControlFlowNode src, SsaDefinition srcDef, int i, ControlFlowNode sink, SsaDefinition sinkDef,
      int j
    ) {
      exists(SourceVariable var, BasicBlock bb |
        isSource(src, srcDef, var, bb, i) and
        isSink(sink, sinkDef, var, bb, j) and
        i <= j and
        intraBlockStep*(srcDef, sinkDef)
      )
    }

    private predicate intraBlockFlow(
      ControlFlowNode src, SsaDefinition srcDef, ControlFlowNode sink, SsaDefinition sinkDef
    ) {
      exists(int i, int j |
        intraBlockFlowAll(src, srcDef, i, sink, sinkDef, j) and
        not exists(int k |
          intraBlockFlowAll(src, srcDef, i, _, _, k) and
          k < j
        )
      )
    }

    private predicate sourceBlock(SsaDefinition def, BasicBlock bb, ControlFlowNode src) {
      isSource(src, def, _, bb, _) and
      not intraBlockFlow(src, def, _, _)
    }

    private predicate sinkBlock(SsaDefinition def, BasicBlock bb, ControlFlowNode sink) {
      sink =
        min(ControlFlowNode n, int i | bb.getNode(i) = n and Config::sink(n, def) | n order by i)
    }

    /**
     * Holds if the edge from `bb1` to `bb2` implies that `def` has a value
     * that is considered a barrier.
     */
    private predicate ssaValueBarrierEdge(SsaDefinition def, BasicBlock bb1, BasicBlock bb2) {
      exists(GuardValue v |
        ssaControlsBranchEdge(def, bb1, bb2, v) and
        Config::barrierValue(v)
      )
    }

    /** Holds if `def1` in `bb1` may step to `def2` in `bb2`. */
    private predicate step(SsaDefinition def1, BasicBlock bb1, SsaDefinition def2, BasicBlock bb2) {
      not sinkBlock(def1, bb1, _) and
      not Config::barrierEdge(bb1, bb2) and
      not ssaValueBarrierEdge(def1, bb1, bb2) and
      (
        def2.(SsaPhiNode).hasInputFromBlock(def1, bb1) and bb2 = def2.getBasicBlock()
        or
        exists(SourceVariable v |
          ssaRelevantAtEndOfBlock(def1, bb1) and
          bb1.getASuccessor() = bb2 and
          v = def1.getSourceVariable() and
          not exists(SsaPhiNode phi | phi.getBasicBlock() = bb2 and phi.getSourceVariable() = v) and
          def1 = def2
        )
        or
        uncertainStep(def1, def2) and
        bb2 = def2.getBasicBlock() and
        bb1 = bb2
      )
    }

    bindingset[bb1, bb2, fs1]
    pragma[inline_late]
    private predicate stepFinallyStack(
      BasicBlock bb1, BasicBlock bb2, FinallyStack fs1, FinallyStack fs2
    ) {
      exists(boolean abrupt | entersFinally(bb1, bb2, abrupt, _) and fs2 = fs1.enter(abrupt)) and
      not leavesFinally(bb1, bb2, _, _)
      or
      exists(boolean abrupt | leavesFinally(bb1, bb2, abrupt, _) and fs2 = fs1.leave(abrupt)) and
      not entersFinally(bb1, bb2, _, _)
      or
      exists(boolean abrupt |
        leavesFinally(bb1, bb2, abrupt, _) and
        entersFinally(bb1, bb2, abrupt, _) and
        fs2 = fs1.leave(abrupt).enter(abrupt)
      )
      or
      not entersFinally(bb1, bb2, _, _) and not leavesFinally(bb1, bb2, _, _) and fs2 = fs1
    }

    /**
     * Holds if the source `srcDef` in `srcBb` may reach `def` in `bb`. If the
     * path has entered one or more finally blocks then `fs` tracks the
     * `SuccessorType`s of the edges entering those blocks.
     */
    private predicate sourceReachesBlock(
      SsaDefinition srcDef, BasicBlock srcBb, SsaDefinition def, BasicBlock bb, FinallyStack fs
    ) {
      sourceBlock(srcDef, srcBb, _) and
      def = srcDef and
      bb = srcBb and
      fs = TNil()
      or
      exists(SsaDefinition middef, BasicBlock midbb, FinallyStack midfs |
        sourceReachesBlock(srcDef, srcBb, middef, midbb, midfs) and
        step(middef, midbb, def, bb) and
        stepFinallyStack(midbb, bb, midfs, fs)
      )
    }

    /**
     * Holds if `def` in `bb` is reachable from a source and may reach a sink.
     */
    private predicate blockReachesSink(SsaDefinition def, BasicBlock bb) {
      sourceReachesBlock(_, _, def, bb, _) and
      (
        sinkBlock(def, bb, _)
        or
        exists(SsaDefinition middef, BasicBlock midbb |
          step(def, bb, middef, midbb) and
          blockReachesSink(middef, midbb)
        )
      )
    }

    private predicate escapeCandidate(SsaDefinition def, BasicBlock bb) {
      sourceBlock(def, bb, _)
      or
      exists(SsaDefinition middef, BasicBlock midbb |
        blockReachesSink(middef, midbb) and
        step(middef, midbb, def, bb)
      )
    }

    /**
     * Holds if the source `srcDef` in `srcBb` may reach `escDef` in `escBb` and from
     * there cannot reach a sink.
     */
    private predicate sourceEscapesSink(
      SsaDefinition srcDef, BasicBlock srcBb, SsaDefinition escDef, BasicBlock escBb
    ) {
      sourceReachesBlock(srcDef, srcBb, escDef, escBb, _) and
      escapeCandidate(escDef, escBb) and
      not blockReachesSink(escDef, escBb)
    }

    /** Holds if `bb` is a relevant block for computing reachability of `src`. */
    private predicate pathBlock(SourceVariable src, BasicBlock bb) {
      exists(SsaDefinition def | def.getSourceVariable() = src |
        blockReachesSink(def, bb)
        or
        escapeCandidate(def, bb)
      )
    }

    /**
     * Holds if `bb1` to `bb2` is a relevant edge for computing reachability
     * of `src`.
     */
    private predicate pathEdge(SourceVariable src, BasicBlock bb1, BasicBlock bb2) {
      step(_, bb1, _, bb2) and
      pathBlock(pragma[only_bind_into](src), bb1) and
      pathBlock(pragma[only_bind_into](src), bb2) and
      bb1 != bb2
    }

    /**
     * Holds if the edge from `bb1` to `bb2` implies that `def` has the value
     * `gv` and that the edge is relevant for computing reachability of `src`.
     *
     * If multiple values may be implied by this edge, then we only include the
     * most precise ones.
     *
     * The underlying variable of `t` is `var`.
     */
    private predicate ssaControlsPathEdge(
      SourceVariable src, SsaDefinition t, SourceVariable var, GuardValue gv, BasicBlock bb1,
      BasicBlock bb2
    ) {
      ssaControlsBranchEdge(t, bb1, bb2, gv) and
      not exists(GuardValue gv0 | ssaControlsBranchEdge(t, bb1, bb2, gv0) and smaller(gv0, gv)) and
      pathEdge(src, bb1, bb2) and
      t.getSourceVariable() = var
    }

    /**
     * Holds if the reachability path for `src` may go through a loop with
     * entry point `entry`.
     */
    pragma[nomagic]
    private predicate loopEntryBlock(SourceVariable src, BasicBlock entry) {
      exists(BasicBlock pred | pathEdge(src, pred, entry) and entry.strictlyDominates(pred))
    }

    /**
     * Holds if precision may be improved by splitting control flow on the
     * value of `var` during the reachability computation of `src`.
     */
    private predicate relevantSplit(SourceVariable src, SourceVariable var) {
      // `var` may be a relevant split if we encounter 2+ conditional edges
      // that imply information about `var`.
      2 <= strictcount(BasicBlock bb1 | ssaControlsPathEdge(src, _, var, _, bb1, _))
      or
      // Or if we encounter a conditional edge that imply a value that's
      // incompatible with an initial or later assigned value.
      exists(GuardValue gv1, GuardValue gv2, BasicBlock bb |
        ssaControlsPathEdge(src, _, var, gv1, _, _) and
        initSsaValue(var, bb, _, gv2) and
        disjointValues(gv1, gv2) and
        pathBlock(src, bb)
      )
      or
      // Or if we encounter a conditional edge in a loop that imply a value for
      // `var` that may be unchanged from one iteration to the next.
      exists(SsaDefinition def, BasicBlock bb1, BasicBlock bb2, BasicBlock loopEntry |
        ssaControlsPathEdge(src, def, var, _, bb1, bb2) and
        loopEntryBlock(src, loopEntry) and
        loopEntry.strictlyDominates(bb1) and
        bb2.getASuccessor*() = loopEntry
      |
        def.getBasicBlock().dominates(loopEntry)
        or
        exists(SsaPhiNode phi |
          phi.definesAt(var, loopEntry, _) and
          phi.getAPhiInput+() = def and
          def.(SsaPhiNode).getAPhiInput*() = phi
        )
      )
    }

    private module SsaDefOption = Option<SsaDefinition>;

    private class SsaDefOption = SsaDefOption::Option;

    private predicate lastDefInBlock(SourceVariable var, SsaDefinition def, BasicBlock bb) {
      def = max(SsaDefinition d, int i | d.definesAt(var, bb, i) | d order by i)
    }

    /**
     * Holds if `bb1` to `bb2` is a relevant edge for computing reachability of
     * `src`, and `var` is a relevant splitting variable that gets (re-)defined
     * in `bb2` by `t`, which is not a phi node.
     *
     * `val` is the best known value for `t` in `bb2`.
     */
    private predicate stepSsaValueRedef(
      SourceVariable src, BasicBlock bb1, BasicBlock bb2, SourceVariable var, SsaDefinition t,
      GuardValueOrAny val
    ) {
      pathEdge(src, bb1, bb2) and
      relevantSplit(src, var) and
      lastDefInBlock(var, t, bb2) and
      not t instanceof SsaPhiNode and
      (
        ssaHasValue(t, val.asBase())
        or
        not ssaHasValue(t, _) and val = AnyValue()
      )
    }

    /**
     * Holds if `bb1` to `bb2` is a relevant edge for computing reachability of
     * `src`, and `var` is a relevant splitting variable that has a phi node,
     * `t2`, in `bb2` taking input from `t1` along this edge. Furthermore,
     * there is no further redefinition of `var` in `bb2`.
     *
     * `val` is the best value for `t1`/`t2` implied by taking this edge.
     */
    private predicate stepSsaValuePhi(
      SourceVariable src, BasicBlock bb1, BasicBlock bb2, SourceVariable var, SsaDefinition t1,
      SsaDefinition t2, GuardValueOrAny val
    ) {
      pathEdge(src, bb1, bb2) and
      relevantSplit(src, var) and
      lastDefInBlock(var, t2, bb2) and
      t2.(SsaPhiNode).hasInputFromBlock(t1, bb1) and
      (
        ssaControlsPathEdge(src, t1, _, val.asBase(), bb1, bb2)
        or
        not ssaControlsPathEdge(src, t1, _, _, bb1, bb2) and
        val = AnyValue()
      )
    }

    /**
     * Holds if `bb1` to `bb2` is a relevant edge for computing reachability of
     * `src`, and `var` is a relevant splitting variable that has no
     * redefinition along this edge nor in `bb2`.
     *
     * Additionally, this edge implies that the SSA definition `t` of `var` has
     * value `val`.
     */
    private predicate stepSsaValueNoRedef(
      SourceVariable src, BasicBlock bb1, BasicBlock bb2, SourceVariable var, SsaDefinition t,
      GuardValue val
    ) {
      pathEdge(src, bb1, bb2) and
      relevantSplit(src, var) and
      not lastDefInBlock(var, _, bb2) and
      ssaControlsPathEdge(src, t, var, val, bb1, bb2)
    }

    /**
     * Holds if the source `srcDef` in `srcBb` may reach `def` in `bb`. The
     * taken path takes splitting based on the value of `var` into account.
     * The pair `(tracked, val)` is the current SSA definition and known value
     * for `var` in `bb`.
     */
    private predicate sourceReachesBlockWithTrackedVar(
      SsaDefinition srcDef, BasicBlock srcBb, SsaDefinition def, BasicBlock bb, FinallyStack fs,
      SsaDefOption tracked, GuardValueExt val, SourceVariable var
    ) {
      sourceBlock(srcDef, srcBb, _) and
      def = srcDef and
      bb = srcBb and
      fs = TNil() and
      relevantSplit(def.getSourceVariable(), var) and
      (
        // tracking variable is not yet live
        not ssaLiveAtEndOfBlock(var, _, bb) and
        tracked.isNone() and
        val = AnyValue()
        or
        // tracking variable is live but without known value
        ssaLiveAtEndOfBlock(var, tracked.asSome(), bb) and
        not initSsaValue(var, bb, _, _) and
        val = AnyValue()
        or
        // tracking variable has known value
        initSsaValue(var, bb, tracked.asSome(), val.asBase())
      )
      or
      exists(
        SourceVariable src, SsaDefinition middef, BasicBlock midbb, FinallyStack midfs,
        SsaDefOption tracked0, GuardValueExt val0
      |
        sourceReachesBlockWithTrackedVar(srcDef, srcBb, middef, midbb, midfs, tracked0, val0, var) and
        src = srcDef.getSourceVariable() and
        step(middef, midbb, def, bb) and
        stepFinallyStack(midbb, bb, midfs, fs) and
        pathBlock(src, bb) and
        not exists(GuardValue gv |
          ssaControlsPathEdge(src, tracked0.asSome(), _, gv, midbb, bb) and
          disjointValuesExt(val0, gv)
        )
      |
        // tracking variable is redefined
        stepSsaValueRedef(src, midbb, bb, var, tracked.asSome(), val)
        or
        exists(GuardValueOrAny val1 |
          // tracking variable has a phi node, and maybe value information from the edge
          stepSsaValuePhi(src, midbb, bb, var, tracked0.asSome(), tracked.asSome(), val1)
        |
          val = val0 and val1 = AnyValue()
          or
          val = intersect(val0, val1.asBase())
        )
        or
        exists(GuardValue val1 |
          // tracking variable is unchanged, and has value information from the edge
          stepSsaValueNoRedef(src, midbb, bb, var, tracked0.asSome(), val1) and
          tracked = tracked0 and
          val = intersect(val0, val1)
        )
        or
        // tracking variable is unchanged, and has no value information from the edge
        not lastDefInBlock(var, _, bb) and
        not stepSsaValueNoRedef(src, midbb, bb, var, tracked0.asSome(), _) and
        tracked = tracked0 and
        val = val0
      )
    }

    /**
     * Holds if the source `srcDef` at `src` may reach the sink `sinkDef` at `sink`.
     */
    predicate flow(
      ControlFlowNode src, SsaDefinition srcDef, ControlFlowNode sink, SsaDefinition sinkDef
    ) {
      intraBlockFlow(src, srcDef, sink, sinkDef)
      or
      exists(BasicBlock srcBb, BasicBlock sinkBb, SourceVariable srcVar |
        sourceBlock(srcDef, srcBb, src) and
        sourceReachesBlock(srcDef, srcBb, sinkDef, sinkBb, _) and
        sinkBlock(sinkDef, sinkBb, sink) and
        srcVar = srcDef.getSourceVariable() and
        forall(SourceVariable t | relevantSplit(srcVar, t) |
          sourceReachesBlockWithTrackedVar(srcDef, srcBb, sinkDef, sinkBb, _, _, _, t)
        )
      )
    }

    /**
     * Holds if the source `srcDef` at `src` may escape, that is, there exists
     * a path from `src` that circumvents all sinks to a point from which no
     * sink is reachable.
     */
    predicate escapeFlow(ControlFlowNode src, SsaDefinition srcDef) {
      not intraBlockFlow(src, srcDef, _, _) and
      exists(BasicBlock srcBb, SsaDefinition escDef, BasicBlock escBb, SourceVariable srcVar |
        sourceBlock(srcDef, srcBb, src) and
        sourceEscapesSink(srcDef, srcBb, escDef, escBb) and
        srcVar = srcDef.getSourceVariable() and
        forall(SourceVariable t | relevantSplit(srcVar, t) |
          sourceReachesBlockWithTrackedVar(srcDef, srcBb, escDef, escBb, _, _, _, t)
        )
      )
    }
  }
}
