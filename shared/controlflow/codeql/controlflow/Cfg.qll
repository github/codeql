/**
 * Provides a shared interface and implementation for constructing control-flow graphs
 * (CFGs) from abstract syntax trees (ASTs).
 */

private import codeql.util.Location
private import codeql.util.FileSystem

/** Provides the language-specific input specification. */
signature module InputSig<LocationSig Location> {
  /** An AST node. */
  class AstNode {
    /** Gets a textual representation of this element. */
    string toString();

    /** Gets the location of this element. */
    Location getLocation();
  }

  /** A control-flow completion. */
  class Completion {
    /** Gets a textual representation of this completion. */
    string toString();
  }

  /**
   * Hold if `c` represents normal evaluation of a statement or an
   * expression.
   */
  predicate completionIsNormal(Completion c);

  /**
   * Hold if `c` represents simple (normal) evaluation of a statement or an
   * expression.
   */
  predicate completionIsSimple(Completion c);

  /** Holds if `c` is a valid completion for AST node `n`. */
  predicate completionIsValidFor(Completion c, AstNode n);

  /** A CFG scope. Each CFG scope gets its own control flow graph. */
  class CfgScope {
    /** Gets a textual representation of this scope. */
    string toString();

    /** Gets the location of this scope. */
    Location getLocation();
  }

  /** Gets the CFG scope of AST node `n`. */
  CfgScope getCfgScope(AstNode n);

  /** Holds if `first` is executed first when entering `scope`. */
  predicate scopeFirst(CfgScope scope, AstNode first);

  /** Holds if `scope` is exited when `last` finishes with completion `c`. */
  predicate scopeLast(CfgScope scope, AstNode last, Completion c);

  /** Gets the maximum number of splits allowed for a given node. */
  default int maxSplits() { result = 5 }

  /** The base class of `SplitKind`. */
  class SplitKindBase;

  /** A split. */
  class Split {
    /** Gets a textual representation of this split. */
    string toString();
  }

  /** A type of a control flow successor. */
  class SuccessorType {
    /** Gets a textual representation of this successor type. */
    string toString();
  }

  /** Gets a successor type that matches completion `c`. */
  SuccessorType getAMatchingSuccessorType(Completion c);

  /**
   * Hold if `t` represents simple (normal) evaluation of a statement or an
   * expression.
   */
  predicate successorTypeIsSimple(SuccessorType t);

  /** Hold if `t` represents a conditional successor type. */
  predicate successorTypeIsCondition(SuccessorType t);

  /** Holds if `t` is an abnormal exit type out of a CFG scope. */
  predicate isAbnormalExitType(SuccessorType t);
}

/**
 * Provides a shared interface for constructing control-flow graphs (CFGs) from
 * abstract syntax trees (ASTs).
 *
 * The implementation is centered around the concept of a _completion_, which
 * models how the execution of a statement or expression terminates.
 *
 * The CFG is built by structural recursion over the AST, using the abstract class
 * `ControlFlowTree`. To achieve this, the CFG edges related to a given AST node,
 * `n`, are divided into three categories:
 *
 *   1. The in-going edge that points to the first CFG node to execute when
 *      `n` is going to be executed.
 *   2. The out-going edges for control flow leaving `n` that are going to some
 *      other node in the surrounding context of `n`.
 *   3. The edges that have both of their end-points entirely within the AST
 *      node and its children.
 *
 * The edges in (1) and (2) are inherently non-local and are therefore
 * initially calculated as half-edges, that is, the single node, `k`, of the
 * edge contained within `n`, by the predicates `k = n.first()` and `k = n.last(_)`,
 * respectively. The edges in (3) can then be enumerated directly by the predicate
 * `succ` by calling `first` and `last` recursively on the children of `n` and
 * connecting the end-points. This yields the entire CFG, since all edges are in
 * (3) for _some_ AST node.
 *
 * The parameter of `last` is the completion, which is necessary to distinguish
 * the out-going edges from `n`. Note that the completion changes as the calculation of
 * `last` proceeds outward through the AST; for example, a completion representing a
 * loop break will be caught up by its surrounding loop and turned into a normal
 * completion.
 */
module Make<LocationSig Location, InputSig<Location> Input> {
  private import Input

