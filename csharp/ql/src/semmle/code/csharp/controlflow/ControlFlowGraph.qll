/**
 * Provides classes representing the control flow graph within callables.
 */

import csharp
import BasicBlocks
private import Completion

/**
 * A control flow node.
 *
 * Either a callable entry node (`CallableEntryNode`), a callable
 * exit node (`CallableExitNode`), a normal control flow node
 * (`NormalControlFlowNode`), or a split node for a control flow
 * element that belongs to a `finally` block (`FinallySplitControlFlowNode`).
 *
 * A control flow node is a node in the control flow graph (CFG).
 * Most control flow nodes can be mapped to a control flow element
 * (`ControlFlowElement`) via `getElement()`, the exception being
 * callable entry nodes (`CallableEntryNode`) and callable exit nodes
 * (`CallableExitNode`). There is a many-to-one relationship between
 * `ControlFlowNode`s and `ControlFlowElement`s. This allows control
 * flow splitting, for example modeling the control flow through
 * `finally` blocks.
 */
class ControlFlowNode extends TControlFlowNode {
  /** Gets a textual representation of this control flow node. */
  string toString() { none() }

  /** Gets the control flow element that this node corresponds to, if any. */
  ControlFlowElement getElement() { none() }

  /** Gets the location of this control flow node. */
  Location getLocation() { result = getElement().getLocation() }

  /** Holds if this control flow node has conditional successors. */
  predicate isCondition() {
    exists(getASuccessorByType(any(ControlFlowEdgeConditional e)))
  }

  /** Gets the basic block that this control flow node belongs to. */
  BasicBlock getBasicBlock() {
    result.getANode() = this
  }

  /**
   * Holds if this node dominates `that` node.
   *
   * That is, all paths reaching `that` node from some callable entry
   * node (`CallableEntryNode`) must go through this node.
   *
   * Example:
   *
   * ```
   * int M(string s) {
   *   if (s == null)
   *     throw new ArgumentNullException(nameof(s));
   *   return s.Length;
   * }
   * ```
   *
   * The node on line 2 dominates the node on line 4 (all paths from the
   * entry point of `M` to `return s.Length;` must go through the null check).
   *
   * This predicate is *reflexive*, so for example `if (s == null)` dominates
   * itself.
   */
  pragma [inline] // potentially very large predicate, so must be inlined
  predicate dominates(ControlFlowNode that) {
    strictlyDominates(that)
    or
    this = that
  }

