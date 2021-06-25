/**
 * Provides a library for working with local (intra-procedural) control-flow
 * reachability involving stack variables.
 */

private import semmle.code.cpp.controlflow.Guards
private import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/** A `GuardCondition` which appear in a control-flow path to a sink. */
abstract private class LogicalGuardCondition extends GuardCondition {
  LogicalGuardCondition() {
    // Either the `GuardCondition` is part of the path from a source to a sink
    revBbSuccessorEntryReaches0(_, this.getBasicBlock(), _, _, _)
    or
    // or it controls the basic block that contains the source node.
    this.controls(any(BasicBlock bb | fwdBbEntryReachesLocally(bb, _, _, _)), _)
  }

  /**
   * Holds if the truth of this logical expression having value `wholeIsTrue`
   * implies that the truth of the child expression `part` has truth value `partIsTrue`.
   */
  abstract predicate impliesCondition(
    LogicalGuardCondition e, boolean testIsTrue, boolean condIsTrue
  );
}

private class BinaryLogicalGuardCondition extends LogicalGuardCondition, BinaryLogicalOperation {
  override predicate impliesCondition(
    LogicalGuardCondition e, boolean testIsTrue, boolean condIsTrue
  ) {
    this.impliesValue(e, testIsTrue, condIsTrue)
  }
}

private class VariableGuardCondition extends LogicalGuardCondition, VariableAccess {
  override predicate impliesCondition(
    LogicalGuardCondition e, boolean testIsTrue, boolean condIsTrue
  ) {
    this = e and
    (
      testIsTrue = true and condIsTrue = true
      or
      testIsTrue = false and condIsTrue = false
    )
  }
}

private class NotGuardCondition extends LogicalGuardCondition, NotExpr {
  override predicate impliesCondition(
    LogicalGuardCondition e, boolean testIsTrue, boolean condIsTrue
  ) {
    e = this.getOperand() and
    (
      testIsTrue = true and
      condIsTrue = false
      or
      testIsTrue = false and
      condIsTrue = true
    )
  }
}

private newtype TCondition =
  MkCondition(LogicalGuardCondition guard, boolean testIsTrue) { testIsTrue = [false, true] }

private class Condition extends MkCondition {
  boolean testIsTrue;
  LogicalGuardCondition guard;

  Condition() { this = MkCondition(guard, testIsTrue) }

  /**
   * Holds if this condition having the value `this.getTruthValue()` implies that `cond` has truth
   * value `cond.getTruthValue()`.
   */
  string toString() { result = guard.toString() + " == " + testIsTrue.toString() }

  /** Gets the value of this `Condition`. */
  boolean getTruthValue() { result = testIsTrue }

  LogicalGuardCondition getCondition() { result = guard }

  pragma[nomagic]
  predicate impliesCondition(Condition cond) {
    exists(LogicalGuardCondition other |
      other = cond.getCondition() and
      this.getCondition()
          .impliesCondition(globalValueNumber(other).getAnExpr(),
            pragma[only_bind_into](pragma[only_bind_out](testIsTrue)),
            pragma[only_bind_into](pragma[only_bind_out](cond.getTruthValue())))
    )
  }

  /** Gets the negated expression represented by this `Condition`, if any. */
  private Condition negate() {
    result.getCondition() = guard and
    result.getTruthValue() = testIsTrue.booleanNot()
  }

  /**
   * Holds if this condition having the value `this.getTruthValue()` implies that `cond` cannot have
   * the truth value `cond.getTruthValue()`.
   */
  final predicate refutesCondition(Condition cond) { this.impliesCondition(cond.negate()) }

  /** Gets the `Location` of the expression that generated this `Condition`. */
  Location getLocation() { result = guard.getLocation() }
}

/**
 * Gets a `Condition` that controls `b`. That is, to enter `b` the condition must hold.
 */
private Condition getADirectCondition(BasicBlock b) {
  result.getCondition().controls(b, result.getTruthValue())
}

/**
 * Like the shared dataflow library, the reachability analysis is split into two stages:
 * In the first stage, we compute an overapproximation of the possible control-flow paths where we don't
 * reason about path conditions. This stage is split into phases: A forward phase (computed by the
 * predicates prefixes with `fwd`), and a reverse phase (computed by the predicates prefixed with `rev`).
 *
 * The forward phease computes the set of control-flow nodes reachable from a given `source` and `v` such
 * that `config.isSource(source, v)` holds.
 *
 * See the QLDoc on `revBbSuccessorEntryReaches0` for a description of what the reverse phase computes.
 */
