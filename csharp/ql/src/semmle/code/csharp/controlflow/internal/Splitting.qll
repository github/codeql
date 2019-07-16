/**
 * INTERNAL: Do not use.
 *
 * Provides classes and predicates relevant for splitting the control flow graph.
 */

import csharp
private import semmle.code.csharp.controlflow.internal.Completion
private import semmle.code.csharp.controlflow.internal.PreBasicBlocks
private import semmle.code.csharp.controlflow.internal.PreSsa as PreSsa
private import semmle.code.csharp.controlflow.ControlFlowGraph::ControlFlow::Internal::Successor
private import semmle.code.csharp.controlflow.Guards as Guards
private import ControlFlow
private import SuccessorTypes

/** The maximum number of splits allowed for a given node. */
private int maxSplits() { result = 7 }

cached
private module Cached {
  private import semmle.code.csharp.Caching

  cached
  newtype TBooleanSplitSubKind =
    TSsaBooleanSplitSubKind(PreSsa::Definition def) {
      Stages::ControlFlowStage::forceCachingInSameStage()
    }

  cached
  newtype TSplitKind =
    TFinallySplitKind() or
    TExceptionHandlerSplitKind() or
    TBooleanSplitKind(BooleanSplitting::BooleanSplitSubKind kind) { kind.startsSplit(_) }

  cached
  newtype TSplit =
    TFinallySplit(FinallySplitting::FinallySplitType type) or
    TExceptionHandlerSplit(ExceptionClass ec) or
    TBooleanSplit(BooleanSplitting::BooleanSplitSubKind kind, boolean branch) {
      kind.startsSplit(_) and
      (branch = true or branch = false)
    }

  cached
  newtype TSplits =
    TSplitsNil() or
    TSplitsCons(SplitInternal head, Splits tail) {
      exists(
        ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c, int rnk,
        int numberOfSplits
      |
        case2aFromRank(pred, predSplits, succ, tail, c, rnk + 1, numberOfSplits) and
        head = case2aSomeAtRank(pred, predSplits, succ, c, rnk)
      |
        numberOfSplits < maxSplits() or head.getKind().isMandatory()
      )
    }

