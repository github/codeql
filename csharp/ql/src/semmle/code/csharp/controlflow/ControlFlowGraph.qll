import csharp

/**
 * Provides classes representing the control flow graph within callables.
 */
module ControlFlow {
  private import semmle.code.csharp.controlflow.BasicBlocks as BBs
  private import semmle.code.csharp.controlflow.Completion

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
    predicate isCondition() {
      exists(getASuccessorByType(any(ConditionalSuccessor e)))
    }

    /** Gets the basic block that this control flow node belongs to. */
    BasicBlock getBasicBlock() {
      result.getANode() = this
    }

    /**
     * Holds if this node dominates `that` node.
     *
     * That is, all paths reaching `that` node from some callable entry
     * node (`EntryNode`) must go through this node.
     *
     * Example:
     *
     * ```
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
    pragma [inline] // potentially very large predicate, so must be inlined
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
     * ```
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
    pragma [inline] // potentially very large predicate, so must be inlined
    predicate strictlyDominates(Node that) {
      this.getBasicBlock().strictlyDominates(that.getBasicBlock())
      or
      exists(BasicBlock bb, int i, int j |
        bb.getNode(i) = this
        and
        bb.getNode(j) = that
        and
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
     * ```
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
    pragma [inline] // potentially very large predicate, so must be inlined
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
     * ```
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
    pragma [inline] // potentially very large predicate, so must be inlined
    predicate strictlyPostDominates(Node that) {
      this.getBasicBlock().strictlyPostDominates(that.getBasicBlock())
      or
      exists(BasicBlock bb, int i, int j |
        bb.getNode(i) = this
        and
        bb.getNode(j) = that
        and
        i > j
      )
    }

    /** Gets a successor node of a given type, if any. */
    Node getASuccessorByType(SuccessorType t) {
      result = getASuccessorByType(this, t)
    }

    /** Gets an immediate successor, if any. */
    Node getASuccessor() { result = getASuccessorByType(_) }

    /** Gets an immediate predecessor node of a given flow type, if any. */
    Node getAPredecessorByType(SuccessorType t) {
      result.getASuccessorByType(t) = this
    }

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
     * ```
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
     * ```
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

    /**
     * Gets an immediate `null` successor, if any.
     *
     * An immediate `null` successor is a successor that is reached when
     * this expression evaluates to `null`.
     *
     * Example:
     *
     * ```
     * x?.M();
     * return;
     * ```
     *
     * The node on line 2 is an immediate `null` successor of the node
     * `x` on line 1.
     */
    deprecated
    Node getANullSuccessor() {
      result = getASuccessorByType(any(NullnessSuccessor t | t.isNull()))
    }

    /**
     * Gets an immediate non-`null` successor, if any.
     *
     * An immediate non-`null` successor is a successor that is reached when
     * this expressions evaluates to a non-`null` value.
     *
     * Example:
     *
     * ```
     * x?.M();
     * ```
     *
     * The node `x?.M()`, representing the call to `M`, is a non-`null` successor
     * of the node `x`.
     */
    deprecated
    Node getANonNullSuccessor() {
      result = getASuccessorByType(any(NullnessSuccessor t | not t.isNull()))
    }

