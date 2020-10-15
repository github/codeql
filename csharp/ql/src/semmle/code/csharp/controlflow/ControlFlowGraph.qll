import csharp

/**
 * Provides classes representing the control flow graph within callables.
 */
module ControlFlow {
  private import semmle.code.csharp.controlflow.BasicBlocks as BBs
  private import semmle.code.csharp.controlflow.internal.Completion
  import semmle.code.csharp.controlflow.internal.SuccessorType
  private import SuccessorTypes

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
  class Node extends TNode {
    /** Gets a textual representation of this control flow node. */
    string toString() { none() }

    /** Gets the control flow element that this node corresponds to, if any. */
    ControlFlowElement getElement() { none() }

    /** Gets the location of this control flow node. */
    Location getLocation() { result = getElement().getLocation() }

    /** Holds if this control flow node has conditional successors. */
    predicate isCondition() { exists(getASuccessorByType(any(ConditionalSuccessor e))) }

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
      strictlyDominates(that)
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
     * That is, all paths reaching a callable exit node (`ExitNode`)
     * from `that` node must go through this node.
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
      strictlyPostDominates(that)
      or
      this = that
    }

    /**
     * Holds if this node strictly post-dominates `that` node.
     *
     * That is, all paths reaching a callable exit node (`ExitNode`)
     * from `that` node must go through this node (which must be different
     * from `that` node).
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
    Node getASuccessorByType(SuccessorType t) { result = getASuccessorByType(this, t) }

    /** Gets an immediate successor, if any. */
    Node getASuccessor() { result = getASuccessorByType(_) }

    /** Gets an immediate predecessor node of a given flow type, if any. */
    Node getAPredecessorByType(SuccessorType t) { result.getASuccessorByType(t) = this }

