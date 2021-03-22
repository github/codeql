/**
 * Provides classes and predicates relevant for splitting the control flow graph.
 */

private import codeql_ruby.AST
private import Completion
private import ControlFlowGraphImpl
private import SuccessorTypes
private import codeql_ruby.controlflow.ControlFlowGraph

/** The maximum number of splits allowed for a given node. */
private int maxSplits() { result = 5 }

cached
private module Cached {
  cached
  newtype TSplitKind =
    TConditionalCompletionSplitKind() or
    TEnsureSplitKind(int nestLevel) { nestLevel = any(Trees::BodyStmtTree t).getNestLevel() }

  cached
  newtype TSplit =
    TConditionalCompletionSplit(ConditionalCompletion c) or
    TEnsureSplit(EnsureSplitting::EnsureSplitType type, int nestLevel) {
      nestLevel = any(Trees::BodyStmtTree t).getNestLevel()
    }

  cached
  newtype TSplits =
    TSplitsNil() or
    TSplitsCons(SplitImpl head, Splits tail) {
      exists(AstNode pred, Splits predSplits, AstNode succ, Completion c, int rnk |
        case2aFromRank(pred, predSplits, succ, tail, c, rnk + 1) and
        head = case2aSomeAtRank(pred, predSplits, succ, c, rnk)
      )
      or
      succEntrySplitsCons(_, _, head, tail, _)
    }

  cached
  string splitsToString(Splits splits) {
    splits = TSplitsNil() and
    result = ""
    or
    exists(SplitImpl head, Splits tail, string headString, string tailString |
      splits = TSplitsCons(head, tail)
    |
      headString = head.toString() and
      tailString = tail.toString() and
      if tailString = ""
      then result = headString
      else
        if headString = ""
        then result = tailString
        else result = headString + ", " + tailString
    )
  }
}

private import Cached

/** A split for a control flow node. */
class Split extends TSplit {
  /** Gets a textual representation of this split. */
  string toString() { none() }
}

/**
 * Holds if split kinds `sk1` and `sk2` may overlap. That is, they may apply
 * to at least one common AST node inside `scope`.
 */
private predicate overlapping(CfgScope scope, SplitKind sk1, SplitKind sk2) {
  exists(AstNode n |
    sk1.appliesTo(n) and
    sk2.appliesTo(n) and
    scope = getCfgScope(n)
  )
}

/**
 * A split kind. Each control flow node can have at most one split of a
 * given kind.
 */
abstract private class SplitKind extends TSplitKind {
  /** Gets a split of this kind. */
  SplitImpl getASplit() { result.getKind() = this }

  /** Holds if some split of this kind applies to AST node `n`. */
  predicate appliesTo(AstNode n) { this.getASplit().appliesTo(n) }

  /**
   * Gets a unique integer representing this split kind. The integer is used
   * to represent sets of splits as ordered lists.
   */
  abstract int getListOrder();

  /** Gets the rank of this split kind among all overlapping kinds for `c`. */
  private int getRank(CfgScope scope) {
    this = rank[result](SplitKind sk | overlapping(scope, this, sk) | sk order by sk.getListOrder())
  }

  /**
   * Holds if this split kind is enabled for AST node `n`. For performance reasons,
   * the number of splits is restricted by the `maxSplits()` predicate.
   */
  predicate isEnabled(AstNode n) {
    this.appliesTo(n) and
    this.getRank(getCfgScope(n)) <= maxSplits()
  }

  /**
   * Gets the rank of this split kind among all the split kinds that apply to
   * AST node `n`. The rank is based on the order defined by `getListOrder()`.
   */
  int getListRank(AstNode n) {
    this.isEnabled(n) and
    this = rank[result](SplitKind sk | sk.appliesTo(n) | sk order by sk.getListOrder())
  }

  /** Gets a textual representation of this split kind. */
  abstract string toString();
}

// This class only exists to not pollute the externally visible `Split` class
// with internal helper predicates
abstract class SplitImpl extends Split {
  /** Gets the kind of this split. */
  abstract SplitKind getKind();