private predicate fwdBbSuccessorEntryReaches0(
  ControlFlowNode source, BasicBlock bb, SemanticStackVariable v,
  boolean skipsFirstLoopAlwaysTrueUponEntry, StackVariableReachability config
) {
  fwdBbEntryReachesLocally(bb, v, source, config) and
  skipsFirstLoopAlwaysTrueUponEntry = false
  or
  exists(BasicBlock pred, boolean predSkipsFirstLoopAlwaysTrueUponEntry |
    bbSuccessorEntryReachesLoopInvariant0(pred, bb, predSkipsFirstLoopAlwaysTrueUponEntry,
      skipsFirstLoopAlwaysTrueUponEntry)
  |
    // Note we cannot filter out barriers at this point.
    // See the comment in `revBbSuccessorEntryReaches0` for an explanation why,
    fwdBbSuccessorEntryReaches0(source, pred, v, predSkipsFirstLoopAlwaysTrueUponEntry, config)
  )
}

/**
 * The second phase of the first stages computes, for each `source` and `v` pair such
 * that `config.isSource(source, v)`, which sinks are reachable from that `(source, v)` pair.
 */
private predicate revBbSuccessorEntryReaches0(
  ControlFlowNode source, BasicBlock bb, SemanticStackVariable v,
  boolean skipsFirstLoopAlwaysTrueUponEntry, StackVariableReachability config
) {
  exists(BasicBlock succ, boolean succSkipsFirstLoopAlwaysTrueUponEntry |
    fwdBbSuccessorEntryReaches0(source, bb, v, skipsFirstLoopAlwaysTrueUponEntry, config) and
    bbSuccessorEntryReachesLoopInvariant0(bb, succ, skipsFirstLoopAlwaysTrueUponEntry,
      succSkipsFirstLoopAlwaysTrueUponEntry)
  |
    revBbEntryReachesLocally(succ, v, _, config) and
    succSkipsFirstLoopAlwaysTrueUponEntry = false
    or
    // Note: We cannot rule out a successor block that contain a barrier here (like we do later in
    // `bbSuccessorEntryReaches`) as we might later discover that the only way to get through a piece of
    // code is through that barrier, and we want to discover this in
    // `bbSuccessorEntryReachesLoopInvariant`. As an example, consider this piece of code:
    // ```
    // if(b) { (1) source(); }
    // (2) if(b) { (3) barrier(); }
    // (4) sink();
    // ```
    // here, we want the successor relation to contain:
    // 1 -> {2}, 2 -> {3, 4}
    // since the second stage will deduce that the edge (2) -> (3) is unconditional (as b is always true
    // if we start at `source()`), and so there is actually no path from (1) to (4) without going through
    // a barrier.
    revBbSuccessorEntryReaches0(source, succ, v, succSkipsFirstLoopAlwaysTrueUponEntry, config)
  )
}

private predicate successorExitsLoop(BasicBlock pred, BasicBlock succ, Loop loop) {
  pred.getASuccessor() = succ and
  bbDominates(loop.getStmt(), pred) and
  not bbDominates(loop.getStmt(), succ)
}

private predicate successorExitsFirstDisjunct(BasicBlock pred, BasicBlock succ) {
  exists(LogicalOrExpr orExpr | orExpr instanceof GuardCondition |
    pred.getAFalseSuccessor() = succ and
    pred.contains(orExpr.getLeftOperand())
  )
}

/**
 * When we exit a loop, we filter out the conditions that arise from the loop's guard.
 * To see why this is necessary, consider this example:
 * ```
 * (1) source();
 * while (b) { (2) ... }
 * (3) sink();
 * ```
 * If we keep all the conditions when we transition from (2) to (3) we learn that `b` is true at
 * (3), but since we exited the loop we also learn that `b` is false at 3.
 * Thus, when we transition from (2) to (3) we discard all those conditions that are true at (2),
 * but NOT true at (3).
 */
private predicate isLoopCondition(LogicalGuardCondition cond, BasicBlock pred, BasicBlock bb) {
  exists(Loop loop, boolean testIsTrue | successorExitsLoop(pred, bb, loop) |
    // the resulting `Condition` holds inside the loop
    cond.controls(pred, testIsTrue) and
    // but not prior to the loop.
    not cond.controls(loop.getBasicBlock(), testIsTrue)
  )
}

