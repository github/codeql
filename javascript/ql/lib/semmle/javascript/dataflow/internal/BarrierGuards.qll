/**
 * A copy of the barrier guard logic from `Configuration.qll` in the JS data flow library.
 *
 * This version considers all barrier guards to be relevant.
 */

private import javascript
private import semmle.javascript.dataflow.internal.AccessPaths
private import semmle.javascript.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.javascript.dataflow.internal.sharedlib.Ssa as Ssa2

private signature class BarrierGuardSig extends DataFlow::Node {
  /**
   * Holds if this node acts as a barrier for data flow, blocking further flow from `e` if `this` evaluates to `outcome`.
   */
  predicate blocksExpr(boolean outcome, Expr e);
}

/**
 * Converts a barrier guard class to a set of nodes to include in an implementation of `isBarrier(node)`.
 */
module MakeBarrierGuard<BarrierGuardSig BaseGuard> {
  final private class FinalBaseGuard = BaseGuard;

  private class Adapter extends FinalBaseGuard {
    predicate blocksExpr(boolean outcome, Expr e, Unit state) {
      super.blocksExpr(outcome, e) and exists(state)
    }
  }

  /**
   * Gets a node that is blocked by a barrier guard.
   */
  DataFlow::Node getABarrierNode() {
    result = MakeStateBarrierGuard<Unit, Adapter>::getABarrierNode(_)
  }
}

deprecated private module DeprecationWrapper {
  signature class LabeledBarrierGuardSig extends DataFlow::Node {
    /**
     * Holds if this node acts as a barrier for `label`, blocking further flow from `e` if `this` evaluates to `outcome`.
     */
    predicate blocksExpr(boolean outcome, Expr e, DataFlow::FlowLabel label);
  }
}

/**
 * Converts a barrier guard class to a set of nodes to include in an implementation of `isBarrier(node, label)`.
 */
deprecated module MakeLabeledBarrierGuard<DeprecationWrapper::LabeledBarrierGuardSig BaseGuard> {
  final private class FinalBaseGuard = BaseGuard;

  private class Adapter extends FinalBaseGuard {
    predicate blocksExpr(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      super.blocksExpr(outcome, e, label)
    }
  }

  /**
   * Gets a node and flow label that is blocked by a barrier guard.
   */
  DataFlow::Node getABarrierNode(DataFlow::FlowLabel label) {
    result = MakeStateBarrierGuard<DataFlow::FlowLabel, Adapter>::getABarrierNode(label)
  }
}

/**
 * Contains deprecated signatures.
 *
 * This module is a workaround for the fact that deprecated signatures can't refer to deprecated classes
 * without getting a deprecation warning
 */
deprecated private module DeprecatedSigs {
  signature predicate isBarrierGuardSig(DataFlow::BarrierGuardNode node);
}

/**
 * Converts a labeled barrier guard class to a set of nodes to include in an implementation of `isBarrier(node)` and `isBarrier(node, label)`
 * in a `DataFlow::StateConfigSig` implementation.
 */
deprecated module MakeLegacyBarrierGuardLabeled<DeprecatedSigs::isBarrierGuardSig/1 isBarrierGuard> {
  final private class FinalNode = DataFlow::Node;

  private class Adapter extends FinalNode instanceof DataFlow::BarrierGuardNode {
    Adapter() { isBarrierGuard(this) }

    predicate blocksExpr(boolean outcome, Expr e, string label) {
      super.blocks(outcome, e, label)
      or
      super.blocks(outcome, e) and label = ""
    }
  }

  private module Guards = MakeStateBarrierGuard<string, Adapter>;

  /**
   * Gets a node that is blocked by a barrier guard.
   */
  DataFlow::Node getABarrierNode() { result = Guards::getABarrierNode("") }

  /**
   * Gets a node and flow label that is blocked by a barrier guard.
   */
  DataFlow::Node getABarrierNode(DataFlow::FlowLabel label) {
    result = Guards::getABarrierNode(label)
  }
}

/**
 * Converts a barrier guard class to a set of nodes to include in an implementation of `isBarrier(node)` in a `DataFlow::ConfigSig` implementation.
 */
