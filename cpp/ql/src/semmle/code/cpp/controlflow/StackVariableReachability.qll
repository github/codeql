import cpp

/**
 * DEPRECATED: use `LocalScopeVariableReachability` instead.
 *
 * A reachability analysis for control-flow nodes involving stack variables.
 */
abstract deprecated class StackVariableReachability extends string {
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
   * predicate reaches(ControlFlowNode source, StackVariable v, ControlFlowNode sink) {
   *   reachesImpl(source, v, sink)
   *   and
   *   isSink(sink, v)
   * }
   *
   * predicate reachesImpl(ControlFlowNode source, StackVariable v, ControlFlowNode sink) {
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
  predicate reaches(ControlFlowNode source, StackVariable v, ControlFlowNode sink) {
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
        not exists(int k | isBarrier(bb.getNode(k), v) | k in [i + 1 .. j - 1])
      )
      or
      not exists(int k | isBarrier(bb.getNode(k), v) | k > i) and
      bbSuccessorEntryReaches(bb, v, sink, _)
    )
  }

  private predicate bbSuccessorEntryReaches(
    BasicBlock bb, StackVariable v, ControlFlowNode node, boolean skipsFirstLoopAlwaysTrueUponEntry
  ) {
    exists(BasicBlock succ, boolean succSkipsFirstLoopAlwaysTrueUponEntry |
      bbSuccessorEntryReachesLoopInvariant(bb, succ, skipsFirstLoopAlwaysTrueUponEntry,
        succSkipsFirstLoopAlwaysTrueUponEntry)
    |
      bbEntryReachesLocally(succ, v, node) and
      succSkipsFirstLoopAlwaysTrueUponEntry = false
      or
      not isBarrier(succ.getNode(_), v) and
      bbSuccessorEntryReaches(succ, v, node, succSkipsFirstLoopAlwaysTrueUponEntry)
    )
  }

  private predicate bbEntryReachesLocally(BasicBlock bb, StackVariable v, ControlFlowNode node) {
    exists(int n | node = bb.getNode(n) and isSink(node, v) |
      not exists(int m | m < n | isBarrier(bb.getNode(m), v))
    )
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
 * Basic block `pred` ends with a condition belonging to a loop, and that
 * condition is provably true upon entry. Basic block `succ` is a successor
 * of `pred`, and `skipsLoop` indicates whether `succ` is the false-successor
 * of `pred`.
 */
private predicate bbLoopConditionAlwaysTrueUponEntrySuccessor(
  BasicBlock pred, BasicBlock succ, boolean skipsLoop
) {
  succ = pred.getASuccessor() and
  exists(ControlFlowNode last |
    last = pred.getEnd() and
    loopConditionAlwaysTrueUponEntry(_, last) and
    if succ = pred.getAFalseSuccessor() then skipsLoop = true else skipsLoop = false
  )
}

/**
 * DEPRECATED: use the corresponding predicate in
 * `LocalScopeVariableReachability` instead.
 *
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
deprecated predicate bbSuccessorEntryReachesLoopInvariant(
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
    not bbLoopConditionAlwaysTrueUponEntrySuccessor(pred, _, _) and
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
 * DEPRECATED: use `LocalScopeVariableReachabilityWithReassignment` instead.
 *
 * Reachability analysis for control-flow nodes involving stack variables.
 * Unlike `StackVariableReachability`, this analysis takes variable
 * reassignments into account.
 */
abstract deprecated class StackVariableReachabilityWithReassignment extends StackVariableReachability {
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
   * predicate reaches(ControlFlowNode source, StackVariable v, ControlFlowNode sink) {
   *   reachesImpl(source, v, sink)
   *   and
   *   isSinkActual(sink, v)
   * }
   *
   * predicate reachesImpl(ControlFlowNode source, StackVariable v, ControlFlowNode sink) {
   *   isSourceActual(source, v)
   *   and
   *   (
   *     sink = source.getASuccessor()
   *     or
   *     exists(ControlFlowNode mid, StackVariable v0 | reachesImpl(source, v0, mid) |
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
  override predicate reaches(ControlFlowNode source, StackVariable v, ControlFlowNode sink) {
    reachesTo(source, v, sink, _)
  }

  /**
   * As `reaches`, but also specifies the last variable it was reassigned to (`v0`).
   */
  predicate reachesTo(
    ControlFlowNode source, StackVariable v, ControlFlowNode sink, StackVariable v0
  ) {
    exists(ControlFlowNode def |
      actualSourceReaches(source, v, def, v0) and
      StackVariableReachability.super.reaches(def, v0, sink) and
      isSinkActual(sink, v0)
    )
  }

  private predicate actualSourceReaches(
    ControlFlowNode source, StackVariable v, ControlFlowNode def, StackVariable v0
  ) {
    isSourceActual(source, v) and def = source and v0 = v
    or
    exists(ControlFlowNode source1, StackVariable v1 | actualSourceReaches(source, v, source1, v1) |
      reassignment(source1, v1, def, v0)
    )
  }

  private predicate reassignment(
    ControlFlowNode source, StackVariable v, ControlFlowNode def, StackVariable v0
  ) {
    StackVariableReachability.super.reaches(source, v, def) and
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
 * DEPRECATED: use `LocalScopeVariableReachabilityExt` instead.
 *
 * Same as `StackVariableReachability`, but `isBarrier` works on control-flow
 * edges rather than nodes and is therefore parameterized by the original
 * source node as well.
 */
abstract deprecated class StackVariableReachabilityExt extends string {
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
  predicate reaches(ControlFlowNode source, StackVariable v, ControlFlowNode sink) {
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
    ControlFlowNode source, BasicBlock bb, StackVariable v, ControlFlowNode node,
    boolean skipsFirstLoopAlwaysTrueUponEntry
  ) {
    exists(BasicBlock succ, boolean succSkipsFirstLoopAlwaysTrueUponEntry |
      bbSuccessorEntryReachesLoopInvariant(bb, succ, skipsFirstLoopAlwaysTrueUponEntry,
        succSkipsFirstLoopAlwaysTrueUponEntry) and
      not isBarrier(source, bb.getEnd(), succ.getStart(), v)
    |
      bbEntryReachesLocally(source, succ, v, node) and
      succSkipsFirstLoopAlwaysTrueUponEntry = false
      or
      not exists(int k | isBarrier(source, succ.getNode(k), succ.getNode(k + 1), v)) and
      bbSuccessorEntryReaches(source, succ, v, node, succSkipsFirstLoopAlwaysTrueUponEntry)
    )
  }

  private predicate bbEntryReachesLocally(
    ControlFlowNode source, BasicBlock bb, StackVariable v, ControlFlowNode node
  ) {
    isSource(source, v) and
    exists(int n | node = bb.getNode(n) and isSink(node, v) |
      not exists(int m | m < n | isBarrier(source, bb.getNode(m), bb.getNode(m + 1), v))
    )
  }
}