/**
 * When we leave the first disjunct we throw away the condition that says the the first disjunct is
 * false. To see why this is necessary, consider this example:
 * ```
 * if((1) b1 || (2) b2) { (3) ... }
 * ```
 * it holds that `b1 == false` controls (2), and since (2) steps to (3) we learn that `b1 == false `
 * holds at (3). So we filter out the conditions that we learn from leaving taking the false
 * branch in a disjunction.
 */
private predicate isDisjunctionCondition(LogicalGuardCondition cond, BasicBlock pred, BasicBlock bb) {
  exists(boolean testIsTrue | successorExitsFirstDisjunct(pred, bb) |
    // the resulting `Condition` holds after evaluating the left-hand side
    cond.controls(bb, testIsTrue) and
    // but not before evaluating the left-hand side.
    not cond.controls(pred, testIsTrue)
  )
}

private predicate isLoopVariantCondition(LogicalGuardCondition cond, BasicBlock pred, BasicBlock bb) {
  exists(Loop loop |
    bb.getEnd() = loop.getCondition() and
    pred.getASuccessor() = bb and
    bbDominates(bb, pred) and
    loopVariant(cond.getAChild*(), loop)
  )
}

private predicate loopVariant(VariableAccess e, Loop loop) {
  exists(SsaDefinition d | d.getAUse(e.getTarget()) = e |
    d.getAnUltimateDefiningValue(e.getTarget()) = loop.getCondition().getAChild*() or
    d.getAnUltimateDefiningValue(e.getTarget()).getEnclosingStmt().getParent*() = loop.getStmt() or
    d.getAnUltimateDefiningValue(e.getTarget()) = loop.(ForStmt).getUpdate().getAChild*()
  )
}

/**
 * A reachability analysis for control-flow nodes involving stack variables.
 * This defines sources, sinks, and any other configurable aspect of the
 * analysis. Multiple analyses can coexist. To create an analysis, extend this
 * class with a subclass whose characteristic predicate is a unique singleton
 * string. For example, write
 *
 * ```
 * class MyAnalysisConfiguration extends StackVariableReachability {
 *   MyAnalysisConfiguration() { this = "MyAnalysisConfiguration" }
 *   // Override `isSource` and `isSink`.
 *   // Override `isBarrier`.
 * }
 * ```
 *
 * Then, to query whether there is flow between some source and sink, call the
 * `reaches` predicate on an instance of `MyAnalysisConfiguration`.
 */
abstract class StackVariableReachability extends string {
  bindingset[this]
  StackVariableReachability() { length() >= 0 }

  /** Holds if `node` is a source for the reachability analysis using variable `v`. */
  abstract predicate isSource(ControlFlowNode node, StackVariable v);

  /** Holds if `sink` is a (potential) sink for the reachability analysis using variable `v`. */
  abstract predicate isSink(ControlFlowNode node, StackVariable v);

  /** Holds if `node` is a barrier for the reachability analysis using variable `v`. */
  abstract predicate isBarrier(ControlFlowNode node, StackVariable v);

  /**
   * Holds if the source node `source` can reach the sink `sink` without crossing
   * a barrier. This is (almost) equivalent to the following QL predicate but
   * uses basic blocks internally for better performance:
   *
   * ```
   * predicate reaches(ControlFlowNode source, SemanticStackVariable v, ControlFlowNode sink) {
   *   reachesImpl(source, v, sink)
   *   and
   *   isSink(sink, v)
   * }
   *
   * predicate reachesImpl(ControlFlowNode source, SemanticStackVariable v, ControlFlowNode sink) {
   *   sink = source.getASuccessor() and isSource(source, v)
   *   or
   *   exists(ControlFlowNode mid | reachesImpl(source, v, mid) |
   *     not isBarrier(mid, v)
   *     and
   *     sink = mid.getASuccessor()
   *   )
   * }
   * ```
   *
   * In addition to using a better performing implementation, this analysis
   * accounts for loops where the condition is provably true upon entry, and discards paths that require
   * an infeasible combination of guard conditions (for example, `if(b) { ... }` and `if(!b) { ... }`).
   */
  predicate reaches(ControlFlowNode source, SemanticStackVariable v, ControlFlowNode sink) {
    /*
     * Implementation detail: the predicates in this class are a generalization of
     * those in DefinitionsAndUses.qll, and should be kept in sync.
     *
     * Unfortunately, caching of abstract predicates does not work well, so the
     * predicates in DefinitionsAndUses.qll cannot use this library.
     */

    exists(BasicBlock bb, int i |
      isSource(source, v) and
      bb.getNode(i) = source and
      not bb.isUnreachable()
    |
      exists(int j |
        j > i and
        sink = bb.getNode(j) and
        isSink(sink, v) and
        not isBarrier(bb.getNode(pragma[only_bind_into]([i + 1 .. j - 1])), v)
      )
      or
      not exists(int k | isBarrier(bb.getNode(k), v) | k > i) and
      bbSuccessorEntryReaches(source, bb, v, sink, _)
    )
  }

