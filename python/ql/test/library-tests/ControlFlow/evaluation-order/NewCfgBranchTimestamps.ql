/**
 * New-CFG version of BranchTimestamps.
 *
 * Checks that when a node has both a true and false successor, the
 * live timestamps on one branch are marked as dead on the other.
 * This ensures that boolean branches are fully annotated with dead()
 * markers for the paths not taken.
 *
 * Limitation: the `@ t[ts, ...]` / `dead(ts)` annotation scheme can only
 * model branch-dead-ness for plain boolean control flow that reconverges
 * linearly after the split — i.e. `if`-with-else and `if`-expression.
 * It cannot model:
 *
 *   * loops (`while` / `for`): body timestamps repeat across iterations,
 *     so the loop-exit annotation can't list them as dead;
 *   * `match` statements: each `case` body is a syntactically distinct
 *     sub-tree, and the branches don't reconverge through a common
 *     annotation point in the timeline;
 *   * `try` / `with` and `raise` / `assert`: exception edges are modelled
 *     as true/false but flow to syntactically distinct handlers, with no
 *     reconvergence in the linear annotation order;
 *   * short-circuit `and` / `or` (`BoolExpr`): the branches reconverge at
 *     the BoolExpr's after-node, so timestamps on one branch are live
 *     downstream of the other rather than dead;
 *   * `if` without an `else` clause, and `if`/`elif` chains: the false
 *     branch reconverges with the true branch at the post-if statement
 *     (no-else) or fans out across multiple elif-test annotations,
 *     neither of which fit the binary annotation scheme.
 *
 * Branch nodes inside those constructs are therefore whitelisted out
 * below. The check still fires (and is useful) for plain `if`/`else`
 * and conditional-expression branching.
 */

import python
import TimerUtils
import NewCfgImpl

private module Utils = EvalOrderCfgUtils<NewCfg>;

private import Utils
private import Utils::CfgTests

/**
 * Holds if `f` contains a construct whose branches the linear-timestamp
 * annotation scheme cannot describe (see file-level comment).
 */
private predicate hasUnmodellableBranching(Function f) {
  exists(AstNode bad |
    bad.getScope() = f and
    (
      bad instanceof While
      or
      bad instanceof For
      or
      bad instanceof MatchStmt
      or
      bad instanceof Try
      or
      bad instanceof With
      or
      bad instanceof Raise
      or
      bad instanceof Assert
      or
      bad instanceof BoolExpr
      or
      bad instanceof If and
      (not exists(bad.(If).getAnOrelse()) or bad.(If).isElif())
    )
  )
}

from TimerCfgNode node, int ts, string branch
where
  missingBranchTimestamp(node, ts, branch) and
  not hasUnmodellableBranching(node.getTestFunction())
select node,
  "Timestamp " + ts + " on true/false branch is missing a dead() annotation on the " + branch +
    " successor in $@", node.getTestFunction(), node.getTestFunction().getName()