  cached
  string splitsToString(Splits splits) {
    splits = TSplitsNil() and
    result = ""
    or
    exists(SplitInternal head, Splits tail, string headString, string tailString |
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

/**
 * A split for a control flow element. For example, a tag that determines how to
 * continue execution after leaving a `finally` block.
 */
class SplitImpl extends TSplit {
  /** Gets a textual representation of this split. */
  string toString() { none() }
}

/**
 * A split kind. Each control flow node can have at most one split of a
 * given kind.
 */
abstract class SplitKind extends TSplitKind {
  /** Gets a split of this kind. */
  SplitInternal getASplit() { result.getKind() = this }

  /** Holds if some split of this kind applies to control flow element `cfe`. */
  predicate appliesTo(ControlFlowElement cfe) { this.getASplit().appliesTo(cfe) }

  /**
   * Gets a unique integer representing this split kind. The integer is used
   * to represent sets of splits as ordered lists.
   */
  abstract int getListOrder();

  /**
   * Holds if a split of this kind is mandatory. That is, a split of this kind must
   * be taken into account, regardless of whether we might exceed the maximum number
   * of splits (`maxSplits()`).
   */
  abstract predicate isMandatory();

  /**
   * Gets the rank of this split kind among all the split kinds that apply to
   * control flow element `cfe`. The rank is based on the order defined by
   * `getListOrder()`.
   */
  int getListRank(ControlFlowElement cfe) {
    this.appliesTo(cfe) and
    this = rank[result](SplitKind sk | sk.appliesTo(cfe) | sk order by sk.getListOrder())
  }

  /** Gets a textual representation of this split kind. */
  abstract string toString();
}

// This class only exists to not pollute the externally visible `Split` class
// with internal helper predicates
abstract class SplitInternal extends SplitImpl {
  /** Gets the kind of this split. */
  abstract SplitKind getKind();

  /**
   * Holds if this split is entered when control passes from `pred` to `succ` with
   * completion `c`.
   *
   * Invariant: `hasEntry(pred, succ, c) implies succ = Successor::succ(pred, c)`.
   */
  abstract predicate hasEntry(ControlFlowElement pred, ControlFlowElement succ, Completion c);

  /**
   * Holds if this split is left when control passes from `pred` to `succ` with
   * completion `c`.
   *
   * Invariant: `hasExit(pred, succ, c) implies succ = Successor::succ(pred, c)`.
   */
  abstract predicate hasExit(ControlFlowElement pred, ControlFlowElement succ, Completion c);

  /**
   * Holds if this split is left when control passes from `pred` out of the enclosing
   * callable with completion `c`.
   *
   * Invariant: `hasExit(pred, c) implies pred.getEnclosingCallable() = Successor::succExit(pred, c)`
   */
  abstract predicate hasExit(ControlFlowElement pred, Completion c);

  /**
   * Holds if this split is maintained when control passes from `pred` to `succ` with
   * completion `c`.
   *
   * Invariant: `hasSuccessor(pred, succ, c) implies succ = Successor::succ(pred, c)`
   */
  abstract predicate hasSuccessor(ControlFlowElement pred, ControlFlowElement succ, Completion c);

  /** Holds if this split applies to control flow element `cfe`. */
  final predicate appliesTo(ControlFlowElement cfe) {
    this.hasEntry(_, cfe, _)
    or
    exists(ControlFlowElement pred | this.appliesTo(pred) | this.hasSuccessor(pred, cfe, _))
  }
}

module FinallySplitting {
  /**
   * The type of a split `finally` node.
   *
   * The type represents one of the possible ways of entering a `finally`
   * block. For example, if a `try` statement ends with a `return` statement,
   * then the `finally` block must end with a `return` as well (provided that
   * the `finally` block exits normally).
   */
  class FinallySplitType extends SuccessorType {
    FinallySplitType() { not this instanceof ConditionalSuccessor }

    /** Holds if this split type matches entry into a `finally` block with completion `c`. */
    predicate isSplitForEntryCompletion(Completion c) {
      if c instanceof NormalCompletion
      then
        // If the entry into the `finally` block completes with any normal completion,
        // it simply means normal execution after the `finally` block
        this instanceof NormalSuccessor
      else this.matchesCompletion(c)
    }
  }

  pragma[noinline]
  private ControlFlowElement getAChild(ControlFlowElement cfe, Callable c) {
    result = cfe.getAChild() and
    c = result.getEnclosingCallable()
  }

  /**
   * Gets a descendant that belongs to the `finally` block of try statement
   * `try`.
   */
  ControlFlowElement getAFinallyDescendant(TryStmt try) {
    result = try.getFinally()
    or
    exists(ControlFlowElement mid |
      mid = getAFinallyDescendant(try) and
      result = getAChild(mid, mid.getEnclosingCallable()) and
      not exists(TryStmt nestedTry |
        result = nestedTry.getFinally() and
        nestedTry != try
      )
    )
  }

  /** A control flow element that belongs to a `finally` block. */
  private class FinallyControlFlowElement extends ControlFlowElement {
    FinallyControlFlowElement() { this = getAFinallyDescendant(_) }

    /** Holds if this node is the entry node in the `finally` block it belongs to. */
    predicate isEntryNode() {
      exists(TryStmt try | this = getAFinallyDescendant(try) | this = first(try.getFinally()))
    }

    /**
     * Holds if this node is a last element in the `finally` block belonging to
     * `try` statement `try`, with completion `c`.
     */
    predicate isExitNode(TryStmt try, Completion c) {
      this = getAFinallyDescendant(try) and
      this = last(try.getFinally(), c)
    }
  }

  /** A control flow element that does not belong to a `finally` block. */
  private class NonFinallyControlFlowElement extends ControlFlowElement {
    NonFinallyControlFlowElement() { not this = getAFinallyDescendant(_) }
  }

  /**
   * A split for elements belonging to a `finally` block, which determines how to
   * continue execution after leaving the `finally` block. For example, in
   *
   * ```
   * try
   * {
   *     if (!M())
   *         throw new Exception();
   * }
   * finally
   * {
   *     Log.Write("M failed");
   * }
   * ```
   *
   * all control flow nodes in the `finally` block have two splits: one representing
   * normal execution of the `try` block (when `M()` returns `true`), and one
   * representing exceptional execution of the `try` block (when `M()` returns `false`).
   */
  class FinallySplitImpl extends SplitImpl, TFinallySplit {
    private FinallySplitType type;

    FinallySplitImpl() { this = TFinallySplit(type) }

    /**
     * Gets the type of this `finally` split, that is, how to continue execution after the
     * `finally` block.
     */
    FinallySplitType getType() { result = type }

    override string toString() {
      if type instanceof NormalSuccessor
      then result = ""
      else result = "finally: " + type.toString()
    }
  }

  private class FinallySplitKind extends SplitKind, TFinallySplitKind {
    override int getListOrder() { result = 0 }

    override predicate isMandatory() { any() }

    override string toString() { result = "Finally" }
  }

  private class FinallySplitInternal extends SplitInternal, FinallySplitImpl {
    override FinallySplitKind getKind() { any() }

    override predicate hasEntry(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      succ.(FinallyControlFlowElement).isEntryNode() and
      succ = succ(pred, c) and
      this.getType().isSplitForEntryCompletion(c) and
      (
        // Abnormal entry must enter the correct splitting
        not c instanceof NormalCompletion
        or
        // Normal entry only when not entering a nested `finally` block; in that case,
        // the outer split must be maintained (see `hasSuccessor()`)
        pred instanceof NonFinallyControlFlowElement
      )
    }

    /**
     * Holds if this split applies to control flow element `pred`, where `pred`
     * is a valid predecessor.
     */
    private predicate appliesToPredecessor(ControlFlowElement pred) {
      this.appliesTo(pred) and
      (exists(succ(pred, _)) or exists(succExit(pred, _)))
    }

    /** Holds if `pred` may exit this split with completion `c`. */
    private predicate exit(ControlFlowElement pred, Completion c) {
      this.appliesToPredecessor(pred) and
      exists(TryStmt try, FinallySplitType type |
        type = this.getType() and
        pred = last(try, c)
      |
        if pred.(FinallyControlFlowElement).isExitNode(try, c)
        then (
          // Finally block can itself exit with completion `c`: either `c` must
          // match this split, `c` must be an abnormal completion, or this split
          // does not require another completion to be recovered
          type.matchesCompletion(c)
          or
          not c instanceof NormalCompletion
          or
          type instanceof NormalSuccessor
        ) else (
          // Finally block can exit with completion `c` derived from try/catch
          // block: must match this split
          type.matchesCompletion(c) and
          not type instanceof NormalSuccessor
        )
      )
    }

    override predicate hasExit(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      this.appliesToPredecessor(pred) and
      succ = succ(pred, c) and
      (
        // Entering a nested `finally` block abnormally means that we should exit this split
        succ.(FinallyControlFlowElement).isEntryNode() and
        not c instanceof NormalCompletion
        or
        exit(pred, c)
        or
        exit(pred, any(BreakCompletion bc)) and
        c instanceof BreakNormalCompletion
      )
    }

    override predicate hasExit(ControlFlowElement pred, Completion c) {
      exists(succExit(pred, c)) and
      (
        exit(pred, c)
        or
        exit(pred, any(BreakCompletion bc)) and
        c instanceof BreakNormalCompletion
      )
    }

    override predicate hasSuccessor(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      this.appliesToPredecessor(pred) and
      succ = succ(pred, c) and
      succ = any(FinallyControlFlowElement fcfe |
          if fcfe.isEntryNode()
          then
            // Entering a nested `finally` block normally must remember the outer split
            c instanceof NormalCompletion
          else
            // Staying in the same `finally` block should maintain this split
            not this.hasEntry(pred, succ, c)
        )
    }
  }
}

module ExceptionHandlerSplitting {
  private newtype TMatch =
    TAlways() or
    TMaybe() or
    TNever()

  /**
   * A split for elements belonging to a `catch` clause, which determines the type of
   * exception to handle. For example, in
   *
   * ```
   * try
   * {
   *     if (M() > 0)
   *         throw new ArgumentException();
   *     else if (M() < 0)
   *         throw new ArithmeticException("negative");
   *     else
   *         return;
   * }
   * catch (ArgumentException e)
   * {
   *     Log.Write("M() positive");
   * }
   * catch (ArithmeticException e) when (e.Message != null)
   * {
   *     Log.Write($"M() {e.Message}");
   * }
   * ```
   *
   * all control flow nodes in
   * ```
   * catch (ArgumentException e)
   * ```
   * and
   * ```
   * catch (ArithmeticException e) when (e.Message != null)
   * ```
   * have two splits: one representing the `try` block throwing an `ArgumentException`,
   * and one representing the `try` block throwing an `ArithmeticException`.
   */
  class ExceptionHandlerSplitImpl extends SplitImpl, TExceptionHandlerSplit {
    private ExceptionClass ec;

    ExceptionHandlerSplitImpl() { this = TExceptionHandlerSplit(ec) }

    /** Gets the exception type that this split represents. */
    ExceptionClass getExceptionClass() { result = ec }

    override string toString() { result = "exception: " + ec.toString() }
  }

  private class ExceptionHandlerSplitKind extends SplitKind, TExceptionHandlerSplitKind {
    override int getListOrder() { result = 1 }

    override predicate isMandatory() { any() }

    override string toString() { result = "ExceptionHandler" }
  }

  private class ExceptionHandlerSplitInternal extends SplitInternal, ExceptionHandlerSplitImpl {
    override ExceptionHandlerSplitKind getKind() { any() }

    override predicate hasEntry(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Entry into first catch clause
      exists(TryStmt ts | this.getExceptionClass() = getAThrownException(ts, pred, c) |
        succ = succ(pred, c) and
        succ = ts.getCatchClause(0).(SpecificCatchClause)
      )
    }

    /**
     * Holds if this split applies to catch clause `scc`. The parameter `match`
     * indicates whether the catch clause `scc` may match the exception type of
     * this split.
     */
    private predicate appliesToCatchClause(SpecificCatchClause scc, TMatch match) {
      exists(TryStmt ts, ExceptionClass ec |
        ec = this.getExceptionClass() and
        ec = getAThrownException(ts, _, _) and
        scc = ts.getACatchClause()
      |
        if scc.getCaughtExceptionType() = ec.getABaseType*()
        then match = TAlways()
        else
          if scc.getCaughtExceptionType() = ec.getASubType+()
          then match = TMaybe()
          else match = TNever()
      )
    }

    /**
     * Holds if this split applies to control flow element `pred`, where `pred`
     * is a valid predecessor with completion `c`.
     */
    private predicate appliesToPredecessor(ControlFlowElement pred, Completion c) {
      this.appliesTo(pred) and
      (exists(succ(pred, c)) or exists(succExit(pred, c))) and
      (
        pred instanceof SpecificCatchClause
        implies
        pred = any(SpecificCatchClause scc |
            if c instanceof MatchingCompletion
            then
              exists(TMatch match | this.appliesToCatchClause(scc, match) |
                c = any(MatchingCompletion mc |
                    if mc.isMatch() then match != TNever() else match != TAlways()
                  )
              )
            else (
              (scc.isLast() and c instanceof ThrowCompletion)
              implies
              exists(TMatch match | this.appliesToCatchClause(scc, match) | match != TAlways())
            )
          )
      )
    }

    /**
     * Holds if this split applies to `pred`, and `pred` may exit this split
     * with throw completion `c`, because it belongs to the last `catch` clause
     * in a `try` statement.
     */
    private predicate hasLastExit(ControlFlowElement pred, ThrowCompletion c) {
      this.appliesToPredecessor(pred, c) and
      exists(TryStmt ts, SpecificCatchClause scc, int last |
        pred = last(ts.getCatchClause(last), c)
      |
        ts.getCatchClause(last) = scc and
        scc.isLast() and
        c.getExceptionClass() = this.getExceptionClass()
      )
    }

    override predicate hasExit(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      this.appliesToPredecessor(pred, c) and
      succ = succ(pred, c) and
      (
        // Exit out to `catch` clause block
        succ = first(any(SpecificCatchClause scc).getBlock())
        or
        // Exit out to a general `catch` clause
        succ instanceof GeneralCatchClause
        or
        // Exit out from last `catch` clause (no catch clauses match)
        this.hasLastExit(pred, c)
      )
    }

    override predicate hasExit(ControlFlowElement pred, Completion c) {
      // Exit out from last `catch` clause (no catch clauses match)
      this.hasLastExit(pred, c) and
      exists(succExit(pred, c))
    }

    override predicate hasSuccessor(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      this.appliesToPredecessor(pred, c) and
      succ = succ(pred, c) and
      not succ = first(any(SpecificCatchClause scc).getBlock()) and
      not succ instanceof GeneralCatchClause and
      not exists(TryStmt ts, SpecificCatchClause scc, int last |
        pred = last(ts.getCatchClause(last), c)
      |
        ts.getCatchClause(last) = scc and
        scc.isLast()
      )
    }
  }
}

module BooleanSplitting {
  private import semmle.code.csharp.controlflow.internal.PreBasicBlocks

  /** A sub-classification of Boolean splits. */
  abstract class BooleanSplitSubKind extends TBooleanSplitSubKind {
    /**
     * Holds if the branch taken by condition `cb1` should be recorded in
     * this split, and the recorded value determines the branch taken by a
     * later condition `cb2`, possibly inverted.
     *
     * For example, in
     *
     * ```
     * var b = GetB();
     * if (b)
     *     Console.WriteLine("b is true");
     * if (!b)
     *     Console.WriteLine("b is false");
     * ```
     *
     * the branch taken in the condition on line 2 can be recorded, and the
     * recorded value will detmine the branch taken in the condition on line 4.
     */
    abstract predicate correlatesConditions(ConditionBlock cb1, ConditionBlock cb2, boolean inverted);

    /** Holds if control flow element `cfe` starts a split of this kind. */
    predicate startsSplit(ControlFlowElement cfe) {
      this.correlatesConditions(any(ConditionBlock cb | cb.getLastElement() = cfe), _, _)
    }

    /**
     * Holds if basic block `bb` can reach a condition correlated with a
     * split of this kind.
     */
    abstract predicate canReachCorrelatedCondition(PreBasicBlock bb);

    /** Gets the callable that this Boolean split kind belongs to. */
    abstract Callable getEnclosingCallable();

    /** Gets a textual representation of this Boolean split kind. */
    abstract string toString();

    /** Gets the location of this Boolean split kind. */
    abstract Location getLocation();
  }

  /**
   * A Boolean split that records the value of a Boolean SSA variable.
   *
   * For example, in
   *
   * ```
   * var b = GetB();
   * if (b)
   *     Console.WriteLine("b is true");
   * if (!b)
   *     Console.WriteLine("b is false");
   * ```
   *
   * there is a Boolean split on the SSA variable for `b` at line 1.
   */
  class SsaBooleanSplitSubKind extends BooleanSplitSubKind, TSsaBooleanSplitSubKind {
    private PreSsa::Definition def;

    SsaBooleanSplitSubKind() { this = TSsaBooleanSplitSubKind(def) }

    /**
     * Holds if condition `cb` is a read of the SSA variable in this split.
     */
    private predicate defCondition(ConditionBlock cb) { cb.getLastElement() = def.getARead() }

    /**
     * Holds if condition `cb` is a read of the SSA variable in this split,
     * and `cb` can be reached from `read` without passing through another
     * condition that reads the same SSA variable.
     */
    private predicate defConditionReachableFromRead(ConditionBlock cb, AssignableRead read) {
      this.defCondition(cb) and
      read = cb.getLastElement()
      or
      exists(AssignableRead mid | this.defConditionReachableFromRead(cb, mid) |
        PreSsa::adjacentReadPairSameVar(read, mid) and
        not this.defCondition(read)
      )
    }

    /**
     * Holds if condition `cb` is a read of the SSA variable in this split,
     * and `cb` can be reached from the SSA definition without passing through
     * another condition that reads the same SSA variable.
     */
    private predicate firstDefCondition(ConditionBlock cb) {
      exists(AssignableRead read | this.defConditionReachableFromRead(cb, read) |
        PreSsa::firstReadSameVar(def, read)
      )
    }

    override predicate correlatesConditions(ConditionBlock cb1, ConditionBlock cb2, boolean inverted) {
      this.firstDefCondition(cb1) and
      exists(AssignableRead read1, AssignableRead read2 |
        read1 = cb1.getLastElement() and
        PreSsa::adjacentReadPairSameVar+(read1, read2) and
        read2 = cb2.getLastElement() and
        inverted = false
      )
    }

    override predicate canReachCorrelatedCondition(PreBasicBlock bb) {
      this.correlatesConditions(_, bb, _) and
      not def.getBasicBlock() = bb
      or
      exists(PreBasicBlock mid | this.canReachCorrelatedCondition(mid) |
        bb = mid.getAPredecessor() and
        not def.getBasicBlock() = bb
      )
    }

    override Callable getEnclosingCallable() { result = def.getCallable() }

    override string toString() { result = def.getAssignable().toString() }

    override Location getLocation() { result = def.getLocation() }
  }

  /**
   * A split for elements that can reach a condition where this split determines
   * the Boolean value that the condition evaluates to. For example, in
   *
   * ```
   * if (b)
   *     Console.WriteLine("b is true");
   * if (!b)
   *     Console.WriteLine("b is false");
   * ```
   *
   * all control flow nodes on line 2 and line 3 have two splits: one representing
   * that the condition on line 1 took the `true` branch, and one representing that
   * the condition on line 1 took the `false` branch.
   */
  class BooleanSplitImpl extends SplitImpl, TBooleanSplit {
    private BooleanSplitSubKind kind;

    private boolean branch;

    BooleanSplitImpl() { this = TBooleanSplit(kind, branch) }

    /** Gets the kind of this Boolean split. */
    BooleanSplitSubKind getSubKind() { result = kind }

    /** Gets the branch taken in this split. */
    boolean getBranch() { result = branch }

    override string toString() {
      exists(int line |
        line = kind.getLocation().getStartLine() and
        result = kind.toString() + " (line " + line + "): " + branch.toString()
      )
    }
  }

  private class BooleanSplitKind extends SplitKind, TBooleanSplitKind {
    private BooleanSplitSubKind kind;

    BooleanSplitKind() { this = TBooleanSplitKind(kind) }

    /** Gets the sub kind of this Boolean split kind. */
    BooleanSplitSubKind getSubKind() { result = kind }

    override int getListOrder() {
      exists(Callable c, int r | c = kind.getEnclosingCallable() |
        result = r + 1 and // start the ordering from 2
        kind = rank[r](BooleanSplitSubKind kind0 |
            kind0.getEnclosingCallable() = c and
            kind0.startsSplit(_)
          |
            kind0
            order by
              kind0.getLocation().getStartLine(), kind0.getLocation().getStartColumn(),
              kind0.toString()
          )
      )
    }

    override predicate isMandatory() { none() }

    override string toString() { result = kind.toString() }
  }

  private class BooleanSplitInternal extends SplitInternal, BooleanSplitImpl {
    override BooleanSplitKind getKind() { result.getSubKind() = this.getSubKind() }

    override predicate hasEntry(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      succ = succ(pred, c) and
      this.getSubKind().startsSplit(pred) and
      this.getBranch() = c.getInnerCompletion().(BooleanCompletion).getValue()
    }

    private ConditionBlock getACorrelatedCondition(boolean inverted) {
      this.getSubKind().correlatesConditions(_, result, inverted)
    }

    /**
     * Holds if this split applies to basic block `bb`, where the the last
     * element of `bb` can have completion `c`.
     */
    private predicate appliesToBlock(PreBasicBlock bb, Completion c) {
      this.appliesTo(bb) and
      exists(ControlFlowElement last | last = bb.getLastElement() |
        (exists(succ(last, c)) or exists(succExit(last, c))) and
        // Respect the value recorded in this split for all correlated conditions
        forall(boolean inverted | bb = this.getACorrelatedCondition(inverted) |
          c.getInnerCompletion() instanceof BooleanCompletion
          implies
          c.getInnerCompletion().(BooleanCompletion).getValue() = this
                .getBranch()
                .booleanXor(inverted)
        )
      )
    }

    override predicate hasExit(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      exists(PreBasicBlock bb | this.appliesToBlock(bb, c) |
        pred = bb.getLastElement() and
        succ = succ(pred, c) and
        // Exit this split if we can no longer reach a correlated condition
        not this.getSubKind().canReachCorrelatedCondition(succ)
      )
    }

    override predicate hasExit(ControlFlowElement pred, Completion c) {
      exists(PreBasicBlock bb | this.appliesToBlock(bb, c) |
        pred = bb.getLastElement() and
        exists(succExit(pred, c))
      )
    }

    override predicate hasSuccessor(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      exists(PreBasicBlock bb, Completion c0 | this.appliesToBlock(bb, c0) |
        pred = bb.getAnElement() and
        succ = succ(pred, c) and
        (
          pred = bb.getLastElement()
          implies
          (
            // We must still be able to reach a correlated condition to stay in this split
            this.getSubKind().canReachCorrelatedCondition(succ) and
            c = c0
          )
        )
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
  SplitInternal getASplit() {
    exists(SplitInternal head, Splits tail | this = TSplitsCons(head, tail) |
      result = head
      or
      result = tail.getASplit()
    )
  }
}

/**
 * Holds if `succ` with splits `succSplits` is the first element that is executed
 * when entering callable `pred`.
 */
pragma[noinline]
predicate succEntrySplits(
  @top_level_exprorstmt_parent pred, ControlFlowElement succ, Splits succSplits, SuccessorType t
) {
  succ = succEntry(pred) and
  t instanceof NormalSuccessor and
  succSplits = TSplitsNil() // initially no splits
}

/**
 * Holds if `pred` with splits `predSplits` can exit the enclosing callable
 * `succ` with type `t`.
 */
predicate succExitSplits(ControlFlowElement pred, Splits predSplits, Callable succ, SuccessorType t) {
  exists(Reachability::SameSplitsBlock b, Completion c | pred = b.getAnElement() |
    b.isReachable(predSplits) and
    t.matchesCompletion(c) and
    succ = succExit(pred, c) and
    forall(SplitInternal predSplit | predSplit = predSplits.getASplit() |
      predSplit.hasExit(pred, c)
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
 * ```
 * succSplits(ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits, Completion c)
 * ```
 *
 * the following invariants are maintained:
 *
 * 1. `pred` is reachable with split set `predSplits`.
 * 2. For all `split` in `predSplits`:
 *    - If `split.hasSuccessor(pred, succ, c)` then `split` in `succSplits`.
 * 3. For all `split` in `predSplits`:
 *    - If `split.hasExit(pred, succ, c)` then `split` not in `succSplits`.
 * 4. For all `split` not in `predSplits`:
 *    - If `split.hasEntry(pred, succ, c)` then `split` in `succSplits`.
 * 5. For all `split` in `succSplits`:
 *    - `split.hasSuccessor(pred, succ, c)` and `split` in `predSplits`, or
 *    - `split.hasEntry(pred, succ, c)` and `split` not in `predSplits`.
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
    b.isReachable(predSplits) and
    succ = succ(pred, c)
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
      not exists(SplitInternal split | split.hasEntry(pred, succ, c))
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
    exists(Splits mid, SplitInternal split | case1bForall(pred, predSplits, succ, c, mid) |
      mid = TSplitsCons(split, except) and
      split.hasSuccessor(pred, succ, c)
    )
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

  private predicate case2aux(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c
  ) {
    exists(Reachability::SameSplitsBlock b |
      succInvariant1(b, pred, predSplits, succ, c) and
      (succ = b.getAnElement() implies succ = b)
    |
      predSplits.getASplit().hasExit(pred, succ, c)
      or
      any(SplitInternal split).hasEntry(pred, succ, c)
    )
  }

  /**
   * Holds if `succSplits` should not inherit a split of kind `sk` from
   * `predSplits, except possibly because of a split in `except`.
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
    exists(Splits mid, SplitInternal split |
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
    ControlFlowElement pred, ControlFlowElement succ, Completion c, SplitInternal split,
    SplitKind sk
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
  private SplitInternal case2auxGetAPredecessorSplit(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c
  ) {
    case2aux(pred, predSplits, succ, c) and
    result = predSplits.getASplit()
  }

  /** Gets a split that should be in `succSplits`. */
  pragma[nomagic]
  private SplitInternal case2aSome(
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
  SplitInternal case2aSomeAtRank(
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
    Completion c, int rnk, int numberOfSplits
  ) {
    case2aux(pred, predSplits, succ, c) and
    succSplits = TSplitsNil() and
    rnk = max(any(SplitKind sk).getListRank(succ)) + 1 and
    numberOfSplits = 0
    or
    case2aFromRank(pred, predSplits, succ, succSplits, c, rnk + 1, numberOfSplits) and
    case2aNoneAtRank(pred, predSplits, succ, c, rnk)
    or
    exists(Splits mid, SplitInternal split, int numberOfSplitsMid |
      split = case2aCons(pred, predSplits, succ, mid, c, rnk, numberOfSplitsMid)
    |
      if numberOfSplitsMid < maxSplits() or split.getKind().isMandatory()
      then succSplits = TSplitsCons(split, mid) and numberOfSplits = numberOfSplitsMid + 1
      else (
        succSplits = mid and numberOfSplits = numberOfSplitsMid
      )
    )
  }

  pragma[noinline]
  private SplitInternal case2aCons(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
    Completion c, int rnk, int numberOfSplits
  ) {
    case2aFromRank(pred, predSplits, succ, succSplits, c, rnk + 1, numberOfSplits) and
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
    exists(Splits mid, SplitInternal split | case2bForall(pred, predSplits, succ, c, mid) |
      mid = TSplitsCons(split, except) and
      // Invariants 2 and 3
      split.hasExit(pred, succ, c)
    )
  }

  private predicate case2(
    ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits,
    Completion c
  ) {
    case2aFromRank(pred, predSplits, succ, succSplits, c, 1, _)
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
module Reachability {
  /**
   * Holds if `cfe` is a control flow element where the set of possible splits may
   * be different from the set of possible splits for one of `cfe`'s predecessors.
   * That is, `cfe` starts a new block of elements with the same set of splits.
   */
  private predicate startsSplits(ControlFlowElement cfe) {
    cfe = succEntry(_)
    or
    exists(SplitInternal s |
      s.hasEntry(_, cfe, _)
      or
      s.hasExit(_, cfe, _)
    )
    or
    exists(ControlFlowElement pred, SplitInternal split, Completion c | cfe = succ(pred, c) |
      split.appliesTo(pred) and
      not split.hasSuccessor(pred, cfe, c)
    )
  }

  private predicate intraSplitsSucc(ControlFlowElement pred, ControlFlowElement succ) {
    succ = succ(pred, _) and
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

    private SameSplitsBlock getASuccessor(Splits predSplits, Splits succSplits) {
      exists(ControlFlowElement pred | pred = this.getAnElement() |
        succSplits(pred, predSplits, result, succSplits, _)
      )
    }

    /**
     * Holds if the elements of this block are reachable from a callable entry
     * point, with the splits `splits`.
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