  private Condition getASinkCondition(SemanticStackVariable v) {
    exists(BasicBlock bb |
      revBbEntryReachesLocally(bb, v, _, this) and
      result.getCondition().controls(bb, result.getTruthValue())
    )
  }

  private Condition getABarrierCondition(SemanticStackVariable v) {
    exists(BasicBlock bb |
      isBarrier(bb.getANode(), v) and
      result.getCondition().controls(bb, result.getTruthValue())
    )
  }

  /**
   * Gets a condition with a known truth value in `bb` when the control-flow starts at the source
   * node `source` and we're tracking reachability using variable `v` (that is,
   * `this.isSource(source, v)` holds).
   *
   * This predicate is `pragma[noopt]` as it seems difficult to get the correct join order for the
   * recursive case otherwise:
   * revBbSuccessorEntryReaches0(bb) -> getASuccessor -> prev_delta ->
   * revBbSuccessorEntryReaches0(pred) -> {isLoopCondition, isDisjunctionCondition, isLoopVariantCondition}
   */
  pragma[noopt]
  private Condition getACondition(ControlFlowNode source, SemanticStackVariable v, BasicBlock bb) {
    revBbSuccessorEntryReaches0(source, bb, v, _, this) and
    (
      result = getADirectCondition(bb) and
      (
        exists(Condition c |
          c = getASinkCondition(v) and
          result.refutesCondition(c)
        )
        or
        exists(Condition c |
          c = getABarrierCondition(v) and
          result.impliesCondition(c)
        )
      )
      or
      exists(BasicBlock pred |
        pred.getASuccessor() = bb and
        result = getACondition(source, v, pred) and
        revBbSuccessorEntryReaches0(source, pred, v, _, this) and
        exists(LogicalGuardCondition c | c = result.getCondition() |
          not isLoopCondition(c, pred, bb) and
          not isDisjunctionCondition(c, pred, bb) and
          not isLoopVariantCondition(c, pred, bb)
        )
      )
    )
  }

  pragma[nomagic]
  private predicate bbSuccessorEntryReachesLoopInvariantSucc(
    ControlFlowNode source, BasicBlock pred, SemanticStackVariable v, BasicBlock succ,
    boolean predSkipsFirstLoopAlwaysTrueUponEntry
  ) {
    revBbSuccessorEntryReaches0(source, pragma[only_bind_into](pred), v,
      predSkipsFirstLoopAlwaysTrueUponEntry, this) and
    pred.getASuccessor() = succ
  }

  pragma[nomagic]
  private predicate bbSuccessorEntryReachesLoopInvariantCand(
    ControlFlowNode source, BasicBlock pred, SemanticStackVariable v, BasicBlock succ,
    boolean predSkipsFirstLoopAlwaysTrueUponEntry, boolean succSkipsFirstLoopAlwaysTrueUponEntry
  ) {
    bbSuccessorEntryReachesLoopInvariantSucc(source, pragma[only_bind_into](pred), v, succ,
      predSkipsFirstLoopAlwaysTrueUponEntry) and
    bbSuccessorEntryReachesLoopInvariant0(pred, succ, predSkipsFirstLoopAlwaysTrueUponEntry,
      succSkipsFirstLoopAlwaysTrueUponEntry)
  }