  /**
   * Holds if this split is entered when control passes from `pred` to `succ` with
   * completion `c`.
   *
   * Invariant: `hasEntry(pred, succ, c) implies succ(pred, succ, c)`.
   */
  abstract predicate hasEntry(AstNode pred, AstNode succ, Completion c);

  /**
   * Holds if this split is entered when control passes from `scope` to the entry point
   * `first`.
   *
   * Invariant: `hasEntryScope(scope, first) implies succEntry(scope, first)`.
   */
  abstract predicate hasEntryScope(CfgScope scope, AstNode first);

  /**
   * Holds if this split is left when control passes from `pred` to `succ` with
   * completion `c`.
   *
   * Invariant: `hasExit(pred, succ, c) implies succ(pred, succ, c)`.
   */
  abstract predicate hasExit(AstNode pred, AstNode succ, Completion c);

  /**
   * Holds if this split is left when control passes from `last` out of the enclosing
   * scope `scope` with completion `c`.
   *
   * Invariant: `hasExitScope(scope, last, c) implies succExit(scope, last, c)`
   */
  abstract predicate hasExitScope(CfgScope scope, AstNode last, Completion c);

  /**
   * Holds if this split is maintained when control passes from `pred` to `succ` with
   * completion `c`.
   *
   * Invariant: `hasSuccessor(pred, succ, c) implies succ(pred, succ, c)`
   */
  abstract predicate hasSuccessor(AstNode pred, AstNode succ, Completion c);

  /** Holds if this split applies to AST node `n`. */
  final predicate appliesTo(AstNode n) {
    this.hasEntry(_, n, _)
    or
    this.hasEntryScope(_, n)
    or
    exists(AstNode pred | this.appliesTo(pred) | this.hasSuccessor(pred, n, _))
  }
}

private module ConditionalCompletionSplitting {
  /**
   * A split for conditional completions. For example, in
   *
   * ```rb
   * def method x
   *   if x < 2 and x > 0
   *     puts "x is 1"
   *   end
   * end
   * ```
   *
   * we record whether `x < 2` and `x > 0` evaluate to `true` or `false`, and
   * restrict the edges out of `x < 2 and x > 0` accordingly.
   */
  class ConditionalCompletionSplit extends Split, TConditionalCompletionSplit {
    ConditionalCompletion completion;

    ConditionalCompletionSplit() { this = TConditionalCompletionSplit(completion) }

    override string toString() { result = completion.toString() }
  }

  private class ConditionalCompletionSplitKind extends SplitKind, TConditionalCompletionSplitKind {
    override int getListOrder() { result = 0 }

    override predicate isEnabled(AstNode n) { this.appliesTo(n) }

    override string toString() { result = "ConditionalCompletion" }
  }

  int getNextListOrder() { result = 1 }

  private class ConditionalCompletionSplitImpl extends SplitImpl, ConditionalCompletionSplit {
    override ConditionalCompletionSplitKind getKind() { any() }

    override predicate hasEntry(AstNode pred, AstNode succ, Completion c) {
      succ(pred, succ, c) and
      last(succ, _, completion) and
      (
        last(succ.(NotExpr).getOperand(), pred, c) and
        completion.(BooleanCompletion).getDual() = c
        or
        last(succ.(LogicalAndExpr).getAnOperand(), pred, c) and
        completion = c
        or
        last(succ.(LogicalOrExpr).getAnOperand(), pred, c) and
        completion = c
        or
        last(succ.(StmtSequence).getLastStmt(), pred, c) and
        completion = c
        or
        last(succ.(ConditionalExpr).getBranch(_), pred, c) and
        completion = c
      )
    }

    override predicate hasEntryScope(CfgScope scope, AstNode succ) { none() }

    override predicate hasExit(AstNode pred, AstNode succ, Completion c) {
      this.appliesTo(pred) and
      succ(pred, succ, c) and
      if c instanceof ConditionalCompletion then completion = c else any()
    }

