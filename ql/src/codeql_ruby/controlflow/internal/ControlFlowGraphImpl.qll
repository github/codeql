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
 * caught up by its surrounding loop and turned into a `NormalCompletion`.
 */

private import codeql_ruby.ast.internal.TreeSitter::Generated
private import AstNodes
private import codeql_ruby.controlflow.ControlFlowGraph
private import Completion
private import SuccessorTypes
private import Splitting

abstract private class ControlFlowTree extends AstNode {
  /**
   * Holds if `first` is the first element executed within this AST node.
   */
  pragma[nomagic]
  abstract predicate first(AstNode first);

  /**
   * Holds if `last` with completion `c` is a potential last element executed
   * within this AST node.
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

  /**
   * Holds if this node should be hidden in the CFG. That is, edges
   * `pred -> this -> succ` are converted to a single edge `pred -> succ`.
   */
  predicate isHidden() { none() }
}

/** Holds if `first` is the first element executed within AST node `n`. */
predicate first(ControlFlowTree n, AstNode first) { n.first(first) }

/**
 * Holds if `last` with completion `c` is a potential last element executed
 * within AST node `n`.
 */
predicate last(ControlFlowTree n, AstNode last, Completion c) {
  n.last(last, c)
  or
  exists(AstNode child |
    n.propagatesAbnormal(child) and
    last(child, last, c) and
    not c instanceof NormalCompletion
  )
}

private predicate succImpl(AstNode pred, AstNode succ, Completion c) {
  any(ControlFlowTree cft).succ(pred, succ, c)
}

private predicate isHidden(ControlFlowTree t) { t.isHidden() }

private predicate succImplIfHidden(AstNode pred, AstNode succ) {
  isHidden(pred) and
  succImpl(pred, succ, any(SimpleCompletion c))
}

/**
 * Holds if `succ` is a control flow successor for `pred`, given that `pred`
 * finishes with completion `c`.
 */
pragma[nomagic]
predicate succ(AstNode pred, AstNode succ, Completion c) {
  exists(AstNode n |
    succImpl(pred, n, c) and
    succImplIfHidden*(n, succ) and
    not isHidden(pred) and
    not isHidden(succ)
  )
}

/** Holds if `first` is first executed when entering `scope`. */
pragma[nomagic]
predicate succEntry(CfgScope scope, AstNode first) {
  exists(AstNode n |
    first(scope, n) and
    succImplIfHidden*(n, first) and
    not isHidden(first)
  )
}

/** Holds if `last` with completion `c` can exit `scope`. */
pragma[nomagic]
predicate succExit(AstNode last, CfgScope scope, Completion c) {
  exists(AstNode n |
    last(scope, n, c) and
    succImplIfHidden*(last, n) and
    not isHidden(last)
  )
}

/**
 * An AST node where the children are evaluated following a standard left-to-right
 * evaluation. The actual evaluation order is determined by the predicate
 * `getChildNode()`.
 */
abstract private class StandardNode extends ControlFlowTree {
  /** Gets the `i`th child node, in order of evaluation. */
  abstract AstNode getChildNode(int i);

  private AstNode getChildNodeRanked(int i) {
    result =
      rank[i + 1](AstNode child, int j |
        child = this.getChildNode(j) and
        // Never descend into children with a separate scope
        not child instanceof CfgScope
      |
        child order by j
      )
  }

  /** Gets the first child node of this element. */
  final AstNode getFirstChildNode() { result = this.getChildNodeRanked(0) }

  /** Gets the last child node of this node. */
  final AstNode getLastChildNode() {
    exists(int last |
      result = this.getChildNodeRanked(last) and
      not exists(this.getChildNodeRanked(last + 1))
    )
  }

  final override predicate propagatesAbnormal(AstNode child) { child = this.getChildNodeRanked(_) }

  pragma[nomagic]
  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    exists(int i |
      last(this.getChildNodeRanked(i), pred, c) and
      c instanceof NormalCompletion and
      first(this.getChildNodeRanked(i + 1), succ)
    )
  }
}

abstract private class PreOrderTree extends ControlFlowTree {
  final override predicate first(AstNode first) { first = this }
}

