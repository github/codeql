/**
 * DEPRECATED: Use `StackVariableReachability` instead.
 */

import cpp

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