    override predicate hasExitScope(CfgScope scope, AstNode last, Completion c) {
      this.appliesTo(last) and
      succExit(scope, last, c) and
      if c instanceof ConditionalCompletion then completion = c else any()
    }

    override predicate hasSuccessor(AstNode pred, AstNode succ, Completion c) { none() }
  }
}

module EnsureSplitting {
  /**
   * The type of a split `ensure` node.
   *
   * The type represents one of the possible ways of entering an `ensure`
   * block. For example, if a block ends with a `return` statement, then
   * the `ensure` block must end with a `return` as well (provided that
   * the `ensure` block executes normally).
   */
  class EnsureSplitType extends SuccessorType {
    EnsureSplitType() { not this instanceof ConditionalSuccessor }

    /** Holds if this split type matches entry into an `ensure` block with completion `c`. */
    predicate isSplitForEntryCompletion(Completion c) {
      if c instanceof NormalCompletion
      then
        // If the entry into the `ensure` block completes with any normal completion,
        // it simply means normal execution after the `ensure` block
        this instanceof NormalSuccessor
      else this = c.getAMatchingSuccessorType()
    }
  }

  /** A node that belongs to an `ensure` block. */
  private class EnsureNode extends AstNode {
    private Trees::BodyStmtTree block;

    EnsureNode() { this = block.getAnEnsureDescendant() }

    int getNestLevel() { result = block.getNestLevel() }

    /** Holds if this node is the entry node in the `ensure` block it belongs to. */
    predicate isEntryNode() { first(block.getEnsure(), this) }
  }

  /**
   * A split for nodes belonging to an `ensure` block, which determines how to
   * continue execution after leaving the `ensure` block. For example, in
   *
   * ```rb
   * begin
   *   if x
   *     raise "Exception"
   *   end
   * ensure
   *   puts "Ensure"
   * end
   * ```
   *
   * all control flow nodes in the `ensure` block have two splits: one representing
   * normal execution of the body (when `x` evaluates to `true`), and one representing
   * exceptional execution of the body (when `x` evaluates to `false`).
   */
  class EnsureSplit extends Split, TEnsureSplit {
    private EnsureSplitType type;
    private int nestLevel;

    EnsureSplit() { this = TEnsureSplit(type, nestLevel) }

    /**
     * Gets the type of this `ensure` split, that is, how to continue execution after the
     * `ensure` block.
     */
    EnsureSplitType getType() { result = type }

    /** Gets the nesting level. */
    int getNestLevel() { result = nestLevel }

    override string toString() {
      if type instanceof NormalSuccessor
      then result = ""
      else
        if nestLevel > 0
        then result = "ensure(" + nestLevel + "): " + type.toString()
        else result = "ensure: " + type.toString()
    }
  }

  private int getListOrder(EnsureSplitKind kind) {
    result = ConditionalCompletionSplitting::getNextListOrder() + kind.getNestLevel()
  }

  int getNextListOrder() {
    result = max([getListOrder(_) + 1, ConditionalCompletionSplitting::getNextListOrder()])
  }

  private class EnsureSplitKind extends SplitKind, TEnsureSplitKind {
    private int nestLevel;

    EnsureSplitKind() { this = TEnsureSplitKind(nestLevel) }

    /** Gets the nesting level. */
    int getNestLevel() { result = nestLevel }

    override int getListOrder() { result = getListOrder(this) }

    override string toString() { result = "ensure (" + nestLevel + ")" }
  }

  pragma[noinline]
  private predicate hasEntry0(AstNode pred, EnsureNode succ, int nestLevel, Completion c) {
    succ.isEntryNode() and
    nestLevel = succ.getNestLevel() and
    succ(pred, succ, c)
  }

  private class EnsureSplitImpl extends SplitImpl, EnsureSplit {
    override EnsureSplitKind getKind() { result.getNestLevel() = this.getNestLevel() }

