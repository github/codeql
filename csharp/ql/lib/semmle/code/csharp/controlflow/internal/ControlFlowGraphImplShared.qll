/** Provides language-independent definitions for AST-to-CFG construction. */

private import ControlFlowGraphImplSpecific

/** An element with associated control flow. */
abstract class ControlFlowTree extends ControlFlowTreeBase {
  /** Holds if `first` is the first element executed within this element. */
  pragma[nomagic]
  abstract predicate first(ControlFlowElement first);

  /**
   * Holds if `last` with completion `c` is a potential last element executed
   * within this element.
   */
  pragma[nomagic]
  abstract predicate last(ControlFlowElement last, Completion c);

  /** Holds if abnormal execution of `child` should propagate upwards. */
  abstract predicate propagatesAbnormal(ControlFlowElement child);

  /**
   * Holds if `succ` is a control flow successor for `pred`, given that `pred`
   * finishes with completion `c`.
   */
  pragma[nomagic]
  abstract predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c);
}

/**
 * Holds if `first` is the first element executed within control flow
 * element `cft`.
 */
predicate first(ControlFlowTree cft, ControlFlowElement first) { cft.first(first) }

/**
 * Holds if `last` with completion `c` is a potential last element executed
 * within control flow element `cft`.
 */
predicate last(ControlFlowTree cft, ControlFlowElement last, Completion c) {
  cft.last(last, c)
  or
  exists(ControlFlowElement cfe |
    cft.propagatesAbnormal(cfe) and
    last(cfe, last, c) and
    not completionIsNormal(c)
  )
}

/**
 * Holds if `succ` is a control flow successor for `pred`, given that `pred`
 * finishes with completion `c`.
 */
pragma[nomagic]
predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
  any(ControlFlowTree cft).succ(pred, succ, c)
}

/** An element that is executed in pre-order. */
abstract class PreOrderTree extends ControlFlowTree {
  final override predicate first(ControlFlowElement first) { first = this }
}

/** An element that is executed in post-order. */
abstract class PostOrderTree extends ControlFlowTree {
  override predicate last(ControlFlowElement last, Completion c) {
    last = this and
    completionIsValidFor(c, last)
  }
}

/**
 * An element where the children are evaluated following a standard left-to-right
 * evaluation. The actual evaluation order is determined by the predicate
 * `getChildElement()`.
 */
abstract class StandardTree extends ControlFlowTree {
  /** Gets the `i`th child element, in order of evaluation. */
  abstract ControlFlowElement getChildElement(int i);

  private ControlFlowElement getChildElementRanked(int i) {
    result =
      rank[i + 1](ControlFlowElement child, int j |
        child = this.getChildElement(j)
      |
        child order by j
      )
  }

  /** Gets the first child node of this element. */
  final ControlFlowElement getFirstChildElement() { result = this.getChildElementRanked(0) }

  /** Gets the last child node of this node. */
  final ControlFlowElement getLastChildElement() {
    exists(int last |
      result = this.getChildElementRanked(last) and
      not exists(this.getChildElementRanked(last + 1))
    )
  }

  /** Holds if this element has no children. */
  predicate isLeafElement() { not exists(this.getFirstChildElement()) }

  override predicate propagatesAbnormal(ControlFlowElement child) {
    child = this.getChildElement(_)
  }

  pragma[nomagic]
  override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
    exists(int i |
      last(this.getChildElementRanked(i), pred, c) and
      completionIsNormal(c) and
      first(this.getChildElementRanked(i + 1), succ)
    )
  }
}

/** A standard element that is executed in pre-order. */
abstract class StandardPreOrderTree extends StandardTree, PreOrderTree {
  override predicate last(ControlFlowElement last, Completion c) {
    last(this.getLastChildElement(), last, c)
    or
    this.isLeafElement() and
    completionIsValidFor(c, this) and
    last = this
  }

  override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
    StandardTree.super.succ(pred, succ, c)
    or
    pred = this and
    first(this.getFirstChildElement(), succ) and
    completionIsSimple(c)
  }
}

