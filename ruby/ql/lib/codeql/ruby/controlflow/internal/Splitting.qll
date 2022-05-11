/**
 * Provides classes and predicates relevant for splitting the control flow graph.
 */

private import codeql.ruby.AST
private import Completion
private import ControlFlowGraphImpl
private import SuccessorTypes
private import codeql.ruby.controlflow.ControlFlowGraph

cached
private module Cached {
  cached
  newtype TSplitKind =
    TConditionalCompletionSplitKind() { forceCachingInSameStage() } or
    TEnsureSplitKind(int nestLevel) { nestLevel = any(Trees::BodyStmtTree t).getNestLevel() }

  cached
  newtype TSplit =
    TConditionalCompletionSplit(ConditionalCompletion c) or
    TEnsureSplit(EnsureSplitting::EnsureSplitType type, int nestLevel) {
      nestLevel = any(Trees::BodyStmtTree t).getNestLevel()
    }
}

import Cached

/** A split for a control flow node. */
class Split extends TSplit {
  /** Gets a textual representation of this split. */
  string toString() { none() }
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

    BodyStmt getBlock() { result = block }

    pragma[noinline]
    predicate isEntered(AstNode pred, int nestLevel, Completion c) {
      this.isEntryNode() and
      nestLevel = this.getNestLevel() and
      succ(pred, this, c) and
      // the entry node may be reachable via a backwards loop edge; in this case
      // the split has already been entered
      not pred = block.getAnEnsureDescendant()
    }
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

  private class EnsureSplitImpl extends SplitImpl, EnsureSplit {
    override EnsureSplitKind getKind() { result.getNestLevel() = this.getNestLevel() }

    override predicate hasEntry(AstNode pred, AstNode succ, Completion c) {
      succ.(EnsureNode).isEntered(pred, this.getNestLevel(), c) and
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
    private predicate exit(AstNode pred, Completion c, boolean inherited) {
      exists(Trees::BodyStmtTree block, EnsureSplitType type |
        this.exit0(pred, block, this.getNestLevel(), c) and
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
        outer.exit(pred, c, inherited) and
        this.getType() instanceof NormalSuccessor and
        inherited = true
      )
    }

    override predicate hasExit(AstNode pred, AstNode succ, Completion c) {
      succ(pred, succ, c) and
      (
        this.exit(pred, c, _)
        or
        this.exit(pred, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion(), _)
      )
    }

    override predicate hasExitScope(CfgScope scope, AstNode last, Completion c) {
      succExit(scope, last, c) and
      (
        this.exit(last, c, _)
        or
        this.exit(last, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion(), _)
      )
    }

    override predicate hasSuccessor(AstNode pred, AstNode succ, Completion c) {
      this.appliesToPredecessor(pred) and
      succ(pred, succ, c) and
      succ =
        any(EnsureNode en |
          if en.isEntryNode() and en.getBlock() != pred.(EnsureNode).getBlock()
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