    override predicate hasEntry(AstNode pred, AstNode succ, Completion c) {
      hasEntry0(pred, succ, this.getNestLevel(), c) and
      this.getType().isSplitForEntryCompletion(c)
    }

    override predicate hasEntryScope(CfgScope scope, AstNode first) { none() }

    /**
     * Holds if this split applies to `pred`, where `pred` is a valid predecessor.
     */
    private predicate appliesToPredecessor(AstNode pred) {
      this.appliesTo(pred) and
      (succ(pred, _, _) or succExit(_, pred, _))
    }

    pragma[noinline]
    private predicate exit0(AstNode pred, Trees::BodyStmtTree block, int nestLevel, Completion c) {
      this.appliesToPredecessor(pred) and
      nestLevel = block.getNestLevel() and
      block.lastInner(pred, c)
    }

    /**
     * Holds if `pred` may exit this split with completion `c`. The Boolean
     * `inherited` indicates whether `c` is an inherited completion from the
     * body.
     */
    private predicate exit(Trees::BodyStmtTree block, AstNode pred, Completion c, boolean inherited) {
      exists(EnsureSplitType type |
        exit0(pred, block, this.getNestLevel(), c) and
        type = this.getType()
      |
        if last(block.getEnsure(), pred, c)
        then
          // `ensure` block can itself exit with completion `c`: either `c` must
          // match this split, `c` must be an abnormal completion, or this split
          // does not require another completion to be recovered
          inherited = false and
          (
            type = c.getAMatchingSuccessorType()
            or
            not c instanceof NormalCompletion
            or
            type instanceof NormalSuccessor
          )
        else (
          // `ensure` block can exit with inherited completion `c`, which must
          // match this split
          inherited = true and
          type = c.getAMatchingSuccessorType() and
          not type instanceof NormalSuccessor
        )
      )
      or
      // If this split is normal, and an outer split can exit based on an inherited
      // completion, we need to exit this split as well. For example, in
      //
      // ```rb
      // def m(b1, b2)
      //   if b1
      //     return
      //   end
      // ensure
      //   begin
      //     if b2
      //       raise "Exception"
      //     end
      //   ensure
      //     puts "inner ensure"
      //   end
      // end
      // ```
      //
      // if the outer split for `puts "inner ensure"` is `return` and the inner split
      // is "normal" (corresponding to `b1 = true` and `b2 = false`), then the inner
      // split must be able to exit with a `return` completion.
      this.appliesToPredecessor(pred) and
      exists(EnsureSplitImpl outer |
        outer.getNestLevel() = this.getNestLevel() - 1 and
        outer.exit(_, pred, c, inherited) and
        this.getType() instanceof NormalSuccessor and
        inherited = true
      )
    }

    override predicate hasExit(AstNode pred, AstNode succ, Completion c) {
      succ(pred, succ, c) and
      (
        exit(_, pred, c, _)
        or
        exit(_, pred, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion(), _)
      )
    }

    override predicate hasExitScope(CfgScope scope, AstNode last, Completion c) {
      succExit(scope, last, c) and
      (
        exit(_, last, c, _)
        or
        exit(_, last, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion(), _)
      )
    }

    override predicate hasSuccessor(AstNode pred, AstNode succ, Completion c) {
      this.appliesToPredecessor(pred) and
      succ(pred, succ, c) and
      succ =
        any(EnsureNode en |
          if en.isEntryNode()
          then
            // entering a nested `ensure` block
            en.getNestLevel() > this.getNestLevel()
          else
            // staying in the same (possibly nested) `ensure` block as `pred`
            en.getNestLevel() >= this.getNestLevel()
        )
    }
  }
}

/**
 * A set of control flow node splits. The set is represented by a list of splits,
 * ordered by ascending rank.
 */
class Splits extends TSplits {
  /** Gets a textual representation of this set of splits. */
  string toString() { result = splitsToString(this) }

  /** Gets a split belonging to this set of splits. */
  SplitImpl getASplit() {
    exists(SplitImpl head, Splits tail | this = TSplitsCons(head, tail) |
      result = head
      or
      result = tail.getASplit()
    )
  }
}