abstract private class StandardPreOrderTree extends StandardNode, PreOrderTree {
  final override predicate last(AstNode last, Completion c) {
    last(this.getLastChildNode(), last, c)
    or
    not exists(this.getLastChildNode()) and
    c.isValidFor(this) and
    last = this
  }

  final override predicate succ(AstNode pred, AstNode succ, Completion c) {
    StandardNode.super.succ(pred, succ, c)
    or
    pred = this and
    first(this.getFirstChildNode(), succ) and
    c instanceof SimpleCompletion
  }
}

abstract private class PostOrderTree extends ControlFlowTree {
  override predicate last(AstNode last, Completion c) {
    last = this and
    c.isValidFor(last)
  }
}

abstract private class StandardPostOrderTree extends StandardNode, PostOrderTree {
  final override predicate first(AstNode first) {
    first(this.getFirstChildNode(), first)
    or
    not exists(this.getFirstChildNode()) and
    first = this
  }

  final override predicate succ(AstNode pred, AstNode succ, Completion c) {
    StandardNode.super.succ(pred, succ, c)
    or
    last(this.getLastChildNode(), pred, c) and
    succ = this and
    c instanceof NormalCompletion
  }
}

abstract private class LeafTree extends PreOrderTree, PostOrderTree {
  final override predicate propagatesAbnormal(AstNode child) { none() }

  final override predicate succ(AstNode pred, AstNode succ, Completion c) { none() }
}

/** Defines the CFG by dispatch on the various AST types. */
private module Trees {
  private class ArgumentListTree extends StandardPostOrderTree, ArgumentList {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class ArrayTree extends StandardPostOrderTree, Array {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class AssignmentTree extends StandardPostOrderTree, Assignment {
    final override AstNode getChildNode(int i) {
      result = this.getRight() and i = 0
      or
      result = this.getLeft() and i = 1
    }
  }

  private class BeginBlockTree extends StandardPreOrderTree, BeginBlock {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class BinaryTree extends StandardPostOrderTree, Binary {
    BinaryTree() { not this instanceof LogicalAndAstNode and not this instanceof LogicalOrAstNode }

    final override AstNode getChildNode(int i) {
      result = this.getLeft() and i = 0
      or
      result = this.getRight() and i = 1
    }
  }

  private class BlockParametersTree extends LeafTree, BlockParameters {
    override predicate isHidden() { any() }
  }

  private class BreakTree extends StandardPostOrderTree, Break {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class CallTree extends StandardPostOrderTree, Call {
    final override AstNode getChildNode(int i) {
      result = this.getReceiver() and i = 0
      or
      result = this.getMethod() and i = 1
    }
  }

  private class CaseTree extends PreOrderTree, Case {
    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getValue() or child = this.getChild(_).(When).getPattern(_)
    }

    final override predicate last(AstNode last, Completion c) {
      last(this.getValue(), last, c) and not exists(this.getChild(_))
      or
      last(this.getChild(_), last, c) and c instanceof SimpleCompletion
      or
      exists(int i, ControlFlowTree lastBranch |
        lastBranch = this.getChild(i) and not exists(this.getChild(i + 1))
      |
        last(lastBranch, last, c) and
        c instanceof FalseCompletion
      )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(this.getValue(), succ) and
      c instanceof SimpleCompletion
      or
      pred = this and
      first(this.getChild(0), succ) and
      not exists(this.getValue()) and
      c instanceof SimpleCompletion
      or
      last(this.getValue(), pred, c) and
      first(this.getChild(0), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i, ControlFlowTree branch | branch = this.getChild(i) |
        last(branch, pred, c) and first(this.getChild(i + 1), succ) and c instanceof FalseCompletion
      )
    }
  }

