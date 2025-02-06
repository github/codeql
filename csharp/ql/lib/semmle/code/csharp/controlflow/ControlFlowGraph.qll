import csharp

/**
 * Provides classes representing the control flow graph within callables.
 */
module ControlFlow {
  private import semmle.code.csharp.controlflow.BasicBlocks as BBs
  import semmle.code.csharp.controlflow.internal.SuccessorType
  private import SuccessorTypes
  private import internal.ControlFlowGraphImpl as Impl
  private import internal.Splitting as Splitting

  /**
   * A control flow node.
   *
   * Either a callable entry node (`EntryNode`), a callable exit node (`ExitNode`),
   * or a control flow node for a control flow element, that is, an expression or a
   * statement (`ElementNode`).
   *
   * A control flow node is a node in the control flow graph (CFG). There is a
   * many-to-one relationship between `ElementNode`s and `ControlFlowElement`s.
   * This allows control flow splitting, for example modeling the control flow
   * through `finally` blocks.
   *
   * Only nodes that can be reached from the callable entry point are included in
   * the CFG.
   */
  class Node extends Impl::Node {
    /** Gets the control flow element that this node corresponds to, if any. */
    final ControlFlowElement getAstNode() { result = super.getAstNode() }

    /** Gets the basic block that this control flow node belongs to. */
    BasicBlock getBasicBlock() { result.getANode() = this }

    /**
     * Holds if this node dominates `that` node.
     *
     * That is, all paths reaching `that` node from some callable entry
     * node (`EntryNode`) must go through this node.
     *
     * Example:
     *
     * ```csharp
     * int M(string s)
     * {
     *     if (s == null)
     *         throw new ArgumentNullException(nameof(s));
     *     return s.Length;
     * }
     * ```
     *
     * The node on line 3 dominates the node on line 5 (all paths from the
     * entry point of `M` to `return s.Length;` must go through the null check).
     *
     * This predicate is *reflexive*, so for example `if (s == null)` dominates
     * itself.
     */
    // potentially very large predicate, so must be inlined
    pragma[inline]
    predicate dominates(Node that) {
      this.strictlyDominates(that)
      or
      this = that
    }

    /**
     * Holds if this node strictly dominates `that` node.
     *
     * That is, all paths reaching `that` node from some callable entry
     * node (`EntryNode`) must go through this node (which must
     * be different from `that` node).
     *
     * Example:
     *
     * ```csharp
     * int M(string s)
     * {
     *     if (s == null)
     *         throw new ArgumentNullException(nameof(s));
     *     return s.Length;
     * }
     * ```
     *
     * The node on line 3 strictly dominates the node on line 5
     * (all paths from the entry point of `M` to `return s.Length;` must go
     * through the null check).
     */
    // potentially very large predicate, so must be inlined
    pragma[inline]
    predicate strictlyDominates(Node that) {
      this.getBasicBlock().strictlyDominates(that.getBasicBlock())
      or
      exists(BasicBlock bb, int i, int j |
        bb.getNode(i) = this and
        bb.getNode(j) = that and
        i < j
      )
    }

    /**
     * Holds if this node post-dominates `that` node.
     *
     * That is, all paths reaching a normal callable exit node (an `AnnotatedExitNode`
     * with a normal exit type) from `that` node must go through this node.
     *
     * Example:
     *
     * ```csharp
     * int M(string s)
     * {
     *     try
     *     {
     *         return s.Length;
     *     }
     *     finally
     *     {
     *         Console.WriteLine("M");
     *     }
     * }
     * ```
     *
     * The node on line 9 post-dominates the node on line 5 (all paths to the
     * exit point of `M` from `return s.Length;` must go through the `WriteLine`
     * call).
     *
     * This predicate is *reflexive*, so for example `Console.WriteLine("M");`
     * post-dominates itself.
     */
    // potentially very large predicate, so must be inlined
    pragma[inline]
    predicate postDominates(Node that) {
      this.strictlyPostDominates(that)
      or
      this = that
    }

    /**
     * Holds if this node strictly post-dominates `that` node.
     *
     * That is, all paths reaching a normal callable exit node (an `AnnotatedExitNode`
     * with a normal exit type) from `that` node must go through this node
     * (which must be different from `that` node).
     *
     * Example:
     *
     * ```csharp
     * int M(string s)
     * {
     *     try
     *     {
     *         return s.Length;
     *     }
     *     finally
     *     {
     *          Console.WriteLine("M");
     *     }
     * }
     * ```
     *
     * The node on line 9 strictly post-dominates the node on line 5 (all
     * paths to the exit point of `M` from `return s.Length;` must go through
     * the `WriteLine` call).
     */
    // potentially very large predicate, so must be inlined
    pragma[inline]
    predicate strictlyPostDominates(Node that) {
      this.getBasicBlock().strictlyPostDominates(that.getBasicBlock())
      or
      exists(BasicBlock bb, int i, int j |
        bb.getNode(i) = this and
        bb.getNode(j) = that and
        i > j
      )
    }