/** A standard element that is executed in post-order. */
abstract class StandardPostOrderTree extends StandardTree, PostOrderTree {
  override predicate first(ControlFlowElement first) {
    first(this.getFirstChildElement(), first)
    or
    not exists(this.getFirstChildElement()) and
    first = this
  }

  override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
    StandardTree.super.succ(pred, succ, c)
    or
    last(this.getLastChildElement(), pred, c) and
    succ = this and
    completionIsNormal(c)
  }
}

/** An element that is a leaf in the control flow graph. */
abstract class LeafTree extends PreOrderTree, PostOrderTree {
  override predicate propagatesAbnormal(ControlFlowElement child) { none() }

  override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) { none() }
}

/**
 * Holds if split kinds `sk1` and `sk2` may overlap. That is, they may apply
 * to at least one common AST node inside `scope`.
 */
private predicate overlapping(CfgScope scope, SplitKind sk1, SplitKind sk2) {
  exists(ControlFlowElement e |
    sk1.appliesTo(e) and
    sk2.appliesTo(e) and
    scope = getCfgScope(e)
  )
}

/**
 * A split kind. Each control flow node can have at most one split of a
 * given kind.
 */
abstract class SplitKind extends SplitKindBase {
  /** Gets a split of this kind. */
  SplitImpl getASplit() { result.getKind() = this }

  /** Holds if some split of this kind applies to AST node `n`. */
  predicate appliesTo(ControlFlowElement n) { this.getASplit().appliesTo(n) }

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
  predicate isEnabled(ControlFlowElement n) {
    this.appliesTo(n) and
    this.getRank(getCfgScope(n)) <= maxSplits()
  }

  /**
   * Gets the rank of this split kind among all the split kinds that apply to
   * AST node `n`. The rank is based on the order defined by `getListOrder()`.
   */
  int getListRank(ControlFlowElement n) {
    this.isEnabled(n) and
    this = rank[result](SplitKind sk | sk.appliesTo(n) | sk order by sk.getListOrder())
  }

  /** Gets a textual representation of this split kind. */
  abstract string toString();
}

/** An interface for implementing an entity to split on. */
abstract class SplitImpl extends Split {
  /** Gets the kind of this split. */
  abstract SplitKind getKind();

  /**
   * Holds if this split is entered when control passes from `pred` to `succ` with
   * completion `c`.
   *
   * Invariant: `hasEntry(pred, succ, c) implies succ(pred, succ, c)`.
   */
  abstract predicate hasEntry(ControlFlowElement pred, ControlFlowElement succ, Completion c);

  /**
   * Holds if this split is entered when control passes from `scope` to the entry point
   * `first`.
   *
   * Invariant: `hasEntryScope(scope, first) implies scopeFirst(scope, first)`.
   */
  abstract predicate hasEntryScope(CfgScope scope, ControlFlowElement first);

  /**
   * Holds if this split is left when control passes from `pred` to `succ` with
   * completion `c`.
   *
   * Invariant: `hasExit(pred, succ, c) implies succ(pred, succ, c)`.
   */
  abstract predicate hasExit(ControlFlowElement pred, ControlFlowElement succ, Completion c);

  /**
   * Holds if this split is left when control passes from `last` out of the enclosing
   * scope `scope` with completion `c`.
   *
   * Invariant: `hasExitScope(scope, last, c) implies scopeLast(scope, last, c)`
   */
  abstract predicate hasExitScope(CfgScope scope, ControlFlowElement last, Completion c);

  /**
   * Holds if this split is maintained when control passes from `pred` to `succ` with
   * completion `c`.
   *
   * Invariant: `hasSuccessor(pred, succ, c) implies succ(pred, succ, c)`
   */
  abstract predicate hasSuccessor(ControlFlowElement pred, ControlFlowElement succ, Completion c);

  /** Holds if this split applies to control flow element `cfe`. */
  final predicate appliesTo(ControlFlowElement cfe) {
    this.hasEntry(_, cfe, _)
    or
    this.hasEntryScope(_, cfe)
    or
    exists(ControlFlowElement pred | this.appliesTo(pred) | this.hasSuccessor(pred, cfe, _))
  }