  final private class AstNodeFinal = AstNode;

  /** An element with associated control flow. */
  abstract class ControlFlowTree extends AstNodeFinal {
    /** Holds if `first` is the first element executed within this element. */
    pragma[nomagic]
    abstract predicate first(AstNode first);

    /**
     * Holds if `last` with completion `c` is a potential last element executed
     * within this element.
     */
    pragma[nomagic]
    abstract predicate last(AstNode last, Completion c);

    /** Holds if abnormal execution of `child` should propagate upwards. */
    abstract predicate propagatesAbnormal(AstNode child);

    /**
     * Holds if `succ` is a control flow successor for `pred`, given that `pred`
     * finishes with completion `c`.
     */
    pragma[nomagic]
    abstract predicate succ(AstNode pred, AstNode succ, Completion c);
  }

  /**
   * Holds if `first` is the first element executed within control flow
   * element `cft`.
   */
  predicate first(ControlFlowTree cft, AstNode first) { cft.first(first) }

  /**
   * Holds if `last` with completion `c` is a potential last element executed
   * within control flow element `cft`.
   */
  predicate last(ControlFlowTree cft, AstNode last, Completion c) {
    cft.last(last, c)
    or
    exists(AstNode n |
      cft.propagatesAbnormal(n) and
      last(n, last, c) and
      not completionIsNormal(c)
    )
  }

  /**
   * Holds if `succ` is a control flow successor for `pred`, given that `pred`
   * finishes with completion `c`.
   */
  pragma[nomagic]
  predicate succ(AstNode pred, AstNode succ, Completion c) {
    any(ControlFlowTree cft).succ(pred, succ, c)
  }

  /** An element that is executed in pre-order, typically used for statements. */
  abstract class PreOrderTree extends ControlFlowTree {
    final override predicate first(AstNode first) { first = this }
  }

  /** An element that is executed in post-order, typically used for expressions. */
  abstract class PostOrderTree extends ControlFlowTree {
    override predicate last(AstNode last, Completion c) {
      last = this and
      completionIsValidFor(c, last)
    }
  }

  /**
   * An element where the children are evaluated following a standard left-to-right
   * evaluation. The actual evaluation order is determined by the predicate
   * `getChildNode()`.
   */
  abstract class StandardTree extends ControlFlowTree {
    /** Gets the `i`th child element, in order of evaluation. */
    abstract AstNode getChildNode(int i);

    private AstNode getChildNodeRanked(int i) {
      result = rank[i + 1](AstNode child, int j | child = this.getChildNode(j) | child order by j)
    }

    /** Gets the first child node of this element. */
    final AstNode getFirstChildNode() { result = this.getChildNodeRanked(0) }

    /** Gets the last child node of this node. */
    final AstNode getLastChildElement() {
      exists(int last |
        result = this.getChildNodeRanked(last) and
        not exists(this.getChildNodeRanked(last + 1))
      )
    }

    /** Holds if this element has no children. */
    predicate isLeafElement() { not exists(this.getFirstChildNode()) }

    override predicate propagatesAbnormal(AstNode child) { child = this.getChildNode(_) }