    /** Gets a successor node of a given type, if any. */
    Node getASuccessorByType(SuccessorType t) { result = this.getASuccessor(t) }

    /** Gets an immediate successor, if any. */
    Node getASuccessor() { result = this.getASuccessorByType(_) }

    /** Gets an immediate predecessor node of a given flow type, if any. */
    Node getAPredecessorByType(SuccessorType t) { result.getASuccessorByType(t) = this }

    /** Gets an immediate predecessor, if any. */
    Node getAPredecessor() { result = this.getAPredecessorByType(_) }

    /**
     * Gets an immediate `true` successor, if any.
     *
     * An immediate `true` successor is a successor that is reached when
     * this condition evaluates to `true`.
     *
     * Example:
     *
     * ```csharp
     * if (x < 0)
     *     x = -x;
     * ```
     *
     * The node on line 2 is an immediate `true` successor of the node
     * on line 1.
     */
    Node getATrueSuccessor() {
      result = this.getASuccessorByType(any(BooleanSuccessor t | t.getValue() = true))
    }

    /**
     * Gets an immediate `false` successor, if any.
     *
     * An immediate `false` successor is a successor that is reached when
     * this condition evaluates to `false`.
     *
     * Example:
     *
     * ```csharp
     * if (!(x >= 0))
     *     x = -x;
     * ```
     *
     * The node on line 2 is an immediate `false` successor of the node
     * on line 1.
     */
    Node getAFalseSuccessor() {
      result = this.getASuccessorByType(any(BooleanSuccessor t | t.getValue() = false))
    }

    /** Gets the enclosing callable of this control flow node. */
    final Callable getEnclosingCallable() { result = Impl::getNodeCfgScope(this) }
  }

  /** Provides different types of control flow nodes. */
  module Nodes {
    /** A node for a callable entry point. */
    class EntryNode extends Node instanceof Impl::EntryNode {
      /** Gets the callable that this entry applies to. */
      Callable getCallable() { result = this.getScope() }

      override BasicBlocks::EntryBlock getBasicBlock() { result = Node.super.getBasicBlock() }
    }

    /** A node for a callable exit point, annotated with the type of exit. */
    class AnnotatedExitNode extends Node instanceof Impl::AnnotatedExitNode {
      /** Holds if this node represent a normal exit. */
      final predicate isNormal() { super.isNormal() }

      /** Gets the callable that this exit applies to. */
      Callable getCallable() { result = this.getScope() }

      override BasicBlocks::AnnotatedExitBlock getBasicBlock() {
        result = Node.super.getBasicBlock()
      }
    }

    /** A node for a callable exit point. */
    class ExitNode extends Node instanceof Impl::ExitNode {
      /** Gets the callable that this exit applies to. */
      Callable getCallable() { result = this.getScope() }

      override BasicBlocks::ExitBlock getBasicBlock() { result = Node.super.getBasicBlock() }
    }

    /**
     * A node for a control flow element, that is, an expression or a statement.
     *
     * Each control flow element maps to zero or more `ElementNode`s: zero when
     * the element is in unreachable (dead) code, and multiple when there are
     * different splits for the element.
     */
    class ElementNode extends Node instanceof Impl::AstCfgNode {
      /** Gets a comma-separated list of strings for each split in this node, if any. */
      final string getSplitsString() { result = super.getSplitsString() }

      /** Gets a split for this control flow node, if any. */
      final Split getASplit() { result = super.getASplit() }
    }

    /** A control-flow node for an expression. */
    class ExprNode extends ElementNode {
      Expr e;

      ExprNode() { e = unique(Expr e_ | e_ = this.getAstNode() | e_) }

      /** Gets the expression that this control-flow node belongs to. */
      Expr getExpr() { result = e }

      /** Gets the value of this expression node, if any. */
      string getValue() { result = e.getValue() }

      /** Gets the type of this expression node. */
      Type getType() { result = e.getType() }
    }

    class Split = Splitting::Split;

    class FinallySplit = Splitting::FinallySplitting::FinallySplit;

    class ExceptionHandlerSplit = Splitting::ExceptionHandlerSplitting::ExceptionHandlerSplit;

    class BooleanSplit = Splitting::BooleanSplitting::BooleanSplit;

    class LoopSplit = Splitting::LoopSplitting::LoopSplit;
  }

  class BasicBlock = BBs::BasicBlock;

  /** Provides different types of basic blocks. */
  module BasicBlocks {
    class EntryBlock = BBs::EntryBasicBlock;

    class AnnotatedExitBlock = BBs::AnnotatedExitBasicBlock;

    class ExitBlock = BBs::ExitBasicBlock;

    class JoinBlock = BBs::JoinBlock;

    class JoinBlockPredecessor = BBs::JoinBlockPredecessor;

    class ConditionBlock = BBs::ConditionBlock;
  }
}