  /** The `succ` relation restricted to predecessors `pred` that this split applies to. */
  pragma[noinline]
  final predicate appliesSucc(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
    this.appliesTo(pred) and
    succ(pred, succ, c)
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

private predicate succEntrySplitsFromRank(
  CfgScope pred, ControlFlowElement succ, Splits splits, int rnk
) {
  splits = TSplitsNil() and
  scopeFirst(pred, succ) and
  rnk = 0
  or
  exists(SplitImpl head, Splits tail | succEntrySplitsCons(pred, succ, head, tail, rnk) |
    splits = TSplitsCons(head, tail)
  )
}

private predicate succEntrySplitsCons(
  CfgScope pred, ControlFlowElement succ, SplitImpl head, Splits tail, int rnk
) {
  succEntrySplitsFromRank(pred, succ, tail, rnk - 1) and
  head.hasEntryScope(pred, succ) and
  rnk = head.getKind().getListRank(succ)
}

/**
 * Holds if `succ` with splits `succSplits` is the first element that is executed
 * when entering callable `pred`.
 */
pragma[noinline]
private predicate succEntrySplits(
  CfgScope pred, ControlFlowElement succ, Splits succSplits, SuccessorType t
) {
  exists(int rnk |
    scopeFirst(pred, succ) and
    successorTypeIsSimple(t) and
    succEntrySplitsFromRank(pred, succ, succSplits, rnk)
  |
    rnk = 0 and
    not any(SplitImpl split).hasEntryScope(pred, succ)
    or
    rnk = max(SplitImpl split | split.hasEntryScope(pred, succ) | split.getKind().getListRank(succ))
  )
}

/**
 * Holds if `pred` with splits `predSplits` can exit the enclosing callable
 * `succ` with type `t`.
 */
private predicate succExitSplits(
  ControlFlowElement pred, Splits predSplits, CfgScope succ, SuccessorType t
) {
  exists(Reachability::SameSplitsBlock b, Completion c | pred = b.getAnElement() |
    b.isReachable(succ, predSplits) and
    t = getAMatchingSuccessorType(c) and
    scopeLast(succ, pred, c) and
    forall(SplitImpl predSplit | predSplit = predSplits.getASplit() |
      predSplit.hasExitScope(succ, pred, c)
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
 * succSplits(ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits, Completion c)
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
    Reachability::SameSplitsBlock b, ControlFlowElement pred, Splits predSplits,
    ControlFlowElement succ, Completion c
  ) {
    pred = b.getAnElement() and
    b.isReachable(_, predSplits) and
    succ(pred, succ, c)
  }

  private predicate case1b0(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c
  ) {
    exists(Reachability::SameSplitsBlock b |
      // Invariant 1
      succInvariant1(b, pred, predSplits, succ, c)
    |
      (succ = b.getAnElement() implies succ = b) and
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
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c, Splits except
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
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c,
    SplitImpl exceptHead, Splits exceptTail
  ) {
    case1bForall(pred, predSplits, succ, c, TSplitsCons(exceptHead, exceptTail))
  }

  private predicate case1(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c
  ) {
    // Case 1a
    exists(Reachability::SameSplitsBlock b | succInvariant1(b, pred, predSplits, succ, c) |
      succ = b.getAnElement() and
      not succ = b
    )
    or
    // Case 1b
    case1bForall(pred, predSplits, succ, c, TSplitsNil())
  }

  pragma[noinline]
  private SplitImpl succInvariant1GetASplit(
    Reachability::SameSplitsBlock b, ControlFlowElement pred, Splits predSplits,
    ControlFlowElement succ, Completion c
  ) {
    succInvariant1(b, pred, predSplits, succ, c) and
    result = predSplits.getASplit()
  }

  private predicate case2aux(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c
  ) {
    exists(Reachability::SameSplitsBlock b |
      succInvariant1(b, pred, predSplits, succ, c) and
      (succ = b.getAnElement() implies succ = b)
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
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c, SplitKind sk,
    Splits except
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
    ControlFlowElement pred, ControlFlowElement succ, Completion c, SplitImpl split, SplitKind sk
  ) {
    split.hasEntry(pred, succ, c) and
    sk = split.getKind()
  }

  /** Holds if `succSplits` should not have a split of kind `sk`. */
  pragma[nomagic]
  private predicate case2aNoneOfKind(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c, SplitKind sk
  ) {
    // None inherited from predecessor
    case2aNoneInheritedOfKindForall(pred, predSplits, succ, c, sk, TSplitsNil()) and
    // None newly entered into
    not entryOfKind(pred, succ, c, _, sk)
  }

  /** Holds if `succSplits` should not have a split of kind `sk` at rank `rnk`. */
  pragma[nomagic]
  private predicate case2aNoneAtRank(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c, int rnk
  ) {
    exists(SplitKind sk | case2aNoneOfKind(pred, predSplits, succ, c, sk) |
      rnk = sk.getListRank(succ)
    )
  }

  pragma[nomagic]
  private SplitImpl case2auxGetAPredecessorSplit(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c
  ) {
    case2aux(pred, predSplits, succ, c) and
    result = predSplits.getASplit()
  }

  /** Gets a split that should be in `succSplits`. */
  pragma[nomagic]
  private SplitImpl case2aSome(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c, SplitKind sk
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
  SplitImpl case2aSomeAtRank(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c, int rnk
  ) {
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
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
    Completion c, int rnk
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
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
    Completion c, int rnk
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
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c, Splits except
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
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c,
    SplitImpl exceptHead, Splits exceptTail
  ) {
    case2bForall(pred, predSplits, succ, c, TSplitsCons(exceptHead, exceptTail))
  }

  private predicate case2(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
    Completion c
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
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
    Completion c
  ) {
    case1(pred, predSplits, succ, c) and
    succSplits = predSplits
    or
    case2(pred, predSplits, succ, succSplits, c)
  }
}

import SuccSplits

/** Provides logic for calculating reachable control flow nodes. */
private module Reachability {
  /**
   * Holds if `cfe` is a control flow element where the set of possible splits may
   * be different from the set of possible splits for one of `cfe`'s predecessors.
   * That is, `cfe` starts a new block of elements with the same set of splits.
   */
  private predicate startsSplits(ControlFlowElement cfe) {
    scopeFirst(_, cfe)
    or
    exists(SplitImpl s |
      s.hasEntry(_, cfe, _)
      or
      s.hasExit(_, cfe, _)
    )
    or
    exists(ControlFlowElement pred, SplitImpl split, Completion c | succ(pred, cfe, c) |
      split.appliesTo(pred) and
      not split.hasSuccessor(pred, cfe, c)
    )
  }

  private predicate intraSplitsSucc(ControlFlowElement pred, ControlFlowElement succ) {
    succ(pred, succ, _) and
    not startsSplits(succ)
  }

  private predicate splitsBlockContains(ControlFlowElement start, ControlFlowElement cfe) =
    fastTC(intraSplitsSucc/2)(start, cfe)

  /**
   * A block of control flow elements where the set of splits is guaranteed
   * to remain unchanged, represented by the first element in the block.
   */
  class SameSplitsBlock extends ControlFlowElement {
    SameSplitsBlock() { startsSplits(this) }

    /** Gets a control flow element in this block. */
    ControlFlowElement getAnElement() {
      splitsBlockContains(this, result)
      or
      result = this
    }

    pragma[noinline]
    private SameSplitsBlock getASuccessor(Splits predSplits, Splits succSplits) {
      exists(ControlFlowElement pred | pred = this.getAnElement() |
        succSplits(pred, predSplits, result, succSplits, _)
      )
    }

    /**
     * Holds if the elements of this block are reachable from a callable entry
     *  point, with the splits `splits`.
     */
    predicate isReachable(CfgScope scope, Splits splits) {
      // Base case
      succEntrySplits(scope, this, splits, _)
      or
      // Recursive case
      exists(SameSplitsBlock pred, Splits predSplits | pred.isReachable(scope, predSplits) |
        this = pred.getASuccessor(predSplits, splits)
      )
    }
  }
}

cached
private module Cached {
  /**
   * If needed, call this predicate from `ControlFlowGraphImplSpecific.qll` in order to
   * force a stage-dependency on the `ControlFlowGraphImplShared.qll` stage and therby
   * collapsing the two stages.
   */
  cached
  predicate forceCachingInSameStage() { any() }

  cached
  newtype TSplits =
    TSplitsNil() or
    TSplitsCons(SplitImpl head, Splits tail) {
      exists(
        ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c, int rnk
      |
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

  /**
   * Internal representation of control flow nodes in the control flow graph.
   * The control flow graph is pruned for unreachable nodes.
   */
  cached
  newtype TCfgNode =
    TEntryNode(CfgScope scope) { succEntrySplits(scope, _, _, _) } or
    TAnnotatedExitNode(CfgScope scope, boolean normal) {
      exists(Reachability::SameSplitsBlock b, SuccessorType t | b.isReachable(scope, _) |
        succExitSplits(b.getAnElement(), _, scope, t) and
        if isAbnormalExitType(t) then normal = false else normal = true
      )
    } or
    TExitNode(CfgScope scope) {
      exists(Reachability::SameSplitsBlock b | b.isReachable(scope, _) |
        succExitSplits(b.getAnElement(), _, scope, _)
      )
    } or
    TElementNode(CfgScope scope, ControlFlowElement cfe, Splits splits) {
      exists(Reachability::SameSplitsBlock b | b.isReachable(scope, splits) |
        cfe = b.getAnElement()
      )
    }

  /** Gets a successor node of a given flow type, if any. */
  cached
  TCfgNode getASuccessor(TCfgNode pred, SuccessorType t) {
    // Callable entry node -> callable body
    exists(ControlFlowElement succElement, Splits succSplits, CfgScope scope |
      result = TElementNode(scope, succElement, succSplits) and
      pred = TEntryNode(scope) and
      succEntrySplits(scope, succElement, succSplits, t)
    )
    or
    exists(CfgScope scope, ControlFlowElement predElement, Splits predSplits |
      pred = TElementNode(pragma[only_bind_into](scope), predElement, predSplits)
    |
      // Element node -> callable exit (annotated)
      exists(boolean normal |
        result = TAnnotatedExitNode(pragma[only_bind_into](scope), normal) and
        succExitSplits(predElement, predSplits, scope, t) and
        if isAbnormalExitType(t) then normal = false else normal = true
      )
      or
      // Element node -> element node
      exists(ControlFlowElement succElement, Splits succSplits, Completion c |
        result = TElementNode(pragma[only_bind_into](scope), succElement, succSplits)
      |
        succSplits(predElement, predSplits, succElement, succSplits, c) and
        t = getAMatchingSuccessorType(c)
      )
    )
    or
    // Callable exit (annotated) -> callable exit
    exists(CfgScope scope |
      pred = TAnnotatedExitNode(scope, _) and
      result = TExitNode(scope) and
      successorTypeIsSimple(t)
    )
  }

  /**
   * Gets a first control flow element executed within `cfe`.
   */
  cached
  ControlFlowElement getAControlFlowEntryNode(ControlFlowElement cfe) { first(cfe, result) }

  /**
   * Gets a potential last control flow element executed within `cfe`.
   */
  cached
  ControlFlowElement getAControlFlowExitNode(ControlFlowElement cfe) { last(cfe, result, _) }

  /**
   * Gets the CFG scope of node `n`. Unlike `getCfgScope`, this predicate
   * is calculated based on reachability from an entry node, and it may
   * yield different results for AST elements that are split into multiple
   * scopes.
   */
  cached
  CfgScope getNodeCfgScope(TCfgNode n) {
    n = TEntryNode(result)
    or
    n = TAnnotatedExitNode(result, _)
    or
    n = TExitNode(result)
    or
    n = TElementNode(result, _, _)
  }
}

import Cached

/**
 * Import this module into a `.ql` file of `@kind graph` to render a CFG. The
 * graph is restricted to nodes from `RelevantNode`.
 */
module TestOutput {
  abstract class RelevantNode extends Node { }

  query predicate nodes(RelevantNode n, string attr, string val) {
    attr = "semmle.order" and
    val =
      any(int i |
        n =
          rank[i](RelevantNode p, Location l |
            l = p.getLocation()
          |
            p
            order by
              l.getFile().getBaseName(), l.getFile().getAbsolutePath(), l.getStartLine(),
              l.getStartColumn(), l.getEndLine(), l.getEndColumn(), p.toString()
          )
      ).toString()
  }

  query predicate edges(RelevantNode pred, RelevantNode succ, string attr, string val) {
    attr = "semmle.label" and
    exists(SuccessorType t | succ = getASuccessor(pred, t) |
      if successorTypeIsSimple(t) then val = "" else val = t.toString()
    )
    or
    attr = "semmle.order" and
    val =
      any(int i |
        succ =
          rank[i](RelevantNode s, SuccessorType t, Location l |
            s = getASuccessor(pred, t) and
            l = s.getLocation()
          |
            s
            order by
              l.getFile().getBaseName(), l.getFile().getAbsolutePath(), l.getStartLine(),
              l.getStartColumn(), l.getEndLine(), l.getEndColumn(), t.toString()
          )
      ).toString()
  }
}

/** Provides a set of splitting-related consistency queries. */
module Consistency {
  query predicate nonUniqueSetRepresentation(Splits s1, Splits s2) {
    forex(Split s | s = s1.getASplit() | s = s2.getASplit()) and
    forex(Split s | s = s2.getASplit() | s = s1.getASplit()) and
    s1 != s2
  }

  query predicate breakInvariant2(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
    SplitImpl split, Completion c
  ) {
    succSplits(pred, predSplits, succ, succSplits, c) and
    split = predSplits.getASplit() and
    split.hasSuccessor(pred, succ, c) and
    not split = succSplits.getASplit()
  }

  query predicate breakInvariant3(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
    SplitImpl split, Completion c
  ) {
    succSplits(pred, predSplits, succ, succSplits, c) and
    split = predSplits.getASplit() and
    split.hasExit(pred, succ, c) and
    not split.hasEntry(pred, succ, c) and
    split = succSplits.getASplit()
  }

  query predicate breakInvariant4(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
    SplitImpl split, Completion c
  ) {
    succSplits(pred, predSplits, succ, succSplits, c) and
    split.hasEntry(pred, succ, c) and
    not split.getKind() = predSplits.getASplit().getKind() and
    not split = succSplits.getASplit() and
    split.getKind().isEnabled(succ)
  }

  query predicate breakInvariant5(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
    SplitImpl split, Completion c
  ) {
    succSplits(pred, predSplits, succ, succSplits, c) and
    split = succSplits.getASplit() and
    not (split.hasSuccessor(pred, succ, c) and split = predSplits.getASplit()) and
    not split.hasEntry(pred, succ, c)
  }

  private class SimpleSuccessorType extends SuccessorType {
    SimpleSuccessorType() {
      this = getAMatchingSuccessorType(any(Completion c | completionIsSimple(c)))
    }
  }

  private class NormalSuccessorType extends SuccessorType {
    NormalSuccessorType() {
      this = getAMatchingSuccessorType(any(Completion c | completionIsNormal(c)))
    }
  }

  query predicate multipleSuccessors(Node node, SuccessorType t, Node successor) {
    strictcount(getASuccessor(node, t)) > 1 and
    successor = getASuccessor(node, t) and
    // allow for functions with multiple bodies
    not (t instanceof SimpleSuccessorType and node instanceof TEntryNode)
  }

  query predicate simpleAndNormalSuccessors(
    Node node, NormalSuccessorType t1, SimpleSuccessorType t2, Node succ1, Node succ2
  ) {
    t1 != t2 and
    succ1 = getASuccessor(node, t1) and
    succ2 = getASuccessor(node, t2)
  }

  query predicate deadEnd(Node node) {
    not node instanceof TExitNode and
    not exists(getASuccessor(node, _))
  }

  query predicate nonUniqueSplitKind(SplitImpl split, SplitKind sk) {
    sk = split.getKind() and
    strictcount(split.getKind()) > 1
  }

  query predicate nonUniqueListOrder(SplitKind sk, int ord) {
    ord = sk.getListOrder() and
    strictcount(sk.getListOrder()) > 1
  }
}