    pragma[nomagic]
    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      exists(int i |
        last(this.getChildNodeRanked(i), pred, c) and
        completionIsNormal(c) and
        first(this.getChildNodeRanked(i + 1), succ)
      )
    }
  }

  /** A standard element that is executed in pre-order. */
  abstract class StandardPreOrderTree extends StandardTree, PreOrderTree {
    override predicate last(AstNode last, Completion c) {
      last(this.getLastChildElement(), last, c)
      or
      this.isLeafElement() and
      completionIsValidFor(c, this) and
      last = this
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      StandardTree.super.succ(pred, succ, c)
      or
      pred = this and
      first(this.getFirstChildNode(), succ) and
      completionIsSimple(c)
    }
  }

  /** A standard element that is executed in post-order. */
  abstract class StandardPostOrderTree extends StandardTree, PostOrderTree {
    override predicate first(AstNode first) {
      first(this.getFirstChildNode(), first)
      or
      not exists(this.getFirstChildNode()) and
      first = this
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      StandardTree.super.succ(pred, succ, c)
      or
      last(this.getLastChildElement(), pred, c) and
      succ = this and
      completionIsNormal(c)
    }
  }

  /** An element that is a leaf in the control flow graph. */
  abstract class LeafTree extends PreOrderTree, PostOrderTree {
    override predicate propagatesAbnormal(AstNode child) { none() }

    override predicate succ(AstNode pred, AstNode succ, Completion c) { none() }
  }

  /**
   * Holds if split kinds `sk1` and `sk2` may overlap. That is, they may apply
   * to at least one common AST node inside `scope`.
   */
  private predicate overlapping(CfgScope scope, SplitKind sk1, SplitKind sk2) {
    exists(AstNode e |
      sk1.appliesTo(e) and
      sk2.appliesTo(e) and
      scope = getCfgScope(e)
    )
  }

  /**
   * A split kind. Each control flow node can have at most one split of a
   * given kind.
   */
  abstract class SplitKind instanceof SplitKindBase {
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
      this =
        rank[result](SplitKind sk | overlapping(scope, this, sk) | sk order by sk.getListOrder())
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

  final private class SplitFinal = Split;

  /** An interface for implementing an entity to split on. */
  abstract class SplitImpl extends SplitFinal {
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
     * Invariant: `hasEntryScope(scope, first) implies scopeFirst(scope, first)`.
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
     * Invariant: `hasExitScope(scope, last, c) implies scopeLast(scope, last, c)`
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

    /**
     * Holds if `succ` is a control flow successor for `pred`, given that `pred`
     * finishes with completion `c`, and this split applies to `pred`.
     */
    pragma[noinline]
    final predicate appliesSucc(AstNode pred, AstNode succ, Completion c) {
      this.appliesTo(pred) and
      succ(pred, succ, c)
    }
  }

  private predicate isFullyConstructedSplits(Splits splits) { exists(TAstNode(_, _, splits)) }

  /**
   * A set of control flow node splits. The set is represented by a list of splits,
   * ordered by ascending rank.
   */
  class Splits extends TSplits {
    /** Gets a textual representation of this set of splits. */
    string toString() {
      result = splitsToString(this)
      or
      not isFullyConstructedSplits(this) and
      result = "<partial split set>"
    }

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
    scopeFirst(pred, succ) and
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
   * when entering callable `pred`.
   */
  pragma[noinline]
  private predicate succEntrySplits(CfgScope pred, AstNode succ, Splits succSplits, SuccessorType t) {
    exists(int rnk |
      scopeFirst(pred, succ) and
      successorTypeIsSimple(t) and
      succEntrySplitsFromRank(pred, succ, succSplits, rnk)
    |
      rnk = 0 and
      not any(SplitImpl split).hasEntryScope(pred, succ)
      or
      rnk =
        max(SplitImpl split | split.hasEntryScope(pred, succ) | split.getKind().getListRank(succ))
    )
  }

  /**
   * Holds if `pred` with splits `predSplits` can exit the enclosing callable
   * `succ` with type `t`.
   */
  private predicate succExitSplits(AstNode pred, Splits predSplits, CfgScope succ, SuccessorType t) {
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
      pred = b.getAnElement() and
      b.isReachable(_, predSplits) and
      succ(pred, succ, c)
    }

    private predicate case1b0(AstNode pred, Splits predSplits, AstNode succ, Completion c) {
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
        succ = b.getAnElement() and
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

  private import SuccSplits

  /** Provides logic for calculating reachable control flow nodes. */
  private module Reachability {
    /**
     * Holds if `n` is an AST node where the set of possible splits may
     * be different from the set of possible splits for one of `n`'s predecessors.
     * That is, `n` starts a new block of elements with the same set of splits.
     */
    private predicate startsSplits(AstNode n) {
      scopeFirst(_, n)
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
     * A block of control flow elements where the set of splits is guaranteed
     * to remain unchanged, represented by the first element in the block.
     */
    class SameSplitsBlock extends AstNodeFinal {
      SameSplitsBlock() { startsSplits(this) }

      /** Gets a control flow element in this block. */
      AstNode getAnElement() {
        splitsBlockContains(this, result)
        or
        result = this
      }

      pragma[noinline]
      private SameSplitsBlock getASuccessor(Splits predSplits, Splits succSplits) {
        exists(AstNode pred | pred = this.getAnElement() |
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

    private string getSplitStringAt(Splits split, int index) {
      exists(SplitImpl head, Splits tail | split = TSplitsCons(head, tail) |
        index = 0 and result = head.toString() and result != ""
        or
        index > 0 and result = getSplitStringAt(tail, index - 1)
      )
    }

    private string getSplitsStringPart(Splits splits, int index) {
      isFullyConstructedSplits(splits) and
      result = getSplitStringAt(splits, index)
    }

    cached
    string splitsToString(Splits splits) {
      result =
        concat(string child, int index |
          child = getSplitsStringPart(splits, index)
        |
          child, ", " order by index
        )
    }

    /**
     * Internal representation of control flow nodes in the control flow graph.
     * The control flow graph is pruned for unreachable nodes.
     */
    cached
    newtype TNode =
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
      TAstNode(CfgScope scope, AstNode n, Splits splits) {
        exists(Reachability::SameSplitsBlock b | b.isReachable(scope, splits) |
          n = b.getAnElement()
        )
      }

    /** Gets a successor node of a given flow type, if any. */
    cached
    Node getASuccessor(Node pred, SuccessorType t) {
      // Callable entry node -> callable body
      exists(AstNode succElement, Splits succSplits, CfgScope scope |
        result = TAstNode(scope, succElement, succSplits) and
        pred = TEntryNode(scope) and
        succEntrySplits(scope, succElement, succSplits, t)
      )
      or
      exists(CfgScope scope, AstNode predElement, Splits predSplits |
        pred = TAstNode(pragma[only_bind_into](scope), predElement, predSplits)
      |
        // Element node -> callable exit (annotated)
        exists(boolean normal |
          result = TAnnotatedExitNode(pragma[only_bind_into](scope), normal) and
          succExitSplits(predElement, predSplits, scope, t) and
          if isAbnormalExitType(t) then normal = false else normal = true
        )
        or
        // Element node -> element node
        exists(AstNode succElement, Splits succSplits, Completion c |
          result = TAstNode(pragma[only_bind_into](scope), succElement, succSplits)
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

    cached
    module Public {
      /**
       * If needed, call this predicate from in order to force a stage-dependency on this
       * cached stage.
       */
      cached
      predicate forceCachingInSameStage() { any() }

      /**
       * Gets a first AST node executed within `n`.
       */
      cached
      AstNode getAControlFlowEntryNode(AstNode n) { first(n, result) }

      /**
       * Gets a potential last AST node executed within `n`.
       */
      cached
      AstNode getAControlFlowExitNode(AstNode n) { last(n, result, _) }

      /**
       * Gets the CFG scope of node `n`. Unlike `getCfgScope`, this predicate
       * is calculated based on reachability from an entry node, and it may
       * yield different results for AST elements that are split into multiple
       * scopes.
       */
      cached
      CfgScope getNodeCfgScope(Node n) {
        n = TEntryNode(result)
        or
        n = TAnnotatedExitNode(result, _)
        or
        n = TExitNode(result)
        or
        n = TAstNode(result, _, _)
      }
    }
  }

  private import Cached
  import Cached::Public

  /**
   * A control flow node.
   *
   * A control flow node is a node in the control flow graph (CFG). There is a
   * many-to-one relationship between CFG nodes and AST nodes.
   *
   * Only nodes that can be reached from an entry point are included in the CFG.
   */
  abstract private class NodeImpl extends TNode {
    /** Gets a textual representation of this control flow node. */
    abstract string toString();

    /** Gets the AST node that this node corresponds to, if any. */
    abstract AstNode getAstNode();

    /** Gets the location of this control flow node. */
    abstract Location getLocation();

    /** Holds if this control flow node has conditional successors. */
    predicate isCondition() {
      exists(this.getASuccessor(any(SuccessorType t | successorTypeIsCondition(t))))
    }

    /** Gets the scope of this node. */
    CfgScope getScope() { result = getNodeCfgScope(this) }

    /** Gets a successor node of a given type, if any. */
    Node getASuccessor(SuccessorType t) { result = getASuccessor(this, t) }

    /** Gets an immediate successor, if any. */
    Node getASuccessor() { result = this.getASuccessor(_) }

    /** Gets an immediate predecessor node of a given flow type, if any. */
    Node getAPredecessor(SuccessorType t) { result.getASuccessor(t) = this }

    /** Gets an immediate predecessor, if any. */
    Node getAPredecessor() { result = this.getAPredecessor(_) }

    /** Holds if this node has more than one predecessor. */
    predicate isJoin() { strictcount(this.getAPredecessor()) > 1 }

    /** Holds if this node has more than one successor. */
    predicate isBranch() { strictcount(this.getASuccessor()) > 1 }
  }

  final class Node = NodeImpl;

  /** An entry node for a given scope. */
  private class EntryNodeImpl extends NodeImpl, TEntryNode {
    private CfgScope scope;

    EntryNodeImpl() { this = TEntryNode(scope) }

    final override AstNode getAstNode() { none() }

    final override Location getLocation() { result = scope.getLocation() }

    final override string toString() { result = "enter " + scope }
  }

  final class EntryNode = EntryNodeImpl;

  /** An exit node for a given scope, annotated with the type of exit. */
  private class AnnotatedExitNodeImpl extends NodeImpl, TAnnotatedExitNode {
    private CfgScope scope;
    private boolean normal;

    AnnotatedExitNodeImpl() { this = TAnnotatedExitNode(scope, normal) }

    /** Holds if this node represent a normal exit. */
    final predicate isNormal() { normal = true }

    final override AstNode getAstNode() { none() }

    final override Location getLocation() { result = scope.getLocation() }

    final override string toString() {
      exists(string s |
        normal = true and s = "normal"
        or
        normal = false and s = "abnormal"
      |
        result = "exit " + scope + " (" + s + ")"
      )
    }
  }

  final class AnnotatedExitNode = AnnotatedExitNodeImpl;

  /** An exit node for a given scope. */
  private class ExitNodeImpl extends NodeImpl, TExitNode {
    private CfgScope scope;

    ExitNodeImpl() { this = TExitNode(scope) }

    final override AstNode getAstNode() { none() }

    final override Location getLocation() { result = scope.getLocation() }

    final override string toString() { result = "exit " + scope }
  }

  final class ExitNode = ExitNodeImpl;

  /**
   * A node for an AST node.
   *
   * Each AST node maps to zero or more `AstCfgNode`s: zero when the node is unreachable
   * (dead) code or not important for control flow, and multiple when there are different
   * splits for the AST node.
   */
  private class AstCfgNodeImpl extends NodeImpl, TAstNode {
    private Splits splits;
    private AstNode n;

    AstCfgNodeImpl() { this = TAstNode(_, n, splits) }

    final override AstNode getAstNode() { result = n }

    override Location getLocation() { result = n.getLocation() }

    final override string toString() {
      exists(string s | s = n.toString() |
        result = "[" + this.getSplitsString() + "] " + s
        or
        not exists(this.getSplitsString()) and result = s
      )
    }

    /** Gets a comma-separated list of strings for each split in this node, if any. */
    final string getSplitsString() {
      result = splits.toString() and
      result != ""
    }

    /** Gets a split for this control flow node, if any. */
    final Split getASplit() { result = splits.getASplit() }
  }

  final class AstCfgNode = AstCfgNodeImpl;

  /** A node to be included in the output of `TestOutput`. */
  signature class RelevantNodeSig extends Node {
    /**
     * Gets a string used to resolve ties in node and edge ordering.
     */
    string getOrderDisambiguation();
  }

  /**
   * Import this module into a `.ql` file of `@kind graph` to render a CFG. The
   * graph is restricted to nodes from `RelevantNode`.
   */
  module TestOutput<RelevantNodeSig RelevantNode> {
    /** Holds if `n` is a relevant node in the CFG. */
    query predicate nodes(RelevantNode n, string attr, string val) {
      attr = "semmle.order" and
      val =
        any(int i |
          n =
            rank[i](RelevantNode p, string filePath, int startLine, int startColumn, int endLine,
              int endColumn |
              p.getLocation().hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn)
            |
              p
              order by
                filePath, startLine, startColumn, endLine, endColumn, p.toString(),
                p.getOrderDisambiguation()
            )
        ).toString()
    }

    /** Holds if `pred -> succ` is an edge in the CFG. */
    query predicate edges(RelevantNode pred, RelevantNode succ, string attr, string val) {
      attr = "semmle.label" and
      val =
        strictconcat(SuccessorType t, string s |
          succ = getASuccessor(pred, t) and
          if successorTypeIsSimple(t) then s = "" else s = t.toString()
        |
          s, ", " order by s
        )
      or
      attr = "semmle.order" and
      val =
        any(int i |
          succ =
            rank[i](RelevantNode s, SuccessorType t, string filePath, int startLine,
              int startColumn, int endLine, int endColumn |
              s = getASuccessor(pred, t) and
              s.getLocation().hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn)
            |
              s
              order by
                filePath, startLine, startColumn, endLine, endColumn, t.toString(), s.toString(),
                s.getOrderDisambiguation()
            )
        ).toString()
    }

    module Mermaid {
      private string nodeId(RelevantNode n) { nodes(n, "semmle.order", result) }

      private string nodes() {
        result =
          concat(RelevantNode n, string id, string text |
            id = nodeId(n) and
            text = n.toString()
          |
            id + "[\"" + text + "\"]", "\n" order by id
          )
      }

      private string edge(RelevantNode pred, RelevantNode succ, string ord) {
        edges(pred, succ, "semmle.order", ord) and
        exists(string label |
          edges(pred, succ, "semmle.label", label) and
          if label = ""
          then result = nodeId(pred) + " --> " + nodeId(succ)
          else result = nodeId(pred) + " -- " + label + " --> " + nodeId(succ)
        )
      }

      private string edges() {
        result =
          concat(RelevantNode pred, RelevantNode succ, string edge, string ord |
            edge = edge(pred, succ, ord)
          |
            edge, "\n" order by ord
          )
      }

      query predicate mermaid(string s) { s = "flowchart TD\n" + nodes() + "\n\n" + edges() }
    }
  }

  /** Provides the input to `ViewCfgQuery`. */
  signature module ViewCfgQueryInputSig<FileSig File> {
    /** The source file selected in the IDE. Should be an `external` predicate. */
    string selectedSourceFile();

    /** The source line selected in the IDE. Should be an `external` predicate. */
    int selectedSourceLine();

    /** The source column selected in the IDE. Should be an `external` predicate. */
    int selectedSourceColumn();

    /**
     * Holds if CFG scope `scope` spans column `startColumn` of line `startLine` to
     * column `endColumn` of line `endLine` in `file`.
     */
    predicate cfgScopeSpan(
      CfgScope scope, File file, int startLine, int startColumn, int endLine, int endColumn
    );
  }

  /**
   * Provides an implementation for a `View CFG` query.
   *
   * Import this module into a `.ql` that looks like
   *
   * ```ql
   * @name Print CFG
   * @description Produces a representation of a file's Control Flow Graph.
   *              This query is used by the VS Code extension.
   * @id <lang>/print-cfg
   * @kind graph
   * @tags ide-contextual-queries/print-cfg
   * ```
   */
  module ViewCfgQuery<FileSig File, ViewCfgQueryInputSig<File> ViewCfgQueryInput> {
    private import ViewCfgQueryInput

    bindingset[file, line, column]
    private CfgScope smallestEnclosingScope(File file, int line, int column) {
      result =
        min(CfgScope scope, int startLine, int startColumn, int endLine, int endColumn |
          cfgScopeSpan(scope, file, startLine, startColumn, endLine, endColumn) and
          (
            startLine < line
            or
            startLine = line and startColumn <= column
          ) and
          (
            endLine > line
            or
            endLine = line and endColumn >= column
          )
        |
          scope order by startLine desc, startColumn desc, endLine, endColumn
        )
    }

    private import IdeContextual<File>

    private class RelevantNode extends Node {
      RelevantNode() {
        this.getScope() =
          smallestEnclosingScope(getFileBySourceArchiveName(selectedSourceFile()),
            selectedSourceLine(), selectedSourceColumn())
      }

      string getOrderDisambiguation() { result = "" }
    }

    import TestOutput<RelevantNode>
    import Mermaid
  }

  /** Provides a set of consistency queries. */
  module Consistency {
    /** Holds if `s1` and `s2` are distinct representations of the same set. */
    query predicate nonUniqueSetRepresentation(Splits s1, Splits s2) {
      forex(Split s | s = s1.getASplit() | s = s2.getASplit()) and
      forex(Split s | s = s2.getASplit() | s = s1.getASplit()) and
      s1 != s2
    }

    /** Holds if splitting invariant 2 is violated. */
    query predicate breakInvariant2(
      AstNode pred, Splits predSplits, AstNode succ, Splits succSplits, SplitImpl split,
      Completion c
    ) {
      succSplits(pred, predSplits, succ, succSplits, c) and
      split = predSplits.getASplit() and
      split.hasSuccessor(pred, succ, c) and
      not split = succSplits.getASplit()
    }

    /** Holds if splitting invariant 3 is violated. */
    query predicate breakInvariant3(
      AstNode pred, Splits predSplits, AstNode succ, Splits succSplits, SplitImpl split,
      Completion c
    ) {
      succSplits(pred, predSplits, succ, succSplits, c) and
      split = predSplits.getASplit() and
      split.hasExit(pred, succ, c) and
      not split.hasEntry(pred, succ, c) and
      split = succSplits.getASplit()
    }

    /** Holds if splitting invariant 4 is violated. */
    query predicate breakInvariant4(
      AstNode pred, Splits predSplits, AstNode succ, Splits succSplits, SplitImpl split,
      Completion c
    ) {
      succSplits(pred, predSplits, succ, succSplits, c) and
      split.hasEntry(pred, succ, c) and
      not split.getKind() = predSplits.getASplit().getKind() and
      not split = succSplits.getASplit() and
      split.getKind().isEnabled(succ)
    }

    /** Holds if splitting invariant 5 is violated. */
    query predicate breakInvariant5(
      AstNode pred, Splits predSplits, AstNode succ, Splits succSplits, SplitImpl split,
      Completion c
    ) {
      succSplits(pred, predSplits, succ, succSplits, c) and
      split = succSplits.getASplit() and
      not (split.hasSuccessor(pred, succ, c) and split = predSplits.getASplit()) and
      not split.hasEntry(pred, succ, c)
    }

    final private class SuccessorTypeFinal = SuccessorType;

    private class SimpleSuccessorType extends SuccessorTypeFinal {
      SimpleSuccessorType() {
        this = getAMatchingSuccessorType(any(Completion c | completionIsSimple(c)))
      }
    }

    private class NormalSuccessorType extends SuccessorTypeFinal {
      NormalSuccessorType() {
        this = getAMatchingSuccessorType(any(Completion c | completionIsNormal(c)))
      }
    }

    /** Holds if `node` has multiple successors of the same type `t`. */
    query predicate multipleSuccessors(Node node, SuccessorType t, Node successor) {
      strictcount(getASuccessor(node, t)) > 1 and
      successor = getASuccessor(node, t) and
      // allow for functions with multiple bodies
      not (t instanceof SimpleSuccessorType and node instanceof EntryNode)
    }

    /** Holds if `node` has both a simple and a normal (non-simple) successor type. */
    query predicate simpleAndNormalSuccessors(
      Node node, NormalSuccessorType t1, SimpleSuccessorType t2, Node succ1, Node succ2
    ) {
      t1 != t2 and
      succ1 = getASuccessor(node, t1) and
      succ2 = getASuccessor(node, t2)
    }

    /** Holds if `node` is lacking a successor. */
    query predicate deadEnd(Node node) {
      not node instanceof ExitNode and
      not exists(getASuccessor(node, _))
    }

    /** Holds if `split` has multiple kinds. */
    query predicate nonUniqueSplitKind(SplitImpl split, SplitKind sk) {
      sk = split.getKind() and
      strictcount(split.getKind()) > 1
    }

    /** Holds if `sk` has multiple integer representations. */
    query predicate nonUniqueListOrder(SplitKind sk, int ord) {
      ord = sk.getListOrder() and
      strictcount(sk.getListOrder()) > 1
    }
  }
}