private predicate succEntrySplitsFromRank(CfgScope pred, AstNode succ, Splits splits, int rnk) {
  splits = TSplitsNil() and
  succEntry(pred, succ) and
  rnk = 0
  or
  exists(SplitImpl head, Splits tail | succEntrySplitsCons(pred, succ, head, tail, rnk) |
    splits = TSplitsCons(head, tail)
  )
}

private predicate succEntrySplitsCons(
  CfgScope pred, AstNode succ, SplitImpl head, Splits tail, int rnk
) {
  succEntrySplitsFromRank(pred, succ, tail, rnk - 1) and
  head.hasEntryScope(pred, succ) and
  rnk = head.getKind().getListRank(succ)
}

/**
 * Holds if `succ` with splits `succSplits` is the first element that is executed
 * when entering scope `pred`.
 */
pragma[noinline]
predicate succEntrySplits(CfgScope pred, AstNode succ, Splits succSplits, SuccessorType t) {
  exists(int rnk |
    succEntry(pred, succ) and
    t instanceof NormalSuccessor and
    succEntrySplitsFromRank(pred, succ, succSplits, rnk)
  |
    rnk = 0 and
    not any(SplitImpl split).hasEntryScope(pred, succ)
    or
    rnk = max(SplitImpl split | split.hasEntryScope(pred, succ) | split.getKind().getListRank(succ))
  )
}

/**
 * Holds if `last` with splits `predSplits` can exit the enclosing scope
 * `scope` with type `t`.
 */
predicate succExitSplits(AstNode last, Splits predSplits, CfgScope scope, SuccessorType t) {
  exists(Reachability::SameSplitsBlock b, Completion c | last = b.getANode() |
    b.isReachable(predSplits) and
    t = c.getAMatchingSuccessorType() and
    succExit(scope, last, c) and
    forall(SplitImpl predSplit | predSplit = predSplits.getASplit() |
      predSplit.hasExitScope(scope, last, c)
    )
  )
}

/**
 * Provides a predicate for the successor relation with split information,
 * as well as logic used to construct the type `TSplits` representing sets
 * of splits. Only sets of splits that can be reached are constructed, hence
 * the predicates are mutually recursive.
 *
 * For the successor relation
 *
 * ```ql
 * succSplits(AstNode pred, Splits predSplits, AstNode succ, Splits succSplits, Completion c)
 * ```
 *
 * the following invariants are maintained:
 *
 * 1. `pred` is reachable with split set `predSplits`.
 * 2. For all `split` in `predSplits`:
 *    - If `split.hasSuccessor(pred, succ, c)` then `split` in `succSplits`.
 * 3. For all `split` in `predSplits`:
 *    - If `split.hasExit(pred, succ, c)` and not `split.hasEntry(pred, succ, c)` then
 *      `split` not in `succSplits`.
 * 4. For all `split` with kind not in `predSplits`:
 *    - If `split.hasEntry(pred, succ, c)` then `split` in `succSplits`.
 * 5. For all `split` in `succSplits`:
 *    - `split.hasSuccessor(pred, succ, c)` and `split` in `predSplits`, or
 *    - `split.hasEntry(pred, succ, c)`.
 *
 * The algorithm divides into four cases:
 *
 * 1. The set of splits for the successor is the same as the set of splits
 *    for the predecessor:
 *    a) The successor is in the same `SameSplitsBlock` as the predecessor.
 *    b) The successor is *not* in the same `SameSplitsBlock` as the predecessor.
 * 2. The set of splits for the successor is different from the set of splits
 *    for the predecessor:
 *    a) The set of splits for the successor is *maybe* non-empty.
 *    b) The set of splits for the successor is *always* empty.
 *
 * Only case 2a may introduce new sets of splits, so only predicates from
 * this case are used in the definition of `TSplits`.
 *
 * The predicates in this module are named after the cases above.
 */