  /**
   * Holds if this node strictly dominates `that` node.
   *
   * That is, all paths reaching `that` node from some callable entry
   * node (`CallableEntryNode`) must go through this node (which must
   * be different from `that` node).
   *
   * Example:
   *
   * ```
   * int M(string s) {
   *   if (s == null)
   *     throw new ArgumentNullException(nameof(s));
   *   return s.Length;
   * }
   * ```
   *
   * The node on line 2 strictly dominates the node on line 4
   * (all paths from the entry point of `M` to `return s.Length;` must go
   * through the null check).
   */
  pragma [inline] // potentially very large predicate, so must be inlined
  predicate strictlyDominates(ControlFlowNode that) {
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
   * That is, all paths reaching a callable exit node (`CallableExitNode`)
   * from `that` node must go through this node.
   *
   * Example:
   *
   * ```
   * int M(string s) {
   *   try {
   *     return s.Length;
   *   }
   *   finally {
   *     Console.WriteLine("M");
   *   }
   * }
   * ```
   *
   * The node on line 6 post-dominates the node on line 3 (all paths to the
   * exit point of `M` from `return s.Length;` must go through the `WriteLine`
   * call).
   *
   * This predicate is *reflexive*, so for example
   * `Console.WriteLine("M");` post-dominates itself.
   */
  pragma [inline] // potentially very large predicate, so must be inlined
  predicate postDominates(ControlFlowNode that) {
    strictlyPostDominates(that)
    or
    this = that
  }

  /**
   * Holds if this node strictly post-dominates `that` node.
   *
   * That is, all paths reaching a callable exit node (`CallableExitNode`)
   * from `that` node must go through this node (which must be different
   * from `that` node).
   *
   * Example:
   *
   * ```
   * int M(string s) {
   *   try {
   *     return s.Length;
   *   }
   *   finally {
   *     Console.WriteLine("M");
   *   }
   * }
   * ```
   *
   * The node on line 6 strictly post-dominates the node on line 3 (all
   * paths to the exit point of `M` from `return s.Length;` must go through
   * the `WriteLine` call).
   */
  pragma [inline] // potentially very large predicate, so must be inlined
  predicate strictlyPostDominates(ControlFlowNode that) {
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

  /** Gets a successor node of a given flow type, if any. */
  ControlFlowNode getASuccessorByType(ControlFlowEdgeType t) {
    result = getASuccessorByType(this, t)
  }

  /** Gets an immediate successor, if any. */
  ControlFlowNode getASuccessor() { result = getASuccessorByType(_) }

  /** Gets an immediate predecessor node of a given flow type, if any. */
  ControlFlowNode getAPredecessorByType(ControlFlowEdgeType t) {
    result.getASuccessorByType(t) = this
  }

  /** Gets an immediate predecessor, if any. */
  ControlFlowNode getAPredecessor() { result = getAPredecessorByType(_) }

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
   *   x = -x;
   * ```
   *
   * The node on line 2 is an immediate `true` successor of the node
   * on line 1.
   */
  ControlFlowNode getATrueSuccessor() {
    result = getASuccessorByType(any(ControlFlowEdgeBoolean e | e.getValue() = true))
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
   *   x = -x;
   * ```
   *
   * The node on line 2 is an immediate `false` successor of the node
   * on line 1.
   */
  ControlFlowNode getAFalseSuccessor() {
    result = getASuccessorByType(any(ControlFlowEdgeBoolean e | e.getValue() = false))
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
  ControlFlowNode getANullSuccessor() {
    result = getASuccessorByType(any(ControlFlowEdgeNullness e | e.isNull()))
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
  ControlFlowNode getANonNullSuccessor() {
    result = getASuccessorByType(any(ControlFlowEdgeNullness e | not e.isNull()))
  }

  /** Holds if this node has more than one predecessor. */
  predicate isJoin() {
    strictcount(getAPredecessor()) > 1
  }
}

/** A node for a callable entry point. */
class CallableEntryNode extends ControlFlowNode, TCallableEntry {
  /** Gets the callable that this entry applies to. */
  Callable getCallable() { this = TCallableEntry(result) }

  override EntryBasicBlock getBasicBlock() {
    result = ControlFlowNode.super.getBasicBlock()
  }

  override Location getLocation() {
    result = getCallable().getLocation()
  }

  override string toString() {
    result = "enter " + getCallable().toString()
  }
}

/** A node for a callable exit point. */
class CallableExitNode extends ControlFlowNode, TCallableExit {
  /** Gets the callable that this exit applies to. */
  Callable getCallable() { this = TCallableExit(result) }

  override ExitBasicBlock getBasicBlock() {
    result = ControlFlowNode.super.getBasicBlock()
  }

  override Location getLocation() {
    result = getCallable().getLocation()
  }

  override string toString() {
    result = "exit " + getCallable().toString()
  }
}

/** A node for a control flow element. */
class NormalControlFlowNode extends ControlFlowNode, TNode {
  override ControlFlowElement getElement() { this = TNode(result) }

  override string toString() { result = getElement().toString() }
}

/** A split node for a control flow element that belongs to a `finally` block. */
class FinallySplitControlFlowNode extends ControlFlowNode, TFinallySplitNode {
  /** Gets the split type that this `finally` node belongs to. */
  FinallySplitType getSplitType() {
    this = TFinallySplitNode(_, result)
  }

  override ControlFlowElement getElement() {
    this = TFinallySplitNode(result, _)
  }

  /** Gets the try statement that this `finally` node belongs to. */
  TryStmt getTryStmt() {
    getElement() = getAFinallyDescendant(result)
  }

  override string toString() {
    result = "[" + getSplitType().toString() + "] " + getElement().toString()
  }
}

/**
 * Gets a descendant that belongs to the `finally` block of try
 * statement `try`.
 */
private ControlFlowElement getAFinallyDescendant(TryStmt try) {
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

/** The type of an edge in the control flow graph. */
class ControlFlowEdgeType extends TControlFlowEdgeType {
  /** Gets a textual representation of this control flow edge type. */
  string toString() { none() }

  /** Holds if this edge type matches completion `c`. */
  predicate matchesCompletion(Completion c) { none() }
}

/** A normal control flow edge. */
class ControlFlowEdgeSuccessor extends ControlFlowEdgeType, TSuccessorEdge {
  override string toString() { result = "successor" }

  override predicate matchesCompletion(Completion c) {
    c instanceof NormalCompletion and
    not c instanceof ConditionalCompletion and
    not c instanceof BreakNormalCompletion
  }
}

/**
 * A conditional control flow edge. Either a Boolean edge (`ControlFlowEdgeBoolean`),
 * a nullness edge (`ControlFlowEdgeNullness`), a matching edge (`ControlFlowEdgeMatching`),
 * or an emptiness edge (`ControlFlowEdgeEmptiness`).
 */
abstract class ControlFlowEdgeConditional extends ControlFlowEdgeType { }

/**
 * A Boolean control flow edge.
 *
 * For example, this program fragment:
 *
 * ```
 * if (x < 0)
 *   return 0;
 * else
 *   return 1;
 * ```
 *
 * has a control flow graph containing Boolean edges:
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
class ControlFlowEdgeBoolean extends ControlFlowEdgeConditional, TBooleanEdge {
  /** Gets the value of this Boolean edge. */
  boolean getValue() { this = TBooleanEdge(result) }

  override string toString() { result = getValue().toString() }

  override predicate matchesCompletion(Completion c) {
    c.(BooleanCompletion).getInnerValue() = this.getValue()
  }
}

/**
 * A nullness control flow edge.
 *
 * For example, this program fragment:
 *
 * ```
 * int? M(string s) => s?.Length;
 * ```
 *
 * has a control flow graph containing nullness edges:
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
class ControlFlowEdgeNullness extends ControlFlowEdgeConditional, TNullnessEdge {
  /** Holds if this is a `null` edge. */
  predicate isNull() { this = TNullnessEdge(true) }

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
 * A matching control flow edge.
 *
 * For example, this program fragment:
 *
 * ```
 * switch (x) {
 *   case 0 :
 *     return 0;
 *    default :
 *      return 1;
 * }
 * ```
 *
 * has a control flow graph containing macthing edges:
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
class ControlFlowEdgeMatching extends ControlFlowEdgeConditional, TMatchingEdge {
  /** Holds if this is a match edge. */
  predicate isMatch() { this = TMatchingEdge(true) }

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
 * An emptiness control flow edge.
 *
 * For example, this program fragment:
 *
 * ```
 * foreach (var arg in args) {
 *   yield return arg;
 * }
 * yield return "";
 * ```
 *
 * has a control flow graph containing emptiness edges:
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
class ControlFlowEdgeEmptiness extends ControlFlowEdgeConditional, TEmptinessEdge {
  /** Holds if this is an empty edge. */
  predicate isEmpty() { this = TEmptinessEdge(true) }

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
 * A `return` control flow edge.
 *
 * Example:
 *
 * ```
 * void M() {
 *   return;
 * }
 * ```
 *
 * There is a `return` edge from `return;` to the callable exit node
 * of `M`.
 */
class ControlFlowEdgeReturn extends ControlFlowEdgeType, TReturnEdge {
  override string toString() { result = "return" }

  override predicate matchesCompletion(Completion c) {
    c instanceof ReturnCompletion
  }
}

/**
 * A `break` control flow edge.
 *
 * Example:
 *
 * ```
 * int M(int x) {
 *   while (true) {
 *     if (x++ > 10)
 *       break;
 *   }
 *   return x;
 * }
 * ```
 *
 * There is a `break` edge from `break;` to `return x;`.
 */
class ControlFlowEdgeBreak extends ControlFlowEdgeType, TBreakEdge {
  override string toString() { result = "break" }

  override predicate matchesCompletion(Completion c) {
    c instanceof BreakCompletion or
    c instanceof BreakNormalCompletion
  }
}

/**
 * A `continue` control flow edge.
 *
 * Example:
 *
 * ```
 * int M(int x) {
 *   while (true) {
 *     if (x++ < 10)
 *       continue;
 *   }
 *   return x;
 * }
 * ```
 *
 * There is a `continue` edge from `continue;` to `while (true) { ... }`.
 */
class ControlFlowEdgeContinue extends ControlFlowEdgeType, TContinueEdge {
  override string toString() { result = "continue" }

  override predicate matchesCompletion(Completion c) {
    c instanceof ContinueCompletion
  }
}

/**
 * A `goto label` control flow edge.
 *
 * Example:
 *
 * ```
 * int M(int x) {
 *   while (true) {
 *     if (x++ > 10)
 *       goto Return;
 *   }
 *   Return: return x;
 * }
 * ```
 *
 * There is a `goto label` edge from `goto Return;` to
 * `Return: return x`.
 */
class ControlFlowEdgeGotoLabel extends ControlFlowEdgeType, TGotoLabelEdge {
  /** Gets the statement that resulted in this `goto` edge. */
  GotoLabelStmt getGotoStmt() { this = TGotoLabelEdge(result) }

  override string toString() { result = "goto(" + getGotoStmt().getLabel() + ")" }

  override predicate matchesCompletion(Completion c) {
    c.(GotoLabelCompletion).getGotoStmt() = getGotoStmt()
  }
}

/**
 * A `goto case` control flow edge.
 *
 * Example:
 *
 * ```
 * switch (x) {
 *   case 0  : return 1;
 *   case 1  : goto case 0;
 *   default : return -1;
 * }
 * ```
 *
 * There is a `goto case` edge from `goto case 0;` to
 * `case 0  : return 1;`.
 */
class ControlFlowEdgeGotoCase extends ControlFlowEdgeType, TGotoCaseEdge {
  /** Gets the statement that resulted in this `goto case` edge. */
  GotoCaseStmt getGotoStmt() { this = TGotoCaseEdge(result) }

  override string toString() { result = "goto(" + getGotoStmt().getLabel() + ")" }

  override predicate matchesCompletion(Completion c) {
    c.(GotoCaseCompletion).getGotoStmt() = getGotoStmt()
  }
}

/**
 * A `goto default` control flow edge.
 *
 * Example:
 *
 * ```
 * switch (x) {
 *   case 0  : return 1;
 *   case 1  : goto default;
 *   default : return -1;
 * }
 * ```
 *
 * There is a `goto default` edge from `goto default;` to
 * `default : return -1;`.
 */
class ControlFlowEdgeGotoDefault extends ControlFlowEdgeType, TGotoDefaultEdge {
  override string toString() { result = "goto default" }

  override predicate matchesCompletion(Completion c) {
    c instanceof GotoDefaultCompletion
  }
}

/**
 * An exceptional control flow edge.
 *
 * Example:
 *
 * ```
 * int M(string s) {
 *   if (s == null)
 *     throw new ArgumentNullException(nameof(s));
 *   return s.Length;
 * }
 * ```
 *
 * There is an exceptional edge (of type `ArgumentNullException`) from
 * `throw new ArgumentNullException(nameof(s));` to the callable exit node
 * of `M`.
 */
class ControlFlowEdgeException extends ControlFlowEdgeType, TExceptionEdge {
  /** Gets the type of exception. */
  ExceptionClass getExceptionClass() { this = TExceptionEdge(result) }

  override string toString() { result = "exception(" + getExceptionClass().getName() + ")" }

  override predicate matchesCompletion(Completion c) {
    c.(ThrowCompletion).getExceptionClass() = getExceptionClass()
  }
}

/**
 * The type of a split `finally` node.
 *
 * The type represents one of the possible ways of entering a `finally`
 * block. For example, if a `try` statement ends with a `return` statement,
 * then the `finally` block must end with a `return` as well (provided that
 * the `finally` block exits normally).
 */
class FinallySplitType extends ControlFlowEdgeType {
  FinallySplitType() {
    not this instanceof ControlFlowEdgeBoolean
  }
}

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
        not this instanceof JumpStmt
      }

      override ControlFlowElement getChildElement(int i) {
        not this instanceof CatchClause and
        not this instanceof FixedStmt and
        not this instanceof UsingStmt and
        result = this.getChild(i)
        or
        this = any(GeneralCatchClause gcc |
          i = 0 and result = gcc.getBlock()
        )
        or
        this = any(SpecificCatchClause scc |
          exists(int j |
            j = rank[i + 1](int k | exists(getSpecificCatchClauseChild(scc, k)) | k) |
            result = getSpecificCatchClauseChild(scc, j)
          )
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

    private ControlFlowElement getSpecificCatchClauseChild(SpecificCatchClause scc, int i) {
      i = 0 and result = scc.getVariableDeclExpr()
      or
      i = 1 and result = scc.getFilterClause()
      or
      i = 2 and result = scc.getBlock()
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
        or
        // Case statement exits with any completion
        result = lastConstCaseStmt(cc, c)
      )
      or
      cfe = any(TypeCase tc |
        // Type test exits with a non-match
        result = lastTypeCaseNoMatch(tc, c)
        or
        // Condition exists with a `false` completion
        result = lastTypeCaseCondition(tc, c) and
        c instanceof FalseCompletion
        or
        // Condition exists abnormally
        result = lastTypeCaseCondition(tc, c) and
        not c instanceof NormalCompletion
        or
        // Case statement exits with any completion
        result = lastTypeCaseStmt(tc, c)
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
        // If there is no `finally` block, last elements are from the body or
        // any of the `catch` clauses
        not ts.hasFinally() and
        result = getBlockOrCatchFinallyPred(ts, c)
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
        c = nrc.getTarget().(NonReturningCallable).getACallCompletion()
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

    pragma [noinline,nomagic]
    private ControlFlowElement lastStandardElementGetNonLastChildElement(StandardElement se, int i, Completion c) {
      result = last(se.getNonLastChildElement(i), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastThrowExprExpr(ThrowExpr te, Completion c) {
      result = last(te.getExpr(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastLogicalNotExprOperand(LogicalNotExpr lne, Completion c) {
      result = last(lne.getOperand(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastLogicalAndExprLeftOperand(LogicalAndExpr lae, Completion c) {
      result = last(lae.getLeftOperand(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastLogicalAndExprRightOperand(LogicalAndExpr lae, Completion c) {
      result = last(lae.getRightOperand(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastLogicalOrExprLeftOperand(LogicalOrExpr loe, Completion c) {
      result = last(loe.getLeftOperand(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastLogicalOrExprRightOperand(LogicalOrExpr loe, Completion c) {
      result = last(loe.getRightOperand(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastNullCoalescingExprLeftOperand(NullCoalescingExpr nce, Completion c) {
      result = last(nce.getLeftOperand(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastNullCoalescingExprRightOperand(NullCoalescingExpr nce, Completion c) {
      result = last(nce.getRightOperand(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastConditionalExprCondition(ConditionalExpr ce, Completion c) {
      result = last(ce.getCondition(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastConditionalExprThen(ConditionalExpr ce, Completion c) {
      result = last(ce.getThen(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastConditionalExprElse(ConditionalExpr ce, Completion c) {
      result = last(ce.getElse(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastAssignOperationWithExpandedAssignmentExpandedAssignment(AssignOperationWithExpandedAssignment a, Completion c) {
      result = last(a.getExpandedAssignment(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastConditionalQualifiableExprChildExpr(ConditionalQualifiableExpr cqe, int i, Completion c) {
      result = last(cqe.getChildExpr(i), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastObjectCreationArgument(ObjectCreation oc, int i, Completion c) {
      result = last(oc.getArgument(i), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastObjectCreationInitializer(ObjectCreation oc, Completion c) {
      result = last(oc.getInitializer(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastArrayCreationInitializer(ArrayCreation ac, Completion c) {
      result = last(ac.getInitializer(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastArrayCreationLengthArgument(ArrayCreation ac, int i, Completion c) {
      not ac.isImplicitlySized() and
      result = last(ac.getLengthArgument(i), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastIfStmtCondition(IfStmt is, Completion c) {
      result = last(is.getCondition(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastIfStmtThen(IfStmt is, Completion c) {
      result = last(is.getThen(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastIfStmtElse(IfStmt is, Completion c) {
      result = last(is.getElse(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastSwitchStmtCondition(SwitchStmt ss, Completion c) {
      result = last(ss.getCondition(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastSwitchStmtStmt(SwitchStmt ss, int i, Completion c) {
      result = last(ss.getStmt(i), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastSwitchStmtCaseStmt(SwitchStmt ss, int i, Completion c) {
      result = last(ss.getStmt(i).(ConstCase).getStmt(), c) or
      result = last(ss.getStmt(i).(TypeCase).getStmt(), c) or
      result = last(ss.getStmt(i).(DefaultCase), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastConstCaseExpr(ConstCase cc, Completion c) {
      result = last(cc.getExpr(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastConstCaseStmt(ConstCase cc, Completion c) {
      result = last(cc.getStmt(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastTypeCaseCondition(TypeCase tc, Completion c) {
      result = last(tc.getCondition(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastTypeCaseVariableDeclExpr(TypeCase tc, Completion c) {
      result = last(tc.getVariableDeclExpr(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastTypeCaseStmt(TypeCase tc, Completion c) {
      result = last(tc.getStmt(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastLoopStmtCondition(LoopStmt ls, Completion c) {
      result = last(ls.getCondition(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastLoopStmtBody(LoopStmt ls, Completion c) {
      result = last(ls.getBody(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastForeachStmtIterableExpr(ForeachStmt fs, Completion c) {
      result = last(fs.getIterableExpr(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastForeachStmtVariableDeclExpr(ForeachStmt fs, Completion c) {
      result = last(fs.getVariableDeclExpr(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastJumpStmtChild(JumpStmt js, Completion c) {
      result = last(js.getChild(0), c)
    }

    pragma [noinline,nomagic]
    ControlFlowElement lastTryStmtFinally(TryStmt ts, Completion c) {
      result = last(ts.getFinally(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastTryStmtBlock(TryStmt ts, Completion c) {
      result = last(ts.getBlock(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastTryStmtCatchClause(TryStmt ts, Completion c) {
      result = last(ts.getACatchClause(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastStandardExprLastChildElement(StandardExpr se, Completion c) {
      result = last(se.getLastChildElement(), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastForStmtUpdate(ForStmt fs, int i, Completion c) {
      result = last(fs.getUpdate(i), c)
    }

    pragma [noinline,nomagic]
    private ControlFlowElement lastForStmtInitializer(ForStmt fs, int i, Completion c) {
      result = last(fs.getInitializer(i), c)
    }

    /**
     * Gets a last element from the `try` block of this `try` statement that may
     * finish with completion `c`, such that control may be transferred to the
     * `finally` block (if it exists).
     */
    private ControlFlowElement getBlockFinallyPred(TryStmt ts, Completion c) {
      result = lastTryStmtBlock(ts, c)
      and
      (
        // Any non-throw completion will always continue to the `finally` block
        not c instanceof ThrowCompletion
        or
        // A throw completion will only continue to the `finally` block if it is
        // definitely not handled by a `catch` clause
        exists(ExceptionClass ec |
          ec = c.(ThrowCompletion).getExceptionClass() and
          not ts.definitelyHandles(ec, _)
        )
      )
    }

    /**
     * Gets a last element from a `try` or `catch` block of this `try` statement
     * that may finish with completion `c`, such that control may be transferred
     * to the `finally` block (if it exists).
     */
    pragma [noinline]
    private ControlFlowElement getBlockOrCatchFinallyPred(TryStmt ts, Completion c) {
      result = getBlockFinallyPred(ts, c) or
      result = lastTryStmtCatchClause(ts, c)
    }

    /**
     * Provides a simple analysis for identifying calls to callables that will
     * not return.
     */
    private module NonReturning {
      private import semmle.code.csharp.ExprOrStmtParent
      private import semmle.code.csharp.frameworks.System

      /**
       * A call that definitely does not return (conservative analysis).
       */
      class NonReturningCall extends Call {
        NonReturningCall() {
          this.getTarget() instanceof NonReturningCallable
        }
      }

      /** A callable that does not return. */
      abstract class NonReturningCallable extends Callable {
        NonReturningCallable() {
          not exists(ReturnStmt ret | ret.getEnclosingCallable() = this) and
          not hasAccessorAutoImplementation(this, _) and
          not exists(Virtualizable v |
            v.isOverridableOrImplementable() |
            v = this or
            v = this.(Accessor).getDeclaration()
          )
        }

        /** Gets a valid completion for a call to this non-returning callable. */
        abstract Completion getACallCompletion();
      }

      /**
       * A callable that exits when called.
       */
      private abstract class ExitingCallable extends NonReturningCallable {
        override Completion getACallCompletion() {
          result instanceof ReturnCompletion
        }
      }

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
        result.(Call).getTarget() instanceof ExitingCallable or
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

      /**
       * A callable that throws an exception when called.
       */
      private class ThrowingCallable extends NonReturningCallable {
        ThrowingCallable() {
          forex(ControlFlowElement body |
            body = this.getABody() |
            body = getAThrowingElement(_)
          )
        }

        override ThrowCompletion getACallCompletion() {
          this.getABody() = getAThrowingElement(result)
        }
      }

      private ControlFlowElement getAThrowingElement(ThrowCompletion c) {
        c = result.(Call).getTarget().(ThrowingCallable).getACallCompletion()
        or
        result = any(ThrowElement te |
          c.(ThrowCompletion).getExceptionClass() = te.getThrownExceptionType() and
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
        exists(IfStmt ifStmt |
          result = ifStmt and
          ifStmt.getThen() = getAThrowingElement(_) and
          ifStmt.getElse() = getAThrowingElement(_) |
          ifStmt.getThen() = getAThrowingElement(c) or
          ifStmt.getElse() = getAThrowingElement(c)
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
        exists(TypeCase tc, int i |
          tc = ss.getCase(i) |
          cfe = lastTypeCaseCondition(tc, c) and
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
        // Flow from last element of case expression to first element of statement
        cfe = lastConstCaseExpr(cc, c) and
        c.(MatchingCompletion).isMatch() and
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
        cfe = lastTypeCaseCondition(tc, c) and
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
        // Flow from last element of body to first element of a relevant `catch` clause
        exists(ExceptionClass ec |
          cfe = lastTryStmtBlock(ts, c) and
          ec = c.(ThrowCompletion).getExceptionClass() and
          result = first(ts.getAnExceptionHandler(ec))
        )
        or
        // Flow into the `finally` block
        cfe = getBlockOrCatchFinallyPred(ts, c) and
        result = first(ts.getFinally())
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
     * Gets the condition of `for` loop `fs` if it exists, otherwise the body.
     */
    private ControlFlowElement getForStmtConditionOrBody(ForStmt fs) {
      result = fs.getCondition()
      or
      not exists(fs.getCondition()) and
      result = fs.getBody()
    }
  }
  import Successor

  /**
   * Provides classes and predicates relevant for splitting the control flow graph.
   * Currently, only `finally` nodes are split.
   */
  private module Splitting {
    /**
     * Gets a split type used to represent normal splitting for `finally`
     * nodes, and no splitting for non`-finally` nodes.
     */
    FinallySplitType getNormalSplit() {
      result instanceof ControlFlowEdgeSuccessor
    }

    /**
     * A block of control flow elements where the spliting is guaranteed
     * to remain unchanged.
     */
    class SameSplitBlock extends ControlFlowElement {
      SameSplitBlock() {
        startsSplit(TControlFlowElementWrapper(this))
      }

      /** Gets a control flow element in this block. */
      ControlFlowElement getAnElement() {
        splitBlockContains(TControlFlowElementWrapper(this), TControlFlowElementWrapper(result)) or
        result = this
      }

      /** Gets a successor block, where the splitting may be different. */
      SameSplitBlock getASuccessor(FinallySplitType predSplitType, FinallySplitType succSplitType) {
        exists(ControlFlowElement pred |
          pred = getAnElement() |
          predSplitType = getNormalSplit() and
          (
            succByTypeNonFinallyNonFinally(pred, _, result) and
            succSplitType = getNormalSplit()
            or
            succByTypeNonFinallyFinally(pred, _, result, succSplitType)
          )
          or
          succByTypeFinallyNonFinally(pred, predSplitType, _, result) and
          succSplitType = getNormalSplit()
          or
          succByTypeFinallyFinally(pred, predSplitType, _, result, succSplitType)
        )
      }

      /**
       * Holds if this block with the given splitting `splitType` is reachable
       * from a callable entry point.
       */
      predicate isReachable(FinallySplitType splitType) {
        // Base case
        succCallableEntry(_, this) and
        splitType = getNormalSplit()
        or
        // Recursive case
        exists(SameSplitBlock pred, FinallySplitType predSplitType |
          pred.isReachable(predSplitType) |
          this = pred.getASuccessor(predSplitType, splitType)
        )
      }
    }

    // A temporary fix to get the right join-order in `SameSplitBlock::getAnElement()`
    private newtype ControlFlowElementWrapper =
      TControlFlowElementWrapper(ControlFlowElement cfe)

    private ControlFlowElement unwrap(ControlFlowElementWrapper cfew) {
      cfew = TControlFlowElementWrapper(result)
    }

    private predicate startsSplit(ControlFlowElementWrapper node) {
      unwrap(node) = any(ControlFlowElement cfe |
        succCallableEntry(_, cfe)
        or
        cfe.(FinallyControlFlowElement).isEntryNode()
        or
        exists(ControlFlowElement pred |
          pred = getAFinallyDescendant(_) |
          cfe = succ(pred, _) and
          not cfe = getAFinallyDescendant(_)
        )
      )
    }

    private predicate intraSplitSucc(ControlFlowElementWrapper pred, ControlFlowElementWrapper succ) {
      succ = TControlFlowElementWrapper(succ(unwrap(pred), _)) and
      not startsSplit(succ)
    }

    private predicate splitBlockContains(ControlFlowElementWrapper bbStart, ControlFlowElementWrapper cfn) =
      boundedFastTC(intraSplitSucc/2, startsSplit/1)(bbStart, cfn)

    private class NonFinallyControlFlowElement extends ControlFlowElement {
      NonFinallyControlFlowElement() {
        not this = getAFinallyDescendant(_)
      }
    }

    /** Holds if split type `splitType` matches entry into a `finally` block with completion `c`. */
    private predicate isSplitForEntryCompletion(FinallySplitType splitType, Completion c) {
      if c instanceof ConditionalCompletion then
        // If the entry into the `finally` block completes with a conditional completion,
        // it simply means normal execution after the `finally` block
        splitType instanceof ControlFlowEdgeSuccessor
      else if c instanceof BreakNormalCompletion then
        // If the entry into the `finally` block completes with a normal completion,
        // as a result of a loop inside the `try` block being terminated with a
        // `break`, it simply means normal execution after the `finally` block
        splitType instanceof ControlFlowEdgeSuccessor
      else
        splitType.matchesCompletion(c)
    }

    /**
     * Holds if `cfe` is a `finally` node belonging to try statement `try`,
     * where we need to split `cfe` on split type `splitType`.
     */
    private predicate isSplitForFinallyNode(FinallySplitType splitType, TryStmt try, ControlFlowElement cfe) {
      // Base case: entry node in a `finally` block
      isFinallyEntryType(splitType, try, cfe)
      or
      /* Recursive case: successor of another `finally` node that is
       * still in the `finally` block.
       *
       * Example:
       *
       * ```
       * try {
       *   ...
       * }
       * finally {
       *   Console.WriteLine("Finally");
       * }
       * Console.WriteLine("After finally");
       * ```
       *
       * - `pred = { ... }` is a finally node because of the base case,
       *   therefore so is `cfe = "Finally"`.
       * - `pred = "Finally"` is a finally node because of the recursive case,
       *   therefore so is `cfe = Console.WriteLine("Finally")`.
       * - `pred = Console.WriteLine("Finally")` is a finally node because of the
       *   recursive case, however, `cfe = "After finally"` is not, because it is
       *   not in the `finally` block.
       */
      exists(ControlFlowElement pred |
        isSplitForFinallyNode(splitType, try, pred) and
        ControlFlowGraph::Internal::succ(pred, _) = cfe and
        cfe = getAFinallyDescendant(try)
      )
    }

    /**
     * Holds if `cfe` is an entry node in the `finally` block of try statement
     * `try`, where we can enter `cfe` with split type `splitType`.
     */
    private predicate isFinallyEntryType(FinallySplitType splitType, TryStmt try, ControlFlowElement cfe) {
      cfe = ControlFlowGraph::Internal::first(try.getFinally())
      and
      exists(ControlFlowElement pred, Completion c |
        ControlFlowGraph::Internal::succ(pred, c) = cfe |
        /* A predecessor can enter the `finally` block with a completion that matches
         * this type
         */
        isSplitForEntryCompletion(splitType, c)
        or
        /* In case of a nested `finally` block, the nodes must inherit the splitting
         * from the parent `finally` block. Example:
         *
         * ```
         * try {
         *   if (...) return;
         *   if (...) throw new Exception();
         * }
         * finally {
         *   try {
         *     ...
         *   }
         *   finally {
         *     ...
         *   }
         * }
         * ```
         *
         * The outer finally block (lines 5--12) is split on types `ControlFlowEdgeSuccessor`,
         * `ControlFlowEdgeReturn`, and `ControlFlowEdgeException`. The inner block
         * (lines 9--11) needs to inherit these splittings in order to be able to recover the
         * completion of the outer `try` statement, in case the inner `try` does not
         * exit abnormally.
         */
        isSplitForFinallyNode(splitType, _, pred)
      )
    }

    private class FinallyControlFlowElement extends ControlFlowElement {
      FinallyControlFlowElement() {
        this = getAFinallyDescendant(_)
      }

      /**
       * Holds if `splitType` is a relevant split type for this `finally` node.
       *
       * This predicate is used to make the `succByTypeFinally*` predicates smaller
       * (pure optimization: irrelevant splittings would have been removed in the
       * pruned control flow graph via `isReachable` had this predicate not been
       * used).
       */
      predicate isRelevantSplitType(FinallySplitType splitType) {
        isSplitForFinallyNode(splitType, _, this)
      }

      /** Holds if this node is the entry node in the `finally` block it belongs to. */
      predicate isEntryNode() {
        exists(TryStmt try |
          this = getAFinallyDescendant(try) and
          this = first(try.getFinally())
        )
      }
    }

    // Successor relation for callable entry points
    predicate succCallableEntry(Callable pred, NonFinallyControlFlowElement succ) {
      if exists(pred.(Constructor).getInitializer()) then
        succ = first(pred.(Constructor).getInitializer())
      else
        succ = first(pred.getBody())
    }

    // Successor relation for non-`finally` to callable exit nodes
    predicate succByTypeNonFinallyCallableExit(NonFinallyControlFlowElement pred, ControlFlowEdgeType t, Callable succ) {
      exists(Completion c |
        pred = last(succ.getBody(), c) |
        c.isValidCallableExitCompletion() and
        t.matchesCompletion(c)
      )
    }

    // Successor relation for non-`finally` to non-`finally` nodes
    predicate succByTypeNonFinallyNonFinally(NonFinallyControlFlowElement pred, ControlFlowEdgeType t, NonFinallyControlFlowElement succ) {
      exists(Completion c |
        succ = succ(pred, c) |
        t.matchesCompletion(c)
      )
    }

    // Successor relation for non-`finally` to `finally` nodes
    predicate succByTypeNonFinallyFinally(NonFinallyControlFlowElement pred, ControlFlowEdgeType t, FinallyControlFlowElement succ, FinallySplitType succSplitType) {
      exists(Completion c |
        succ = succ(pred, c) |
        // Entering a `finally` node must respect the split type
        isSplitForEntryCompletion(succSplitType, c) and
        t.matchesCompletion(c)
      )
    }

    /**
     * Holds if `cfe` is a last element in the `finally` block belonging to
     * `try` statement `try`, with completion `c`
     */
    private predicate isLastInFinally(TryStmt try, ControlFlowElement cfe, Completion c) {
      cfe = getAFinallyDescendant(try) and
      cfe = lastTryStmtFinally(try, c)
    }

    // Successor relation for `finally` to callable exit nodes
    predicate succByTypeFinallyCallableExit(FinallyControlFlowElement pred, FinallySplitType predSplitType, ControlFlowEdgeType t, Callable succ) {
      exists(Completion c |
        t.matchesCompletion(c) and
        pred.isRelevantSplitType(predSplitType) and
        pred = last(succ.getBody(), c) and
        c.isValidCallableExitCompletion()
        |
        // No splitting: any completion inside the `finally` block is valid
        isLastInFinally(_, pred, c) and
        predSplitType instanceof ControlFlowEdgeSuccessor
        or
        // Splitting: completion must respect the split type
        predSplitType.matchesCompletion(c)
        or
        // Ignore splitting: The `finally` block can itself complete abnormally
        isLastInFinally(_, pred, c) and
        not c instanceof NormalCompletion
      )
    }

    // Successor relation for `finally` to non-`finally` nodes
    predicate succByTypeFinallyNonFinally(FinallyControlFlowElement pred, FinallySplitType predSplitType, ControlFlowEdgeType t, NonFinallyControlFlowElement succ) {
      exists(Completion c |
        t.matchesCompletion(c) and
        pred.isRelevantSplitType(predSplitType) and
        succ = succ(pred, c)
        |
        // No splitting: any completion inside the `finally` block is valid
        isLastInFinally(_, pred, c) and
        predSplitType instanceof ControlFlowEdgeSuccessor
        or
        // Splitting: completion must respect the split type
        predSplitType.matchesCompletion(c)
        or
        // Ignore splitting: The `finally` block can itself complete abnormally
        isLastInFinally(_, pred, c) and
        not c instanceof NormalCompletion
      )
    }

    // Successor relation for `finally` to `finally` nodes
    predicate succByTypeFinallyFinally(FinallyControlFlowElement pred, FinallySplitType predSplitType, ControlFlowEdgeType t, FinallyControlFlowElement succ, FinallySplitType succSplitType) {
      exists(Completion c |
        t.matchesCompletion(c) |
        succByTypeFinallyFinally0(pred, predSplitType, c, succ, succSplitType)
      )
    }

    pragma [noinline]
    predicate succByTypeFinallyFinally0(FinallyControlFlowElement pred, FinallySplitType predSplitType, Completion c, FinallyControlFlowElement succ, FinallySplitType succSplitType) {
      pred.isRelevantSplitType(predSplitType) and
      succ = succ(pred, c) and
      if succ.isEntryNode() then
        if c instanceof NormalCompletion then
          // Entering a nested `finally` block normally must remember the outer splitting
          succSplitType = predSplitType
        else
          // Entering a nested `finally` abnormally must enter the correct splitting
          isSplitForEntryCompletion(succSplitType, c)
      else
        // Staying in the same `finally` block must stay in the same splitting
        succSplitType = predSplitType
    }
  }
  private import Splitting

  private cached module Cached {
    /**
     * Internal representation of control flow nodes in the control flow graph.
     * The control flow graph is pruned for unreachable nodes and `finally` nodes
     * are split where relevant.
     */
    cached
    newtype TControlFlowNode =
      TCallableEntry(Callable c) {
        succCallableEntry(c, _)
      }
      or
      TCallableExit(Callable c) {
        exists(SameSplitBlock b |
          b.isReachable(_) |
          b.getAnElement() = last(c.getBody(), _)
        )
      }
      or
      TNode(ControlFlowElement cfe) {
        exists(SameSplitBlock b |
          b.isReachable(getNormalSplit()) |
          cfe = b.getAnElement()
        )
      }
      or
      TFinallySplitNode(ControlFlowElement cfe, FinallySplitType splitType) {
        exists(SameSplitBlock b |
          b.isReachable(splitType) |
          cfe = b.getAnElement() and
          not splitType = getNormalSplit()
        )
      }

    /** Internal representation of types of control flow. */
    cached
    newtype TControlFlowEdgeType =
      TSuccessorEdge()
      or
      TBooleanEdge(boolean b) {
        b = true or b = false
      }
      or
      TNullnessEdge(boolean isNull) {
        isNull = true or isNull = false
      }
      or
      TMatchingEdge(boolean isMatch) {
        isMatch = true or isMatch = false
      }
      or
      TEmptinessEdge(boolean isEmpty) {
        isEmpty = true or isEmpty = false
      }
      or
      TReturnEdge()
      or
      TBreakEdge()
      or
      TContinueEdge()
      or
      TGotoLabelEdge(GotoLabelStmt goto)
      or
      TGotoCaseEdge(GotoCaseStmt goto)
      or
      TGotoDefaultEdge()
      or
      TExceptionEdge(ExceptionClass ec) {
        exists(ThrowCompletion c | c.getExceptionClass() = ec)
      }

    /** Gets a successor node of a given flow type, if any. */
    cached
    ControlFlowNode getASuccessorByType(ControlFlowNode pred, ControlFlowEdgeType t) {
      exists(CallableEntryNode predNode, NormalControlFlowNode succNode |
        predNode = pred |
        succNode = result and
        succCallableEntry(predNode.getCallable(), succNode.getElement()) and
        t instanceof ControlFlowEdgeSuccessor
      )
      or
      exists(NormalControlFlowNode predNode |
        predNode = pred |
        exists(CallableExitNode succNode |
          succNode = result |
          succByTypeNonFinallyCallableExit(predNode.getElement(), t, succNode.getCallable()) or
          succByTypeFinallyCallableExit(predNode.getElement(), getNormalSplit(), t, succNode.getCallable())
        )
        or
        exists(NormalControlFlowNode succNode |
          succNode = result |
          succByTypeNonFinallyNonFinally(predNode.getElement(), t, succNode.getElement()) or
          succByTypeNonFinallyFinally(predNode.getElement(), t, succNode.getElement(), getNormalSplit()) or
          succByTypeFinallyNonFinally(predNode.getElement(), getNormalSplit(), t, succNode.getElement()) or
          succByTypeFinallyFinally(predNode.getElement(), getNormalSplit(), t, succNode.getElement(), getNormalSplit())
        )
        or
        exists(FinallySplitControlFlowNode succNode |
          succNode = result |
          succByTypeNonFinallyFinally(predNode.getElement(), t, succNode.getElement(), succNode.getSplitType()) or
          succByTypeFinallyFinally(predNode.getElement(), getNormalSplit(), t, succNode.getElement(), succNode.getSplitType())
        )
      )
      or
      exists(FinallySplitControlFlowNode predNode |
        predNode = pred |
        exists(CallableExitNode succNode |
          succNode = result |
          succByTypeFinallyCallableExit(predNode.getElement(), predNode.getSplitType(), t, succNode.getCallable())
        )
        or
        exists(NormalControlFlowNode succNode |
          succNode = result |
          succByTypeFinallyNonFinally(predNode.getElement(), predNode.getSplitType(), t, succNode.getElement()) or
          succByTypeFinallyFinally(predNode.getElement(), predNode.getSplitType(), t, succNode.getElement(), getNormalSplit())
        )
        or
        exists(FinallySplitControlFlowNode succNode |
          succNode = result |
          succByTypeFinallyFinally(predNode.getElement(), predNode.getSplitType(), t, succNode.getElement(), succNode.getSplitType())
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