deprecated module MakeLegacyBarrierGuard<DeprecatedSigs::isBarrierGuardSig/1 isBarrierGuard> {
  final private class FinalNode = DataFlow::Node;

  private class Adapter extends FinalNode instanceof DataFlow::BarrierGuardNode {
    Adapter() { isBarrierGuard(this) }

    predicate blocksExpr(boolean outcome, Expr e, string label) {
      super.blocks(outcome, e, label)
      or
      super.blocks(outcome, e) and label = ""
    }
  }

  private module Guards = MakeStateBarrierGuard<string, Adapter>;

  /**
   * Gets a node that is blocked by a barrier guard.
   */
  DataFlow::Node getABarrierNode() { result = Guards::getABarrierNode(["", "data", "taint"]) }
}

bindingset[this]
private signature class FlowStateSig;

private module WithFlowState<FlowStateSig FlowState> {
  signature class BarrierGuardSig extends DataFlow::Node {
    /**
     * Holds if this node acts as a barrier for `state`, blocking further flow from `e` if `this` evaluates to `outcome`.
     */
    predicate blocksExpr(boolean outcome, Expr e, FlowState state);
  }
}

/**
 * Projects the dominator tree onto a tree that only considers dominance between `ConditionGuardNode`s.
 *
 * This exists to speeds up the dominance check for barrier guards acting on an access path, avoiding the following two
 * bad join orders:
 *
 * - Enumerate all basic blocks dominated by a barrier guard, and then find uses of the access path in those blocks.
 * - Enumerate all uses of an access path and then select those that are in a dominated block.
 *
 * Both joins have pathological cases in different benchmarks.
 *
 * We use a join order that is essentially the first one above, except we only enumerate condition guards, not all the blocks.
 */
cached
private module ConditionGuardDominators {
  /** Gets the condition guard that most-immediately dominates `bb`. */
  private ConditionGuardNode getDominatingCondition(ReachableBasicBlock bb) {
    result.getBasicBlock() = bb
    or
    not bb = any(ConditionGuardNode guard).getBasicBlock() and
    result = getDominatingCondition(bb.getImmediateDominator())
  }

  private predicate immediateDom(ConditionGuardNode dominator, ConditionGuardNode dominated) {
    dominator = getDominatingCondition(dominated.getBasicBlock().getImmediateDominator())
    or
    dominator = dominated // make the fastTC below reflexive
  }

  /** Gets a condition guard dominated by `node` */
  cached
  ConditionGuardNode getADominatedConditionGuard(ConditionGuardNode node) =
    fastTC(immediateDom/2)(node, result)

  /** Gets a use of `ap` and binds `guard` to its immediately-dominating condition guard (if any). */
  cached
  Expr getAnAccessPathUseUnderCondition(AccessPath ap, ConditionGuardNode guard) {
    exists(ReachableBasicBlock bb |
      result = ap.getAnInstanceIn(bb) and
      guard = getDominatingCondition(bb)
    )
  }
}

/**
 * Converts a barrier guard class to a set of nodes to include in an implementation of `isBarrier(node, state)`.
 */