private module SuccSplits {
  private predicate succInvariant1(
    Reachability::SameSplitsBlock b, AstNode pred, Splits predSplits, AstNode succ, Completion c
  ) {
    pred = b.getANode() and
    b.isReachable(predSplits) and
    succ(pred, succ, c)
  }

  private predicate case1b0(AstNode pred, Splits predSplits, AstNode succ, Completion c) {
    exists(Reachability::SameSplitsBlock b |
      // Invariant 1
      succInvariant1(b, pred, predSplits, succ, c)
    |
      (succ = b.getANode() implies succ = b) and
      // Invariant 4
      not exists(SplitImpl split | split.hasEntry(pred, succ, c))
    )
  }

  /**
   * Case 1b.
   *
   * Invariants 1 and 4 hold in the base case, and invariants 2, 3, and 5 are
   * maintained for all splits in `predSplits` (= `succSplits`), except
   * possibly for the splits in `except`.
   *
   * The predicate is written using explicit recursion, as opposed to a `forall`,
   * to avoid negative recursion.
   */
  private predicate case1bForall(
    AstNode pred, Splits predSplits, AstNode succ, Completion c, Splits except
  ) {
    case1b0(pred, predSplits, succ, c) and
    except = predSplits
    or
    exists(SplitImpl split |
      case1bForallCons(pred, predSplits, succ, c, split, except) and
      split.hasSuccessor(pred, succ, c)
    )
  }

  pragma[noinline]
  private predicate case1bForallCons(
    AstNode pred, Splits predSplits, AstNode succ, Completion c, SplitImpl exceptHead,
    Splits exceptTail
  ) {
    case1bForall(pred, predSplits, succ, c, TSplitsCons(exceptHead, exceptTail))
  }

  private predicate case1(AstNode pred, Splits predSplits, AstNode succ, Completion c) {
    // Case 1a
    exists(Reachability::SameSplitsBlock b | succInvariant1(b, pred, predSplits, succ, c) |
      succ = b.getANode() and
      not succ = b
    )
    or
    // Case 1b
    case1bForall(pred, predSplits, succ, c, TSplitsNil())
  }

  pragma[noinline]
  private SplitImpl succInvariant1GetASplit(
    Reachability::SameSplitsBlock b, AstNode pred, Splits predSplits, AstNode succ, Completion c
  ) {
    succInvariant1(b, pred, predSplits, succ, c) and
    result = predSplits.getASplit()
  }

  private predicate case2aux(AstNode pred, Splits predSplits, AstNode succ, Completion c) {
    exists(Reachability::SameSplitsBlock b |
      succInvariant1(b, pred, predSplits, succ, c) and
      (succ = b.getANode() implies succ = b)
    |
      succInvariant1GetASplit(b, pred, predSplits, succ, c).hasExit(pred, succ, c)
      or
      any(SplitImpl split).hasEntry(pred, succ, c)
    )
  }

  /**
   * Holds if `succSplits` should not inherit a split of kind `sk` from
   * `predSplits`, except possibly because of a split in `except`.
   *
   * The predicate is written using explicit recursion, as opposed to a `forall`,
   * to avoid negative recursion.
   */
  private predicate case2aNoneInheritedOfKindForall(
    AstNode pred, Splits predSplits, AstNode succ, Completion c, SplitKind sk, Splits except
  ) {
    case2aux(pred, predSplits, succ, c) and
    sk.appliesTo(succ) and
    except = predSplits
    or
    exists(Splits mid, SplitImpl split |
      case2aNoneInheritedOfKindForall(pred, predSplits, succ, c, sk, mid) and
      mid = TSplitsCons(split, except)
    |
      split.getKind() = any(SplitKind sk0 | sk0 != sk and sk0.appliesTo(succ))
      or
      split.hasExit(pred, succ, c)
    )
  }

  pragma[nomagic]
  private predicate entryOfKind(
    AstNode pred, AstNode succ, Completion c, SplitImpl split, SplitKind sk
  ) {
    split.hasEntry(pred, succ, c) and
    sk = split.getKind()
  }

