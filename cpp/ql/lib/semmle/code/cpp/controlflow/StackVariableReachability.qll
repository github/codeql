/**
 * Provides a library for working with local (intra-procedural) control-flow
 * reachability involving stack variables.
 */

import cpp

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
   * accounts for loops where the condition is provably true upon entry.
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
      this.isSource(source, v) and
      bb.getNode(i) = source and
      not bb.isUnreachable()
    |
      exists(int j |
        j > i and
        sink = bb.getNode(j) and
        this.isSink(sink, v) and
        not exists(int k, ControlFlowNode node |
          node = bb.getNode(k) and this.isBarrier(pragma[only_bind_into](node), v)
        |
          k in [i + 1 .. j - 1]
        )
      )
      or
      not exists(int k | this.isBarrier(bb.getNode(k), v) | k > i) and
      this.bbSuccessorEntryReaches(bb, v, sink, _)
    )
  }

  private predicate bbSuccessorEntryReaches(
    BasicBlock bb, SemanticStackVariable v, ControlFlowNode node,
    boolean skipsFirstLoopAlwaysTrueUponEntry
  ) {
    exists(BasicBlock succ, boolean succSkipsFirstLoopAlwaysTrueUponEntry |
      bbSuccessorEntryReachesLoopInvariant(bb, succ, skipsFirstLoopAlwaysTrueUponEntry,
        succSkipsFirstLoopAlwaysTrueUponEntry)
    |
      this.bbEntryReachesLocally(succ, v, node) and
      succSkipsFirstLoopAlwaysTrueUponEntry = false
      or
      not this.isBarrier(succ.getNode(_), v) and
      this.bbSuccessorEntryReaches(succ, v, node, succSkipsFirstLoopAlwaysTrueUponEntry)
    )
  }

  private predicate bbEntryReachesLocally(
    BasicBlock bb, SemanticStackVariable v, ControlFlowNode node
  ) {
    exists(int n |
      node = bb.getNode(n) and
      this.isSink(node, v)
    |
      not exists(this.firstBarrierIndexIn(bb, v))
      or
      n <= this.firstBarrierIndexIn(bb, v)
    )
  }

  private int firstBarrierIndexIn(BasicBlock bb, SemanticStackVariable v) {
    result = min(int m | this.isBarrier(bb.getNode(m), v))
  }
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
predicate bbSuccessorEntryReachesLoopInvariant(
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
    this.reachesTo(source, v, sink, _)
  }

  /**
   * As `reaches`, but also specifies the last variable it was reassigned to (`v0`).
   */
  predicate reachesTo(
    ControlFlowNode source, SemanticStackVariable v, ControlFlowNode sink, SemanticStackVariable v0
  ) {
    exists(ControlFlowNode def |
      this.actualSourceReaches(source, v, def, v0) and
      StackVariableReachability.super.reaches(def, v0, sink) and
      this.isSinkActual(sink, v0)
    )
  }

  private predicate actualSourceReaches(
    ControlFlowNode source, SemanticStackVariable v, ControlFlowNode def, SemanticStackVariable v0
  ) {
    this.isSourceActual(source, v) and def = source and v0 = v
    or
    exists(ControlFlowNode source1, SemanticStackVariable v1 |
      this.actualSourceReaches(source, v, source1, v1)
    |
      this.reassignment(source1, v1, def, v0)
    )
  }

  private predicate reassignment(
    ControlFlowNode source, SemanticStackVariable v, ControlFlowNode def, SemanticStackVariable v0
  ) {
    StackVariableReachability.super.reaches(source, v, def) and
    exprDefinition(v0, def, v.getAnAccess())
  }

  final override predicate isSource(ControlFlowNode node, StackVariable v) {
    this.isSourceActual(node, v)
    or
    // Reassignment generates a new (non-actual) source
    this.reassignment(_, _, node, v)
  }

  final override predicate isSink(ControlFlowNode node, StackVariable v) {
    this.isSinkActual(node, v)
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
      this.isSource(source, v) and
      bb.getNode(i) = source and
      not bb.isUnreachable()
    |
      exists(int j |
        j > i and
        sink = bb.getNode(j) and
        this.isSink(sink, v) and
        not exists(int k | this.isBarrier(source, bb.getNode(k), bb.getNode(k + 1), v) |
          k in [i .. j - 1]
        )
      )
      or
      not exists(int k | this.isBarrier(source, bb.getNode(k), bb.getNode(k + 1), v) | k >= i) and
      this.bbSuccessorEntryReaches(source, bb, v, sink, _)
    )
  }

  private predicate bbSuccessorEntryReaches(
    ControlFlowNode source, BasicBlock bb, SemanticStackVariable v, ControlFlowNode node,
    boolean skipsFirstLoopAlwaysTrueUponEntry
  ) {
    exists(BasicBlock succ, boolean succSkipsFirstLoopAlwaysTrueUponEntry |
      bbSuccessorEntryReachesLoopInvariant(bb, succ, skipsFirstLoopAlwaysTrueUponEntry,
        succSkipsFirstLoopAlwaysTrueUponEntry) and
      not this.isBarrier(source, bb.getEnd(), succ.getStart(), v)
    |
      this.bbEntryReachesLocally(source, succ, v, node) and
      succSkipsFirstLoopAlwaysTrueUponEntry = false
      or
      not exists(int k | this.isBarrier(source, succ.getNode(k), succ.getNode(k + 1), v)) and
      this.bbSuccessorEntryReaches(source, succ, v, node, succSkipsFirstLoopAlwaysTrueUponEntry)
    )
  }

  private predicate bbEntryReachesLocally(
    ControlFlowNode source, BasicBlock bb, SemanticStackVariable v, ControlFlowNode node
  ) {
    this.isSource(source, v) and
    exists(int n | node = bb.getNode(n) and this.isSink(node, v) |
      not exists(int m | m < n | this.isBarrier(source, bb.getNode(m), bb.getNode(m + 1), v))
    )
  }
}