  /**
   * Holds if `pred`, `succ`, `predSkipsFirstLoopAlwaysTrueUponEntry` and
   * `succSkipsFirstLoopAlwaysTrueUponEntry` satisfy the loop invariants specified in the QLDoc
   * for `bbSuccessorEntryReachesLoopInvariant0`.
   *
   * In addition, this predicate:
   * 1. Rules out successor blocks that are unreachable due to contradictory path conditions.
   * 2. Refines the successor relation when the edge `pred -> succ` is a conditional edge whose truth
   *    value is known.
   */
  pragma[nomagic]
  private predicate bbSuccessorEntryReachesLoopInvariant(
    ControlFlowNode source, BasicBlock pred, SemanticStackVariable v, BasicBlock succ,
    boolean predSkipsFirstLoopAlwaysTrueUponEntry, boolean succSkipsFirstLoopAlwaysTrueUponEntry
  ) {
    bbSuccessorEntryReachesLoopInvariantCand(source, pred, v, succ,
      predSkipsFirstLoopAlwaysTrueUponEntry, succSkipsFirstLoopAlwaysTrueUponEntry) and
    not exists(Condition cond, Condition direct |
      cond = getACondition(source, v, pred) and
      direct = pragma[only_bind_out](getADirectCondition(succ)) and
      cond.refutesCondition(direct)
    ) and
    (
      // If we picked the successor edge corresponding to a condition being true, there must not be
      // another path condition that refutes that the condition is true.
      not exists(Condition cond | cond = getACondition(source, v, pred) |
        succ = pred.getATrueSuccessor() and
        cond.refutesCondition(pragma[only_bind_out](MkCondition(pred.getEnd(), true)))
      )
      or
      // If we picked the successor edge corresponding to a condition being false, there must not be
      // another path condition that refutes that the condition is false.
      not exists(Condition cond | cond = getACondition(source, v, pred) |
        succ = pred.getAFalseSuccessor() and
        cond.refutesCondition(pragma[only_bind_out](MkCondition(pred.getEnd(), false)))
      )
    )
  }

  private predicate bbSuccessorEntryReaches(
    ControlFlowNode source, BasicBlock bb, SemanticStackVariable v, ControlFlowNode node,
    boolean skipsFirstLoopAlwaysTrueUponEntry
  ) {
    exists(BasicBlock succ, boolean succSkipsFirstLoopAlwaysTrueUponEntry |
      bbSuccessorEntryReachesLoopInvariant(source, bb, v, succ, skipsFirstLoopAlwaysTrueUponEntry,
        succSkipsFirstLoopAlwaysTrueUponEntry)
    |
      revBbEntryReachesLocally(succ, v, node, this) and
      succSkipsFirstLoopAlwaysTrueUponEntry = false
      or
      bbSuccessorEntryReachesLoopInvariant(source, bb, v, succ, skipsFirstLoopAlwaysTrueUponEntry,
        succSkipsFirstLoopAlwaysTrueUponEntry) and
      not isBarrier(pragma[only_bind_out](succ.getANode()), v) and
      pragma[only_bind_into](this)
          .bbSuccessorEntryReaches(source, succ, v, node, succSkipsFirstLoopAlwaysTrueUponEntry)
    )
  }
}

private predicate fwdBbEntryReachesLocally(
  BasicBlock bb, SemanticStackVariable v, ControlFlowNode node, StackVariableReachability config
) {
  exists(int n |
    node = bb.getNode(n) and
    config.isSource(node, v) and
    (
      not exists(lastBarrierIndexIn(bb, v, config))
      or
      lastBarrierIndexIn(bb, v, config) <= n
    )
  )
}

private predicate revBbEntryReachesLocally(
  BasicBlock bb, SemanticStackVariable v, ControlFlowNode node, StackVariableReachability config
) {
  exists(int n |
    node = bb.getNode(n) and
    config.isSink(node, v)
  |
    not exists(firstBarrierIndexIn(bb, v, config))
    or
    n <= firstBarrierIndexIn(bb, v, config)
  )
}

private int firstBarrierIndexIn(
  BasicBlock bb, SemanticStackVariable v, StackVariableReachability config
) {
  result = min(int m | config.isBarrier(bb.getNode(m), v))
}

private int lastBarrierIndexIn(
  BasicBlock bb, SemanticStackVariable v, StackVariableReachability config
) {
  result = max(int m | config.isBarrier(bb.getNode(m), v))
}