  /** Holds if `succSplits` should not have a split of kind `sk`. */
  pragma[nomagic]
  private predicate case2aNoneOfKind(
    AstNode pred, Splits predSplits, AstNode succ, Completion c, SplitKind sk
  ) {
    // None inherited from predecessor
    case2aNoneInheritedOfKindForall(pred, predSplits, succ, c, sk, TSplitsNil()) and
    // None newly entered into
    not entryOfKind(pred, succ, c, _, sk)
  }

  /** Holds if `succSplits` should not have a split of kind `sk` at rank `rnk`. */
  pragma[nomagic]
  private predicate case2aNoneAtRank(
    AstNode pred, Splits predSplits, AstNode succ, Completion c, int rnk
  ) {
    exists(SplitKind sk | case2aNoneOfKind(pred, predSplits, succ, c, sk) |
      rnk = sk.getListRank(succ)
    )
  }

  pragma[nomagic]
  private SplitImpl case2auxGetAPredecessorSplit(
    AstNode pred, Splits predSplits, AstNode succ, Completion c
  ) {
    case2aux(pred, predSplits, succ, c) and
    result = predSplits.getASplit()
  }

  /** Gets a split that should be in `succSplits`. */
  pragma[nomagic]
  private SplitImpl case2aSome(
    AstNode pred, Splits predSplits, AstNode succ, Completion c, SplitKind sk
  ) {
    (
      // Inherited from predecessor
      result = case2auxGetAPredecessorSplit(pred, predSplits, succ, c) and
      result.hasSuccessor(pred, succ, c)
      or
      // Newly entered into
      exists(SplitKind sk0 |
        case2aNoneInheritedOfKindForall(pred, predSplits, succ, c, sk0, TSplitsNil())
      |
        entryOfKind(pred, succ, c, result, sk0)
      )
    ) and
    sk = result.getKind()
  }

  /** Gets a split that should be in `succSplits` at rank `rnk`. */
  pragma[nomagic]
  SplitImpl case2aSomeAtRank(AstNode pred, Splits predSplits, AstNode succ, Completion c, int rnk) {
    exists(SplitKind sk | result = case2aSome(pred, predSplits, succ, c, sk) |
      rnk = sk.getListRank(succ)
    )
  }

  /**
   * Case 2a.
   *
   * As opposed to the other cases, in this case we need to construct a new set
   * of splits `succSplits`. Since this involves constructing the very IPA type,
   * we cannot recurse directly over the structure of `succSplits`. Instead, we
   * recurse over the ranks of all splits that *might* be in `succSplits`.
   *
   * - Invariant 1 holds in the base case,
   * - invariant 2 holds for all splits with rank at least `rnk`,
   * - invariant 3 holds for all splits in `predSplits`,
   * - invariant 4 holds for all splits in `succSplits` with rank at least `rnk`,
   *   and
   * - invariant 4 holds for all splits in `succSplits` with rank at least `rnk`.
   */
  predicate case2aFromRank(
    AstNode pred, Splits predSplits, AstNode succ, Splits succSplits, Completion c, int rnk
  ) {
    case2aux(pred, predSplits, succ, c) and
    succSplits = TSplitsNil() and
    rnk = max(any(SplitKind sk).getListRank(succ)) + 1
    or
    case2aFromRank(pred, predSplits, succ, succSplits, c, rnk + 1) and
    case2aNoneAtRank(pred, predSplits, succ, c, rnk)
    or
    exists(Splits mid, SplitImpl split | split = case2aCons(pred, predSplits, succ, mid, c, rnk) |
      succSplits = TSplitsCons(split, mid)
    )
  }

  pragma[noinline]
  private SplitImpl case2aCons(
    AstNode pred, Splits predSplits, AstNode succ, Splits succSplits, Completion c, int rnk
  ) {
    case2aFromRank(pred, predSplits, succ, succSplits, c, rnk + 1) and
    result = case2aSomeAtRank(pred, predSplits, succ, c, rnk)
  }