    /** Holds if this node has more than one predecessor. */
    predicate isJoin() {
      strictcount(getAPredecessor()) > 1
    }
  }

  /** Provides different types of control flow nodes. */
  module Nodes {
    /** A node for a callable entry point. */
    class EntryNode extends Node, TEntryNode {
      /** Gets the callable that this entry applies to. */
      Callable getCallable() { this = TEntryNode(result) }

      override BasicBlocks::EntryBlock getBasicBlock() {
        result = Node.super.getBasicBlock()
      }

      override Location getLocation() {
        result = getCallable().getLocation()
      }

      override string toString() {
        result = "enter " + getCallable().toString()
      }
    }

    /** A node for a callable exit point. */
    class ExitNode extends Node, TExitNode {
      /** Gets the callable that this exit applies to. */
      Callable getCallable() { this = TExitNode(result) }

      override BasicBlocks::ExitBlock getBasicBlock() {
        result = Node.super.getBasicBlock()
      }

      override Location getLocation() {
        result = getCallable().getLocation()
      }

      override string toString() {
        result = "exit " + getCallable().toString()
      }
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

      ElementNode() {
        this = TElementNode(cfe, splits)
      }

      override ControlFlowElement getElement() {
        result = cfe
      }

      override string toString() {
        exists(string s |
          s = splits.toString() |
          if s = "" then
            result = cfe.toString()
          else
            result = "[" + s + "] " + cfe.toString()
        )
      }

      /** Gets a split for this control flow node, if any. */
      Split getASplit() {
        result = splits.getASplit()
      }
    }

    class Split = SplitImpl;
    class FinallySplit = FinallySplitting::FinallySplitImpl;
    class ExceptionHandlerSplit = ExceptionHandlerSplitting::ExceptionHandlerSplitImpl;
    class BooleanSplit = BooleanSplitting::BooleanSplitImpl;
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

  /** The type of a control flow successor. */
  class SuccessorType extends TSuccessorType {
    /** Gets a textual representation of successor type. */
    string toString() { none() }

    /** Holds if this successor type matches completion `c`. */
    predicate matchesCompletion(Completion c) { none() }
  }

  /** Provides different types of control flow successor types. */
  module SuccessorTypes {
    /** A normal control flow successor. */
    class NormalSuccessor extends SuccessorType, TSuccessorSuccessor {
      override string toString() { result = "successor" }

      override predicate matchesCompletion(Completion c) {
        c instanceof NormalCompletion and
        not c instanceof ConditionalCompletion and
        not c instanceof BreakNormalCompletion
      }
    }

    /**
     * A conditional control flow successor. Either a Boolean successor (`BooleanSuccessor`),
     * a nullness successor (`NullnessSuccessor`), a matching successor (`MatchingSuccessor`),
     * or an emptiness successor (`EmptinessSuccessor`).
     */
    abstract class ConditionalSuccessor extends SuccessorType {
      /** Gets the Boolean value of this successor. */
      abstract boolean getValue();
    }

    /**
     * A Boolean control flow successor.
     *
     * For example, this program fragment:
     *
     * ```
     * if (x < 0)
     *     return 0;
     * else
     *     return 1;
     * ```
     *
     * has a control flow graph containing Boolean successors:
     *
     * ```
     *        if
     *        |
     *      x < 0
     *       / \
     *      /   \
     *     /     \
     *  true    false
     *    |        \
     * return 0   return 1
     * ```
     */
    class BooleanSuccessor extends ConditionalSuccessor, TBooleanSuccessor {
      override boolean getValue() { this = TBooleanSuccessor(result) }

      override string toString() { result = getValue().toString() }

      override predicate matchesCompletion(Completion c) {
        c.(BooleanCompletion).getInnerValue() = this.getValue()
      }
    }

    /**
     * A nullness control flow successor.
     *
     * For example, this program fragment:
     *
     * ```
     * int? M(string s) => s?.Length;
     * ```
     *
     * has a control flow graph containing nullness successors:
     *
     * ```
     *      enter M
     *        |
     *        s
     *       / \
     *      /   \
     *     /     \
     *  null   non-null
     *     \      |
     *      \   Length
     *       \   /
     *        \ /
     *      exit M
     * ```
     */
    class NullnessSuccessor extends ConditionalSuccessor, TNullnessSuccessor {
      /** Holds if this is a `null` successor. */
      predicate isNull() { this = TNullnessSuccessor(true) }

      override boolean getValue() { this = TNullnessSuccessor(result) }

      override string toString() {
        if this.isNull() then
          result = "null"
        else
          result = "non-null"
      }

      override predicate matchesCompletion(Completion c) {
        if this.isNull() then
          c.(NullnessCompletion).isNull()
        else
          c = any(NullnessCompletion nc | not nc.isNull())
      }
    }

    /**
     * A matching control flow successor.
     *
     * For example, this program fragment:
     *
     * ```
     * switch (x) {
     *     case 0 :
     *         return 0;
     *     default :
     *         return 1;
     * }
     * ```
     *
     * has a control flow graph containing macthing successors:
     *
     * ```
     *      switch
     *        |
     *        x
     *        |
     *      case 0
     *       / \
     *      /   \
     *     /     \
     *  match   no-match
     *    |        \
     * return 0   default
     *              |
     *           return 1
     * ```
     */
    class MatchingSuccessor extends ConditionalSuccessor, TMatchingSuccessor {
      /** Holds if this is a match successor. */
      predicate isMatch() { this = TMatchingSuccessor(true) }

      override boolean getValue() { this = TMatchingSuccessor(result) }

      override string toString() {
        if this.isMatch() then
          result = "match"
        else
          result = "no-match"
      }

      override predicate matchesCompletion(Completion c) {
        if this.isMatch() then
          c.(MatchingCompletion).isMatch()
        else
          c = any(MatchingCompletion mc | not mc.isMatch())
      }
    }

    /**
     * An emptiness control flow successor.
     *
     * For example, this program fragment:
     *
     * ```
     * foreach (var arg in args)
     * {
     *     yield return arg;
     * }
     * yield return "";
     * ```
     *
     * has a control flow graph containing emptiness successors:
     *
     * ```
     *           args
     *            |
     *          foreach------<-------
     *           / \                 \
     *          /   \                |
     *         /     \               |
     *        /       \              |
     *     empty    non-empty        |
     *       |          \            |
     * yield return ""   \           |
     *                 var arg       |
     *                    |          |
     *             yield return arg  |
     *                     \_________/
     * ```
     */
    class EmptinessSuccessor extends ConditionalSuccessor, TEmptinessSuccessor {
      /** Holds if this is an empty successor. */
      predicate isEmpty() { this = TEmptinessSuccessor(true) }

      override boolean getValue() { this = TEmptinessSuccessor(result) }

      override string toString() {
        if this.isEmpty() then
          result = "empty"
        else
          result = "non-empty"
      }

      override predicate matchesCompletion(Completion c) {
        if this.isEmpty() then
          c.(EmptinessCompletion).isEmpty()
        else
          c = any(EmptinessCompletion ec | not ec.isEmpty())
      }
    }

    /**
     * A `return` control flow successor.
     *
     * Example:
     *
     * ```
     * void M()
     * {
     *     return;
     * }
     * ```
     *
     * The callable exit node of `M` is a `return` successor of the `return;`
     * statement.
     */
    class ReturnSuccessor extends SuccessorType, TReturnSuccessor {
      override string toString() { result = "return" }

      override predicate matchesCompletion(Completion c) {
        c instanceof ReturnCompletion
      }
    }

    /**
     * A `break` control flow successor.
     *
     * Example:
     *
     * ```
     * int M(int x)
     * {
     *     while (true)
     *     {
     *         if (x++ > 10)
     *             break;
     *     }
     *     return x;
     * }
     * ```
     *
     * The node `return x;` is a `break` succedssor of the node `break;`.
     */
    class BreakSuccessor extends SuccessorType, TBreakSuccessor {
      override string toString() { result = "break" }

      override predicate matchesCompletion(Completion c) {
        c instanceof BreakCompletion or
        c instanceof BreakNormalCompletion
      }
    }

    /**
     * A `continue` control flow successor.
     *
     * Example:
     *
     * ```
     * int M(int x)
     * {
     *     while (true) {
     *         if (x++ < 10)
     *             continue;
     *     }
     *     return x;
     * }
     * ```
     *
     * The node `while (true) { ... }` is a `continue` successor of the node
     * `continue;`.
     */
    class ContinueSuccessor extends SuccessorType, TContinueSuccessor {
      override string toString() { result = "continue" }

      override predicate matchesCompletion(Completion c) {
        c instanceof ContinueCompletion
      }
    }

    /**
     * A `goto label` control flow successor.
     *
     * Example:
     *
     * ```
     * int M(int x)
     * {
     *     while (true)
     *     {
     *         if (x++ > 10)
     *             goto Return;
     *     }
     *     Return: return x;
     * }
     * ```
     *
     * The node `Return: return x` is a `goto label` successor of the node
     * `goto Return;`.
     */
    class GotoLabelSuccessor extends SuccessorType, TGotoLabelSuccessor {
      /** Gets the statement that resulted in this `goto` successor. */
      GotoLabelStmt getGotoStmt() { this = TGotoLabelSuccessor(result) }

      override string toString() { result = "goto(" + getGotoStmt().getLabel() + ")" }

      override predicate matchesCompletion(Completion c) {
        c.(GotoLabelCompletion).getGotoStmt() = getGotoStmt()
      }
    }

    /**
     * A `goto case` control flow successor.
     *
     * Example:
     *
     * ```
     * switch (x)
     * {
     *     case 0  : return 1;
     *     case 1  : goto case 0;
     *     default : return -1;
     * }
     * ```
     *
     * The node `case 0  : return 1;` is a  `goto case` successor of the node
     * `goto case 0;`.
     */
    class GotoCaseSuccessor extends SuccessorType, TGotoCaseSuccessor {
      /** Gets the statement that resulted in this `goto case` successor. */
      GotoCaseStmt getGotoStmt() { this = TGotoCaseSuccessor(result) }

      override string toString() { result = "goto(" + getGotoStmt().getLabel() + ")" }

      override predicate matchesCompletion(Completion c) {
        c.(GotoCaseCompletion).getGotoStmt() = getGotoStmt()
      }
    }

    /**
     * A `goto default` control flow successor.
     *
     * Example:
     *
     * ```
     * switch (x)
     * {
     *     case 0  : return 1;
     *     case 1  : goto default;
     *     default : return -1;
     * }
     * ```
     *
     * The node `default : return -1;` is a `goto default` successor of the node
     * `goto default;`.
     */
    class GotoDefaultSuccessor extends SuccessorType, TGotoDefaultSuccessor {
      override string toString() { result = "goto default" }

      override predicate matchesCompletion(Completion c) {
        c instanceof GotoDefaultCompletion
      }
    }

    /**
     * An exceptional control flow successor.
     *
     * Example:
     *
     * ```
     * int M(string s)
     * {
     *     if (s == null)
     *         throw new ArgumentNullException(nameof(s));
     *     return s.Length;
     * }
     * ```
     *
     * The callable exit node of `M` is an exceptional successor (of type
     * `ArgumentNullException`) of the node `throw new ArgumentNullException(nameof(s));`.
     */
    class ExceptionSuccessor extends SuccessorType, TExceptionSuccessor {
      /** Gets the type of exception. */
      ExceptionClass getExceptionClass() { this = TExceptionSuccessor(result) }

      override string toString() { result = "exception(" + getExceptionClass().getName() + ")" }

      override predicate matchesCompletion(Completion c) {
        c.(ThrowCompletion).getExceptionClass() = getExceptionClass()
      }
    }

    /**
     * An exit control flow successor.
     *
     * Example:
     *
     * ```
     * int M(string s)
     * {
     *     if (s == null)
     *         System.Environment.Exit(0);
     *     return s.Length;
     * }
     * ```
     *
     * The callable exit node of `M` is an exit successor of the node on line 4.
     */
    class ExitSuccessor extends SuccessorType, TExitSuccessor {
      override string toString() { result = "exit" }

      override predicate matchesCompletion(Completion c) {
        c instanceof ExitCompletion
      }
    }
  }
  private import SuccessorTypes

  /**
   * INTERNAL: Do not use.
   */
  module Internal {
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
    private module Successor {
      /**
       * A control flow element where the children are evaluated following a
       * standard left-to-right evaluation. The actual evaluation order is
       * determined by the predicate `getChildElement()`.
       */
      private abstract class StandardElement extends ControlFlowElement {
        /** Gets the first child element of this element. */
        ControlFlowElement getFirstChildElement() {
          result = this.getChildElement(0)
        }

        /** Holds if this element has no children. */
        predicate isLeafElement() {
          not exists(this.getFirstChildElement())
        }

        /** Gets the last child element of this element. */
        ControlFlowElement getLastChildElement() {
          exists(int last |
            last = max(int i | exists(this.getChildElement(i))) and
            result = this.getChildElement(last)
          )
        }

        /** Gets the `i`th child element, which is not the last element. */
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
          not this instanceof ConstCase and
          not this instanceof TypeCase and
          not this instanceof LoopStmt and
          not this instanceof TryStmt and
          not this instanceof SpecificCatchClause and
          not this instanceof JumpStmt
        }

        override ControlFlowElement getChildElement(int i) {
          not this instanceof FixedStmt and
          not this instanceof UsingStmt and
          result = this.getChild(i)
          or
          this = any(GeneralCatchClause gcc |
            i = 0 and result = gcc.getBlock()
          )
          or
          this = any(FixedStmt fs |
            result = fs.getVariableDeclExpr(i)
            or
            result = fs.getBody() and
            i = max(int j | exists(fs.getVariableDeclExpr(j))) + 1
          )
          or
          this = any(UsingStmt us |
            if exists(us.getExpr()) then (
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
        AssignOperationWithExpandedAssignment() {
          this.hasExpandedAssignment()
        }
      }

      /** A conditionally qualified expression. */
      private class ConditionalQualifiableExpr extends QualifiableExpr {
        ConditionalQualifiableExpr() {
          this.isConditional()
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
          not this instanceof ConditionalQualifiableExpr and
          not this instanceof ThrowExpr and
          not this instanceof TypeAccess and
          not this instanceof ObjectCreation and
          not this instanceof ArrayCreation
        }

        override ControlFlowElement getChildElement(int i) {
          not this instanceof TypeofExpr and
          not this instanceof DefaultValueExpr and
          not this instanceof SizeofExpr and
          not this instanceof NameOfExpr and
          not this instanceof QualifiableExpr and
          not this instanceof Assignment and
          not this instanceof IsExpr and
          not this instanceof AsExpr and
          not this instanceof CastExpr and
          not this instanceof AnonymousFunctionExpr and
          not this instanceof DelegateCall and
          not this instanceof @unknown_expr and
          result = this.getChild(i)
          or
          this = any(ExtensionMethodCall emc |
            result = emc.getArgument(i)
          )
          or
          result = getQualifiableExprChild(this, i)
          or
          result = getAssignmentChild(this, i)
          or
          result = getIsExprChild(this, i)
          or
          result = getAsExprChild(this, i)
          or
          result = getCastExprChild(this, i)
          or
          result = this.(DelegateCall).getChild(i - 1)
          or
          result = getUnknownExprChild(this, i)
        }
      }

      private ControlFlowElement getQualifiableExprChild(QualifiableExpr qe, int i) {
        i >= 0 and
        not qe instanceof ExtensionMethodCall and
        not qe.isConditional() and
        if exists(Expr q | q = qe.getQualifier() | not q instanceof TypeAccess) then
          result = qe.getChild(i - 1)
        else
          result = qe.getChild(i)
      }

      private ControlFlowElement getAssignmentChild(Assignment a, int i) {
        // The left-hand side of an assignment is evaluated before the right-hand side
        i = 0 and result = a.getLValue()
        or
        i = 1 and result = a.getRValue()
      }

      private ControlFlowElement getIsExprChild(IsExpr ie, int i) {
        // The type access at index 1 is not evaluated at run-time
        i = 0 and result = ie.getExpr()
        or
        i = 1 and result = ie.(IsPatternExpr).getVariableDeclExpr()
        or
        i = 1 and result = ie.(IsConstantExpr).getConstant()
      }

      private ControlFlowElement getAsExprChild(AsExpr ae, int i) {
        // The type access at index 1 is not evaluated at run-time
        i = 0 and result = ae.getExpr()
      }

      private ControlFlowElement getUnknownExprChild(@unknown_expr e, int i) {
        exists(int c |
          result = e.(Expr).getChild(c) |
          c = rank[i+1](int j | exists(e.(Expr).getChild(j)))
        )
      }

      private ControlFlowElement getCastExprChild(CastExpr ce, int i) {
        // The type access at index 1 is not evaluated at run-time
        i = 0 and result = ce.getExpr()
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
        cfe = any(PostOrderElement poe |
          result = first(poe.getFirstChild())
          or
          not exists(poe.getFirstChild()) and
          result = poe
        )
        or
        cfe = any(AssignOperationWithExpandedAssignment a |
          result = first(a.getExpandedAssignment())
        )
        or
        cfe = any(ConditionalQualifiableExpr cqe |
          result = first(cqe.getChildExpr(-1))
        )
        or
        cfe = any(ArrayCreation ac |
          if ac.isImplicitlySized() then
            // No length argument: element itself
            result = ac
          else
            // First element of first length argument
            result = first(ac.getLengthArgument(0))
        )
        or
        cfe = any(ForeachStmt fs |
          // Unlike most other statements, `foreach` statements are not modelled in
          // pre-order, because we use the `foreach` node itself to represent the
          // emptiness test that determines whether to execute the loop body
          result = first(fs.getIterableExpr())
        )
      }

      private class PreOrderElement extends ControlFlowElement {
        PreOrderElement() {
          this instanceof StandardStmt or
          this instanceof IfStmt or
          this instanceof SwitchStmt or
          this instanceof ConstCase or
          this instanceof TypeCase or
          this instanceof TryStmt or
          this instanceof SpecificCatchClause or
          (this instanceof LoopStmt and not this instanceof ForeachStmt) or
          this instanceof LogicalNotExpr or
          this instanceof LogicalAndExpr or
          this instanceof LogicalOrExpr or
          this instanceof NullCoalescingExpr or
          this instanceof ConditionalExpr
        }
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
          result = this.(ObjectCreation).getArgument(0)
        }
      }

      /**
       * Gets a potential last element executed within control flow element `cfe`,
       * as well as its completion.
       *
       * For example, if `cfe` is `A || B` then both `A` and `B` are potential
       * last elements with Boolean completions.
       */
      ControlFlowElement last(ControlFlowElement cfe, Completion c) {
        // Pre-order: last element of last child (or self, if no children)
        cfe = any(StandardStmt ss |
          result = last(ss.getLastChildElement(), c)
          or
          ss.isLeafElement() and
          result = ss and
          c.isValidFor(result)
        )
        or
        // Post-order: element itself
        cfe instanceof StandardExpr and
        not cfe instanceof NonReturningCall and
        result = cfe and
        c.isValidFor(result)
        or
        // Pre/post order: a child exits abnormally
        result = last(cfe.(StandardElement).getChildElement(_), c) and
        not c instanceof NormalCompletion
        or
        cfe = any(LogicalNotExpr lne |
          // Operand exits with a Boolean completion
          exists(BooleanCompletion operandCompletion |
            result = lastLogicalNotExprOperand(lne, operandCompletion) |
            c = any(BooleanCompletion bc |
              bc.getOuterValue() = operandCompletion.getOuterValue().booleanNot() and
              bc.getInnerValue() = operandCompletion.getInnerValue()
            )
          )
          or
          // Operand exits with a non-Boolean completion
          result = lastLogicalNotExprOperand(lne, c) and
          not c instanceof BooleanCompletion
        )
        or
        cfe = any(LogicalAndExpr lae |
          // Left operand exits with a false completion
          result = lastLogicalAndExprLeftOperand(lae, c) and
          c instanceof FalseCompletion
          or
          // Left operand exits abnormally
          result = lastLogicalAndExprLeftOperand(lae, c) and
          not c instanceof NormalCompletion
          or
          // Right operand exits with any completion
          result = lastLogicalAndExprRightOperand(lae, c)
        )
        or
        cfe = any(LogicalOrExpr loe |
          // Left operand exits with a true completion
          result = lastLogicalOrExprLeftOperand(loe, c) and
          c instanceof TrueCompletion
          or
          // Left operand exits abnormally
          result = lastLogicalOrExprLeftOperand(loe, c) and
          not c instanceof NormalCompletion
          or
          // Right operand exits with any completion
          result = lastLogicalOrExprRightOperand(loe, c)
        )
        or
        cfe = any(NullCoalescingExpr nce |
          // Left operand exits with any non-`null` completion
          result = lastNullCoalescingExprLeftOperand(nce, c) and
          not c.(NullnessCompletion).isNull()
          or
          // Right operand exits with any completion
          result = lastNullCoalescingExprRightOperand(nce, c)
        )
        or
        cfe = any(ConditionalExpr ce |
          // Condition exits abnormally
          result = lastConditionalExprCondition(ce, c) and
          not c instanceof NormalCompletion
          or
          // Then branch exits with any completion
          result = lastConditionalExprThen(ce, c)
          or
          // Else branch exits with any completion
          result = lastConditionalExprElse(ce, c)
        )
        or
        result = lastAssignOperationWithExpandedAssignmentExpandedAssignment(cfe, c)
        or
        cfe = any(ConditionalQualifiableExpr cqe |
          // Post-order: element itself
          result = cqe and
          c.isValidFor(cqe)
          or
          // Qualifier exits with a `null` completion
          result = lastConditionalQualifiableExprChildExpr(cqe, -1, c) and
          c.(NullnessCompletion).isNull()
        )
        or
        cfe = any(ThrowExpr te |
          // Post-order: element itself
          te.getThrownExceptionType() = c.(ThrowCompletion).getExceptionClass() and
          result = te
          or
          // Expression being thrown exits abnormally
          result = lastThrowExprExpr(te, c) and
          not c instanceof NormalCompletion
        )
        or
        cfe = any(ObjectCreation oc |
          // Post-order: element itself (when no initializer)
          result = oc and
          not oc.hasInitializer() and
          c.isValidFor(result)
          or
          // Last element of initializer
          result = lastObjectCreationInitializer(oc, c)
        )
        or
        cfe = any(ArrayCreation ac |
          // Post-order: element itself (when no initializer)
          result = ac and
          not ac.hasInitializer() and
          c.isValidFor(result)
          or
          // Last element of initializer
          result = lastArrayCreationInitializer(ac, c)
        )
        or
        cfe = any(IfStmt is |
          // Condition exits with a false completion and there is no `else` branch
          result = lastIfStmtCondition(is, c) and
          c instanceof FalseCompletion and
          not exists(is.getElse())
          or
          // Condition exits abnormally
          result = lastIfStmtCondition(is, c) and
          not c instanceof NormalCompletion
          or
          // Then branch exits with any completion
          result = lastIfStmtThen(is, c)
          or
          // Else branch exits with any completion
          result = lastIfStmtElse(is, c)
        )
        or
        cfe = any(SwitchStmt ss |
          // Switch expression exits normally and there are no cases
          result = lastSwitchStmtCondition(ss, c) and
          not exists(ss.getACase()) and
          c instanceof NormalCompletion
          or
          // Switch expression exits abnormally
          result = lastSwitchStmtCondition(ss, c) and
          not c instanceof NormalCompletion
          or
          // A statement exits with a `break` completion
          result = lastSwitchStmtStmt(ss, _, any(BreakCompletion bc)) and
          c instanceof BreakNormalCompletion
          or
          // A statement exits abnormally
          result = lastSwitchStmtStmt(ss, _, c) and
          not c instanceof BreakCompletion and
          not c instanceof NormalCompletion and
          not c instanceof GotoDefaultCompletion and
          not c instanceof GotoCaseCompletion
          or
          // Last case exits with a non-match
          exists(int last |
            last = max(int i | exists(ss.getCase(i))) |
            result = lastConstCaseNoMatch(ss.getCase(last), c) or
            result = lastTypeCaseNoMatch(ss.getCase(last), c)
          )
          or
          // Last statement exits with any non-break completion
          exists(int last |
            last = max(int i | exists(ss.getStmt(i))) |
            result = lastSwitchStmtStmt(ss, last, c) and
            not c instanceof BreakCompletion
          )
        )
        or
        cfe = any(ConstCase cc |
          // Case expression exits with a non-match
          result = lastConstCaseNoMatch(cc, c)
          or
          // Case expression exits abnormally
          result = lastConstCaseExpr(cc, c) and
          not c instanceof NormalCompletion
        )
        or
        cfe = any(TypeCase tc |
          // Type test exits with a non-match
          result = lastTypeCaseNoMatch(tc, c)
        )
        or
        cfe = any(CaseStmt cs |
          // Condition exists with a `false` completion
          result = lastCaseCondition(cs, c) and
          c instanceof FalseCompletion
          or
          // Condition exists abnormally
          result = lastCaseCondition(cs, c) and
          not c instanceof NormalCompletion
          or
          // Case statement exits with any completion
          result = lastCaseStmt(cs, c)
        )
        or
        exists(LoopStmt ls |
          cfe = ls and
          not ls instanceof ForeachStmt |
          // Condition exits with a false completion
          result = lastLoopStmtCondition(ls, c) and
          c instanceof FalseCompletion
          or
          // Condition exits abnormally
          result = lastLoopStmtCondition(ls, c) and
          not c instanceof NormalCompletion
          or
          exists(Completion bodyCompletion |
            result = lastLoopStmtBody(ls, bodyCompletion) |
            if bodyCompletion instanceof BreakCompletion then
              // Body exits with a break completion; the loop exits normally
              // Note: we use a `BreakNormalCompletion` rather than a `NormalCompletion`
              // in order to be able to get the correct break label in the control flow
              // graph from the `result` node to the node after the loop.
              c instanceof BreakNormalCompletion
            else (
              // Body exits with a completion that does not continue the loop
              not bodyCompletion.continuesLoop() and
              c = bodyCompletion
            )
          )
        )
        or
        cfe = any(ForeachStmt fs |
          // Iterator expression exits abnormally
          result = lastForeachStmtIterableExpr(fs, c) and
          not c instanceof NormalCompletion
          or
          // Emptiness test exits with no more elements
          result = fs and
          c.(EmptinessCompletion).isEmpty()
          or
          exists(Completion bodyCompletion |
            result = lastLoopStmtBody(fs, bodyCompletion) |
            if bodyCompletion instanceof BreakCompletion then
              // Body exits with a break completion; the loop exits normally
              // Note: we use a `BreakNormalCompletion` rather than a `NormalCompletion`
              // in order to be able to get the correct break label in the control flow
              // graph from the `result` node to the node after the loop.
              c instanceof BreakNormalCompletion
            else (
              // Body exits abnormally
              c = bodyCompletion and
              not c instanceof NormalCompletion and
              not c instanceof ContinueCompletion
            )
          )
        )
        or
        cfe = any(TryStmt ts |
          // If the `finally` block completes normally, it resumes any non-normal
          // completion that was current before the `finally` block was entered
          exists(Completion finallyCompletion |
            result = lastTryStmtFinally(ts, finallyCompletion) and
            finallyCompletion instanceof NormalCompletion
            |
            exists(getBlockOrCatchFinallyPred(ts, any(NormalCompletion nc))) and
            c = finallyCompletion
            or
            exists(getBlockOrCatchFinallyPred(ts, c)) and
            not c instanceof NormalCompletion
          )
          or
          // If the `finally` block completes abnormally, take the completion of
          // the `finally` block itself
          result = lastTryStmtFinally(ts, c) and
          not c instanceof NormalCompletion
          or
          result = getBlockOrCatchFinallyPred(ts, c) and
          (
            // If there is no `finally` block, last elements are from the body, from
            // the blocks of one of the `catch` clauses, or from the last `catch` clause
            not ts.hasFinally()
            or
            // Exit completions ignore the `finally` block
            c instanceof ExitCompletion
          )
        )
        or
        cfe = any(SpecificCatchClause scc |
          // Last element of `catch` block
          result = lastCatchClauseBlock(cfe, c)
          or
          (
            if scc.isLast() then (
              // Last `catch` clause inherits throw completions from the `try` block,
              // when the clause does not match
              throwMayBeUncaught(scc, c) and
              (
                // Incompatible exception type: clause itself
                result = scc
                or
                // Incompatible filter
                result = lastSpecificCatchClauseFilterClause(scc, _)
              )
            ) else (
              // Incompatible exception type: clause itself
              result = scc and
              c = any(MatchingCompletion mc | not mc.isMatch())
              or
              // Incompatible filter
              result = lastSpecificCatchClauseFilterClause(scc, c) and
              c instanceof FalseCompletion
            )
          )
        )
        or
        cfe = any(JumpStmt js |
          // Post-order: element itself
          result = js and
          (
            js instanceof BreakStmt and c instanceof BreakCompletion
            or
            js instanceof ContinueStmt and c instanceof ContinueCompletion
            or
            js = c.(GotoLabelCompletion).getGotoStmt()
            or
            js = c.(GotoCaseCompletion).getGotoStmt()
            or
            js instanceof GotoDefaultStmt and c instanceof GotoDefaultCompletion
            or
            js.(ThrowStmt).getThrownExceptionType() = c.(ThrowCompletion).getExceptionClass()
            or
            js instanceof ReturnStmt and c instanceof ReturnCompletion
            or
            // `yield break` behaves like a return statement
            js instanceof YieldBreakStmt and c instanceof ReturnCompletion
            or
            // `yield return` behaves like a normal statement
            js instanceof YieldReturnStmt and c.isValidFor(js)
          )
          or
          // Child exits abnormally
          result = lastJumpStmtChild(cfe, c) and
          not c instanceof NormalCompletion
        )
        or
        // Propagate completion from a call to a non-terminating callable
        cfe = any(NonReturningCall nrc |
          result = nrc and
          c = nrc.getACompletion()
        )
      }

      private ControlFlowElement lastConstCaseNoMatch(ConstCase cc, MatchingCompletion c) {
        result = lastConstCaseExpr(cc, c) and
        not c.isMatch()
      }

      private ControlFlowElement lastTypeCaseNoMatch(TypeCase tc, MatchingCompletion c) {
        result = tc.getTypeAccess() and
        not c.isMatch() and
        c.isValidFor(result)
      }

      pragma [nomagic]
      private ControlFlowElement lastStandardElementGetNonLastChildElement(StandardElement se, int i, Completion c) {
        result = last(se.getNonLastChildElement(i), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastThrowExprExpr(ThrowExpr te, Completion c) {
        result = last(te.getExpr(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastLogicalNotExprOperand(LogicalNotExpr lne, Completion c) {
        result = last(lne.getOperand(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastLogicalAndExprLeftOperand(LogicalAndExpr lae, Completion c) {
        result = last(lae.getLeftOperand(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastLogicalAndExprRightOperand(LogicalAndExpr lae, Completion c) {
        result = last(lae.getRightOperand(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastLogicalOrExprLeftOperand(LogicalOrExpr loe, Completion c) {
        result = last(loe.getLeftOperand(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastLogicalOrExprRightOperand(LogicalOrExpr loe, Completion c) {
        result = last(loe.getRightOperand(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastNullCoalescingExprLeftOperand(NullCoalescingExpr nce, Completion c) {
        result = last(nce.getLeftOperand(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastNullCoalescingExprRightOperand(NullCoalescingExpr nce, Completion c) {
        result = last(nce.getRightOperand(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastConditionalExprCondition(ConditionalExpr ce, Completion c) {
        result = last(ce.getCondition(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastConditionalExprThen(ConditionalExpr ce, Completion c) {
        result = last(ce.getThen(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastConditionalExprElse(ConditionalExpr ce, Completion c) {
        result = last(ce.getElse(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastAssignOperationWithExpandedAssignmentExpandedAssignment(AssignOperationWithExpandedAssignment a, Completion c) {
        result = last(a.getExpandedAssignment(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastConditionalQualifiableExprChildExpr(ConditionalQualifiableExpr cqe, int i, Completion c) {
        result = last(cqe.getChildExpr(i), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastObjectCreationArgument(ObjectCreation oc, int i, Completion c) {
        result = last(oc.getArgument(i), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastObjectCreationInitializer(ObjectCreation oc, Completion c) {
        result = last(oc.getInitializer(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastArrayCreationInitializer(ArrayCreation ac, Completion c) {
        result = last(ac.getInitializer(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastArrayCreationLengthArgument(ArrayCreation ac, int i, Completion c) {
        not ac.isImplicitlySized() and
        result = last(ac.getLengthArgument(i), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastIfStmtCondition(IfStmt is, Completion c) {
        result = last(is.getCondition(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastIfStmtThen(IfStmt is, Completion c) {
        result = last(is.getThen(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastIfStmtElse(IfStmt is, Completion c) {
        result = last(is.getElse(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastSwitchStmtCondition(SwitchStmt ss, Completion c) {
        result = last(ss.getCondition(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastSwitchStmtStmt(SwitchStmt ss, int i, Completion c) {
        result = last(ss.getStmt(i), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastSwitchStmtCaseStmt(SwitchStmt ss, int i, Completion c) {
        result = last(ss.getStmt(i).(ConstCase).getStmt(), c) or
        result = last(ss.getStmt(i).(TypeCase).getStmt(), c) or
        result = last(ss.getStmt(i).(DefaultCase), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastConstCaseExpr(ConstCase cc, Completion c) {
        result = last(cc.getExpr(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastCaseStmt(CaseStmt cs, Completion c) {
        result = last(cs.(TypeCase).getStmt(), c)
        or
        result = last(cs.(ConstCase).getStmt(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastCaseCondition(CaseStmt cs, Completion c) {
        result = last(cs.getCondition(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastTypeCaseVariableDeclExpr(TypeCase tc, Completion c) {
        result = last(tc.getVariableDeclExpr(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastLoopStmtCondition(LoopStmt ls, Completion c) {
        result = last(ls.getCondition(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastLoopStmtBody(LoopStmt ls, Completion c) {
        result = last(ls.getBody(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastForeachStmtIterableExpr(ForeachStmt fs, Completion c) {
        result = last(fs.getIterableExpr(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastForeachStmtVariableDeclExpr(ForeachStmt fs, Completion c) {
        result = last(fs.getVariableDeclExpr(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastJumpStmtChild(JumpStmt js, Completion c) {
        result = last(js.getChild(0), c)
      }

      pragma [nomagic]
      ControlFlowElement lastTryStmtFinally(TryStmt ts, Completion c) {
        result = last(ts.getFinally(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastTryStmtBlock(TryStmt ts, Completion c) {
        result = last(ts.getBlock(), c)
      }

      pragma [nomagic]
      ControlFlowElement lastTryStmtCatchClause(TryStmt ts, int i, Completion c) {
        result = last(ts.getCatchClause(i), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastSpecificCatchClauseFilterClause(SpecificCatchClause scc, Completion c) {
        result = last(scc.getFilterClause(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastCatchClauseBlock(CatchClause cc, Completion c) {
        result = last(cc.getBlock(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastStandardExprLastChildElement(StandardExpr se, Completion c) {
        result = last(se.getLastChildElement(), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastForStmtUpdate(ForStmt fs, int i, Completion c) {
        result = last(fs.getUpdate(i), c)
      }

      pragma [nomagic]
      private ControlFlowElement lastForStmtInitializer(ForStmt fs, int i, Completion c) {
        result = last(fs.getInitializer(i), c)
      }

      /**
       * Gets a last element from a `try` or `catch` block of this `try` statement
       * that may finish with completion `c`, such that control may be transferred
       * to the `finally` block (if it exists).
       */
      pragma [nomagic]
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
        exists(int last |
          ts.getCatchClause(last).isLast() |
          result = lastTryStmtCatchClause(ts, last, c)
        )
      }

      /**
       * Holds if the `try` block that catch clause `scc` belongs to may throw an
       * exception of type `c`, where no `catch` clause is guaranteed to catch it.
       * The catch clause `last` is the last catch clause in the `try` statement
       * that it belongs to.
       */
      pragma [nomagic]
      private predicate throwMayBeUncaught(SpecificCatchClause last, ThrowCompletion c) {
        exists(TryStmt ts |
          ts = last.getTryStmt() and
          exists(lastTryStmtBlock(ts, c)) and
          not ts.getACatchClause() instanceof GeneralCatchClause and
          forall(SpecificCatchClause scc |
            scc = ts.getACatchClause() |
            scc.hasFilterClause()
            or
            not c.getExceptionClass().getABaseType*() = scc.getCaughtExceptionType()
          ) and
          last.isLast()
        )
      }

      /**
       * Provides a simple analysis for identifying calls to callables that will
       * not return.
       */
      private module NonReturning {
        private import semmle.code.csharp.ExprOrStmtParent
        private import semmle.code.csharp.commons.Assertions
        private import semmle.code.csharp.frameworks.System

        /** A call that definitely does not return (conservative analysis). */
        abstract class NonReturningCall extends Call {
          /** Gets a valid completion for this non-returning call. */
          abstract Completion getACompletion();
        }

        private class ExitingCall extends NonReturningCall {
          ExitingCall() {
            this.getTarget() instanceof ExitingCallable
            or
            exists(AssertMethod m |
              m = this.(FailingAssertion).getAssertMethod() |
              not exists(m.getExceptionClass())
            )
          }

          override ExitCompletion getACompletion() { any() }
        }

        private class ThrowingCall extends NonReturningCall {
          private ThrowCompletion c;

          ThrowingCall() {
            c = this.getTarget().(ThrowingCallable).getACallCompletion()
            or
            exists(AssertMethod m |
              m = this.(FailingAssertion).getAssertMethod() |
              c.getExceptionClass() = m.getExceptionClass()
            )
          }

          override ThrowCompletion getACompletion() { result = c }
        }

        private abstract class NonReturningCallable extends Callable {
          NonReturningCallable() {
            not exists(ReturnStmt ret | ret.getEnclosingCallable() = this) and
            not hasAccessorAutoImplementation(this, _) and
            not exists(Virtualizable v |
              v.isOverridableOrImplementable() |
              v = this or
              v = this.(Accessor).getDeclaration()
            )
          }
        }

        private abstract class ExitingCallable extends NonReturningCallable { }

        private class DirectlyExitingCallable extends ExitingCallable {
          DirectlyExitingCallable() {
            this = any(Method m |
              m.hasQualifiedName("System.Environment", "Exit") or
              m.hasQualifiedName("System.Windows.Forms.Application", "Exit")
            )
          }
        }

        private class IndirectlyExitingCallable extends ExitingCallable {
          IndirectlyExitingCallable() {
            forex(ControlFlowElement body |
              body = this.getABody() |
              body = getAnExitingElement()
            )
          }
        }

        private ControlFlowElement getAnExitingElement() {
          result instanceof ExitingCall
          or
          result = getAnExitingStmt()
        }

        private Stmt getAnExitingStmt() {
          result.(ExprStmt).getExpr() = getAnExitingElement()
          or
          result.(BlockStmt).getFirstStmt() = getAnExitingElement()
          or
          exists(IfStmt ifStmt |
            result = ifStmt and
            ifStmt.getThen() = getAnExitingElement() and
            ifStmt.getElse() = getAnExitingElement()
          )
        }

        private class ThrowingCallable extends NonReturningCallable {
          ThrowingCallable() {
            forex(ControlFlowElement body |
              body = this.getABody() |
              body = getAThrowingElement(_)
            )
          }

          /** Gets a valid completion for a call to this throwing callable. */
          ThrowCompletion getACallCompletion() {
            this.getABody() = getAThrowingElement(result)
          }
        }

        private ControlFlowElement getAThrowingElement(ThrowCompletion c) {
          c = result.(ThrowingCall).getACompletion()
          or
          result = any(ThrowElement te |
            c.getExceptionClass() = te.getThrownExceptionType() and
            // For stub implementations, there may exist proper implementations that are not seen
            // during compilation, so we conservatively rule those out
            not isStub(te)
          )
          or
          result = getAThrowingStmt(c)
        }

        private Stmt getAThrowingStmt(ThrowCompletion c) {
          result.(ExprStmt).getExpr() = getAThrowingElement(c)
          or
          result.(BlockStmt).getFirstStmt() = getAThrowingStmt(c)
          or
          exists(IfStmt ifStmt, ThrowCompletion c1, ThrowCompletion c2 |
            result = ifStmt and
            ifStmt.getThen() = getAThrowingElement(c1) and
            ifStmt.getElse() = getAThrowingElement(c2) |
            c = c1
            or
            c = c2
          )
        }

        /** Holds if `throw` element `te` indicates a stub implementation. */
        private predicate isStub(ThrowElement te) {
          exists(Expr e |
            e = te.getExpr() |
            e instanceof NullLiteral or
            e.getType() instanceof SystemNotImplementedExceptionClass
          )
        }
      }
      private import NonReturning

      /**
       * Gets a control flow successor for control flow element `cfe`, given that
       * `cfe` finishes with completion `c`.
       */
      pragma [nomagic]
      ControlFlowElement succ(ControlFlowElement cfe, Completion c) {
        // Pre-order: flow from element itself to first element of first child
        cfe = any(StandardStmt ss |
          result = first(ss.getFirstChildElement()) and
          c instanceof SimpleCompletion
        )
        or
        // Post-order: flow from last element of last child to element itself
        cfe = lastStandardExprLastChildElement(result, c) and
        c instanceof NormalCompletion
        or
        // Standard left-to-right evaluation
        exists(StandardElement parent, int i |
          cfe = lastStandardElementGetNonLastChildElement(parent, i, c) and
          c instanceof NormalCompletion and
          result = first(parent.getChildElement(i + 1))
        )
        or
        cfe = any(LogicalNotExpr lne |
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
          cfe = lastLogicalAndExprLeftOperand(lae, c) and
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
          cfe = lastLogicalOrExprLeftOperand(loe, c) and
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
          cfe = lastNullCoalescingExprLeftOperand(nce, c) and
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
          cfe = lastConditionalExprCondition(ce, c) and
          c instanceof TrueCompletion and
          result = first(ce.getThen())
          or
          // Flow from last element of condition to first element of else branch
          cfe = lastConditionalExprCondition(ce, c) and
          c instanceof FalseCompletion and
          result = first(ce.getElse())
        )
        or
        exists(ConditionalQualifiableExpr parent, int i |
          cfe = lastConditionalQualifiableExprChildExpr(parent, i, c) and
          c instanceof NormalCompletion and
          not c.(NullnessCompletion).isNull()
          |
          // Post-order: flow from last element of last child to element itself
          i = max(int j | exists(parent.getChildExpr(j))) and
          result = parent
          or
          // Standard left-to-right evaluation
          result = first(parent.getChildExpr(i + 1))
        )
        or
        // Post-order: flow from last element of thrown expression to expression itself
        cfe = lastThrowExprExpr(result, c) and
        c instanceof NormalCompletion
        or
        exists(ObjectCreation oc |
          // Flow from last element of argument `i` to first element of argument `i+1`
          exists(int i |
            cfe = lastObjectCreationArgument(oc, i, c) |
            result = first(oc.getArgument(i + 1)) and
            c instanceof NormalCompletion
          )
          or
          // Flow from last element of last argument to self
          exists(int last |
            last = max(int i | exists(oc.getArgument(i))) |
            cfe = lastObjectCreationArgument(oc, last, c) and
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
            cfe = lastArrayCreationLengthArgument(ac, i, c) and
            c instanceof SimpleCompletion |
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
          cfe = lastIfStmtCondition(is, c)
          and
          (
            // Flow from last element of condition to first element of then branch
            c instanceof TrueCompletion and result = first(is.getThen())
            or
            // Flow from last element of condition to first element of else branch
            c instanceof FalseCompletion and result = first(is.getElse())
          )
        )
        or
        exists(SwitchStmt ss |
          // Pre-order: flow from statement itself to first element of switch expression
          cfe = ss and
          result = first(ss.getCondition()) and
          c instanceof SimpleCompletion
          or
          // Flow from last element of switch expression to first element of first statement
          cfe = lastSwitchStmtCondition(ss, c) and
          c instanceof NormalCompletion and
          result = first(ss.getStmt(0))
          or
          // Flow from last element of non-`case` statement `i` to first element of statement `i+1`
          exists(int i |
            cfe = lastSwitchStmtStmt(ss, i, c) |
            not ss.getStmt(i) instanceof CaseStmt and
            c instanceof NormalCompletion and
            result = first(ss.getStmt(i + 1))
          )
          or
          // Flow from last element of `case` statement `i` to first element of statement `i+1`
          exists(int i |
            cfe = lastSwitchStmtCaseStmt(ss, i, c) |
            c instanceof NormalCompletion and
            result = first(ss.getStmt(i + 1))
          )
          or
          // Flow from last element of case expression to next case
          exists(ConstCase cc, int i |
            cc = ss.getCase(i) |
            cfe = lastConstCaseExpr(cc, c) and
            c = any(MatchingCompletion mc | not mc.isMatch()) and
            result = first(ss.getCase(i + 1))
          )
          or
          // Flow from last element of condition to next case
          exists(CaseStmt tc, int i |
            tc = ss.getCase(i) |
            cfe = lastCaseCondition(tc, c) and
            c instanceof FalseCompletion and
            result = first(ss.getCase(i + 1))
          )
          or
          exists(GotoCompletion gc |
            cfe = lastSwitchStmtStmt(ss, _, gc) and
            gc = c |
            // Flow from last element of a statement with a `goto default` completion
            // to first element `default` statement
            gc instanceof GotoDefaultCompletion and
            result = first(ss.getDefaultCase())
            or
            // Flow from last element of a statement with a `goto case` completion
            // to first element of relevant case
            exists(ConstCase cc |
              cc = ss.getAConstCase() and
              cc.getLabel() = gc.(GotoCaseCompletion).getLabel() and
              result = first(cc.getStmt())
            )
          )
        )
        or
        exists(ConstCase cc |
          // Pre-order: flow from statement itself to first element of expression
          cfe = cc and
          result = first(cc.getExpr()) and
          c instanceof SimpleCompletion
          or
          cfe = lastConstCaseExpr(cc, c) and
          c.(MatchingCompletion).isMatch() and (
            if exists(cc.getCondition()) then
              // Flow from the last element of case expression to the condition
              result = first(cc.getCondition())
            else
              // Flow from last element of case expression to first element of statement
              result = first(cc.getStmt())
          )
          or
          // Flow from last element of case condition to first element of statement
          cfe = lastCaseCondition(cc, c) and
          c instanceof TrueCompletion and
          result = first(cc.getStmt())
        )
        or
        exists(TypeCase tc |
          // Pre-order: flow from statement itself to type test
          cfe = tc and
          result = tc.getTypeAccess() and
          c instanceof SimpleCompletion
          or
          cfe = tc.getTypeAccess() and
          c.isValidFor(cfe) and
          c = any(MatchingCompletion mc |
            if mc.isMatch() then
              if exists(tc.getVariableDeclExpr()) then
                // Flow from type test to first element of variable declaration
                result = first(tc.getVariableDeclExpr())
              else if exists(tc.getCondition()) then
                // Flow from type test to first element of condition
                result = first(tc.getCondition())
              else
                // Flow from type test to first element of statement
                result = first(tc.getStmt())
            else
              // Flow from type test to first element of next case
              exists(SwitchStmt ss, int i |
                tc = ss.getCase(i) |
                result = first(ss.getCase(i + 1))
              )
          )
          or
          cfe = lastTypeCaseVariableDeclExpr(tc, c) and
          if exists(tc.getCondition()) then
            // Flow from variable declaration to first element of condition
            result = first(tc.getCondition())
          else
            // Flow from variable declaration to first element of statement
            result = first(tc.getStmt())
          or
          // Flow from condition to first element of statement
          cfe = lastCaseCondition(tc, c) and
          c instanceof TrueCompletion and
          result = first(tc.getStmt())
        )
        or
        exists(LoopStmt ls |
          // Flow from last element of condition to first element of loop body
          cfe = lastLoopStmtCondition(ls, c) and
          c instanceof TrueCompletion and
          result = first(ls.getBody())
          or
          // Flow from last element of loop body back to first element of condition
          not ls instanceof ForStmt and
          cfe = lastLoopStmtBody(ls, c) and
          c.continuesLoop() and
          result = first(ls.getCondition())
        )
        or
        cfe = any(WhileStmt ws |
          // Pre-order: flow from statement itself to first element of condition
          result = first(ws.getCondition()) and
          c instanceof SimpleCompletion
        )
        or
        cfe = any(DoStmt ds |
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
            c instanceof SimpleCompletion |
            next = fs.getInitializer(0)
            or
            not exists(fs.getInitializer(0)) and
            next = getForStmtConditionOrBody(fs)
          )
          or
          // Flow from last element of initializer `i` to first element of initializer `i+1`
          exists(int i |
            cfe = lastForStmtInitializer(fs, i, c) |
            c instanceof NormalCompletion and
            result = first(fs.getInitializer(i + 1))
          )
          or
          // Flow from last element of last initializer to first element of condition/loop body
          exists(int last |
            last = max(int i | exists(fs.getInitializer(i))) |
            cfe = lastForStmtInitializer(fs, last, c) and
            c instanceof NormalCompletion and
            result = first(getForStmtConditionOrBody(fs))
          )
          or
          // Flow from last element of condition into first element of loop body
          cfe = lastLoopStmtCondition(fs, c) and
          c instanceof TrueCompletion and
          result = first(fs.getBody())
          or
          // Flow from last element of loop body to first element of update/condition/self
          exists(ControlFlowElement next |
            cfe = lastLoopStmtBody(fs, c) and
            c.continuesLoop() and
            result = first(next) and
            if exists(fs.getUpdate(0)) then
              next = fs.getUpdate(0)
            else
              next = getForStmtConditionOrBody(fs)
          )
          or
          // Flow from last element of update to first element of next update/condition/loop body
          exists(ControlFlowElement next, int i |
            cfe = lastForStmtUpdate(fs, i, c) and
            c instanceof NormalCompletion and
            result = first(next) and
            if exists(fs.getUpdate(i + 1)) then
              next = fs.getUpdate(i + 1)
            else
              next = getForStmtConditionOrBody(fs)
          )
        )
        or
        exists(ForeachStmt fs |
          // Flow from last element of iterator expression to emptiness test
          cfe = lastForeachStmtIterableExpr(fs, c) and
          c instanceof NormalCompletion and
          result = fs
          or
          // Flow from emptiness test to first element of variable declaration/loop body
          cfe = fs and
          c = any(EmptinessCompletion ec | not ec.isEmpty()) and
          (
            result = first(fs.getVariableDeclExpr())
            or
            not exists(fs.getVariableDeclExpr()) and
            result = first(fs.getBody())
          )
          or
          // Flow from last element of variable declaration to first element of loop body
          cfe = lastForeachStmtVariableDeclExpr(fs, c) and
          c instanceof SimpleCompletion and
          result = first(fs.getBody())
          or
          // Flow from last element of loop body back to emptiness test
          cfe = lastLoopStmtBody(fs, c) and
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
          exists(SpecificCatchClause scc, int i |
            scc = ts.getCatchClause(i) |
            cfe = scc and
            scc = lastTryStmtCatchClause(ts, i, c) and
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
            cfe = lastTryStmtCatchClause(ts, i, c) and
            cfe = lastSpecificCatchClauseFilterClause(scc, _) and
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
            cfe = lastCatchClauseBlock(scc, c) and
            result = first(ts.getFinally())
          )
          or
          // Flow from last element of `try` block to first element of `finally` block
          cfe = lastTryStmtBlock(ts, c) and
          result = first(ts.getFinally()) and
          not c instanceof ExitCompletion and
          (
            c instanceof ThrowCompletion
            implies
            not exists(ts.getACatchClause())
          )
        )
        or
        exists(SpecificCatchClause scc |
          // Flow from catch clause to variable declaration/filter clause/block
          cfe = scc and
          c.(MatchingCompletion).isMatch() and
          exists(ControlFlowElement next |
            result = first(next) |
            if exists(scc.getVariableDeclExpr()) then
              next = scc.getVariableDeclExpr()
            else if exists(scc.getFilterClause()) then
              next = scc.getFilterClause()
            else
              next = scc.getBlock()
          )
          or
          // Flow from variable declaration to filter clause/block
          cfe = last(scc.getVariableDeclExpr(), c) and
          c instanceof SimpleCompletion and
          exists(ControlFlowElement next |
            result = first(next) |
            if exists(scc.getFilterClause()) then
              next = scc.getFilterClause()
            else
              next = scc.getBlock()
          )
          or
          // Flow from filter to block
          cfe = last(scc.getFilterClause(), c) and
          c instanceof TrueCompletion and
          result = first(scc.getBlock())
        )
        or
        // Post-order: flow from last element of child to statement itself
        cfe = lastJumpStmtChild(result, c) and
        c instanceof NormalCompletion
        or
        // Flow from constructor initializer to first element of constructor body
        cfe = any(ConstructorInitializer ci |
          c instanceof SimpleCompletion and
          result = first(ci.getConstructor().getBody())
        )
        or
        // Flow from element with `goto` completion to first element of relevant
        // target
        c = any(GotoLabelCompletion glc |
          cfe = last(_, glc) and
          // Special case: when a `goto` happens inside a `try` statement with a
          // `finally` block, flow does not go directly to the target, but instead
          // to the `finally` block (and from there possibly to the target)
          not cfe = getBlockOrCatchFinallyPred(any(TryStmt ts | ts.hasFinally()), _) and
          result = first(glc.getGotoStmt().getTarget())
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
      ControlFlowElement succEntry(Callable c) {
        if exists(c.(Constructor).getInitializer()) then
          result = first(c.(Constructor).getInitializer())
        else
          result = first(c.getBody())
      }

      /**
       * Gets the callable that is exited when `cfe` finishes with completion `c`,
       * if any.
       */
      Callable succExit(ControlFlowElement cfe, Completion c) {
        cfe = last(result.getBody(), c) and
        not c instanceof GotoCompletion
      }
    }
    import Successor

    /**
     * Provides a basic block implementation on control flow elements. That is,
     * a "pre-CFG" where the nodes are (unsplit) control flow elements and the
     * successor releation is `succ = succ(pred, _)`.
     *
     * The logic is duplicated from the implementation in `BasicBlocks.qll`, and
     * being an internal class, all predicate documentation has been removed.
     */
    module PreBasicBlocks {
      private predicate startsBB(ControlFlowElement cfe) {
        not cfe = succ(_, _) and
        (
          exists(succ(cfe, _))
          or
          exists(succExit(cfe, _))
        )
        or
        strictcount(ControlFlowElement pred, Completion c | cfe = succ(pred, c)) > 1
        or
        exists(ControlFlowElement pred, int i |
          cfe = succ(pred, _) and
          i = count(ControlFlowElement succ, Completion c | succ = succ(pred, c)) |
          i > 1
          or
          i = 1 and
          exists(succExit(pred, _))
        )
      }

      private predicate intraBBSucc(ControlFlowElement pred, ControlFlowElement succ) {
        succ = succ(pred, _) and
        not startsBB(succ)
      }

      private predicate bbIndex(ControlFlowElement bbStart, ControlFlowElement cfe, int i) =
        shortestDistances(startsBB/1, intraBBSucc/2)(bbStart, cfe, i)

      private predicate succBB(PreBasicBlock pred, PreBasicBlock succ) {
        succ = pred.getASuccessor()
      }

      private predicate entryBB(PreBasicBlock bb) {
        bb = succEntry(_)
      }

      private predicate bbIDominates(PreBasicBlock dom, PreBasicBlock bb) =
        idominance(entryBB/1, succBB/2)(_, dom, bb)

      class PreBasicBlock extends ControlFlowElement {
        PreBasicBlock() { startsBB(this) }

        PreBasicBlock getASuccessor() { result = succ(this.getLastElement(), _) }

        PreBasicBlock getAPredecessor() {
          result.getASuccessor() = this
        }

        ControlFlowElement getElement(int pos) {
          bbIndex(this, result, pos)
        }

        ControlFlowElement getAnElement() {
          result = this.getElement(_)
        }

        ControlFlowElement getFirstElement() {
          result = this
        }

        ControlFlowElement getLastElement() {
          result = this.getElement(length() - 1)
        }

        int length() {
          result = strictcount(getAnElement())
        }

        predicate immediatelyDominates(PreBasicBlock bb) {
          bbIDominates(this, bb)
        }

        predicate strictlyDominates(PreBasicBlock bb) {
          this.immediatelyDominates+(bb)
        }

        predicate dominates(PreBasicBlock bb) {
          bb = this
          or
          this.strictlyDominates(bb)
        }

        predicate inDominanceFrontier(PreBasicBlock df) {
          this.dominatesPredecessor(df) and
          not this.strictlyDominates(df)
        }

        private predicate dominatesPredecessor(PreBasicBlock df) {
          this.dominates(df.getAPredecessor())
        }
      }

      class ConditionBlock extends PreBasicBlock {
        ConditionBlock() {
          strictcount(ConditionalCompletion c |
            exists(succ(this.getLastElement(), c))
            or
            exists(succExit(this.getLastElement(), c))
          ) > 1
        }

        private predicate immediatelyControls(PreBasicBlock succ, ConditionalCompletion c) {
          succ = succ(this.getLastElement(), c) and
          forall(PreBasicBlock pred |
            pred = succ.getAPredecessor() and pred != this |
            succ.dominates(pred)
          )
        }

        predicate controls(PreBasicBlock controlled, ConditionalSuccessor s) {
          exists(PreBasicBlock succ, ConditionalCompletion c |
            immediatelyControls(succ, c) |
            succ.dominates(controlled) and
            s.matchesCompletion(c)
          )
        }
      }
    }

    /**
     * Provides an SSA implementation based on "pre-basic-blocks", restricted
     * to local scope variables and fields/properties that behave like local
     * scope variables.
     *
     * The logic is duplicated from the implementation in `SSA.qll`, and
     * being an internal class, all predicate documentation has been removed.
     */
    module PreSsa {
      private import PreBasicBlocks
      private import AssignableDefinitions

      /**
       * A simple assignable. Either a local scope variable or a field/property
       * that behaves like a local scope variable.
       */
      class SimpleAssignable extends Assignable {
        private Callable c;

        SimpleAssignable() {
          (
            this instanceof LocalScopeVariable
            or
            this instanceof Field
            or
            this = any(TrivialProperty tp | not tp.isOverridableOrImplementable())
          ) and
          forall(AssignableDefinition def |
            def.getTarget() = this |
            c = def.getEnclosingCallable()
            or
            def.getEnclosingCallable() instanceof Constructor
          ) and
          exists(AssignableAccess aa |
            aa.getTarget() = this |
            c = aa.getEnclosingCallable()
          ) and
          forall(QualifiableExpr qe |
            qe.(AssignableAccess).getTarget() = this |
            qe.targetIsThisInstance()
          )
        }

        /** Gets a callable in which this simple assignable can be analyzed. */
        Callable getACallable() { result = c }
      }

      class Definition extends TPreSsaDef {
        string toString() {
          exists(AssignableDefinition def |
            this = TExplicitPreSsaDef(_, _, def, _) |
            result = def.toString()
          )
          or
          exists(SimpleAssignable a |
            this = TImplicitEntryPreSsaDef(_, _, a) |
            result = "implicit(" + a + ")"
          )
          or
          exists(SimpleAssignable a |
            this = TPhiPreSsaDef(_, a) |
            result = "phi(" + a.toString() + ")"
          )
        }

        SimpleAssignable getAssignable() {
          this = TExplicitPreSsaDef(_, _, _, result)
          or
          this = TImplicitEntryPreSsaDef(_, _, result)
          or
          this = TPhiPreSsaDef(_, result)
        }

        AssignableRead getARead() {
          firstReadSameVar(this, result)
          or
          exists(AssignableRead read |
            firstReadSameVar(this, read) |
            adjacentReadPairSameVar+(read, result)
          )
        }

        Location getLocation() {
          exists(AssignableDefinition def |
            this = TExplicitPreSsaDef(_, _, def, _) |
            result = def.getLocation()
          )
          or
          exists(Callable c |
            this = TImplicitEntryPreSsaDef(c, _, _) |
            result = c.getLocation()
          )
          or
          exists(PreBasicBlock bb |
            this = TPhiPreSsaDef(bb, _) |
            result = bb.getLocation()
          )
        }

        PreBasicBlock getBasicBlock() {
          this = TExplicitPreSsaDef(result, _, _, _)
          or
          this = TImplicitEntryPreSsaDef(_, result, _)
          or
          this = TPhiPreSsaDef(result, _)
        }

        Callable getCallable() {
          result = this.getBasicBlock().getEnclosingCallable()
        }

        AssignableDefinition getDefinition() {
          this = TExplicitPreSsaDef(_, _, result, _)
        }

        Definition getAPhiInput() {
          exists(PreBasicBlock bb, PreBasicBlock phiPred, SimpleAssignable a |
            this = TPhiPreSsaDef(bb, a) |
            bb.getAPredecessor() = phiPred and
            ssaDefReachesEndOfBlock(phiPred, result, a)
          )
        }
      }

      predicate implicitEntryDef(Callable c, PreBasicBlock bb, SimpleAssignable a) {
        not a instanceof LocalScopeVariable and
        c = a.getACallable() and
        bb = succEntry(c)
      }

      private predicate assignableDefAt(PreBasicBlocks::PreBasicBlock bb, int i, AssignableDefinition def, SimpleAssignable a) {
        bb.getElement(i) = def.getExpr() and
        a = def.getTarget() and
        // In cases like `(x, x) = (0, 1)`, we discard the first (dead) definition of `x`
        not exists(TupleAssignmentDefinition first, TupleAssignmentDefinition second |
          first = def |
          second.getAssignment() = first.getAssignment() and
          second.getEvaluationOrder() > first.getEvaluationOrder() and
          second.getTarget() = a
        )
        or
        def.(ImplicitParameterDefinition).getParameter() = a and
        exists(Callable c |
          a = c.getAParameter() |
          bb = succEntry(c) and
          i = -1
        )
      }

      private predicate readAt(PreBasicBlock bb, int i, AssignableRead read, SimpleAssignable a) {
        read = bb.getElement(i) and
        read.getTarget() = a
      }

      pragma[noinline]
      private predicate exitBlock(PreBasicBlock bb, Callable c) {
        exists(succExit(bb.getLastElement(), _)) and
        c = bb.getEnclosingCallable()
      }

      private predicate outRefExitRead(PreBasicBlock bb, int i, LocalScopeVariable v) {
        exitBlock(bb, v.getCallable()) and
        i = bb.length() + 1 and
        (v.isRef() or v.(Parameter).isOut())
      }

      private newtype RefKind =
        Read()
        or
        Write(boolean certain) { certain = true or certain = false }

      private predicate ref(PreBasicBlock bb, int i, SimpleAssignable a, RefKind k) {
        (readAt(bb, i, _, a) or outRefExitRead(bb, i, a)) and
        k = Read()
        or
        exists(AssignableDefinition def, boolean certain |
          assignableDefAt(bb, i, def, a) |
          if def.getTargetAccess().isRefArgument() then certain = false else certain = true and
          k = Write(certain)
        )
      }

      private int refRank(PreBasicBlock bb, int i, SimpleAssignable a, RefKind k) {
        i = rank[result](int j | ref(bb, j, a, _)) and
        ref(bb, i, a, k)
      }

      private int maxRefRank(PreBasicBlock bb, SimpleAssignable a) {
        result = refRank(bb, _, a, _) and
        not result + 1 = refRank(bb, _, a, _)
      }

      private int firstReadOrCertainWrite(PreBasicBlock bb, SimpleAssignable a) {
        result = min(int r, RefKind k |
          r = refRank(bb, _, a, k) and
          k != Write(false)
          |
          r
        )
      }

      predicate liveAtEntry(PreBasicBlock bb, SimpleAssignable a) {
        refRank(bb, _, a, Read()) = firstReadOrCertainWrite(bb, a)
        or
        not exists(firstReadOrCertainWrite(bb, a)) and
        liveAtExit(bb, a)
      }

      private predicate liveAtExit(PreBasicBlock bb, SimpleAssignable a) {
        liveAtEntry(bb.getASuccessor(), a)
      }

      predicate assignableDefAtLive(PreBasicBlocks::PreBasicBlock bb, int i, AssignableDefinition def, SimpleAssignable a) {
        assignableDefAt(bb, i, def, a) and
        exists(int rnk |
          rnk = refRank(bb, i, a, Write(_)) |
          rnk + 1 = refRank(bb, _, a, Read())
          or
          rnk = maxRefRank(bb, a) and
          liveAtExit(bb, a)
        )
      }

      predicate defAt(PreBasicBlock bb, int i, Definition def, SimpleAssignable a) {
        def = TExplicitPreSsaDef(bb, i, _, a)
        or
        def = TImplicitEntryPreSsaDef(_, bb, a) and i = -1
        or
        def = TPhiPreSsaDef(bb, a) and i = -1
      }

      private newtype SsaRefKind = SsaRead() or SsaDef()

      private predicate ssaRef(PreBasicBlock bb, int i, SimpleAssignable a, SsaRefKind k) {
        readAt(bb, i, _, a) and
        k = SsaRead()
        or
        defAt(bb, i, _, a) and
        k = SsaDef()
      }

      private int ssaRefRank(PreBasicBlock bb, int i, SimpleAssignable a, SsaRefKind k) {
        i = rank[result](int j | ssaRef(bb, j, a, _)) and
        ssaRef(bb, i, a, k)
      }

      private predicate defReachesRank(PreBasicBlock bb, Definition def, SimpleAssignable a, int rnk) {
        exists(int i |
          rnk = ssaRefRank(bb, i, a, SsaDef()) and
          defAt(bb, i, def, a)
        )
        or
        defReachesRank(bb, def, a, rnk - 1) and
        rnk = ssaRefRank(bb, _, a, SsaRead())
      }

      private int maxSsaRefRank(PreBasicBlock bb, SimpleAssignable a) {
        result = ssaRefRank(bb, _, a, _) and
        not result + 1 = ssaRefRank(bb, _, a, _)
      }

      private predicate reachesEndOf(Definition def, SimpleAssignable a, PreBasicBlock bb) {
        exists(int last |
          last = maxSsaRefRank(bb, a) |
          defReachesRank(bb, def, a, last)
        )
        or
        exists(PreBasicBlock mid |
          reachesEndOf(def, a, mid) and
          not exists(ssaRefRank(mid, _, a, SsaDef())) and
          bb = mid.getASuccessor()
        )
      }

      private predicate varOccursInBlock(SimpleAssignable a, PreBasicBlock bb) {
        exists(ssaRefRank(bb, _, a, _))
      }

      pragma [nomagic]
      private predicate blockPrecedesVar(SimpleAssignable a, PreBasicBlock bb) {
        varOccursInBlock(a, bb.getASuccessor*())
      }

      private predicate varBlockReaches(SimpleAssignable a, PreBasicBlock bb1, PreBasicBlock bb2) {
        varOccursInBlock(a, bb1) and
        bb2 = bb1.getASuccessor() and
        blockPrecedesVar(a, bb2)
        or
        varBlockReachesRec(a, bb1, bb2) and
        blockPrecedesVar(a, bb2)
      }

      pragma [nomagic]
      private predicate varBlockReachesRec(SimpleAssignable a, PreBasicBlock bb1, PreBasicBlock bb2) {
        exists(PreBasicBlock mid |
          varBlockReaches(a, bb1, mid) |
          bb2 = mid.getASuccessor() and
          not varOccursInBlock(a, mid)
        )
      }

      private predicate varBlockStep(SimpleAssignable a, PreBasicBlock bb1, PreBasicBlock bb2) {
        varBlockReaches(a, bb1, bb2) and
        varOccursInBlock(a, bb2)
      }

      private predicate adjacentVarRefs(SimpleAssignable a, PreBasicBlock bb1, int i1, PreBasicBlock bb2, int i2) {
        exists(int rankix |
          bb1 = bb2 and
          rankix = ssaRefRank(bb1, i1, a, _) and
          rankix + 1 = ssaRefRank(bb2, i2, a, _)
        )
        or
        ssaRefRank(bb1, i1, a, _) = maxSsaRefRank(bb1, a) and
        varBlockStep(a, bb1, bb2) and
        ssaRefRank(bb2, i2, a, _) = 1
      }

      predicate firstReadSameVar(Definition def, AssignableRead read) {
        exists(SimpleAssignable a, PreBasicBlock b1, int i1, PreBasicBlock b2, int i2 |
          adjacentVarRefs(a, b1, i1, b2, i2) and
          defAt(b1, i1, def, a) and
          readAt(b2, i2, read, a)
        )
      }

      predicate adjacentReadPairSameVar(AssignableRead read1, AssignableRead read2) {
        exists(SimpleAssignable a, PreBasicBlock bb1, int i1, PreBasicBlock bb2, int i2 |
          adjacentVarRefs(a, bb1, i1, bb2, i2) and
          readAt(bb1, i1, read1, a) and
          readAt(bb2, i2, read2, a)
        )
      }

      pragma[noinline]
      private predicate ssaDefReachesEndOfBlockRec(PreBasicBlock bb, Definition def, SimpleAssignable a) {
        exists(PreBasicBlock idom |
          ssaDefReachesEndOfBlock(idom, def, a) |
          idom.immediatelyDominates(bb)
        )
      }

      predicate ssaDefReachesEndOfBlock(PreBasicBlock bb, Definition def, SimpleAssignable a) {
        exists(int last |
          last = maxSsaRefRank(bb, a) |
          defReachesRank(bb, def, a, last) and
          liveAtExit(bb, a)
        )
        or
        ssaDefReachesEndOfBlockRec(bb, def, a) and
        liveAtExit(bb, a) and
        not ssaRef(bb, _, a, SsaDef())
      }
    }

    /**
     * Provides classes and predicates relevant for splitting the control flow graph.
     */
    private module Splitting {
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
        predicate appliesTo(ControlFlowElement cfe) {
          this.getASplit().appliesTo(cfe)
        }

        private predicate appliesToSucc(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
          succ = succ(pred, c) and
          exists(SplitInternal s |
            s = this.getASplit() |
            s.appliesTo(pred) and
            s.hasSuccessor(pred, succ, c)
            or
            s.hasEntry(pred, succ, c)
          )
        }

        /**
         * Holds if some control flow path (but not all paths) to `cfe` leads to
         * a split of this kind.
         */
        predicate appliesToMaybe(ControlFlowElement cfe) {
          this.appliesTo(cfe) and
          exists(ControlFlowElement pred, Completion c |
            cfe = succ(pred, c) |
            not this.appliesToSucc(pred, cfe, c)
          )
          or
          exists(ControlFlowElement mid |
            this.appliesToMaybe(mid) |
            this.getASplit().hasSuccessor(mid, cfe, _)
          )
        }

        /** Holds if all control flow paths to `cfe` lead to a split of this kind. */
        predicate appliesToAlways(ControlFlowElement cfe) {
          this.appliesTo(cfe) and
          not this.appliesToMaybe(cfe)
        }

        /**
         * Gets a unique integer representing this split kind. The integer is used
         * to represent sets of splits as ordered lists.
         */
        abstract int getListOrder();

        /**
         * Gets the rank of this split kind among all the split kinds that apply to
         * control flow element `cfe`. The rank is based on the order defined by
         * `getListOrder()`.
         */
        int getListRank(ControlFlowElement cfe) {
          this.appliesTo(cfe) and
          this = rank[result](SplitKind sk |
            sk.appliesTo(cfe) |
            sk order by sk.getListOrder()
          )
        }

        /**
         * Holds if a split of this kind can be the last element in a list
         * representation of a set of splits for control flow element `cfe`.
         */
        predicate endsList(ControlFlowElement cfe, int rnk) {
          rnk = this.getListRank(cfe) and
          forall(int rnk0, SplitKind sk |
            rnk0 > rnk and
            rnk0 = sk.getListRank(cfe) |
            sk.appliesToMaybe(cfe)
          )
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
        predicate appliesTo(ControlFlowElement cfe) {
          this.hasEntry(_, cfe, _)
          or
          exists(ControlFlowElement pred |
            this.appliesTo(pred) |
            this.hasSuccessor(pred, cfe, _)
          )
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
          FinallySplitType() {
            not this instanceof ConditionalSuccessor
          }

          /** Holds if this split type matches entry into a `finally` block with completion `c`. */
          predicate isSplitForEntryCompletion(Completion c) {
            if c instanceof NormalCompletion then
              // If the entry into the `finally` block completes with any normal completion,
              // it simply means normal execution after the `finally` block
              this instanceof NormalSuccessor
            else
              this.matchesCompletion(c)
          }
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
            result = mid.getAChild() and
            mid.getEnclosingCallable() = result.getEnclosingCallable() and
            not exists(TryStmt nestedTry |
              result = nestedTry.getFinally() and
              nestedTry != try
            )
          )
        }

        /** A control flow element that belongs to a `finally` block. */
        private class FinallyControlFlowElement extends ControlFlowElement {
          FinallyControlFlowElement() {
            this = getAFinallyDescendant(_)
          }

          /** Holds if this node is the entry node in the `finally` block it belongs to. */
          predicate isEntryNode() {
            exists(TryStmt try |
              this = getAFinallyDescendant(try) |
              this = first(try.getFinally())
            )
          }

          /**
           * Holds if this node is a last element in the `finally` block belonging to
           * `try` statement `try`, with completion `c`.
           */
          predicate isExitNode(TryStmt try, Completion c) {
            this = getAFinallyDescendant(try) and
            this = lastTryStmtFinally(try, c)
          }
        }

        /** A control flow element that does not belong to a `finally` block. */
        private class NonFinallyControlFlowElement extends ControlFlowElement {
          NonFinallyControlFlowElement() {
            not this = getAFinallyDescendant(_)
          }
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
          FinallySplitType getType() {
            result = type
          }

          override string toString() {
            if type instanceof NormalSuccessor then
              result = ""
            else
              result = "finally: " + type.toString()
          }
        }

        private class FinallySplitKind extends SplitKind, TFinallySplitKind {
          override int getListOrder() { result = 0 }
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
              pred = last(try, c) |
              if pred.(FinallyControlFlowElement).isExitNode(try, c) then (
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
              if fcfe.isEntryNode() then
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
        private newtype TMatch = TAlways() or TMaybe() or TNever()

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
          override string toString() { result = "ExceptionHandler" }
        }

        private class ExceptionHandlerSplitInternal extends SplitInternal, ExceptionHandlerSplitImpl {
          override ExceptionHandlerSplitKind getKind() { any() }

          override predicate hasEntry(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
            // Entry into first catch clause
            exists(TryStmt ts |
              this.getExceptionClass() = getAThrownException(ts, pred, c) |
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
              scc = ts.getACatchClause() |
              if scc.getCaughtExceptionType() = ec.getABaseType*() then
                match = TAlways()
              else if scc.getCaughtExceptionType() = ec.getASubType+() then
                match = TMaybe()
              else
                match = TNever()
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
                if c instanceof MatchingCompletion then
                  exists(TMatch match |
                    this.appliesToCatchClause(scc, match) |
                    c = any(MatchingCompletion mc |
                      if mc.isMatch() then
                        match != TNever()
                      else
                        match != TAlways()
                    )
                  )
                else (
                  (scc.isLast() and c instanceof ThrowCompletion)
                  implies
                  exists(TMatch match |
                    this.appliesToCatchClause(scc, match) |
                    match != TAlways()
                  )
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
              pred = lastTryStmtCatchClause(ts, last, c) |
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
              pred = lastTryStmtCatchClause(ts, last, c) |
              ts.getCatchClause(last) = scc and
              scc.isLast()
            )
          }
        }
      }

      module BooleanSplitting {
        private import PreBasicBlocks
        private import PreSsa

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

          SsaBooleanSplitSubKind() {
            this = TSsaBooleanSplitSubKind(def)
          }

          /**
           * Holds if condition `cb` is a read of the SSA variable in this split.
           */
          private predicate defCondition(ConditionBlock cb) {
            cb.getLastElement() = def.getARead()
          }

          /**
           * Holds if condition `cb` is a read of the SSA variable in this split,
           * and `cb` can be reached from `read` without passing through another
           * condition that reads the same SSA variable.
           */
          private predicate defConditionReachableFromRead(ConditionBlock cb, AssignableRead read) {
            this.defCondition(cb) and
            read = cb.getLastElement()
            or
            exists(AssignableRead mid |
              this.defConditionReachableFromRead(cb, mid) |
              adjacentReadPairSameVar(read, mid) and
              not this.defCondition(read)
            )
          }

          /**
           * Holds if condition `cb` is a read of the SSA variable in this split,
           * and `cb` can be reached from the SSA definition without passing through
           * another condition that reads the same SSA variable.
           */
          private predicate firstDefCondition(ConditionBlock cb) {
            exists(AssignableRead read |
              this.defConditionReachableFromRead(cb, read) |
              firstReadSameVar(def, read)
            )
          }

          override predicate correlatesConditions(ConditionBlock cb1, ConditionBlock cb2, boolean inverted) {
            this.firstDefCondition(cb1) and
            exists(AssignableRead read1, AssignableRead read2 |
              read1 = cb1.getLastElement() and
              adjacentReadPairSameVar+(read1, read2) and
              read2 = cb2.getLastElement() and
              inverted = false
            )
          }

          override predicate canReachCorrelatedCondition(PreBasicBlock bb) {
            this.correlatesConditions(_, bb, _) and
            not def.getBasicBlock() = bb
            or
            exists(PreBasicBlock mid |
              this.canReachCorrelatedCondition(mid) |
              bb = mid.getAPredecessor() and
              not def.getBasicBlock() = bb
            )
          }

          override Callable getEnclosingCallable() {
            result = def.getCallable()
          }

          override string toString() {
            result = def.getAssignable().toString()
          }

          override Location getLocation() {
            result = def.getLocation()
          }
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

          BooleanSplitImpl() {
            this = TBooleanSplit(kind, branch)
          }

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

          BooleanSplitKind() {
            this = TBooleanSplitKind(kind)
          }

          /** Gets the sub kind of this Boolean split kind. */
          BooleanSplitSubKind getSubKind() { result = kind }

          override int getListOrder() {
            exists(Callable c, int r |
              c = kind.getEnclosingCallable() |
              result = r + 1 and // start the ordering from 2
              kind = rank[r](BooleanSplitSubKind kind0 |
                kind0.getEnclosingCallable() = c and
                kind0.startsSplit(_) |
                kind0 order by kind0.getLocation().getStartLine(), kind0.getLocation().getStartColumn()
              )
            )
          }

          override string toString() { result = kind.toString() }
        }

        private class BooleanSplitInternal extends SplitInternal, BooleanSplitImpl {
          override BooleanSplitKind getKind() {
            result.getSubKind() = this.getSubKind()
          }

          override predicate hasEntry(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
            succ = succ(pred, c) and
            this.getSubKind().startsSplit(pred) and
            c = any(BooleanCompletion bc | bc.getInnerValue() = this.getBranch())
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
            exists(ControlFlowElement last |
              last = bb.getLastElement() |
              (exists(succ(last, c)) or exists(succExit(last, c))) and
              // Respect the value recorded in this split for all correlated conditions
              forall(boolean inverted |
                bb = this.getACorrelatedCondition(inverted) |
                c instanceof BooleanCompletion
                implies
                c = any(BooleanCompletion bc | bc.getInnerValue() = this.getBranch().booleanXor(inverted))
              )
            )
          }

          override predicate hasExit(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
            exists(PreBasicBlock bb |
              this.appliesToBlock(bb, c) |
              pred = bb.getLastElement() and
              succ = succ(pred, c) and
              // Exit this split if we can no longer reach a correlated condition
              not this.getSubKind().canReachCorrelatedCondition(succ)
            )
          }

          override predicate hasExit(ControlFlowElement pred, Completion c) {
            exists(PreBasicBlock bb |
              this.appliesToBlock(bb, c) |
              pred = bb.getLastElement() and
              exists(succExit(pred, c))
            )
          }

          override predicate hasSuccessor(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
            exists(PreBasicBlock bb, Completion c0 |
              this.appliesToBlock(bb, c0) |
              pred = bb.getAnElement() and
              succ = succ(pred, c) and
              (
                pred = bb.getLastElement()
                implies
                // We must still be able to reach a correlated condition to stay in this split
                this.getSubKind().canReachCorrelatedCondition(succ) and
                c = c0
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
        /**
         * Holds if this non-empty set of splits applies to control flow
         * element `cfe`, starting from rank `rnk`.
         *
         * As a special case, `appliesToFromRank(ControlFlowElement cfe, 1)`
         * means that this non-empty set of splits applies fully to `cfe`.
         */
        predicate appliesToFromRank(ControlFlowElement cfe, int rnk) {
          exists(SplitInternal end |
            this = TSplitsCons(end, TSplitsNil()) |
            end.appliesTo(cfe) and
            end.getKind().endsList(cfe, rnk)
          )
          or
          this.appliesToFromRankCons(cfe, _, _, rnk)
          or
          exists(SplitKind sk |
            this.appliesToFromRank(cfe, rnk + 1) |
            sk.appliesToMaybe(cfe) and
            rnk = sk.getListRank(cfe)
          )
        }

        pragma [noinline]
        predicate appliesToFromRankCons(ControlFlowElement cfe, SplitInternal head, Splits tail, int rnk) {
          tail.appliesToFromRank(cfe, rnk + 1) and
          this = TSplitsCons(head, tail) and
          head.appliesTo(cfe) and
          rnk = head.getKind().getListRank(cfe)
        }

        /** Gets a textual representation of this set of splits. */
        string toString() {
          this = TSplitsNil() and
          result = ""
          or
          exists(SplitInternal head, Splits tail, string headString, string tailString |
            this = TSplitsCons(head, tail) |
            headString = head.toString() and
            tailString = tail.toString() and
            if tailString = "" then
              result = headString
            else if headString = "" then
              result = tailString
            else
              result = headString + ", " + tailString
          )
        }

        /** Gets a split belonging to this set of splits. */
        SplitInternal getASplit() {
          exists(SplitInternal head, Splits tail |
            this = TSplitsCons(head, tail) |
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
      pragma [noinline]
      predicate succEntrySplits(Callable pred, ControlFlowElement succ, Splits succSplits, SuccessorType t) {
        succ = succEntry(pred) and
        t instanceof NormalSuccessor and
        succSplits = TSplitsNil() // initially no splits
      }

      private predicate succSplits0(ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Completion c) {
        // Performance optimization: if we know that `pred` and `succ` must have the
        // same set of splits, there is no need to perform the checks in `succSplits1()`
        // through `succSplits3()` below
        exists(Reachability::SameSplitsBlock b |
          pred = b.getAnElement() and
          b.isReachable(predSplits) and
          succ = succ(pred, c) and
          (succ = b.getAnElement() implies succ = b)
        )
      }

      pragma [inline]
      private predicate entryOrSuccessor(ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, SplitInternal succHead, Completion c) {
        succHead.hasEntry(pred, succ, c)
        or
        succHead = predSplits.getASplit() and
        succHead.hasSuccessor(pred, succ, c)
      }

      pragma [noinline]
      private predicate endSplits(ControlFlowElement cfe, SplitInternal end, Splits splits, int rnk) {
        splits = TSplitsCons(end, TSplitsNil()) and
        end.getKind().endsList(cfe, rnk)
      }

      /**
       * Holds if
       * - the set of splits `predSplits` applies to `pred`;
       * - `succ` is a successor of `pred` with completion `c`;
       * - the non-empty set of splits `succSplits` applies to `succ`, starting
       *   from rank `rnk`; and
       * - each split in `succSplits` is either newly entered into, or passed
       *   over from one of the predecessor splits in `predSplits`.
       */
      private predicate succSplits1(ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits, Completion c, int rnk) {
        succSplits0(pred, predSplits, succ, c) and
        exists(SplitInternal end |
          endSplits(succ, end, succSplits, rnk) |
          entryOrSuccessor(pred, predSplits, succ, end, c)
        )
        or
        exists(SplitInternal succHead, Splits succTail |
          succSplits1(pred, predSplits, succ, succTail, c, rnk + 1) |
          succSplits.appliesToFromRankCons(succ, succHead, succTail, rnk) and
          entryOrSuccessor(pred, predSplits, succ, succHead, c)
        )
        or
        exists(SplitKind sk |
          succSplits1(pred, predSplits, succ, succSplits, c, rnk + 1) |
          sk.appliesToMaybe(succ) and
          rnk = sk.getListRank(succ)
        )
      }

      /**
       * Holds if
       * - the set of splits `predSplits` applies to `pred`;
       * - `succ` is a successor of `pred` with completion `c`;
       * - the set of splits `succSplits` applies to `succ`; and
       * - each split in `succSplits` is either newly entered into, or passed
       *   over from one of the predecessor splits in `predSplits`.
       */
      private predicate succSplits2(ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits, Completion c) {
        succSplits1(pred, predSplits, succ, succSplits, c, 1)
        or
        succSplits0(pred, predSplits, succ, c) and
        succSplits = TSplitsNil() and
        not exists(SplitKind sk | sk.appliesToAlways(succ))
      }

      /**
       * Holds if
       * - the set of splits `predSplits` applies to `pred`;
       * - `succ` is a successor of `pred` with completion `c`;
       * - the set of splits `succSplits` applies to `succ`;
       * - each split in `succSplits` is either newly entered into, or passed
       *   over from one of the predecessor splits in `predSplits`;
       * - each split in `predSplits` (except possibly those in `predSplitsRemaining`)
       *   is passed over to one of the successor splits in `succSplits`, or left; and
       * - `succSplits` contains a split for each newly entered split.
       */
      private predicate succSplits3(ControlFlowElement pred, Splits predSplits, Splits predSplitsRemaining, ControlFlowElement succ, Splits succSplits, Completion c) {
        succSplits2(pred, predSplits, succ, succSplits, c) and
        predSplitsRemaining = predSplits and
        // Enter a new split when required
        forall(SplitInternal split |
          split.hasEntry(pred, succ, c) |
          split = succSplits.getASplit()
        )
        or
        exists(SplitInternal predSplit |
          succSplits3(pred, predSplits, TSplitsCons(predSplit, predSplitsRemaining), succ, succSplits, c) |
          // Each predecessor split must be either passed over as a successor split,
          // or must be left (possibly entering a new split)
          predSplit.hasSuccessor(pred, succ, c) and
          predSplit = succSplits.getASplit()
          or
          predSplit.hasExit(pred, succ, c) and
          forall(SplitInternal succSplit |
            succSplit = succSplits.getASplit() |
            succSplit.getKind() != predSplit.getKind()
            or
            succSplit.hasEntry(pred, succ, c)
          )
        )
      }

      /**
       * Holds if `succ` with splits `succSplits` is a successor of type `t` for `pred`
       * with splits `predSplits`.
       */
      predicate succSplits(ControlFlowElement pred, Splits predSplits, ControlFlowElement succ, Splits succSplits, SuccessorType t) {
        exists(Completion c |
          t.matchesCompletion(c) |
          exists(Reachability::SameSplitsBlock b |
            pred = b.getAnElement() |
            b.isReachable(predSplits) and
            succ = succ(pred, c) and
            succ = b.getAnElement() and
            not succ = b and
            succSplits = predSplits
          )
          or
          succSplits3(pred, predSplits, TSplitsNil(), succ, succSplits, c)
        )
      }

      /**
       * Holds if `pred` with splits `predSplits` can exit the enclosing callable
       * `succ` with type `t`.
       */
      predicate succExitSplits(ControlFlowElement pred, Splits predSplits, Callable succ, SuccessorType t) {
        exists(Reachability::SameSplitsBlock b, Completion c |
          pred = b.getAnElement() |
          b.isReachable(predSplits) and
          t.matchesCompletion(c) and
          succ = succExit(pred, c) and
          forall(SplitInternal predSplit |
            predSplit = predSplits.getASplit() |
            predSplit.hasExit(pred, c)
          )
        )
      }
    }
    import Splitting

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
        exists(ControlFlowElement pred, SplitInternal split, Completion c |
          cfe = succ(pred, c) |
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
        SameSplitsBlock() {
          startsSplits(this)
        }

        /** Gets a control flow element in this block. */
        ControlFlowElement getAnElement() {
          splitsBlockContains(this, result)
          or
          result = this
        }

        private SameSplitsBlock getASuccessor(Splits predSplits, Splits succSplits) {
          exists(ControlFlowElement pred |
            pred = this.getAnElement() |
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
          exists(SameSplitsBlock pred, Splits predSplits |
            pred.isReachable(predSplits) |
            this = pred.getASuccessor(predSplits, splits)
          )
        }
      }
    }

    private cached module Cached {
      private import semmle.code.csharp.controlflow.Guards as Guards

      pragma[noinline]
      private predicate phiNodeMaybeLive(PreBasicBlocks::PreBasicBlock bb, PreSsa::SimpleAssignable a) {
        exists(PreBasicBlocks::PreBasicBlock def |
          PreSsa::defAt(def, _, _, a) |
          def.inDominanceFrontier(bb)
        )
      }

      cached
      newtype TPreSsaDef =
        TExplicitPreSsaDef(PreBasicBlocks::PreBasicBlock bb, int i, AssignableDefinition def, PreSsa::SimpleAssignable a) {
          Guards::Internal::CachedWithCFG::forceCachingInSameStage() and
          PreSsa::assignableDefAtLive(bb, i, def, a)
        }
        or
        TImplicitEntryPreSsaDef(Callable c, PreBasicBlocks::PreBasicBlock bb, Assignable a) {
          PreSsa::implicitEntryDef(c, bb, a) and
          PreSsa::liveAtEntry(bb, a)
        }
        or
        TPhiPreSsaDef(PreBasicBlocks::PreBasicBlock bb, PreSsa::SimpleAssignable a) {
          phiNodeMaybeLive(bb, a) and
          PreSsa::liveAtEntry(bb, a)
        }

      cached
      newtype TBooleanSplitSubKind =
        TSsaBooleanSplitSubKind(PreSsa::Definition def)

      cached
      newtype TSplitKind =
        TFinallySplitKind()
        or
        TExceptionHandlerSplitKind()
        or
        TBooleanSplitKind(BooleanSplitting::BooleanSplitSubKind kind) {
          kind.startsSplit(_)
        }

      cached
      newtype TSplit =
        TFinallySplit(FinallySplitting::FinallySplitType type)
        or
        TExceptionHandlerSplit(ExceptionClass ec)
        or
        TBooleanSplit(BooleanSplitting::BooleanSplitSubKind kind, boolean branch) {
          kind.startsSplit(_) and
          (branch = true or branch = false)
        }

      cached
      newtype TSplits =
        TSplitsNil()
        or
        TSplitsCons(SplitInternal head, Splits tail) {
          exists(ControlFlowElement cfe, SplitKind sk |
            head.appliesTo(cfe) and
            sk = head.getKind() |
            tail = TSplitsNil() and
            sk.endsList(cfe, _)
            or
            tail.appliesToFromRank(cfe, sk.getListRank(cfe) + 1)
          )
        }

      /**
       * Internal representation of control flow nodes in the control flow graph.
       * The control flow graph is pruned for unreachable nodes.
       */
      cached
      newtype TNode =
        TEntryNode(Callable c) {
          succEntrySplits(c, _, _, _)
        }
        or
        TExitNode(Callable c) {
          exists(Reachability::SameSplitsBlock b |
            b.isReachable(_) |
            succExitSplits(b.getAnElement(), _, c, _)
          )
        }
        or
        TElementNode(ControlFlowElement cfe, Splits splits) {
          exists(Reachability::SameSplitsBlock b |
            b.isReachable(splits) |
            cfe = b.getAnElement()
          )
        }

      /** Internal representation of types of control flow. */
      cached
      newtype TSuccessorType =
        TSuccessorSuccessor()
        or
        TBooleanSuccessor(boolean b) {
          b = true or b = false
        }
        or
        TNullnessSuccessor(boolean isNull) {
          isNull = true or isNull = false
        }
        or
        TMatchingSuccessor(boolean isMatch) {
          isMatch = true or isMatch = false
        }
        or
        TEmptinessSuccessor(boolean isEmpty) {
          isEmpty = true or isEmpty = false
        }
        or
        TReturnSuccessor()
        or
        TBreakSuccessor()
        or
        TContinueSuccessor()
        or
        TGotoLabelSuccessor(GotoLabelStmt goto)
        or
        TGotoCaseSuccessor(GotoCaseStmt goto)
        or
        TGotoDefaultSuccessor()
        or
        TExceptionSuccessor(ExceptionClass ec) {
          exists(ThrowCompletion c | c.getExceptionClass() = ec)
        }
        or
        TExitSuccessor()

      /** Gets a successor node of a given flow type, if any. */
      cached
      Node getASuccessorByType(Node pred, SuccessorType t) {
        // Callable entry node -> callable body
        exists(ControlFlowElement succElement, Splits succSplits |
          result = TElementNode(succElement, succSplits) |
          succEntrySplits(pred.(Nodes::EntryNode).getCallable(), succElement, succSplits, t)
        )
        or
        exists(ControlFlowElement predElement, Splits predSplits |
          pred = TElementNode(predElement, predSplits) |
          // Element node -> callable exit
          succExitSplits(predElement, predSplits, result.(Nodes::ExitNode).getCallable(), t)
          or
          // Element node -> element node
          exists(ControlFlowElement succElement, Splits succSplits |
            result = TElementNode(succElement, succSplits) |
            succSplits(predElement, predSplits, succElement, succSplits, t)
          )
        )
      }

      /**
       * Gets a first control flow element executed within `cfe`.
       */
      cached
      ControlFlowElement getAControlFlowEntryNode(ControlFlowElement cfe) {
        result = first(cfe)
      }

      /**
       * Gets a potential last control flow element executed within `cfe`.
       */
      cached
      ControlFlowElement getAControlFlowExitNode(ControlFlowElement cfe) {
        result = last(cfe, _)
      }
    }
    import Cached
  }
  private import Internal
}

// The code below is all for backwards-compatibility; should be deleted eventually

deprecated
class ControlFlowNode = ControlFlow::Node;

deprecated
class CallableEntryNode = ControlFlow::Nodes::EntryNode;

deprecated
class CallableExitNode = ControlFlow::Nodes::ExitNode;

/**
 * DEPRECATED: Use `ElementNode` instead.
 *
 * A node for a control flow element.
 */
deprecated
class NormalControlFlowNode extends ControlFlow::Nodes::ElementNode {
  NormalControlFlowNode() {
    forall(ControlFlow::Nodes::FinallySplit s |
      s = this.getASplit() |
      s.getType() instanceof ControlFlow::SuccessorTypes::NormalSuccessor
    )
  }
}

/**
 * DEPRECATED: Use `ElementNode` instead.
 *
 * A split node for a control flow element that belongs to a `finally` block.
 */
deprecated
class FinallySplitControlFlowNode extends ControlFlow::Nodes::ElementNode {
  FinallySplitControlFlowNode() {
    exists(ControlFlow::Internal::FinallySplitting::FinallySplitType type |
      type = this.getASplit().(ControlFlow::Nodes::FinallySplit).getType() |
      not type instanceof ControlFlow::SuccessorTypes::NormalSuccessor
    )
  }

  /** Gets the try statement that this `finally` node belongs to. */
  TryStmt getTryStmt() {
    this.getElement() = ControlFlow::Internal::FinallySplitting::getAFinallyDescendant(result)
  }
}

/** DEPRECATED: Use `ControlFlow::SuccessorType` instead. */
deprecated
class ControlFlowEdgeType = ControlFlow::SuccessorType;

/** DEPRECATED: Use `ControlFlow::NormalSuccessor` instead. */
deprecated
class ControlFlowEdgeSuccessor = ControlFlow::SuccessorTypes::NormalSuccessor;

/** DEPRECATED: Use `ControlFlow::ConditionalSuccessor` instead. */
deprecated
class ControlFlowEdgeConditional = ControlFlow::SuccessorTypes::ConditionalSuccessor;

/** DEPRECATED: Use `ControlFlow::BooleanSuccessor` instead. */
deprecated
class ControlFlowEdgeBoolean = ControlFlow::SuccessorTypes::BooleanSuccessor;

/** DEPRECATED: Use `ControlFlow::NullnessSuccessor` instead. */
deprecated
class ControlFlowEdgeNullness = ControlFlow::SuccessorTypes::NullnessSuccessor;

/** DEPRECATED: Use `ControlFlow::MatchingSuccessor` instead. */
deprecated
class ControlFlowEdgeMatching = ControlFlow::SuccessorTypes::MatchingSuccessor;

/** DEPRECATED: Use `ControlFlow::EmptinessSuccessor` instead. */
deprecated
class ControlFlowEdgeEmptiness = ControlFlow::SuccessorTypes::EmptinessSuccessor;

/** DEPRECATED: Use `ControlFlow::ReturnSuccessor` instead. */
deprecated
class ControlFlowEdgeReturn = ControlFlow::SuccessorTypes::ReturnSuccessor;

/** DEPRECATED: Use `ControlFlow::BreakSuccessor` instead. */
deprecated
class ControlFlowEdgeBreak = ControlFlow::SuccessorTypes::BreakSuccessor;

/** DEPRECATED: Use `ControlFlow::ContinueSuccessor` instead. */
deprecated
class ControlFlowEdgeContinue = ControlFlow::SuccessorTypes::ContinueSuccessor;

/** DEPRECATED: Use `ControlFlow::GotoLabelSuccessor` instead. */
deprecated
class ControlFlowEdgeGotoLabel = ControlFlow::SuccessorTypes::GotoLabelSuccessor;

/** DEPRECATED: Use `ControlFlow::GotoCaseSuccessor` instead. */
deprecated
class ControlFlowEdgeGotoCase = ControlFlow::SuccessorTypes::GotoCaseSuccessor;

/** DEPRECATED: Use `ControlFlow::GotoDefaultSuccessor` instead. */
deprecated
class ControlFlowEdgeGotoDefault = ControlFlow::SuccessorTypes::GotoDefaultSuccessor;

/** DEPRECATED: Use `ControlFlow::ExceptionSuccessor` instead. */
deprecated
class ControlFlowEdgeException = ControlFlow::SuccessorTypes::ExceptionSuccessor;