/**
 * Holds if `bb` contains the entry point `loop` for a loop at position `i`.
 * The condition of that loop is provably true upon entry but not provably
 * true in general (if it were, the false-successor had already been removed
 * from the CFG).
 *
 * Examples:
 * ```
 * for (int i = 0; i < 2; i++) { } // always true upon entry
 * for (int i = 0; true; i++) { } // always true
 * ```
 */
private predicate bbLoopEntryConditionAlwaysTrueAt(BasicBlock bb, int i, ControlFlowNode loop) {
  exists(Expr condition |
    loopConditionAlwaysTrueUponEntry(loop, condition) and
    not conditionAlwaysTrue(condition) and
    bb.getNode(i) = loop
  )
}

/**
 * Basic block `pred` contains all or part of the condition belonging to a loop,
 * and there is an edge from `pred` to `succ` that concludes the condition.
 * If the edge corrseponds with the loop condition being found to be `true`, then
 * `skipsLoop` is `false`.  Otherwise the edge corresponds with the loop condition
 * being found to be `false` and `skipsLoop` is `true`.  Non-concluding edges
 * within a complex loop condition are not matched by this predicate.
 */
private predicate bbLoopConditionAlwaysTrueUponEntrySuccessor(
  BasicBlock pred, BasicBlock succ, boolean skipsLoop
) {
  exists(Expr cond |
    loopConditionAlwaysTrueUponEntry(_, cond) and
    cond.getAChild*() = pred.getEnd() and
    succ = pred.getASuccessor() and
    not cond.getAChild*() = succ.getStart() and
    (
      succ = pred.getAFalseSuccessor() and
      skipsLoop = true
      or
      succ = pred.getATrueSuccessor() and
      skipsLoop = false
    )
  )
}

/**
 * Loop invariant for `bbSuccessorEntryReaches`:
 *
 * - `succ` is a successor of `pred`.
 * - `predSkipsFirstLoopAlwaysTrueUponEntry`: whether the path from
 * `pred` (via `succ`) skips the first loop where the condition is
 * provably true upon entry.
 * - `succSkipsFirstLoopAlwaysTrueUponEntry`: whether the path from
 * `succ` skips the first loop where the condition is provably true
 * upon entry.
 * - If `pred` contains the entry point of a loop where the condition
 * is provably true upon entry, then `succ` is not allowed to skip
 * that loop (`succSkipsFirstLoopAlwaysTrueUponEntry = false`).
 */
predicate bbSuccessorEntryReachesLoopInvariant0(
  BasicBlock pred, BasicBlock succ, boolean predSkipsFirstLoopAlwaysTrueUponEntry,
  boolean succSkipsFirstLoopAlwaysTrueUponEntry
) {
  succ = pred.getASuccessor() and
  (succSkipsFirstLoopAlwaysTrueUponEntry = true or succSkipsFirstLoopAlwaysTrueUponEntry = false) and
  (
    // The edge from `pred` to `succ` is from a loop condition provably
    // true upon entry, so the value of `predSkipsFirstLoopAlwaysTrueUponEntry`
    // is determined by whether the true edge or the false edge is chosen,
    // regardless of the value of `succSkipsFirstLoopAlwaysTrueUponEntry`.
    bbLoopConditionAlwaysTrueUponEntrySuccessor(pred, succ, predSkipsFirstLoopAlwaysTrueUponEntry)
    or
    // The edge from `pred` to `succ` is _not_ from a loop condition provably
    // true upon entry, so the values of `predSkipsFirstLoopAlwaysTrueUponEntry`
    // and `succSkipsFirstLoopAlwaysTrueUponEntry` must be the same.
    not bbLoopConditionAlwaysTrueUponEntrySuccessor(pred, succ, _) and
    succSkipsFirstLoopAlwaysTrueUponEntry = predSkipsFirstLoopAlwaysTrueUponEntry and
    // Moreover, if `pred` contains the entry point of a loop where the
    // condition is provably true upon entry, then `succ` is not allowed
    // to skip that loop, and hence `succSkipsFirstLoopAlwaysTrueUponEntry = false`.
    (
      bbLoopEntryConditionAlwaysTrueAt(pred, _, _)
      implies
      succSkipsFirstLoopAlwaysTrueUponEntry = false
    )
  )
}