  /**
   * Case 2b.
   *
   * Invariants 1, 4, and 5 hold in the base case, and invariants 2 and 3 are
   * maintained for all splits in `predSplits`, except possibly for the splits
   * in `except`.
   *
   * The predicate is written using explicit recursion, as opposed to a `forall`,
   * to avoid negative recursion.
   */
  private predicate case2bForall(
    AstNode pred, Splits predSplits, AstNode succ, Completion c, Splits except
  ) {
    // Invariant 1
    case2aux(pred, predSplits, succ, c) and
    // Invariants 4 and 5
    not any(SplitKind sk).appliesTo(succ) and
    except = predSplits
    or
    exists(SplitImpl split | case2bForallCons(pred, predSplits, succ, c, split, except) |
      // Invariants 2 and 3
      split.hasExit(pred, succ, c)
    )
  }

  pragma[noinline]
  private predicate case2bForallCons(
    AstNode pred, Splits predSplits, AstNode succ, Completion c, SplitImpl exceptHead,
    Splits exceptTail
  ) {
    case2bForall(pred, predSplits, succ, c, TSplitsCons(exceptHead, exceptTail))
  }

  private predicate case2(
    AstNode pred, Splits predSplits, AstNode succ, Splits succSplits, Completion c
  ) {
    case2aFromRank(pred, predSplits, succ, succSplits, c, 1)
    or
    case2bForall(pred, predSplits, succ, c, TSplitsNil()) and
    succSplits = TSplitsNil()
  }

  /**
   * Holds if `succ` with splits `succSplits` is a successor of type `t` for `pred`
   * with splits `predSplits`.
   */
  predicate succSplits(
    AstNode pred, Splits predSplits, AstNode succ, Splits succSplits, Completion c
  ) {
    case1(pred, predSplits, succ, c) and
    succSplits = predSplits
    or
    case2(pred, predSplits, succ, succSplits, c)
  }
}

import SuccSplits

/** Provides logic for calculating reachable control flow nodes. */
module Reachability {
  /**
   * Holds if `n` is an AST node where the set of possible splits may be different
   * from the set of possible splits for one of `n`'s predecessors. That is, `n`
   * starts a new block of elements with the same set of splits.
   */
  private predicate startsSplits(AstNode n) {
    succEntry(_, n)
    or
    exists(SplitImpl s |
      s.hasEntry(_, n, _)
      or
      s.hasExit(_, n, _)
    )
    or
    exists(AstNode pred, SplitImpl split, Completion c | succ(pred, n, c) |
      split.appliesTo(pred) and
      not split.hasSuccessor(pred, n, c)
    )
  }

  private predicate intraSplitsSucc(AstNode pred, AstNode succ) {
    succ(pred, succ, _) and
    not startsSplits(succ)
  }

  private predicate splitsBlockContains(AstNode start, AstNode n) =
    fastTC(intraSplitsSucc/2)(start, n)

  /**
   * A block of AST nodes where the set of splits is guaranteed to remain unchanged,
   * represented by the first element in the block.
   */
  class SameSplitsBlock extends AstNode {
    SameSplitsBlock() { startsSplits(this) }

    /** Gets an AST node in this block. */
    AstNode getANode() {
      splitsBlockContains(this, result)
      or
      result = this
    }

    pragma[noinline]
    private SameSplitsBlock getASuccessor(Splits predSplits, Splits succSplits) {
      exists(AstNode pred | pred = this.getANode() |
        succSplits(pred, predSplits, result, succSplits, _)
      )
    }

    /**
     * Holds if the elements of this block are reachable from an point, with the
     * splits `splits`.
     */
    predicate isReachable(Splits splits) {
      // Base case
      succEntrySplits(_, this, splits, _)
      or
      // Recursive case
      exists(SameSplitsBlock pred, Splits predSplits | pred.isReachable(predSplits) |
        this = pred.getASuccessor(predSplits, splits)
      )
    }
  }
}