  private class ClassTree extends StandardPreOrderTree, Class {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class DoTree extends StandardPreOrderTree, Do {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class DoBlockTree extends StandardPreOrderTree, DoBlock {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class ElseTree extends StandardPreOrderTree, Else {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class EndBlockTree extends StandardPreOrderTree, EndBlock {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  /**
   * Control flow of a for-in loop
   *
   * For example, this program fragment:
   *
   * ```rb
   * for arg in args do
   *  puts arg
   * end
   * puts "done";
   * ```
   *
   * has the following control flow graph:
   *
   * ```
   *           args
   *            |
   *          for------<-----
   *           / \           \
   *          /   \          |
   *         /     \         |
   *        /       \        |
   *     empty    non-empty  |
   *       |          \      |
   *  puts "done"      \     |
   *                  arg    |
   *                    |    |
   *                puts arg |
   *                     \___/
   * ```
   */
  private class ForTree extends ControlFlowTree, For {
    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getPattern(_) or child = this.getValue()
    }

    final override predicate first(AstNode node) { node = this.getValue() }

    final override predicate last(AstNode last, Completion c) {
      last = this and
      c.(EmptinessCompletion).isEmpty()
      or
      last(this.getBody(), last, c) and
      not c.continuesLoop() and
      not c instanceof BreakCompletion and
      not c instanceof RedoCompletion
      or
      c =
        any(NestedCompletion nc |
          last(this.getBody(), last, nc.getInnerCompletion().(BreakCompletion)) and
          nc.getOuterCompletion() instanceof SimpleCompletion
        )
    }

    /**
     * for pattern in value do body end
     * ```
     * value +-> for +--[non empty]--> pattern -> body -> for
     *               |--[empty]--> exit
     * ```
     */
    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(this.getValue(), pred, c) and
      succ = this and
      c instanceof SimpleCompletion
      or
      pred = this and
      first(this.getPattern(0), succ) and
      c instanceof EmptinessCompletion and
      not c.(EmptinessCompletion).isEmpty()
      or
      exists(int i, ControlFlowTree next |
        last(this.getPattern(i), pred, c) and
        first(next, succ) and
        c instanceof SimpleCompletion
      |
        next = this.getPattern(i + 1)
        or
        not exists(this.getPattern(i + 1)) and next = this.getBody()
      )
      or
      last(this.getBody(), pred, c) and
      succ = this and
      c.continuesLoop()
      or
      last(this.getBody(), pred, any(RedoCompletion rc)) and
      first(this.getBody(), succ) and
      c instanceof SimpleCompletion
    }
  }

  private class HeredocBeginningTree extends StandardPreOrderTree, HeredocBeginning {
    final override AstNode getChildNode(int i) {
      i = 0 and
      result =
        min(string name, HeredocBody doc, HeredocEnd end |
          name = this.getValue().regexpCapture("^<<[-~]?[`']?(.*)[`']?$", 1) and
          end = unique(HeredocEnd x | x = doc.getChild(_)) and
          end.getValue() = name and
          doc.getLocation().getFile() = this.getLocation().getFile() and
          (
            doc.getLocation().getStartLine() > this.getLocation().getStartLine()
            or
            doc.getLocation().getStartLine() = this.getLocation().getStartLine() and
            doc.getLocation().getStartColumn() > this.getLocation().getStartColumn()
          )
        |
          doc order by doc.getLocation().getStartLine(), doc.getLocation().getStartColumn()
        )
    }
  }

  private class IdentifierTree extends LeafTree, Identifier { }

  private class IfElsifTree extends PreOrderTree, IfElsifAstNode {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getConditionNode() }

    final override predicate last(AstNode last, Completion c) {
      last(this.getConditionNode(), last, c) and
      c instanceof FalseCompletion and
      not exists(this.getAlternativeNode())
      or
      last(this.getConditionNode(), last, c) and
      c instanceof TrueCompletion and
      not exists(this.getConsequenceNode())
      or
      last(this.getConsequenceNode(), last, c)
      or
      last(this.getAlternativeNode(), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(this.getConditionNode(), succ) and
      c instanceof SimpleCompletion
      or
      last(this.getConditionNode(), pred, c) and
      (
        c instanceof TrueCompletion and first(this.getConsequenceNode(), succ)
        or
        c instanceof FalseCompletion and first(this.getAlternativeNode(), succ)
      )
    }
  }

  private class InTree extends StandardPreOrderTree, In {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }

    override predicate isHidden() { any() }
  }