/**
 * Reachability analysis for control-flow nodes involving stack variables.
 * Unlike `StackVariableReachability`, this analysis takes variable
 * reassignments into account.
 *
 * This class is used like `StackVariableReachability`, except that
 * subclasses should override `isSourceActual` and `isSinkActual` instead of
 * `isSource` and `isSink`, and that there is a `reachesTo` predicate in
 * addition to `reaches`.
 */
abstract class StackVariableReachabilityWithReassignment extends StackVariableReachability {
  bindingset[this]
  StackVariableReachabilityWithReassignment() { length() >= 0 }

  /** Override this predicate rather than `isSource` (`isSource` is used internally). */
  abstract predicate isSourceActual(ControlFlowNode node, StackVariable v);

  /** Override this predicate rather than `isSink` (`isSink` is used internally). */
  abstract predicate isSinkActual(ControlFlowNode node, StackVariable v);

  /**
   * Holds if the source node `source` can reach the sink `sink` without crossing
   * a barrier, taking reassignments into account. This is (almost) equivalent
   * to the following QL predicate, but uses basic blocks internally for better
   * performance:
   *
   * ```
   * predicate reaches(ControlFlowNode source, SemanticStackVariable v, ControlFlowNode sink) {
   *   reachesImpl(source, v, sink)
   *   and
   *   isSinkActual(sink, v)
   * }
   *
   * predicate reachesImpl(ControlFlowNode source, SemanticStackVariable v, ControlFlowNode sink) {
   *   isSourceActual(source, v)
   *   and
   *   (
   *     sink = source.getASuccessor()
   *     or
   *     exists(ControlFlowNode mid, SemanticStackVariable v0 | reachesImpl(source, v0, mid) |
   *       // ordinary successor
   *       not isBarrier(mid, v) and
   *       sink = mid.getASuccessor() and
   *       v = v0
   *       or
   *       // reassigned from v0 to v
   *       exprDefinition(v, mid, v0.getAnAccess()) and
   *       sink = mid.getASuccessor()
   *     )
   *   )
   * }
   * ```
   *
   * In addition to using a better performing implementation, this analysis
   * accounts for loops where the condition is provably true upon entry.
   */
  override predicate reaches(ControlFlowNode source, SemanticStackVariable v, ControlFlowNode sink) {
    reachesTo(source, v, sink, _)
  }

  /**
   * As `reaches`, but also specifies the last variable it was reassigned to (`v0`).
   */
  predicate reachesTo(
    ControlFlowNode source, SemanticStackVariable v, ControlFlowNode sink, SemanticStackVariable v0
  ) {
    exists(ControlFlowNode def |
      actualSourceReaches(source, v, def, v0) and
      StackVariableReachability.super.reaches(def, v0, sink) and
      isSinkActual(sink, v0)
    )
  }

  private predicate actualSourceReaches(
    ControlFlowNode source, SemanticStackVariable v, ControlFlowNode def, SemanticStackVariable v0
  ) {
    isSourceActual(source, v) and def = source and v0 = v
    or
    exists(ControlFlowNode source1, SemanticStackVariable v1 |
      actualSourceReaches(source, v, source1, v1)
    |
      reassignment(source1, v1, def, v0)
    )
  }

  private predicate bbSuccessorEntryReaches(
    BasicBlock bb, SemanticStackVariable v, ControlFlowNode node,
    boolean skipsFirstLoopAlwaysTrueUponEntry
  ) {
    exists(BasicBlock succ, boolean succSkipsFirstLoopAlwaysTrueUponEntry |
      bbSuccessorEntryReachesLoopInvariant0(bb, succ, skipsFirstLoopAlwaysTrueUponEntry,
        succSkipsFirstLoopAlwaysTrueUponEntry)
    |
      revBbEntryReachesLocally(succ, v, node, this) and
      succSkipsFirstLoopAlwaysTrueUponEntry = false
      or
      not isBarrier(succ.getNode(_), v) and
      bbSuccessorEntryReaches(succ, v, node, succSkipsFirstLoopAlwaysTrueUponEntry)
    )
  }