module MakeStateBarrierGuard<
  FlowStateSig FlowState, WithFlowState<FlowState>::BarrierGuardSig BaseGuard>
{
  final private class FinalNode = DataFlow::Node;

  abstract private class BarrierGuard extends FinalNode {
    abstract predicate blocksExpr(boolean outcome, Expr test, FlowState state);
  }

  private class ExplicitBarrierGuard extends BarrierGuard instanceof BaseGuard {
    override predicate blocksExpr(boolean outcome, Expr test, FlowState state) {
      BaseGuard.super.blocksExpr(outcome, test, state)
    }
  }

  /**
   * Gets a node and flow state that is blocked by a barrier guard.
   */
  pragma[nomagic]
  DataFlow::Node getABarrierNode(FlowState state) { barrierGuardBlocksNode(result, state) }

  //
  // ================================================================================================
  // NOTE
  // The rest of this file is a copy of the barrier-guard logic in Configuration.qll except:
  //  - FlowLabel is replaced by FlowState
  //  - BarrierGuardNode and AdditionalBarrierGuardNode are replaced by the BarrierGuard class defined above
  //  - `barrierGuardBlocksEdge` is missing as dataflow2 does not support barrier edges
  //  - `barrierGuardIsRelevant` does not check pruning results as we can't access that from here
  //  - `barrierGuardBlocksNode` has been rewritten to perform better without pruning.
  // ================================================================================================
  //
  /**
   * Holds if data flow node `guard` acts as a barrier for data flow.
   *
   * `state` is bound to the blocked state, or the empty FlowState if all labels should be blocked.
   */
  pragma[nomagic]
  private predicate barrierGuardBlocksExpr(
    BarrierGuard guard, boolean outcome, Expr test, FlowState state
  ) {
    guard.blocksExpr(outcome, test, state)
  }

  /**
   * Holds if `guard` may block the flow of a value reachable through exploratory flow.
   */
  pragma[nomagic]
  private predicate barrierGuardIsRelevant(BarrierGuard guard) {
    exists(Expr e |
      barrierGuardBlocksExpr(guard, _, e, _)
      // All guards are considered relevant (this is the difference from the main JS lib)
      // isRelevantForward(e.flow(), _)
    )
  }

  /**
   * Holds if data flow node `guard` acts as a barrier for data flow due to aliasing through
   * an access path.
   *
   * `state` is bound to the blocked state, or the empty FlowState if all labels should be blocked.
   */
  pragma[nomagic]
  private predicate barrierGuardBlocksAccessPath(
    BarrierGuard guard, boolean outcome, AccessPath ap, FlowState state
  ) {
    barrierGuardIsRelevant(guard) and
    barrierGuardBlocksExpr(guard, outcome, ap.getAnInstance(), state)
  }

  /**
   * Holds if there exists an input variable of `ref` that blocks the state `state`.
   *
   * This predicate is outlined to give the optimizer a hint about the join ordering.
   */
  pragma[nomagic]
  private predicate barrierGuardBlocksSsaRefinement(
    BarrierGuard guard, boolean outcome, SsaRefinementNode ref, FlowState state
  ) {
    barrierGuardIsRelevant(guard) and
    guard.getEnclosingExpr() = ref.getGuard().getTest() and
    forex(SsaVariable input | input = ref.getAnInput() |
      barrierGuardBlocksExpr(guard, outcome, input.getAUse(), state)
    )
  }

  /**
   * Holds if the result of `guard` is used in the branching condition `cond`.
   *
   * `outcome` is bound to the outcome of `cond` for join-ordering purposes.
   */
  pragma[nomagic]
  private predicate barrierGuardUsedInCondition(
    BarrierGuard guard, ConditionGuardNode cond, boolean outcome
  ) {
    barrierGuardIsRelevant(guard) and
    outcome = cond.getOutcome() and
    (
      cond.getTest() = guard.getEnclosingExpr()
      or
      cond.getTest().flow().getImmediatePredecessor+() = guard
    )
  }

  private predicate ssa2GuardChecks(
    Ssa2::SsaDataflowInput::Guard guard, Ssa2::SsaDataflowInput::Expr test, boolean branch,
    FlowState state
  ) {
    exists(BarrierGuard g |
      g.asExpr() = guard and
      g.blocksExpr(branch, test, state)
    )
  }

  private module Ssa2Barrier = Ssa2::BarrierGuardWithState<FlowState, ssa2GuardChecks/4>;

  private predicate ssa2BlocksNode(DataFlow::Node node, FlowState state) {
    node = DataFlowPrivate::getNodeFromSsa2(Ssa2Barrier::getABarrierNode(state))
  }

  /** Holds if a barrier guard blocks uses of `ap` in basic blocks dominated by `cond`. */
  pragma[nomagic]
  private predicate barrierGuardBlocksAccessPathIn(
    AccessPath ap, ConditionGuardNode cond, FlowState state
  ) {
    exists(BarrierGuard guard, boolean outcome |
      barrierGuardBlocksAccessPath(guard, outcome, ap, state) and
      barrierGuardUsedInCondition(guard, cond, outcome)
    )
  }

  /**
   * Holds if `expr` is an access path reference that is blocked by a barrier guard.
   */
  pragma[noopt]
  private predicate barrierGuardBlocksAccessPathUse(Expr use, FlowState state) {
    exists(AccessPath p, ConditionGuardNode cond, ConditionGuardNode useDominator |
      barrierGuardBlocksAccessPathIn(p, cond, state) and
      useDominator = ConditionGuardDominators::getADominatedConditionGuard(cond) and
      use = ConditionGuardDominators::getAnAccessPathUseUnderCondition(p, useDominator)
    )
  }

  /**
   * Holds if data flow node `nd` acts as a barrier for data flow, possibly due to aliasing
   * through an access path.
   *
   * `state` is bound to the blocked state.
   */
  pragma[nomagic]
  private predicate barrierGuardBlocksNode(DataFlow::Node nd, FlowState state) {
    exists(BarrierGuard guard, SsaRefinementNode ref, boolean outcome |
      nd = DataFlow::ssaDefinitionNode(ref) and
      outcome = ref.getGuard().(ConditionGuardNode).getOutcome() and
      barrierGuardBlocksSsaRefinement(guard, outcome, ref, state)
    )
    or
    exists(Expr use |
      barrierGuardBlocksAccessPathUse(use, state) and
      nd = DataFlow::valueNode(use)
    )
    or
    ssa2BlocksNode(nd, state)
  }

  /**
   * Gets a logical `and` expression, or parenthesized expression, that contains `guard`.
   */
  private Expr getALogicalAndParent(BarrierGuard guard) {
    barrierGuardIsRelevant(guard) and result = guard.asExpr()
    or
    result.(LogAndExpr).getAnOperand() = getALogicalAndParent(guard)
    or
    result.getUnderlyingValue() = getALogicalAndParent(guard)
  }

  /**
   * Gets a logical `or` expression, or parenthesized expression, that contains `guard`.
   */
  private Expr getALogicalOrParent(BarrierGuard guard) {
    barrierGuardIsRelevant(guard) and result = guard.asExpr()
    or
    result.(LogOrExpr).getAnOperand() = getALogicalOrParent(guard)
    or
    result.getUnderlyingValue() = getALogicalOrParent(guard)
  }

  final private class FinalFunction = Function;

  /**
   * A function that returns the result of a barrier guard.
   */
  private class BarrierGuardFunction extends FinalFunction {
    DataFlow::ParameterNode sanitizedParameter;
    BarrierGuard guard;
    boolean guardOutcome;
    FlowState state;
    int paramIndex;

    BarrierGuardFunction() {
      barrierGuardIsRelevant(guard) and
      exists(Expr e |
        exists(Expr returnExpr |
          returnExpr = guard.asExpr()
          or
          // ad hoc support for conjunctions:
          getALogicalAndParent(guard) = returnExpr and guardOutcome = true
          or
          // ad hoc support for disjunctions:
          getALogicalOrParent(guard) = returnExpr and guardOutcome = false
        |
          exists(SsaExplicitDefinition ssa |
            ssa.getDef().getSource() = returnExpr and
            ssa.getVariable().getAUse() = this.getAReturnedExpr()
          )
          or
          returnExpr = this.getAReturnedExpr()
        ) and
        sanitizedParameter.flowsToExpr(e) and
        barrierGuardBlocksExpr(guard, guardOutcome, e, state)
      ) and
      sanitizedParameter.getParameter() = this.getParameter(paramIndex)
    }

    /**
     * Holds if this function sanitizes argument `e` of call `call`, provided the call evaluates to `outcome`.
     */
    predicate isBarrierCall(DataFlow::CallNode call, Expr e, boolean outcome, FlowState st) {
      exists(DataFlow::Node arg |
        DataFlow::argumentPassingStep(pragma[only_bind_into](call), pragma[only_bind_into](arg),
          pragma[only_bind_into](this), pragma[only_bind_into](sanitizedParameter)) and
        arg.asExpr() = e and
        arg = call.getArgument(paramIndex) and
        outcome = guardOutcome and
        state = st
      )
    }
  }

  /**
   * A call that sanitizes an argument.
   */
  private class AdditionalBarrierGuardCall extends BarrierGuard instanceof DataFlow::CallNode {
    BarrierGuardFunction f;

    AdditionalBarrierGuardCall() { f.isBarrierCall(this, _, _, _) }

    override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
      f.isBarrierCall(this, e, outcome, state)
    }
  }

  /**
   * A sanitizer where an inner sanitizer is compared against a boolean.
   * E.g. (assuming `sanitizes(e)` is an existing sanitizer):
   * ```javascript
   * if (sanitizes(e) === true) {
   *  // e is sanitized
   * }
   * ```
   */
  private class CallAgainstEqualityCheck extends BarrierGuard {
    BarrierGuard prev;
    boolean polarity;

    CallAgainstEqualityCheck() {
      prev instanceof DataFlow::CallNode and
      exists(EqualityTest test, BooleanLiteral bool |
        this.asExpr() = test and
        test.hasOperands(prev.asExpr(), bool) and
        polarity = test.getPolarity().booleanXor(bool.getBoolValue())
      )
    }

    override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
      exists(boolean prevOutcome |
        barrierGuardBlocksExpr(prev, prevOutcome, e, state) and
        outcome = prevOutcome.booleanXor(polarity)
      )
    }
  }
}