  private class IntegerTree extends LeafTree, Integer { }

  class LogicalAndTree extends PostOrderTree, LogicalAndAstNode {
    final override predicate propagatesAbnormal(AstNode child) { child in [left, right] }

    final override predicate first(AstNode first) { first(left, first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(left, pred, c) and
      c instanceof TrueCompletion and
      first(right, succ)
      or
      last(left, pred, c) and
      c instanceof FalseCompletion and
      succ = this
      or
      last(right, pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  class LogicalOrTree extends PostOrderTree, LogicalOrAstNode {
    final override predicate propagatesAbnormal(AstNode child) { child in [left, right] }

    final override predicate first(AstNode first) { first(left, first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(left, pred, c) and
      c instanceof FalseCompletion and
      first(right, succ)
      or
      last(left, pred, c) and
      c instanceof TrueCompletion and
      succ = this
      or
      last(right, pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  class LogicalNotTree extends PostOrderTree, LogicalNotAstNode {
    final override predicate propagatesAbnormal(AstNode child) { child = operand }

    final override predicate first(AstNode first) { first(operand, first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      succ = this and
      (
        last(operand, pred, c.(BooleanCompletion).getDual())
        or
        last(operand, pred, c) and
        c instanceof SimpleCompletion
      )
    }
  }

  private class MethodTree extends StandardPreOrderTree, Method {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class MethodCallTree extends StandardPostOrderTree, MethodCall {
    // this.getBlock() is not included as it uses a different scope
    final override AstNode getChildNode(int i) {
      result = this.getArguments() and i = 0
      or
      result = this.getMethod() and i = 1
    }
  }

  private class ModuleTree extends StandardPreOrderTree, Module {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class NextTree extends StandardPostOrderTree, Next {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class OperatorAssignmentTree extends StandardPostOrderTree, OperatorAssignment {
    final override AstNode getChildNode(int i) {
      result = this.getLeft() and i = 0
      or
      result = this.getRight() and i = 1
    }
  }

  private class ParenthesizedStatementsTree extends StandardPostOrderTree, ParenthesizedStatements {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class PatternTree extends StandardPostOrderTree, Pattern {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class ProgramTree extends StandardPreOrderTree, Program {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class RedoTree extends StandardPostOrderTree, Redo {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class RescueModifierTree extends PreOrderTree, RescueModifier {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getHandler() }

    final override predicate last(AstNode last, Completion c) {
      last(this.getBody(), last, c) and
      not c instanceof RaiseCompletion
      or
      last(this.getHandler(), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(this.getBody(), succ) and
      c instanceof SimpleCompletion
      or
      last(this.getBody(), pred, c) and
      c instanceof RaiseCompletion and
      first(this.getHandler(), succ)
    }
  }

  private class ReturnTree extends StandardPostOrderTree, Return {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class SingletonClassTree extends StandardPreOrderTree, SingletonClass {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class SingletonMethodTree extends StandardPreOrderTree, SingletonMethod {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class StringTree extends LeafTree, String { }

  private class ThenTree extends StandardPreOrderTree, Then {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class UnaryTree extends StandardPostOrderTree, Unary {
    UnaryTree() { not this instanceof LogicalNotAstNode }

    final override AstNode getChildNode(int i) { result = this.getOperand() and i = 0 }
  }

  private class WhenTree extends PreOrderTree, When {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getPattern(_) }

    final override predicate last(AstNode last, Completion c) {
      exists(int i |
        not exists(this.getPattern(i + 1)) and
        last(this.getPattern(i), last, c) and
        c instanceof FalseCompletion
      )
      or
      last(this.getBody(), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(this.getPattern(0), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i, Pattern p |
        p = this.getPattern(i) and
        last(p, pred, c)
      |
        c instanceof TrueCompletion and first(this.getBody(), succ)
        or
        c instanceof FalseCompletion and
        first(this.getPattern(i + 1), succ)
      )
    }
  }

  private class ConditionalLoopTree extends PreOrderTree, ConditionalLoopAstNode {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getCondition() }

    final override predicate last(AstNode last, Completion c) {
      last(this.getCondition(), last, c) and
      this.endLoop(c)
      or
      last(this.getBody(), last, c) and
      not c.continuesLoop() and
      not c instanceof BreakCompletion and
      not c instanceof RedoCompletion
      or
      c =
        any(NestedCompletion nc |
          last(this.getBody(), last, nc.getInnerCompletion().(BreakCompletion)) and
          nc.getOuterCompletion() instanceof SimpleCompletion
        )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(this.getCondition(), succ) and
      c instanceof SimpleCompletion
      or
      last(this.getCondition(), pred, c) and
      this.continueLoop(c) and
      first(this.getBody(), succ)
      or
      last(this.getBody(), pred, c) and
      first(this.getCondition(), succ) and
      c.continuesLoop()
      or
      last(this.getBody(), pred, any(RedoCompletion rc)) and
      first(this.getBody(), succ) and
      c instanceof SimpleCompletion
    }
  }
}

cached
private module Cached {
  private predicate isAbnormalExitType(SuccessorType t) {
    t instanceof RaiseSuccessor or t instanceof ExitSuccessor
  }

  cached
  newtype TCfgNode =
    TEntryNode(CfgScope scope) { succEntrySplits(scope, _, _, _) } or
    TAnnotatedExitNode(CfgScope scope, boolean normal) {
      exists(Reachability::SameSplitsBlock b, SuccessorType t | b.isReachable(_) |
        succExitSplits(b.getANode(), _, scope, t) and
        if isAbnormalExitType(t) then normal = false else normal = true
      )
    } or
    TExitNode(CfgScope scope) {
      exists(Reachability::SameSplitsBlock b | b.isReachable(_) |
        succExitSplits(b.getANode(), _, scope, _)
      )
    } or
    TAstNode(AstNode n, Splits splits) {
      exists(Reachability::SameSplitsBlock b | b.isReachable(splits) | n = b.getANode())
    }

  cached
  newtype TSuccessorType =
    TSuccessorSuccessor() or
    TBooleanSuccessor(boolean b) { b = true or b = false } or
    TEmptinessSuccessor(boolean isEmpty) { isEmpty = true or isEmpty = false } or
    TReturnSuccessor() or
    TBreakSuccessor() or
    TNextSuccessor() or
    TRedoSuccessor() or
    TRetrySuccessor() or
    TRaiseSuccessor() or // TODO: Add exception type?
    TExitSuccessor()

  /** Gets a successor node of a given flow type, if any. */
  cached
  CfgNode getASuccessor(CfgNode pred, SuccessorType t) {
    exists(CfgScope scope, AstNode succElement, Splits succSplits |
      pred = TEntryNode(scope) and
      succEntrySplits(scope, succElement, succSplits, t) and
      result = TAstNode(succElement, succSplits)
    )
    or
    exists(AstNode predNode, Splits predSplits | pred = TAstNode(predNode, predSplits) |
      exists(CfgScope scope, boolean normal |
        succExitSplits(predNode, predSplits, scope, t) and
        (if isAbnormalExitType(t) then normal = false else normal = true) and
        result = TAnnotatedExitNode(scope, normal)
      )
      or
      exists(AstNode succElement, Splits succSplits, Completion c |
        succSplits(predNode, predSplits, succElement, succSplits, c) and
        t = c.getAMatchingSuccessorType() and
        result = TAstNode(succElement, succSplits)
      )
    )
    or
    exists(CfgScope scope |
      pred = TAnnotatedExitNode(scope, _) and
      t instanceof SuccessorTypes::NormalSuccessor and
      result = TExitNode(scope)
    )
  }

  /** Gets a first control flow element executed within `n`. */
  cached
  AstNode getAControlFlowEntryNode(AstNode n) { first(n, result) }

  /** Gets a potential last control flow element executed within `n`. */
  cached
  AstNode getAControlFlowExitNode(AstNode n) { last(n, result, _) }
}

import Cached

/** An AST node that is split into multiple control flow nodes. */
class SplitAstNode extends AstNode {
  SplitAstNode() { strictcount(CfgNode n | n.getNode() = this) > 1 }
}