  private predicate reaches0(ControlFlowNode source, SemanticStackVariable v, ControlFlowNode sink) {
    /*
     * Implementation detail: the predicates in this class are a generalization of
     * those in DefinitionsAndUses.qll, and should be kept in sync.
     *
     * Unfortunately, caching of abstract predicates does not work well, so the
     * predicates in DefinitionsAndUses.qll cannot use this library.
     */

    exists(BasicBlock bb, int i |
      isSource(source, v) and
      bb.getNode(i) = source and
      not bb.isUnreachable()
    |
      exists(int j |
        j > i and
        sink = bb.getNode(j) and
        isSink(sink, v) and
        not isBarrier(bb.getNode(pragma[only_bind_into]([i + 1 .. j - 1])), v)
      )
      or
      not exists(int k | isBarrier(bb.getNode(k), v) | k > i) and
      bbSuccessorEntryReaches(bb, v, sink, _)
    )
  }

  private predicate reassignment(
    ControlFlowNode source, SemanticStackVariable v, ControlFlowNode def, SemanticStackVariable v0
  ) {
    reaches0(source, v, def) and
    exprDefinition(v0, def, v.getAnAccess())
  }

  final override predicate isSource(ControlFlowNode node, StackVariable v) {
    isSourceActual(node, v)
    or
    // Reassignment generates a new (non-actual) source
    reassignment(_, _, node, v)
  }

  final override predicate isSink(ControlFlowNode node, StackVariable v) {
    isSinkActual(node, v)
    or
    // Reassignment generates a new (non-actual) sink
    exprDefinition(_, node, v.getAnAccess())
  }
}

/**
 * Same as `StackVariableReachability`, but `isBarrier` works on control-flow
 * edges rather than nodes and is therefore parameterized by the original
 * source node as well. Otherwise, this class is used like
 * `StackVariableReachability`.
 */
abstract class StackVariableReachabilityExt extends string {
  bindingset[this]
  StackVariableReachabilityExt() { length() >= 0 }

  /** `node` is a source for the reachability analysis using variable `v`. */
  abstract predicate isSource(ControlFlowNode node, StackVariable v);

  /** `sink` is a (potential) sink for the reachability analysis using variable `v`. */
  abstract predicate isSink(ControlFlowNode node, StackVariable v);

  /** `node` is a barrier for the reachability analysis using variable `v` and starting from `source`. */
  abstract predicate isBarrier(
    ControlFlowNode source, ControlFlowNode node, ControlFlowNode next, StackVariable v
  );

  /** See `StackVariableReachability.reaches`. */
  predicate reaches(ControlFlowNode source, SemanticStackVariable v, ControlFlowNode sink) {
    exists(BasicBlock bb, int i |
      isSource(source, v) and
      bb.getNode(i) = source and
      not bb.isUnreachable()
    |
      exists(int j |
        j > i and
        sink = bb.getNode(j) and
        isSink(sink, v) and
        not exists(int k | isBarrier(source, bb.getNode(k), bb.getNode(k + 1), v) |
          k in [i .. j - 1]
        )
      )
      or
      not exists(int k | isBarrier(source, bb.getNode(k), bb.getNode(k + 1), v) | k >= i) and
      bbSuccessorEntryReaches(source, bb, v, sink, _)
    )
  }

  private predicate bbSuccessorEntryReaches(
    ControlFlowNode source, BasicBlock bb, SemanticStackVariable v, ControlFlowNode node,
    boolean skipsFirstLoopAlwaysTrueUponEntry
  ) {
    exists(BasicBlock succ, boolean succSkipsFirstLoopAlwaysTrueUponEntry |
      bbSuccessorEntryReachesLoopInvariant0(bb, succ, skipsFirstLoopAlwaysTrueUponEntry,
        succSkipsFirstLoopAlwaysTrueUponEntry) and
      not isBarrier(source, bb.getEnd(), succ.getStart(), v)
    |
      this.bbEntryReachesLocally(source, succ, v, node) and
      succSkipsFirstLoopAlwaysTrueUponEntry = false
      or
      not exists(int k | isBarrier(source, succ.getNode(k), succ.getNode(k + 1), v)) and
      bbSuccessorEntryReaches(source, succ, v, node, succSkipsFirstLoopAlwaysTrueUponEntry)
    )
  }

  private predicate bbEntryReachesLocally(
    ControlFlowNode source, BasicBlock bb, SemanticStackVariable v, ControlFlowNode node
  ) {
    isSource(source, v) and
    exists(int n | node = bb.getNode(n) and isSink(node, v) |
      not exists(int m | m < n | isBarrier(source, bb.getNode(m), bb.getNode(m + 1), v))
    )
  }
}