    /** Gets an immediate predecessor, if any. */
    Node getAPredecessor() { result = getAPredecessorByType(_) }

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
      result = getASuccessorByType(any(BooleanSuccessor t | t.getValue() = true))
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
      result = getASuccessorByType(any(BooleanSuccessor t | t.getValue() = false))
    }

    /** Holds if this node has more than one predecessor. */
    predicate isJoin() { strictcount(this.getAPredecessor()) > 1 }

    /** Holds if this node has more than one successor. */
    predicate isBranch() { strictcount(this.getASuccessor()) > 1 }

    /** Gets the enclosing callable of this control flow node. */
    Callable getEnclosingCallable() { none() }
  }

  /** Provides different types of control flow nodes. */
  module Nodes {
    /** A node for a callable entry point. */
    class EntryNode extends Node, TEntryNode {
      /** Gets the callable that this entry applies to. */
      Callable getCallable() { this = TEntryNode(result) }

      override BasicBlocks::EntryBlock getBasicBlock() { result = Node.super.getBasicBlock() }

      override Callable getEnclosingCallable() { result = this.getCallable() }

      override Location getLocation() { result = getCallable().getLocation() }

      override string toString() { result = "enter " + getCallable().toString() }
    }

    /** A node for a callable exit point. */
    class ExitNode extends Node, TExitNode {
      /** Gets the callable that this exit applies to. */
      Callable getCallable() { this = TExitNode(result) }

      override BasicBlocks::ExitBlock getBasicBlock() { result = Node.super.getBasicBlock() }

      override Callable getEnclosingCallable() { result = this.getCallable() }

      override Location getLocation() { result = getCallable().getLocation() }

      override string toString() { result = "exit " + getCallable().toString() }
    }

    /**
     * A node for a control flow element, that is, an expression or a statement.
     *
     * Each control flow element maps to zero or more `ElementNode`s: zero when
     * the element is in unreachable (dead) code, and multiple when there are
     * different splits for the element.
     */
    class ElementNode extends Node, TElementNode {
      private Splits splits;
      private ControlFlowElement cfe;

      ElementNode() { this = TElementNode(cfe, splits) }

      override Callable getEnclosingCallable() {
        result = cfe.getEnclosingCallable()
        or
        result = this.getASplit().(InitializerSplitting::InitializerSplitImpl).getConstructor()
      }

      override ControlFlowElement getElement() { result = cfe }

      override string toString() {
        result = "[" + this.getSplitsString() + "] " + cfe.toString()
        or
        not exists(this.getSplitsString()) and result = cfe.toString()
      }

      /** Gets a comma-separated list of strings for each split in this node, if any. */
      string getSplitsString() {
        result = splits.toString() and
        result != ""
      }

      /** Gets a split for this control flow node, if any. */
      Split getASplit() { result = splits.getASplit() }
    }

    class Split = SplitImpl;

    class FinallySplit = FinallySplitting::FinallySplitImpl;

    class ExceptionHandlerSplit = ExceptionHandlerSplitting::ExceptionHandlerSplitImpl;

    class BooleanSplit = BooleanSplitting::BooleanSplitImpl;

    class LoopSplit = LoopSplitting::LoopSplitImpl;
  }

  class BasicBlock = BBs::BasicBlock;

  /** Provides different types of basic blocks. */
  module BasicBlocks {
    class EntryBlock = BBs::EntryBasicBlock;

    class ExitBlock = BBs::ExitBasicBlock;

    class JoinBlock = BBs::JoinBlock;

    class JoinBlockPredecessor = BBs::JoinBlockPredecessor;

    class ConditionBlock = BBs::ConditionBlock;
  }

  /**
   * INTERNAL: Do not use.
   */
  module Internal {
    import semmle.code.csharp.controlflow.internal.Splitting

    /**
     * Provides auxiliary classes and predicates used to construct the basic successor
     * relation on control flow elements.
     *
     * The implementation is centered around the concept of a _completion_, which
     * models how the execution of a statement or expression terminates.
     * Completions are represented as an algebraic data type `Completion` defined in
     * `Completion.qll`.
     *
     * The CFG is built by structural recursion over the AST. To achieve this the
     * CFG edges related to a given AST node, `n`, are divided into three categories:
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
     * edge contained within `n`, by the predicates `k = first(n)` and `k = last(n, _)`,
     * respectively. The edges in (3) can then be enumerated directly by the predicate
     * `succ` by calling `first` and `last` recursively on the children of `n` and
     * connecting the end-points. This yields the entire CFG, since all edges are in
     * (3) for _some_ AST node.
     *
     * The second parameter of `last` is the completion, which is necessary to distinguish
     * the out-going edges from `n`. Note that the completion changes as the calculation of
     * `last` proceeds outward through the AST; for example, a `BreakCompletion` is
     * caught up by its surrounding loop and turned into a `NormalCompletion`, and a
     * `NormalCompletion` proceeds outward through the end of a `finally` block and is
     * turned into whatever completion was caught by the `finally`.
     *
     * An important goal of the CFG is to get the order of side-effects correct.
     * Most expressions can have side-effects and must therefore be modeled in the
     * CFG in AST post-order. For example, a `MethodCall` evaluates its arguments
     * before the call. Most statements do not have side-effects, but merely affect
     * the control flow and some could therefore be excluded from the CFG. However,
     * as a design choice, all statements are included in the CFG and generally
     * serve as their own entry-points, thus executing in some version of AST
     * pre-order.
     */
    module Successor {
      private import semmle.code.csharp.ExprOrStmtParent

      /**
       * A control flow element where the children are evaluated following a
       * standard left-to-right evaluation. The actual evaluation order is
       * determined by the predicate `getChildElement()`.
       */
      abstract private class StandardElement extends ControlFlowElement {
        /** Gets the first child element of this element. */
        ControlFlowElement getFirstChildElement() { result = this.getChildElement(0) }

        /** Holds if this element has no children. */
        predicate isLeafElement() { not exists(this.getFirstChildElement()) }

        /** Gets the last child element of this element. */
        ControlFlowElement getLastChildElement() {
          exists(int last |
            last = max(int i | exists(this.getChildElement(i))) and
            result = this.getChildElement(last)
          )
        }

        /** Gets the `i`th child element, which is not the last element. */
        pragma[noinline]
        ControlFlowElement getNonLastChildElement(int i) {
          result = this.getChildElement(i) and
          not result = this.getLastChildElement()
        }

        /** Gets the `i`th child element, in order of evaluation, starting from 0. */
        abstract ControlFlowElement getChildElement(int i);
      }

      private class StandardStmt extends StandardElement, Stmt {
        StandardStmt() {
          // The following statements need special treatment
          not this instanceof IfStmt and
          not this instanceof SwitchStmt and
          not this instanceof CaseStmt and
          not this instanceof LoopStmt and
          not this instanceof TryStmt and
          not this instanceof SpecificCatchClause and
          not this instanceof JumpStmt
        }

        override ControlFlowElement getChildElement(int i) {
          not this instanceof GeneralCatchClause and
          not this instanceof FixedStmt and
          not this instanceof UsingBlockStmt and
          result = this.getChild(i)
          or
          this = any(GeneralCatchClause gcc | i = 0 and result = gcc.getBlock())
          or
          this =
            any(FixedStmt fs |
              result = fs.getVariableDeclExpr(i)
              or
              result = fs.getBody() and
              i = max(int j | exists(fs.getVariableDeclExpr(j))) + 1
            )
          or
          this =
            any(UsingBlockStmt us |
              if exists(us.getExpr())
              then (
                result = us.getExpr() and
                i = 0
                or
                result = us.getBody() and
                i = 1
              ) else (
                result = us.getVariableDeclExpr(i)
                or
                result = us.getBody() and
                i = max(int j | exists(us.getVariableDeclExpr(j))) + 1
              )
            )
        }
      }

      /**
       * An assignment operation that has an expanded version. We use the expanded
       * version in the control flow graph in order to get better data flow / taint
       * tracking.
       */
      private class AssignOperationWithExpandedAssignment extends AssignOperation {
        AssignOperationWithExpandedAssignment() { this.hasExpandedAssignment() }
      }

      /** A conditionally qualified expression. */
      private class ConditionallyQualifiedExpr extends QualifiableExpr {
        ConditionallyQualifiedExpr() { this.isConditional() }
      }

      /** An expression that should not be included in the control flow graph. */
      abstract private class NoNodeExpr extends Expr { }

      private class SimpleNoNodeExpr extends NoNodeExpr {
        SimpleNoNodeExpr() {
          this instanceof TypeAccess and
          not this = any(PatternMatch pm).getPattern()
        }
      }

      /** A write access that is not also a read access. */
      private class WriteAccess extends AssignableWrite {
        WriteAccess() {
          // `x++` is both a read and write access
          not this instanceof AssignableRead
        }
      }

      private class WriteAccessNoNodeExpr extends WriteAccess, NoNodeExpr {
        WriteAccessNoNodeExpr() {
          // For example a write to a static field, `Foo.Bar = 0`.
          forall(Expr e | e = this.getAChildExpr() | e instanceof NoNodeExpr)
        }
      }

      private ControlFlowElement getExprChildElement0(Expr e, int i) {
        not e instanceof NameOfExpr and
        not e instanceof QualifiableExpr and
        not e instanceof Assignment and
        not e instanceof AnonymousFunctionExpr and
        result = e.getChild(i)
        or
        e = any(ExtensionMethodCall emc | result = emc.getArgument(i))
        or
        e =
          any(QualifiableExpr qe |
            not qe instanceof ExtensionMethodCall and
            result = qe.getChild(i)
          )
        or
        e =
          any(Assignment a |
            // The left-hand side of an assignment is evaluated before the right-hand side
            i = 0 and result = a.getLValue()
            or
            i = 1 and result = a.getRValue()
          )
      }

      private ControlFlowElement getExprChildElement(Expr e, int i) {
        result =
          rank[i + 1](ControlFlowElement cfe, int j |
            cfe = getExprChildElement0(e, j) and
            not cfe instanceof NoNodeExpr
          |
            cfe order by j
          )
      }

      private int getFirstChildElement(Expr e) {
        result = min(int i | exists(getExprChildElement(e, i)))
      }

      private int getLastChildElement(Expr e) {
        result = max(int i | exists(getExprChildElement(e, i)))
      }

      /**
       * A qualified write access. In a qualified write access, the access itself is
       * not evaluated, only the qualifier and the indexer arguments (if any).
       */
      private class QualifiedWriteAccess extends WriteAccess, QualifiableExpr {
        QualifiedWriteAccess() {
          this.hasQualifier()
          or
          // Member initializers like
          // ```csharp
          // new Dictionary<int, string>() { [0] = "Zero", [1] = "One", [2] = "Two" }
          // ```
          // need special treatment, because the the accesses `[0]`, `[1]`, and `[2]`
          // have no qualifier.
          this = any(MemberInitializer mi).getLValue()
        }
      }

      /** A normal or a (potential) dynamic call to an accessor. */
      private class StatOrDynAccessorCall extends Expr {
        StatOrDynAccessorCall() {
          this instanceof AccessorCall or
          this instanceof DynamicAccess
        }
      }

      /**
       * An expression that writes via an accessor call, for example `x.Prop = 0`,
       * where `Prop` is a property.
       *
       * Accessor writes need special attention, because we need to model the fact
       * that the accessor is called *after* the assigned value has been evaluated.
       * In the example above, this means we want a CFG that looks like
       *
       * ```csharp
       * x -> 0 -> set_Prop -> x.Prop = 0
       * ```
       */
      class AccessorWrite extends Expr {
        AssignableDefinition def;

        AccessorWrite() {
          def.getExpr() = this and
          def.getTargetAccess().(WriteAccess) instanceof StatOrDynAccessorCall and
          not this instanceof AssignOperationWithExpandedAssignment
        }

        /**
         * Gets the `i`th accessor being called in this write. More than one call
         * can happen in tuple assignments.
         */
        StatOrDynAccessorCall getCall(int i) {
          result =
            rank[i + 1](AssignableDefinitions::TupleAssignmentDefinition tdef |
              tdef.getExpr() = this and tdef.getTargetAccess() instanceof StatOrDynAccessorCall
            |
              tdef order by tdef.getEvaluationOrder()
            ).getTargetAccess()
          or
          i = 0 and
          result = def.getTargetAccess() and
          not def instanceof AssignableDefinitions::TupleAssignmentDefinition
        }
      }

      private class StandardExpr extends StandardElement, Expr {
        StandardExpr() {
          // The following expressions need special treatment
          not this instanceof LogicalNotExpr and
          not this instanceof LogicalAndExpr and
          not this instanceof LogicalOrExpr and
          not this instanceof NullCoalescingExpr and
          not this instanceof ConditionalExpr and
          not this instanceof AssignOperationWithExpandedAssignment and
          not this instanceof ConditionallyQualifiedExpr and
          not this instanceof ThrowExpr and
          not this instanceof ObjectCreation and
          not this instanceof ArrayCreation and
          not this instanceof QualifiedWriteAccess and
          not this instanceof AccessorWrite and
          not this instanceof NoNodeExpr and
          not this instanceof SwitchExpr and
          not this instanceof SwitchCaseExpr
        }

        override ControlFlowElement getChildElement(int i) { result = getExprChildElement(this, i) }
      }

      /**
       * Gets the first element executed within control flow element `cfe`.
       */
      ControlFlowElement first(ControlFlowElement cfe) {
        // Pre-order: element itself
        cfe instanceof PreOrderElement and
        result = cfe
        or
        // Post-order: first element of first child (or self, if no children)
        cfe =
          any(PostOrderElement poe |
            result = first(poe.getFirstChild())
            or
            not exists(poe.getFirstChild()) and
            result = poe
          )
        or
        cfe =
          any(AssignOperationWithExpandedAssignment a | result = first(a.getExpandedAssignment()))
        or
        cfe = any(ConditionallyQualifiedExpr cqe | result = first(getExprChildElement(cqe, 0)))
        or
        cfe =
          any(ArrayCreation ac |
            // First element of first length argument
            result = first(ac.getLengthArgument(0))
            or
            // No length argument: element itself
            not exists(ac.getLengthArgument(0)) and
            result = ac
          )
        or
        cfe =
          any(ForeachStmt fs |
            // Unlike most other statements, `foreach` statements are not modelled in
            // pre-order, because we use the `foreach` node itself to represent the
            // emptiness test that determines whether to execute the loop body
            result = first(fs.getIterableExpr())
          )
        or
        cfe instanceof QualifiedWriteAccess and
        result = first(getExprChildElement(cfe, getFirstChildElement(cfe)))
        or
        cfe instanceof AccessorWrite and
        result = first(getExprChildElement(cfe, getFirstChildElement(cfe)))
      }

      private class PreOrderElement extends ControlFlowElement {
        PreOrderElement() {
          this instanceof StandardStmt
          or
          this instanceof IfStmt
          or
          this instanceof SwitchStmt
          or
          this instanceof CaseStmt
          or
          this instanceof TryStmt
          or
          this instanceof SpecificCatchClause
          or
          this instanceof LoopStmt and not this instanceof ForeachStmt
          or
          this instanceof LogicalNotExpr
          or
          this instanceof LogicalAndExpr
          or
          this instanceof LogicalOrExpr
          or
          this instanceof NullCoalescingExpr
          or
          this instanceof ConditionalExpr
          or
          this instanceof SwitchExpr
          or
          this instanceof SwitchCaseExpr
        }
      }

      private Expr getObjectCreationArgument(ObjectCreation oc, int i) {
        i >= 0 and
        if oc.hasInitializer()
        then result = getExprChildElement(oc, i + 1)
        else result = getExprChildElement(oc, i)
      }

      private class PostOrderElement extends ControlFlowElement {
        PostOrderElement() {
          this instanceof StandardExpr or
          this instanceof JumpStmt or
          this instanceof ThrowExpr or
          this instanceof ObjectCreation
        }

        ControlFlowElement getFirstChild() {
          result = this.(StandardExpr).getFirstChildElement() or
          result = this.(JumpStmt).getChild(0) or
          result = this.(ThrowExpr).getExpr() or
          result = getObjectCreationArgument(this, 0)
        }
      }

      /** A specification of how to compute the last element of a control flow element. */
      private newtype TLastComputation =
        /** The element is itself the last element. */
        TSelf(Completion c) or
        /** The last element must be computed recursively. */
        TRec(TLastRecComputation c)

      /**
       * A specification of how to compute the last element of a control flow element
       * using recursion.
       */
      private newtype TLastRecComputation =
        TLastRecSpecificCompletion(Completion c) or
        TLastRecSpecificNegCompletion(Completion c) or
        TLastRecAnyCompletion() or
        TLastRecNormalCompletion() or
        TLastRecAbnormalCompletion() or
        TLastRecBooleanNegationCompletion() or
        TLastRecNonBooleanCompletion() or
        TLastRecBreakCompletion() or
        TLastRecSwitchAbnormalCompletion() or
        TLastRecInvalidOperationException() or
        TLastRecNonContinueCompletion() or
        TLastRecLoopBodyAbnormal()

      private TSelf getValidSelfCompletion(ControlFlowElement cfe) {
        result = TSelf(any(Completion c | c.isValidFor(cfe)))
      }

      private TRec specificBoolean(boolean value) {
        result = TRec(TLastRecSpecificCompletion(any(BooleanCompletion bc | bc.getValue() = value)))
      }

      /**
       * Gets an element from which the last element of `cfe` can be computed
       * (recursively) based on computation specification `c`. The predicate
       * itself is non-recursive.
       *
       * With the exception of `try` statements, all elements have a simple
       * recursive last computation.
       */
      pragma[nomagic]
      private ControlFlowElement lastNonRec(ControlFlowElement cfe, TLastComputation c) {
        // Pre-order: last element of last child (or self, if no children)
        cfe =
          any(StandardStmt ss |
            result = ss.getLastChildElement() and
            c = TRec(TLastRecAnyCompletion())
            or
            ss.isLeafElement() and
            result = ss and
            c = getValidSelfCompletion(result)
          )
        or
        // Post-order: element itself
        cfe instanceof StandardExpr and
        result = cfe and
        c = getValidSelfCompletion(result)
        or
        // Pre/post order: a child exits abnormally
        result = cfe.(StandardElement).getChildElement(_) and
        c = TRec(TLastRecAbnormalCompletion())
        or
        cfe =
          any(LogicalNotExpr lne |
            // Operand exits with a Boolean completion
            result = lne.getOperand() and
            c = TRec(TLastRecBooleanNegationCompletion())
            or
            // Operand exits with a non-Boolean completion
            result = lne.getOperand() and
            c = TRec(TLastRecNonBooleanCompletion())
          )
        or
        cfe =
          any(LogicalAndExpr lae |
            // Left operand exits with a false completion
            result = lae.getLeftOperand() and
            c = specificBoolean(false)
            or
            // Left operand exits abnormally
            result = lae.getLeftOperand() and
            c = TRec(TLastRecAbnormalCompletion())
            or
            // Right operand exits with any completion
            result = lae.getRightOperand() and
            c = TRec(TLastRecAnyCompletion())
          )
        or
        cfe =
          any(LogicalOrExpr loe |
            // Left operand exits with a true completion
            result = loe.getLeftOperand() and
            c = specificBoolean(true)
            or
            // Left operand exits abnormally
            result = loe.getLeftOperand() and
            c = TRec(TLastRecAbnormalCompletion())
            or
            // Right operand exits with any completion
            result = loe.getRightOperand() and
            c = TRec(TLastRecAnyCompletion())
          )
        or
        cfe =
          any(NullCoalescingExpr nce |
            // Left operand exits with any non-`null` completion
            result = nce.getLeftOperand() and
            c = TRec(TLastRecSpecificNegCompletion(any(NullnessCompletion nc | nc.isNull())))
            or
            // Right operand exits with any completion
            result = nce.getRightOperand() and
            c = TRec(TLastRecAnyCompletion())
          )
        or
        cfe =
          any(ConditionalExpr ce |
            // Condition exits abnormally
            result = ce.getCondition() and
            c = TRec(TLastRecAbnormalCompletion())
            or
            // Then branch exits with any completion
            result = ce.getThen() and
            c = TRec(TLastRecAnyCompletion())
            or
            // Else branch exits with any completion
            result = ce.getElse() and
            c = TRec(TLastRecAnyCompletion())
          )
        or
        cfe =
          any(AssignOperation ao |
            result = ao.getExpandedAssignment() and
            c = TRec(TLastRecAnyCompletion())
          )
        or
        cfe =
          any(ConditionallyQualifiedExpr cqe |
            // Post-order: element itself
            result = cqe and
            c = getValidSelfCompletion(result)
            or
            // Qualifier exits with a `null` completion
            result = getExprChildElement(cqe, 0) and
            c = TRec(TLastRecSpecificCompletion(any(NullnessCompletion nc | nc.isNull())))
          )
        or
        cfe =
          any(ThrowExpr te |
            // Post-order: element itself
            result = te and
            c = getValidSelfCompletion(result)
            or
            // Expression being thrown exits abnormally
            result = te.getExpr() and
            c = TRec(TLastRecAbnormalCompletion())
          )
        or
        cfe =
          any(ObjectCreation oc |
            // Post-order: element itself (when no initializer)
            result = oc and
            not oc.hasInitializer() and
            c = getValidSelfCompletion(result)
            or
            // Last element of initializer
            result = oc.getInitializer() and
            c = TRec(TLastRecAnyCompletion())
          )
        or
        cfe =
          any(ArrayCreation ac |
            // Post-order: element itself (when no initializer)
            result = ac and
            not ac.hasInitializer() and
            c = getValidSelfCompletion(result)
            or
            // Last element of initializer
            result = ac.getInitializer() and
            c = TRec(TLastRecAnyCompletion())
          )
        or
        cfe =
          any(IfStmt is |
            // Condition exits with a false completion and there is no `else` branch
            result = is.getCondition() and
            c = specificBoolean(false) and
            not exists(is.getElse())
            or
            // Condition exits abnormally
            result = is.getCondition() and
            c = TRec(TLastRecAbnormalCompletion())
            or
            // Then branch exits with any completion
            result = is.getThen() and
            c = TRec(TLastRecAnyCompletion())
            or
            // Else branch exits with any completion
            result = is.getElse() and
            c = TRec(TLastRecAnyCompletion())
          )
        or
        cfe =
          any(Switch s |
            // Switch expression exits normally and there are no cases
            result = s.getExpr() and
            not exists(s.getACase()) and
            c = TRec(TLastRecNormalCompletion())
            or
            // Switch expression exits abnormally
            result = s.getExpr() and
            c = TRec(TLastRecAbnormalCompletion())
            or
            // Case condition exits abnormally
            result = s.getACase().getCondition() and
            c = TRec(TLastRecAbnormalCompletion())
          )
        or
        cfe =
          any(SwitchStmt ss |
            // A statement exits with a `break` completion
            result = ss.getStmt(_) and
            c = TRec(TLastRecBreakCompletion())
            or
            // A statement exits abnormally
            result = ss.getStmt(_) and
            c = TRec(TLastRecSwitchAbnormalCompletion())
            or
            // Last case exits with a non-match
            exists(CaseStmt cs, int last |
              last = max(int i | exists(ss.getCase(i))) and
              cs = ss.getCase(last)
            |
              result = cs.getPattern() and
              c = TRec(TLastRecSpecificNegCompletion(any(MatchingCompletion mc | mc.isMatch())))
              or
              result = cs.getCondition() and
              c = specificBoolean(false)
            )
          )
        or
        cfe =
          any(SwitchExpr se |
            // A matching case exists with any completion
            result = se.getACase().getBody() and
            c = TRec(TLastRecAnyCompletion())
            or
            // Last case exists with a non-match
            exists(SwitchCaseExpr sce, int i |
              sce = se.getCase(i) and
              not sce.matchesAll() and
              not exists(se.getCase(i + 1)) and
              c = TRec(TLastRecInvalidOperationException())
            |
              result = sce.getPattern() or
              result = sce.getCondition()
            )
          )
        or
        cfe =
          any(Case case |
            // Condition exists with a `false` completion
            result = case.getCondition() and
            c = specificBoolean(false)
            or
            // Condition exists abnormally
            result = case.getCondition() and
            c = TRec(TLastRecAbnormalCompletion())
            or
            // Case pattern exits with a non-match
            result = case.getPattern() and
            c = TRec(TLastRecSpecificNegCompletion(any(MatchingCompletion mc | mc.isMatch())))
            or
            // Case body exits with any completion
            result = case.getBody() and
            c = TRec(TLastRecAnyCompletion())
          )
        or
        exists(LoopStmt ls |
          cfe = ls and
          not ls instanceof ForeachStmt
        |
          // Condition exits with a false completion
          result = ls.getCondition() and
          c = specificBoolean(false)
          or
          // Condition exits abnormally
          result = ls.getCondition() and
          c = TRec(TLastRecAbnormalCompletion())
          or
          // Body exits with a break completion; the loop exits normally
          // Note: we use a `BreakNormalCompletion` rather than a `NormalCompletion`
          // in order to be able to get the correct break label in the control flow
          // graph from the `result` node to the node after the loop.
          result = ls.getBody() and
          c = TRec(TLastRecBreakCompletion())
          or
          // Body exits with a completion that does not continue the loop
          result = ls.getBody() and
          c = TRec(TLastRecNonContinueCompletion())
        )
        or
        cfe =
          any(ForeachStmt fs |
            // Iterator expression exits abnormally
            result = fs.getIterableExpr() and
            c = TRec(TLastRecAbnormalCompletion())
            or
            // Emptiness test exits with no more elements
            result = fs and
            c = TSelf(any(EmptinessCompletion ec | ec.isEmpty()))
            or
            // Body exits with a break completion; the loop exits normally
            // Note: we use a `BreakNormalCompletion` rather than a `NormalCompletion`
            // in order to be able to get the correct break label in the control flow
            // graph from the `result` node to the node after the loop.
            result = fs.getBody() and
            c = TRec(TLastRecBreakCompletion())
            or
            // Body exits abnormally
            result = fs.getBody() and
            c = TRec(TLastRecLoopBodyAbnormal())
          )
        or
        cfe =
          any(TryStmt ts |
            // If the `finally` block completes abnormally, take the completion of
            // the `finally` block itself
            result = ts.getFinally() and
            c = TRec(TLastRecAbnormalCompletion())
          )
        or
        cfe =
          any(SpecificCatchClause scc |
            // Last element of `catch` block
            result = scc.getBlock() and
            c = TRec(TLastRecAnyCompletion())
            or
            not scc.isLast() and
            (
              // Incompatible exception type: clause itself
              result = scc and
              c = TSelf(any(MatchingCompletion mc | mc.isNonMatch()))
              or
              // Incompatible filter
              result = scc.getFilterClause() and
              c = specificBoolean(false)
            )
          )
        or
        cfe =
          any(JumpStmt js |
            // Post-order: element itself
            result = js and
            c = getValidSelfCompletion(result)
            or
            // Child exits abnormally
            result = js.getChild(0) and
            c = TRec(TLastRecAbnormalCompletion())
          )
        or
        cfe =
          any(QualifiedWriteAccess qwa |
            // Skip the access in a qualified write access
            result = getExprChildElement(qwa, getLastChildElement(qwa)) and
            c = TRec(TLastRecAnyCompletion())
            or
            // A child exits abnormally
            result = getExprChildElement(qwa, _) and
            c = TRec(TLastRecAbnormalCompletion())
          )
        or
        cfe =
          any(AccessorWrite aw |
            // Post-order: element itself
            result = aw and
            c = getValidSelfCompletion(result)
            or
            // A child exits abnormally
            result = getExprChildElement(aw, _) and
            c = TRec(TLastRecAbnormalCompletion())
            or
            // An accessor call exits abnormally
            result = aw.getCall(_) and
            c =
              TSelf(any(Completion comp |
                  comp.isValidFor(result) and not comp instanceof NormalCompletion
                ))
          )
      }

      pragma[noinline]
      private LabeledStmt getLabledStmt(string label, Callable c) {
        result.getEnclosingCallable() = c and
        label = result.getLabel()
      }

      /**
       * Gets a potential last element executed within control flow element `cfe`,
       * as well as its completion.
       *
       * For example, if `cfe` is `A || B` then both `A` and `B` are potential
       * last elements with Boolean completions.
       */
      ControlFlowElement last(ControlFlowElement cfe, Completion c) {
        result = lastNonRec(cfe, TSelf(c))
        or
        result = lastRecSpecific(cfe, c, c)
        or
        exists(TLastRecComputation rec, Completion c0 | result = lastRec(rec, cfe, c0) |
          rec = TLastRecSpecificNegCompletion(any(Completion c1 | c1 != c0)) and
          c = c0
          or
          rec = TLastRecAnyCompletion() and c = c0
          or
          rec = TLastRecNormalCompletion() and
          c0 instanceof NormalCompletion and
          c = c0
          or
          rec = TLastRecAbnormalCompletion() and
          not c0 instanceof NormalCompletion and
          c = c0
          or
          rec = TLastRecBooleanNegationCompletion() and
          (
            c =
              any(NestedCompletion nc |
                nc.getInnerCompletion() = c0 and
                nc.getOuterCompletion().(BooleanCompletion).getValue() =
                  c0.(BooleanCompletion).getValue().booleanNot()
              )
            or
            c =
              any(BooleanCompletion bc |
                bc.getValue() =
                  c0.(NestedCompletion).getInnerCompletion().(BooleanCompletion).getValue() and
                not bc instanceof NestedCompletion
              )
          )
          or
          rec = TLastRecNonBooleanCompletion() and
          not c0 instanceof BooleanCompletion and
          c = c0
          or
          rec = TLastRecBreakCompletion() and
          c0 instanceof BreakCompletion and
          c instanceof BreakNormalCompletion
          or
          rec = TLastRecSwitchAbnormalCompletion() and
          not c instanceof BreakCompletion and
          not c instanceof NormalCompletion and
          not getLabledStmt(c.(GotoCompletion).getLabel(), cfe.getEnclosingCallable()) instanceof
            CaseStmt and
          c = c0
          or
          rec = TLastRecInvalidOperationException() and
          (c0.(MatchingCompletion).isNonMatch() or c0 instanceof FalseCompletion) and
          c =
            any(NestedCompletion nc |
              nc.getInnerCompletion() = c0 and
              nc
                  .getOuterCompletion()
                  .(ThrowCompletion)
                  .getExceptionClass()
                  .hasQualifiedName("System.InvalidOperationException")
            )
          or
          rec = TLastRecNonContinueCompletion() and
          not c0 instanceof BreakCompletion and
          not c0.continuesLoop() and
          c = c0
          or
          rec = TLastRecLoopBodyAbnormal() and
          not c0 instanceof NormalCompletion and
          not c0 instanceof ContinueCompletion and
          not c0 instanceof BreakCompletion and
          c = c0
        )
        or
        // Last `catch` clause inherits throw completions from the `try` block,
        // when the clause does not match
        exists(SpecificCatchClause scc, ThrowCompletion tc |
          scc = cfe and
          scc.isLast() and
          throwMayBeUncaught(scc, tc)
        |
          // Incompatible exception type: clause itself
          result = scc and
          exists(MatchingCompletion mc |
            mc.isNonMatch() and
            mc.isValidFor(scc) and
            c =
              any(NestedCompletion nc |
                nc.getInnerCompletion() = mc and
                nc.getOuterCompletion() = tc.getOuterCompletion()
              )
          )
          or
          // Incompatible filter
          exists(FalseCompletion fc |
            result = lastSpecificCatchClauseFilterClause(scc, fc) and
            c =
              any(NestedCompletion nc |
                nc.getInnerCompletion() = fc and
                nc.getOuterCompletion() = tc.getOuterCompletion()
              )
          )
        )
        or
        cfe =
          any(TryStmt ts |
            result = getBlockOrCatchFinallyPred(ts, c) and
            (
              // If there is no `finally` block, last elements are from the body, from
              // the blocks of one of the `catch` clauses, or from the last `catch` clause
              not ts.hasFinally()
              or
              // Exit completions ignore the `finally` block
              c instanceof ExitCompletion
            )
            or
            result = lastTryStmtFinally(ts, c, any(NormalCompletion nc))
            or
            // If the `finally` block completes normally, it inherits any non-normal
            // completion that was current before the `finally` block was entered
            c =
              any(NestedCompletion nc |
                result = lastTryStmtFinally(ts, nc.getInnerCompletion(), nc.getOuterCompletion())
              )
          )
      }

      /**
       * Gets a potential last element executed within control flow element `cfe`,
       * as well as its completion, where the last element of `cfe` is recursively
       * computed as specified by `rec`.
       */
      pragma[nomagic]
      private ControlFlowElement lastRec(
        TLastRecComputation rec, ControlFlowElement cfe, Completion c
      ) {
        result = last(lastNonRec(cfe, TRec(rec)), c)
      }

      pragma[nomagic]
      private ControlFlowElement lastRecSpecific(
        ControlFlowElement cfe, Completion c1, Completion c2
      ) {
        result = lastRec(TLastRecSpecificCompletion(c2), cfe, c1)
      }

      pragma[nomagic]
      private ControlFlowElement lastTryStmtBlock(TryStmt ts, Completion c) {
        result = last(ts.getBlock(), c)
      }

      pragma[nomagic]
      private ControlFlowElement lastLastCatchClause(CatchClause cc, Completion c) {
        cc.isLast() and
        result = last(cc, c)
      }

      pragma[nomagic]
      private ControlFlowElement lastCatchClauseBlock(CatchClause cc, Completion c) {
        result = last(cc.getBlock(), c)
      }

      private ControlFlowElement lastSpecificCatchClauseFilterClause(
        SpecificCatchClause scc, Completion c
      ) {
        result = last(scc.getFilterClause(), c)
      }

      /**
       * Gets a last element from a `try` or `catch` block of this `try` statement
       * that may finish with completion `c`, such that control may be transferred
       * to the `finally` block (if it exists).
       */
      pragma[nomagic]
      private ControlFlowElement getBlockOrCatchFinallyPred(TryStmt ts, Completion c) {
        result = lastTryStmtBlock(ts, c) and
        (
          // Any non-throw completion from the `try` block will always continue directly
          // to the `finally` block
          not c instanceof ThrowCompletion
          or
          // Any completion from the `try` block will continue to the `finally` block
          // when there are no catch clauses
          not exists(ts.getACatchClause())
        )
        or
        // Last element from any of the `catch` clause blocks continues to the `finally` block
        result = lastCatchClauseBlock(ts.getACatchClause(), c)
        or
        // Last element of last `catch` clause continues to the `finally` block
        result = lastLastCatchClause(ts.getACatchClause(), c)
      }

      pragma[nomagic]
      private ControlFlowElement lastTryStmtFinally0(TryStmt ts, Completion c) {
        result = last(ts.getFinally(), c)
      }

      pragma[nomagic]
      ControlFlowElement lastTryStmtFinally(TryStmt ts, NormalCompletion finally, Completion outer) {
        result = lastTryStmtFinally0(ts, finally) and
        exists(getBlockOrCatchFinallyPred(ts, any(Completion c0 | outer = c0.getOuterCompletion())))
      }

      /**
       * Holds if the `try` block that catch clause `last` belongs to may throw an
       * exception of type `c`, where no `catch` clause is guaranteed to catch it.
       * The catch clause `last` is the last catch clause in the `try` statement
       * that it belongs to.
       */
      pragma[nomagic]
      private predicate throwMayBeUncaught(SpecificCatchClause last, ThrowCompletion c) {
        exists(TryStmt ts |
          ts = last.getTryStmt() and
          exists(lastTryStmtBlock(ts, c)) and
          not ts.getACatchClause() instanceof GeneralCatchClause and
          forall(SpecificCatchClause scc | scc = ts.getACatchClause() |
            scc.hasFilterClause()
            or
            not c.getExceptionClass().getABaseType*() = scc.getCaughtExceptionType()
          ) and
          last.isLast()
        )
      }

      /**
       * Gets a control flow successor for control flow element `cfe`, given that
       * `cfe` finishes with completion `c`.
       */
      pragma[nomagic]
      ControlFlowElement succ(ControlFlowElement cfe, Completion c) {
        // Pre-order: flow from element itself to first element of first child
        cfe =
          any(StandardStmt ss |
            result = first(ss.getFirstChildElement()) and
            c instanceof SimpleCompletion
          )
        or
        // Post-order: flow from last element of last child to element itself
        cfe = last(result.(StandardExpr).getLastChildElement(), c) and
        c instanceof NormalCompletion
        or
        // Standard left-to-right evaluation
        exists(StandardElement parent, int i |
          cfe = last(parent.(StandardElement).getNonLastChildElement(i), c) and
          c instanceof NormalCompletion and
          result = first(parent.getChildElement(i + 1))
        )
        or
        cfe =
          any(LogicalNotExpr lne |
            // Pre-order: flow from expression itself to first element of operand
            result = first(lne.getOperand()) and
            c instanceof SimpleCompletion
          )
        or
        exists(LogicalAndExpr lae |
          // Pre-order: flow from expression itself to first element of left operand
          lae = cfe and
          result = first(lae.getLeftOperand()) and
          c instanceof SimpleCompletion
          or
          // Flow from last element of left operand to first element of right operand
          cfe = last(lae.getLeftOperand(), c) and
          c instanceof TrueCompletion and
          result = first(lae.getRightOperand())
        )
        or
        exists(LogicalOrExpr loe |
          // Pre-order: flow from expression itself to first element of left operand
          loe = cfe and
          result = first(loe.getLeftOperand()) and
          c instanceof SimpleCompletion
          or
          // Flow from last element of left operand to first element of right operand
          cfe = last(loe.getLeftOperand(), c) and
          c instanceof FalseCompletion and
          result = first(loe.getRightOperand())
        )
        or
        exists(NullCoalescingExpr nce |
          // Pre-order: flow from expression itself to first element of left operand
          nce = cfe and
          result = first(nce.getLeftOperand()) and
          c instanceof SimpleCompletion
          or
          // Flow from last element of left operand to first element of right operand
          cfe = last(nce.getLeftOperand(), c) and
          c.(NullnessCompletion).isNull() and
          result = first(nce.getRightOperand())
        )
        or
        exists(ConditionalExpr ce |
          // Pre-order: flow from expression itself to first element of condition
          ce = cfe and
          result = first(ce.getCondition()) and
          c instanceof SimpleCompletion
          or
          // Flow from last element of condition to first element of then branch
          cfe = last(ce.getCondition(), c) and
          c instanceof TrueCompletion and
          result = first(ce.getThen())
          or
          // Flow from last element of condition to first element of else branch
          cfe = last(ce.getCondition(), c) and
          c instanceof FalseCompletion and
          result = first(ce.getElse())
        )
        or
        exists(ConditionallyQualifiedExpr parent, int i |
          cfe = last(getExprChildElement(parent, i), c) and
          c instanceof NormalCompletion and
          if i = 0 then c.(NullnessCompletion).isNonNull() else any()
        |
          // Post-order: flow from last element of last child to element itself
          i = max(int j | exists(getExprChildElement(parent, j))) and
          result = parent
          or
          // Standard left-to-right evaluation
          result = first(getExprChildElement(parent, i + 1))
        )
        or
        // Post-order: flow from last element of thrown expression to expression itself
        cfe = last(result.(ThrowExpr).getExpr(), c) and
        c instanceof NormalCompletion
        or
        exists(ObjectCreation oc |
          // Flow from last element of argument `i` to first element of argument `i+1`
          exists(int i | cfe = last(getObjectCreationArgument(oc, i), c) |
            result = first(getObjectCreationArgument(oc, i + 1)) and
            c instanceof NormalCompletion
          )
          or
          // Flow from last element of last argument to self
          exists(int last | last = max(int i | exists(getObjectCreationArgument(oc, i))) |
            cfe = last(getObjectCreationArgument(oc, last), c) and
            result = oc and
            c instanceof NormalCompletion
          )
          or
          // Flow from self to first element of initializer
          cfe = oc and
          result = first(oc.getInitializer()) and
          c instanceof SimpleCompletion
        )
        or
        exists(ArrayCreation ac |
          // Flow from self to first element of initializer
          cfe = ac and
          result = first(ac.getInitializer()) and
          c instanceof SimpleCompletion
          or
          exists(int i |
            cfe = last(ac.getLengthArgument(i), c) and
            c instanceof SimpleCompletion
          |
            // Flow from last length argument to self
            i = max(int j | exists(ac.getLengthArgument(j))) and
            result = ac
            or
            // Flow from one length argument to the next
            result = first(ac.getLengthArgument(i + 1))
          )
        )
        or
        exists(IfStmt is |
          // Pre-order: flow from statement itself to first element of condition
          cfe = is and
          result = first(is.getCondition()) and
          c instanceof SimpleCompletion
          or
          cfe = last(is.getCondition(), c) and
          (
            // Flow from last element of condition to first element of then branch
            c instanceof TrueCompletion and result = first(is.getThen())
            or
            // Flow from last element of condition to first element of else branch
            c instanceof FalseCompletion and result = first(is.getElse())
          )
        )
        or
        exists(Switch s |
          // Pre-order: flow from statement itself to first switch expression
          cfe = s and
          result = first(s.getExpr()) and
          c instanceof SimpleCompletion
          or
          // Flow from last element of switch expression to first element of first case
          cfe = last(s.getExpr(), c) and
          c instanceof NormalCompletion and
          result = first(s.getCase(0))
          or
          // Flow from last element of case pattern to next case
          exists(Case case, int i | case = s.getCase(i) |
            cfe = last(case.getPattern(), c) and
            c.(MatchingCompletion).isNonMatch() and
            result = first(s.getCase(i + 1))
          )
          or
          // Flow from last element of condition to next case
          exists(Case case, int i | case = s.getCase(i) |
            cfe = last(case.getCondition(), c) and
            c instanceof FalseCompletion and
            result = first(s.getCase(i + 1))
          )
        )
        or
        exists(SwitchStmt ss |
          // Flow from last element of non-`case` statement `i` to first element of statement `i+1`
          exists(int i | cfe = last(ss.getStmt(i), c) |
            not ss.getStmt(i) instanceof CaseStmt and
            c instanceof NormalCompletion and
            result = first(ss.getStmt(i + 1))
          )
          or
          // Flow from last element of `case` statement `i` to first element of statement `i+1`
          exists(int i | cfe = last(ss.getStmt(i).(CaseStmt).getBody(), c) |
            c instanceof NormalCompletion and
            result = first(ss.getStmt(i + 1))
          )
        )
        or
        exists(Case case |
          // Pre-order: flow from case itself to first element of pattern
          cfe = case and
          result = first(case.getPattern()) and
          c instanceof SimpleCompletion
          or
          cfe = last(case.getPattern(), c) and
          c.(MatchingCompletion).isMatch() and
          (
            if exists(case.getCondition())
            then
              // Flow from the last element of pattern to the condition
              result = first(case.getCondition())
            else
              // Flow from last element of pattern to first element of body
              result = first(case.getBody())
          )
          or
          // Flow from last element of condition to first element of body
          cfe = last(case.getCondition(), c) and
          c instanceof TrueCompletion and
          result = first(case.getBody())
        )
        or
        // Pre-order: flow from statement itself to first element of statement
        cfe =
          any(DefaultCase dc |
            result = first(dc.getStmt()) and
            c instanceof SimpleCompletion
          )
        or
        exists(LoopStmt ls |
          // Flow from last element of condition to first element of loop body
          cfe = last(ls.getCondition(), c) and
          c instanceof TrueCompletion and
          result = first(ls.getBody())
          or
          // Flow from last element of loop body back to first element of condition
          not ls instanceof ForStmt and
          cfe = last(ls.getBody(), c) and
          c.continuesLoop() and
          result = first(ls.getCondition())
        )
        or
        cfe =
          any(WhileStmt ws |
            // Pre-order: flow from statement itself to first element of condition
            result = first(ws.getCondition()) and
            c instanceof SimpleCompletion
          )
        or
        cfe =
          any(DoStmt ds |
            // Pre-order: flow from statement itself to first element of body
            result = first(ds.getBody()) and
            c instanceof SimpleCompletion
          )
        or
        exists(ForStmt fs |
          // Pre-order: flow from statement itself to first element of first initializer/
          // condition/loop body
          exists(ControlFlowElement next |
            cfe = fs and
            result = first(next) and
            c instanceof SimpleCompletion
          |
            next = fs.getInitializer(0)
            or
            not exists(fs.getInitializer(0)) and
            next = getForStmtConditionOrBody(fs)
          )
          or
          // Flow from last element of initializer `i` to first element of initializer `i+1`
          exists(int i | cfe = last(fs.getInitializer(i), c) |
            c instanceof NormalCompletion and
            result = first(fs.getInitializer(i + 1))
          )
          or
          // Flow from last element of last initializer to first element of condition/loop body
          exists(int last | last = max(int i | exists(fs.getInitializer(i))) |
            cfe = last(fs.getInitializer(last), c) and
            c instanceof NormalCompletion and
            result = first(getForStmtConditionOrBody(fs))
          )
          or
          // Flow from last element of condition into first element of loop body
          cfe = last(fs.getCondition(), c) and
          c instanceof TrueCompletion and
          result = first(fs.getBody())
          or
          // Flow from last element of loop body to first element of update/condition/self
          exists(ControlFlowElement next |
            cfe = last(fs.getBody(), c) and
            c.continuesLoop() and
            result = first(next) and
            if exists(fs.getUpdate(0))
            then next = fs.getUpdate(0)
            else next = getForStmtConditionOrBody(fs)
          )
          or
          // Flow from last element of update to first element of next update/condition/loop body
          exists(ControlFlowElement next, int i |
            cfe = last(fs.getUpdate(i), c) and
            c instanceof NormalCompletion and
            result = first(next) and
            if exists(fs.getUpdate(i + 1))
            then next = fs.getUpdate(i + 1)
            else next = getForStmtConditionOrBody(fs)
          )
        )
        or
        exists(ForeachStmt fs |
          // Flow from last element of iterator expression to emptiness test
          cfe = last(fs.getIterableExpr(), c) and
          c instanceof NormalCompletion and
          result = fs
          or
          // Flow from emptiness test to first element of variable declaration/loop body
          cfe = fs and
          c = any(EmptinessCompletion ec | not ec.isEmpty()) and
          (
            result = first(fs.getVariableDeclExpr())
            or
            result = first(fs.getVariableDeclTuple())
            or
            not exists(fs.getVariableDeclExpr()) and
            not exists(fs.getVariableDeclTuple()) and
            result = first(fs.getBody())
          )
          or
          // Flow from last element of variable declaration to first element of loop body
          (
            cfe = last(fs.getVariableDeclExpr(), c) or
            cfe = last(fs.getVariableDeclTuple(), c)
          ) and
          c instanceof SimpleCompletion and
          result = first(fs.getBody())
          or
          // Flow from last element of loop body back to emptiness test
          cfe = last(fs.getBody(), c) and
          c.continuesLoop() and
          result = fs
        )
        or
        exists(TryStmt ts |
          // Pre-order: flow from statement itself to first element of body
          cfe = ts and
          result = first(ts.getBlock()) and
          c instanceof SimpleCompletion
          or
          // Flow from last element of body to first `catch` clause
          exists(getAThrownException(ts, cfe, c)) and
          result = first(ts.getCatchClause(0))
          or
          exists(CatchClause cc, int i | cc = ts.getCatchClause(i) |
            cfe = cc and
            cc = last(ts.getCatchClause(i), c) and
            (
              // Flow from one `catch` clause to the next
              result = first(ts.getCatchClause(i + 1)) and
              c = any(MatchingCompletion mc | not mc.isMatch())
              or
              // Flow from last `catch` clause to first element of `finally` block
              ts.getCatchClause(i).isLast() and
              result = first(ts.getFinally()) and
              c instanceof ThrowCompletion // inherited from `try` block
            )
            or
            cfe = last(ts.getCatchClause(i), c) and
            cfe = last(cc.getFilterClause(), _) and
            (
              // Flow from last element of `catch` clause filter to next `catch` clause
              result = first(ts.getCatchClause(i + 1)) and
              c instanceof FalseCompletion
              or
              // Flow from last element of `catch` clause filter, of last clause, to first
              // element of `finally` block
              ts.getCatchClause(i).isLast() and
              result = first(ts.getFinally()) and
              c instanceof ThrowCompletion // inherited from `try` block
            )
            or
            // Flow from last element of a `catch` block to first element of `finally` block
            cfe = lastCatchClauseBlock(cc, c) and
            result = first(ts.getFinally())
          )
          or
          // Flow from last element of `try` block to first element of `finally` block
          cfe = lastTryStmtBlock(ts, c) and
          result = first(ts.getFinally()) and
          not c instanceof ExitCompletion and
          (c instanceof ThrowCompletion implies not exists(ts.getACatchClause()))
        )
        or
        exists(SpecificCatchClause scc |
          // Flow from catch clause to variable declaration/filter clause/block
          cfe = scc and
          c.(MatchingCompletion).isMatch() and
          exists(ControlFlowElement next | result = first(next) |
            if exists(scc.getVariableDeclExpr())
            then next = scc.getVariableDeclExpr()
            else
              if exists(scc.getFilterClause())
              then next = scc.getFilterClause()
              else next = scc.getBlock()
          )
          or
          // Flow from variable declaration to filter clause/block
          cfe = last(scc.getVariableDeclExpr(), c) and
          c instanceof SimpleCompletion and
          exists(ControlFlowElement next | result = first(next) |
            if exists(scc.getFilterClause())
            then next = scc.getFilterClause()
            else next = scc.getBlock()
          )
          or
          // Flow from filter to block
          cfe = last(scc.getFilterClause(), c) and
          c instanceof TrueCompletion and
          result = first(scc.getBlock())
        )
        or
        // Post-order: flow from last element of child to statement itself
        cfe = last(result.(JumpStmt).getChild(0), c) and
        c instanceof NormalCompletion
        or
        exists(ConstructorInitializer ci, Constructor con |
          cfe = last(ci, c) and
          con = ci.getConstructor() and
          c instanceof NormalCompletion
        |
          // Flow from constructor initializer to first member initializer
          exists(InitializerSplitting::InitializedInstanceMember m |
            InitializerSplitting::constructorInitializeOrder(con, m, 0)
          |
            result = first(m.getInitializer())
          )
          or
          // Flow from constructor initializer to first element of constructor body
          not InitializerSplitting::constructorInitializeOrder(con, _, _) and
          result = first(con.getBody())
        )
        or
        exists(Constructor con, InitializerSplitting::InitializedInstanceMember m, int i |
          cfe = last(m.getInitializer(), c) and
          c instanceof NormalCompletion and
          InitializerSplitting::constructorInitializeOrder(con, m, i)
        |
          // Flow from one member initializer to the next
          exists(InitializerSplitting::InitializedInstanceMember next |
            InitializerSplitting::constructorInitializeOrder(con, next, i + 1) and
            result = first(next.getInitializer())
          )
          or
          // Flow from last member initializer to constructor body
          m = InitializerSplitting::lastConstructorInitializer(con) and
          result = first(con.getBody())
        )
        or
        // Flow from element with `goto` completion to first element of relevant
        // target
        c =
          any(GotoCompletion gc |
            cfe = last(_, gc) and
            // Special case: when a `goto` happens inside a `try` statement with a
            // `finally` block, flow does not go directly to the target, but instead
            // to the `finally` block (and from there possibly to the target)
            not cfe = getBlockOrCatchFinallyPred(any(TryStmt ts | ts.hasFinally()), _) and
            result = first(getLabledStmt(gc.getLabel(), cfe.getEnclosingCallable()))
          )
        or
        // Standard left-to-right evaluation
        exists(QualifiedWriteAccess qwa, int i |
          cfe = last(getExprChildElement(qwa, i), c) and
          c instanceof NormalCompletion and
          result = first(getExprChildElement(qwa, i + 1))
        )
        or
        exists(AccessorWrite aw |
          // Standard left-to-right evaluation
          exists(int i |
            cfe = last(getExprChildElement(aw, i), c) and
            c instanceof NormalCompletion and
            result = first(getExprChildElement(aw, i + 1))
          )
          or
          // Flow from last element of last child to first accessor call
          cfe = last(getExprChildElement(aw, getLastChildElement(aw)), c) and
          result = aw.getCall(0) and
          c instanceof NormalCompletion
          or
          // Flow from one call to the next
          exists(int i | cfe = aw.getCall(i) |
            result = aw.getCall(i + 1) and
            c.isValidFor(cfe) and
            c instanceof NormalCompletion
          )
          or
          // Post-order: flow from last call to element itself
          exists(int last | last = max(int i | exists(aw.getCall(i))) |
            cfe = aw.getCall(last) and
            result = aw and
            c.isValidFor(cfe) and
            c instanceof NormalCompletion
          )
        )
      }

      /**
       * Gets an exception type that is thrown by `cfe` in the block of `try` statement
       * `ts`. Throw completion `c` matches the exception type.
       */
      ExceptionClass getAThrownException(TryStmt ts, ControlFlowElement cfe, ThrowCompletion c) {
        cfe = lastTryStmtBlock(ts, c) and
        result = c.getExceptionClass()
      }

      /**
       * Gets the condition of `for` loop `fs` if it exists, otherwise the body.
       */
      private ControlFlowElement getForStmtConditionOrBody(ForStmt fs) {
        result = fs.getCondition()
        or
        not exists(fs.getCondition()) and
        result = fs.getBody()
      }

      /**
       * Gets the control flow element that is first executed when entering
       * callable `c`.
       */
      ControlFlowElement succEntry(@top_level_exprorstmt_parent p) {
        p =
          any(Callable c |
            if exists(c.(Constructor).getInitializer())
            then result = first(c.(Constructor).getInitializer())
            else
              if InitializerSplitting::constructorInitializes(c, _)
              then
                result =
                  first(any(InitializerSplitting::InitializedInstanceMember m |
                      InitializerSplitting::constructorInitializeOrder(c, m, 0)
                    ).getInitializer())
              else result = first(c.getBody())
          )
        or
        expr_parent_top_level_adjusted(any(Expr e | result = first(e)), _, p) and
        not p instanceof Callable and
        not p instanceof InitializerSplitting::InitializedInstanceMember
      }

      /**
       * Gets the callable that is exited when `cfe` finishes with completion `c`,
       * if any.
       */
      Callable succExit(ControlFlowElement cfe, Completion c) {
        cfe = last(result.getBody(), c) and
        not c instanceof GotoCompletion
        or
        exists(InitializerSplitting::InitializedInstanceMember m |
          m = InitializerSplitting::lastConstructorInitializer(result) and
          cfe = last(m.getInitializer(), c) and
          not result.hasBody()
        )
      }
    }

    import Successor

    cached
    private module Cached {
      private import semmle.code.csharp.Caching

      /**
       * Internal representation of control flow nodes in the control flow graph.
       * The control flow graph is pruned for unreachable nodes.
       */
      cached
      newtype TNode =
        TEntryNode(Callable c) {
          Stages::ControlFlowStage::forceCachingInSameStage() and
          succEntrySplits(c, _, _, _)
        } or
        TExitNode(Callable c) {
          exists(Reachability::SameSplitsBlock b | b.isReachable(_) |
            succExitSplits(b.getAnElement(), _, c, _)
          )
        } or
        TElementNode(ControlFlowElement cfe, Splits splits) {
          exists(Reachability::SameSplitsBlock b | b.isReachable(splits) | cfe = b.getAnElement())
        }

      /** Gets a successor node of a given flow type, if any. */
      cached
      Node getASuccessorByType(Node pred, SuccessorType t) {
        // Callable entry node -> callable body
        exists(ControlFlowElement succElement, Splits succSplits |
          result = TElementNode(succElement, succSplits)
        |
          succEntrySplits(pred.(Nodes::EntryNode).getCallable(), succElement, succSplits, t)
        )
        or
        exists(ControlFlowElement predElement, Splits predSplits |
          pred = TElementNode(predElement, predSplits)
        |
          // Element node -> callable exit
          succExitSplits(predElement, predSplits, result.(Nodes::ExitNode).getCallable(), t)
          or
          // Element node -> element node
          exists(ControlFlowElement succElement, Splits succSplits, Completion c |
            result = TElementNode(succElement, succSplits)
          |
            succSplits(predElement, predSplits, succElement, succSplits, c) and
            t.matchesCompletion(c)
          )
        )
      }

      /**
       * Gets a first control flow element executed within `cfe`.
       */
      cached
      ControlFlowElement getAControlFlowEntryNode(ControlFlowElement cfe) { result = first(cfe) }

      /**
       * Gets a potential last control flow element executed within `cfe`.
       */
      cached
      ControlFlowElement getAControlFlowExitNode(ControlFlowElement cfe) { result = last(cfe, _) }
    }

    import Cached

    /** A control flow element that is split into multiple control flow nodes. */
    class SplitControlFlowElement extends ControlFlowElement {
      SplitControlFlowElement() { strictcount(this.getAControlFlowNode()) > 1 }
    }
  }

  private import Internal
}
