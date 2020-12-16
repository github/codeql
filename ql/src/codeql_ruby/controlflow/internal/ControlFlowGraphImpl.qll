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
private import codeql.files.FileSystem

private AstNode parent(AstNode n) {
  result.getAFieldOrChild() = n and
  not n instanceof CfgScope
}

/** Gets the CFG scope of node `n`. */
CfgScope getScope(AstNode n) { result = parent+(n) }

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
    scope.entry(n) and
    succImplIfHidden*(n, first) and
    not isHidden(first)
  )
}

/** Holds if `last` with completion `c` can exit `scope`. */
pragma[nomagic]
predicate succExit(CfgScope scope, AstNode last, Completion c) {
  exists(AstNode n |
    scope.exit(n, c) and
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
    result = rank[i + 1](AstNode child, int j | child = this.getChildNode(j) | child order by j)
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
module Trees {
  private class AliasTree extends StandardPreOrderTree, Alias {
    final override AstNode getChildNode(int i) {
      i = 0 and result = this.getName()
      or
      i = 1 and result = this.getAlias()
    }
  }

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

  private class BareStringTree extends StandardPostOrderTree, BareString {
    final override Interpolation getChildNode(int i) { result = this.getChild(i) }
  }

  private class BareSymbolTree extends StandardPostOrderTree, BareSymbol {
    final override Interpolation getChildNode(int i) { result = this.getChild(i) }
  }

  private class BeginTree extends RescueEnsureBlockTree, PreOrderTree, Begin {
    final override AstNode getChildNode(int i, boolean rescuable) {
      result = this.getChild(i) and rescuable = true
    }

    final override predicate last(AstNode last, Completion c) { this.lastBody(last, c) }

    override predicate isHidden() { any() }
  }

  class BeginBlockTree extends PreOrderTree, PostOrderTree, StandardNode, BeginBlock {
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

  class BlockTree extends StandardNode, PreOrderTree, PostOrderTree, Block {
    final override AstNode getChildNode(int i) {
      result = this.getParameters() and i = 0
      or
      result = this.getChild(i - 1)
    }
  }

  private class BlockArgumentTree extends StandardPostOrderTree, BlockArgument {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class BlockParameterTree extends LeafTree, BlockParameter { }

  private class BlockParametersTree extends StandardPreOrderTree, BlockParameters {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

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
      or
      result = this.getArguments() and i = 2
      or
      result = this.getBlock() and i = 3
    }
  }

  private class CaseTree extends PreOrderTree, Case {
    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getValue() or child = this.getChild(_)
    }

    final override predicate last(AstNode last, Completion c) {
      last(this.getValue(), last, c) and not exists(this.getChild(_))
      or
      last(this.getChild(_).(When).getBody(), last, c)
      or
      exists(int i, ControlFlowTree lastBranch |
        lastBranch = this.getChild(i) and
        not exists(this.getChild(i + 1)) and
        last(lastBranch, last, c)
      )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      exists(AstNode next |
        pred = this and
        first(next, succ) and
        c instanceof SimpleCompletion
      |
        next = this.getValue()
        or
        not exists(this.getValue()) and
        next = this.getChild(0)
      )
      or
      last(this.getValue(), pred, c) and
      first(this.getChild(0), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i, WhenTree branch | branch = this.getChild(i) |
        last(branch.getLastPattern(), pred, c) and
        first(this.getChild(i + 1), succ) and
        c.(ConditionalCompletion).getValue() = false
      )
    }
  }

  private class ChainedStringTree extends StandardPostOrderTree, ChainedString {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class CharacterTree extends LeafTree, Character { }

  private class ClassTree extends RescueEnsureBlockTree, PreOrderTree, Class {
    final override AstNode getChildNode(int i, boolean rescuable) {
      result = this.getName() and i = 0 and rescuable = false
      or
      result = this.getChild(i - 1) and rescuable = true
    }

    final override predicate last(AstNode last, Completion c) { this.lastBody(last, c) }
  }

  private class ClassVariableTree extends LeafTree, ClassVariable { }

  private class ComplexTree extends LeafTree, Complex { }

  private class ConstantTree extends LeafTree, Constant { }

  /** A parameter that may have a default value. */
  abstract class DefaultValueParameterTree extends PreOrderTree {
    abstract AstNode getDefaultValue();

    predicate hasDefaultValue() { exists(this.getDefaultValue()) }

    final override predicate propagatesAbnormal(AstNode child) { child = this.getDefaultValue() }

    final override predicate last(AstNode last, Completion c) {
      last = this and
      exists(this.getDefaultValue()) and
      c.(MatchingCompletion).getValue() = true
      or
      last(this.getDefaultValue(), last, c)
      or
      last = this and
      not exists(this.getDefaultValue()) and
      c instanceof SimpleCompletion
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(this.getDefaultValue(), succ) and
      c.(MatchingCompletion).getValue() = false
    }
  }

  private class DestructuredLeftAssignmentTree extends StandardPostOrderTree,
    DestructuredLeftAssignment {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class DestructuredParameterTree extends StandardPostOrderTree, DestructuredParameter {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class DoTree extends StandardPreOrderTree, Do {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  class DoBlockTree extends RescueEnsureBlockTree, PostOrderTree, DoBlock {
    final override predicate first(AstNode first) { first = this }

    final override AstNode getChildNode(int i, boolean rescuable) {
      result = this.getParameters() and i = 0 and rescuable = false
      or
      result = this.getChild(i - 1) and rescuable = true
    }
  }

  private class ElementReferenceTree extends StandardPostOrderTree, ElementReference {
    final override AstNode getChildNode(int i) {
      i = 0 and result = this.getObject()
      or
      result = this.getChild(i - 1)
    }
  }

  private class ElseTree extends StandardPreOrderTree, Else {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class EmptyStatementTree extends LeafTree, EmptyStatement { }

  class EndBlockTree extends StandardNode, PreOrderTree, PostOrderTree, EndBlock {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class EnsureTree extends StandardPreOrderTree, Ensure {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class EscapeSequenceTree extends LeafTree, EscapeSequence { }

  private class ExceptionVariableTree extends StandardPostOrderTree, ExceptionVariable {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }

    override predicate isHidden() { any() }
  }

  private class ExceptionsTree extends PreOrderTree, Exceptions {
    final override predicate propagatesAbnormal(AstNode child) { none() }

    final override predicate last(AstNode last, Completion c) {
      last(this.getChild(_), last, c) and
      c.(MatchingCompletion).getValue() = true
      or
      exists(int lst |
        last(this.getChild(lst), last, c) and
        not exists(this.getChild(lst + 1))
      )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(this.getChild(0), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i |
        last(this.getChild(i), pred, c) and
        c.(MatchingCompletion).getValue() = false and
        first(this.getChild(i + 1), succ)
      )
    }

    override predicate isHidden() { any() }
  }

  private class FalseTree extends LeafTree, False { }

  private class FloatTree extends LeafTree, Float { }

  /**
   * Control flow of a for-in loop
   *
   * For example, this program fragment:
   *
   * ```rb
   * for arg in args do
   *   puts arg
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
      c.(EmptinessCompletion).getValue() = true
      or
      last(this.getBody(), last, c) and
      not c.continuesLoop() and
      not c instanceof BreakCompletion and
      not c instanceof RedoCompletion
      or
      last(this.getBody(), last, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion())
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
      c.(EmptinessCompletion).getValue() = false
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
      last(this.getBody(), pred, c) and
      first(this.getBody(), succ) and
      c instanceof RedoCompletion
    }
  }

  private class GlobalVariableTree extends LeafTree, GlobalVariable { }

  private class HashTree extends StandardPostOrderTree, Hash {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class HashSplatArgumentTree extends StandardPostOrderTree, HashSplatArgument {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class HashSplatParameterTree extends LeafTree, HashSplatParameter { }

  private HeredocBody heredoc(HeredocBeginning start) {
    exists(int i, File f |
      start =
        rank[i](HeredocBeginning b |
          f = b.getLocation().getFile()
        |
          b order by b.getLocation().getStartLine(), b.getLocation().getStartColumn()
        ) and
      result =
        rank[i](HeredocBody b |
          f = b.getLocation().getFile()
        |
          b order by b.getLocation().getStartLine(), b.getLocation().getStartColumn()
        )
    )
  }

  private class HeredocBeginningTree extends StandardPreOrderTree, HeredocBeginning {
    final override AstNode getChildNode(int i) {
      i = 0 and
      result = heredoc(this)
    }
  }

  private class HeredocBodyTree extends StandardPostOrderTree, HeredocBody {
    final override Interpolation getChildNode(int i) { result = this.getChild(i) }
  }

  private class HeredocContentTree extends LeafTree, HeredocContent { }

  private class HeredocEndTree extends LeafTree, HeredocEnd { }

  private class IdentifierTree extends LeafTree, Identifier { }

  private class IfElsifTree extends PostOrderTree, IfElsifAstNode {
    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getConditionNode() or child = this.getBranch(_)
    }

    final override predicate first(AstNode first) { first(this.getConditionNode(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      exists(boolean b |
        last(this.getConditionNode(), pred, c) and
        b = c.(BooleanCompletion).getValue()
      |
        first(this.getBranch(b), succ)
        or
        not exists(this.getBranch(b)) and
        succ = this
      )
      or
      last(this.getBranch(_), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class InTree extends StandardPreOrderTree, In {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }

    override predicate isHidden() { any() }
  }

  private class InstanceVariableTree extends LeafTree, InstanceVariable { }

  private class IntegerTree extends LeafTree, Integer { }

  private class InterpolationTree extends StandardPostOrderTree, Interpolation {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class KeywordParameterTree extends DefaultValueParameterTree, KeywordParameter {
    final override AstNode getDefaultValue() { result = this.getValue() }
  }

  class LambdaTree extends PreOrderTree, PostOrderTree, Lambda {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getParameters() }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      this.getBody().(ControlFlowTree).succ(pred, succ, c)
      or
      last(this.getParameters(), pred, c) and
      c instanceof NormalCompletion and
      (
        first(this.getBody().(DoBlockTree).firstBody(), succ)
        or
        first(this.getBody().(BlockTree).getFirstChildNode(), succ)
      )
    }
  }

  private class LambdaParametersTree extends StandardPreOrderTree, LambdaParameters {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class LeftAssignmentListTree extends StandardPostOrderTree, LeftAssignmentList {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

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

  private class MethodTree extends RescueEnsureBlockTree, PostOrderTree, Method {
    final override AstNode getChildNode(int i, boolean rescuable) {
      result = this.getParameters() and i = 0 and rescuable = false
      or
      result = this.getChild(i - 1) and rescuable = true
    }

    final override predicate first(AstNode first) { first(this.getName(), first) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      RescueEnsureBlockTree.super.succ(pred, succ, c)
      or
      last(this.getName(), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class MethodParametersTree extends StandardPreOrderTree, MethodParameters {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class ModuleTree extends RescueEnsureBlockTree, PreOrderTree, Module {
    final override AstNode getChildNode(int i, boolean rescuable) {
      result = this.getName() and i = 0 and rescuable = false
      or
      result = this.getChild(i - 1) and rescuable = true
    }

    final override predicate last(AstNode last, Completion c) { this.lastBody(last, c) }
  }

  private class NextTree extends StandardPostOrderTree, Next {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class NilTree extends LeafTree, Nil { }

  private class OperatorAssignmentTree extends StandardPostOrderTree, OperatorAssignment {
    final override AstNode getChildNode(int i) {
      result = this.getLeft() and i = 0
      or
      result = this.getRight() and i = 1
    }
  }

  private class OptionalParameterTree extends DefaultValueParameterTree, OptionalParameter {
    final override AstNode getDefaultValue() { result = this.getValue() }
  }

  private class PairTree extends StandardPostOrderTree, Pair {
    final override AstNode getChildNode(int i) {
      result = this.getKey() and i = 0
      or
      result = this.getValue() and i = 1
    }
  }

  private class ParenthesizedStatementsTree extends StandardPostOrderTree, ParenthesizedStatements {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class PatternTree extends StandardPreOrderTree, Pattern {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }

    final override predicate isHidden() { any() }
  }

  private class ProgramTree extends StandardPreOrderTree, Program {
    final override AstNode getChildNode(int i) {
      result = this.getChild(i) and
      not result instanceof Uninterpreted
    }

    override predicate isHidden() { any() }
  }

  private class RangeTree extends StandardPostOrderTree, Range {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class RationalTree extends LeafTree, Rational { }

  private class RedoTree extends StandardPostOrderTree, Redo {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class RegexTree extends StandardPostOrderTree, Regex {
    final override Interpolation getChildNode(int i) { result = this.getChild(i) }
  }

  private class RescueTree extends PreOrderTree, Rescue {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getExceptions() }

    predicate lastMatch(AstNode last, Completion c) {
      last(this.getBody(), last, c)
      or
      not exists(this.getBody()) and
      (
        last(this.getVariable(), last, c)
        or
        not exists(this.getVariable()) and
        (
          last(this.getExceptions(), last, c) and
          c.(MatchingCompletion).getValue() = true
          or
          not exists(this.getExceptions()) and
          last = this and
          c.isValidFor(this)
        )
      )
    }

    predicate lastNoMatch(AstNode last, Completion c) {
      last(this.getExceptions(), last, c) and
      c.(MatchingCompletion).getValue() = false
    }

    final override predicate last(AstNode last, Completion c) {
      this.lastNoMatch(last, c)
      or
      this.lastMatch(last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      exists(AstNode next |
        pred = this and
        first(next, succ) and
        c instanceof SimpleCompletion
      |
        next = this.getExceptions()
        or
        not exists(this.getExceptions()) and
        (
          next = this.getVariable()
          or
          not exists(this.getVariable()) and
          next = this.getBody()
        )
      )
      or
      exists(AstNode next |
        last(this.getExceptions(), pred, c) and
        first(next, succ) and
        c.(MatchingCompletion).getValue() = true
      |
        next = this.getVariable()
        or
        not exists(this.getVariable()) and
        next = this.getBody()
      )
      or
      last(this.getVariable(), pred, c) and
      first(this.getBody(), succ) and
      c instanceof NormalCompletion
    }
  }

  /** Gets a child of `n` that is in CFG scope `scope`. */
  pragma[noinline]
  private AstNode getAChildInScope(AstNode n, CfgScope scope) {
    result.getParent() = n and
    scope = getScope(result)
  }

  /** A block that may contain `rescue`/`ensure`. */
  abstract class RescueEnsureBlockTree extends ControlFlowTree {
    /**
     * Gets the `i`th child of this block. `rescuable` indicates whether exceptional
     * execution of the child can be caught by `rescue`/`ensure`.
     */
    abstract AstNode getChildNode(int i, boolean rescuable);

    /** Gets the `i`th child in the body of this block. */
    final private AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getChildNode(_, rescuable) and
      result =
        rank[i + 1](AstNode child, int j |
          child = this.getChildNode(j, _) and
          not result instanceof Rescue and
          not result instanceof Ensure and
          not result instanceof Else
        |
          child order by j
        )
    }

    /** Gets the `i`th `rescue` block in this block. */
    final Rescue getRescue(int i) {
      result = rank[i + 1](Rescue s | s = this.getAFieldOrChild() | s order by s.getParentIndex())
    }

    /** Gets the `else` block in this block, if any. */
    final private Else getElse() { result = unique(Else s | s = this.getAFieldOrChild()) }

    /** Gets the `ensure` block in this block, if any. */
    final Ensure getEnsure() { result = unique(Ensure s | s = this.getAFieldOrChild()) }

    final private predicate hasEnsure() { exists(this.getEnsure()) }

    final override predicate propagatesAbnormal(AstNode child) { none() }

    /**
     * Gets a descendant that belongs to the `ensure` block of this block, if any.
     * Nested `ensure` blocks are not included.
     */
    AstNode getAnEnsureDescendant() {
      result = this.getEnsure()
      or
      exists(AstNode mid |
        mid = this.getAnEnsureDescendant() and
        result = getAChildInScope(mid, getScope(mid)) and
        not exists(RescueEnsureBlockTree nestedBlock |
          result = nestedBlock.getEnsure() and
          nestedBlock != this
        )
      )
    }

    /**
     * Holds if `innerBlock` has an `ensure` block and is immediately nested inside the
     * `ensure` block of this block.
     */
    private predicate nestedEnsure(RescueEnsureBlockTree innerBlock) {
      exists(Ensure innerEnsure |
        innerEnsure = getAChildInScope(this.getAnEnsureDescendant(), getScope(this)) and
        innerEnsure = innerBlock.getEnsure()
      )
    }

    /**
     * Gets the `ensure`-nesting level of this block. That is, the number of `ensure`
     * blocks that this block is nested under.
     */
    int nestLevel() { result = count(RescueEnsureBlockTree outer | outer.nestedEnsure+(this)) }

    /**
     * Holds if `last` is a last element in the body of this block. `ensurable`
     * indicates whether `last` may be a predecessor of an `ensure` block.
     */
    pragma[nomagic]
    private predicate lastBody(AstNode last, Completion c, boolean ensurable) {
      exists(boolean rescuable |
        if c instanceof RaiseCompletion then ensurable = rescuable else ensurable = true
      |
        last(this.getBodyChild(_, rescuable), last, c) and
        not c instanceof NormalCompletion
        or
        exists(int lst |
          last(this.getBodyChild(lst, rescuable), last, c) and
          not exists(this.getBodyChild(lst + 1, _))
        )
      )
    }

    /**
     * Gets a last element from this block that may finish with completion `c`, such
     * that control may be transferred to the `ensure` block (if it exists), but only
     * if `ensurable = true`.
     */
    pragma[nomagic]
    private AstNode getAnEnsurePredecessor(Completion c, boolean ensurable) {
      this.lastBody(result, c, ensurable) and
      (
        // Any non-throw completion will always continue directly to the `ensure` block,
        // unless there is an `else` block
        not c instanceof RaiseCompletion and
        not exists(this.getElse())
        or
        // Any completion will continue to the `ensure` block when there are no `rescue`
        // blocks
        not exists(this.getRescue(_))
      )
      or
      // Last element from any matching `rescue` block continues to the `ensure` block
      this.getRescue(_).(RescueTree).lastMatch(result, c) and
      ensurable = true
      or
      // If the last `rescue` block does not match, continue to the `ensure` block
      exists(int lst, MatchingCompletion mc |
        this.getRescue(lst).(RescueTree).lastNoMatch(result, mc) and
        mc.getValue() = false and
        not exists(this.getRescue(lst + 1)) and
        c =
          any(NestedEnsureCompletion nec |
            nec.getOuterCompletion() instanceof RaiseCompletion and
            nec.getInnerCompletion() = mc and
            nec.getNestLevel() = 0
          ) and
        ensurable = true
      )
      or
      // Last element of `else` block continues to the `ensure` block
      last(this.getElse(), result, c) and
      ensurable = true
    }

    pragma[nomagic]
    private predicate lastEnsure0(AstNode last, Completion c) { last(this.getEnsure(), last, c) }

    pragma[nomagic]
    private predicate lastEnsure(
      AstNode last, NormalCompletion ensure, Completion outer, int nestLevel
    ) {
      this.lastEnsure0(last, ensure) and
      exists(
        this.getAnEnsurePredecessor(any(Completion c0 | outer = c0.getOuterCompletion()), true)
      ) and
      nestLevel = this.nestLevel()
    }

    predicate lastBody(AstNode last, Completion c) {
      exists(boolean ensurable | last = this.getAnEnsurePredecessor(c, ensurable) |
        not this.hasEnsure()
        or
        ensurable = false
      )
      or
      // If the body completes normally, take the completion from the `ensure` block
      this.lastEnsure(last, c, any(NormalCompletion nc), _)
      or
      // If the `ensure` block completes normally, it inherits any non-normal
      // completion from the body
      c =
        any(NestedEnsureCompletion nec |
          this
              .lastEnsure(last, nec.getAnInnerCompatibleCompletion(), nec.getOuterCompletion(),
                nec.getNestLevel())
        )
      or
      not exists(this.getBodyChild(_, _)) and
      not exists(this.getRescue(_)) and
      this.lastEnsure0(last, c)
      or
      last([this.getEnsure(), this.getBodyChild(_, false)], last, c) and
      not c instanceof NormalCompletion
    }

    AstNode firstBody() {
      result = this.getBodyChild(0, _)
      or
      not exists(this.getBodyChild(_, _)) and
      (
        result = this.getRescue(0)
        or
        not exists(this.getRescue(_)) and
        result = this.getEnsure()
      )
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      this instanceof PreOrderTree and
      pred = this and
      c instanceof SimpleCompletion and
      first(this.firstBody(), succ)
      or
      // Normal left-to-right evaluation in the body
      exists(int i |
        last(this.getBodyChild(i, _), pred, c) and
        first(this.getBodyChild(i + 1, _), succ) and
        c instanceof NormalCompletion
      )
      or
      // Exceptional flow from body to first `rescue`
      this.lastBody(pred, c, true) and
      first(this.getRescue(0), succ) and
      c instanceof RaiseCompletion
      or
      // Flow from one `rescue` clause to the next when there is no match
      exists(RescueTree rescue, int i | rescue = this.getRescue(i) |
        rescue.lastNoMatch(pred, c) and
        first(this.getRescue(i + 1), succ)
      )
      or
      // Flow from body to `else` block when no exception
      this.lastBody(pred, c, _) and
      first(this.getElse(), succ) and
      c instanceof NormalCompletion
      or
      // Flow into `ensure` block
      pred = getAnEnsurePredecessor(c, true) and
      first(this.getEnsure(), succ)
    }
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

  private class RestAssignmentTree extends StandardPostOrderTree, RestAssignment {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class RetryTree extends StandardPreOrderTree, Retry {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class ReturnTree extends StandardPostOrderTree, Return {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class RightAssignmentListTree extends StandardPostOrderTree, RightAssignmentList {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class ScopeResolutionTree extends StandardPostOrderTree, ScopeResolution {
    final override AstNode getChildNode(int i) {
      result = this.getScope() and i = 0
      or
      result = this.getName() and i = 1
    }
  }

  private class SelfTree extends LeafTree, Self { }

  private class SetterTree extends LeafTree, Setter { }

  private class SingletonClassTree extends RescueEnsureBlockTree, PreOrderTree, SingletonClass {
    final override AstNode getChildNode(int i, boolean rescuable) {
      rescuable = true and
      (
        result = this.getValue() and i = 0
        or
        result = this.getChild(i - 1)
      )
    }

    final override predicate last(AstNode last, Completion c) { this.lastBody(last, c) }
  }

  private class SingletonMethodTree extends RescueEnsureBlockTree, PostOrderTree, SingletonMethod {
    final override AstNode getChildNode(int i, boolean rescuable) {
      result = this.getParameters() and
      i = 0 and
      rescuable = false
      or
      result = this.getChild(i - 1) and
      rescuable = true
    }

    final override predicate first(AstNode first) { first(this.getObject(), first) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      RescueEnsureBlockTree.super.succ(pred, succ, c)
      or
      last(this.getObject(), pred, c) and
      first(this.getName(), succ) and
      c instanceof NormalCompletion
      or
      last(this.getName(), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class SplatArgumentTree extends StandardPostOrderTree, SplatArgument {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class SplatParameterTree extends LeafTree, SplatParameter { }

  private class StringTree extends StandardPostOrderTree, String {
    final override Interpolation getChildNode(int i) { result = this.getChild(i) }
  }

  private class StringArrayTree extends StandardPostOrderTree, StringArray {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class StringContentTree extends LeafTree, StringContent { }

  private class SubshellTree extends StandardPostOrderTree, Subshell {
    final override Interpolation getChildNode(int i) { result = this.getChild(i) }
  }

  private class SuperTree extends LeafTree, Super { }

  private class SuperclassTree extends StandardPostOrderTree, Superclass {
    final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
  }

  private class SymbolTree extends StandardPostOrderTree, Symbol {
    final override Interpolation getChildNode(int i) { result = this.getChild(i) }
  }

  private class SymbolArrayTree extends StandardPostOrderTree, SymbolArray {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class ThenTree extends StandardPreOrderTree, Then {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }

    override predicate isHidden() { any() }
  }

  private class TrueTree extends LeafTree, True { }

  private class UnaryTree extends StandardPostOrderTree, Unary {
    UnaryTree() { not this instanceof LogicalNotAstNode }

    final override AstNode getChildNode(int i) { result = this.getOperand() and i = 0 }
  }

  private class UndefTree extends StandardPreOrderTree, Undef {
    final override AstNode getChildNode(int i) { result = this.getChild(i) }
  }

  private class WhenTree extends PreOrderTree, When {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getPattern(_) }

    final Pattern getLastPattern() {
      exists(int i |
        result = this.getPattern(i) and
        not exists(this.getPattern(i + 1))
      )
    }

    final override predicate last(AstNode last, Completion c) {
      last(this.getLastPattern(), last, c) and
      c.(ConditionalCompletion).getValue() = false
      or
      last(this.getBody(), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(this.getPattern(0), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i, Pattern p, boolean b |
        p = this.getPattern(i) and
        last(p, pred, c) and
        b = c.(ConditionalCompletion).getValue()
      |
        b = true and
        first(this.getBody(), succ)
        or
        b = false and
        first(this.getPattern(i + 1), succ)
      )
    }
  }

  private class ConditionalLoopTree extends PreOrderTree, ConditionalLoopAstNode {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getConditionNode() }

    final override predicate last(AstNode last, Completion c) {
      last(this.getConditionNode(), last, c) and
      this.endLoop(c)
      or
      last(this.getBodyNode(), last, c) and
      not c.continuesLoop() and
      not c instanceof BreakCompletion and
      not c instanceof RedoCompletion
      or
      last(this.getBodyNode(), last, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion())
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(this.getConditionNode(), succ) and
      c instanceof SimpleCompletion
      or
      last(this.getConditionNode(), pred, c) and
      this.continueLoop(c) and
      first(this.getBodyNode(), succ)
      or
      last(this.getBodyNode(), pred, c) and
      first(this.getConditionNode(), succ) and
      c.continuesLoop()
      or
      last(this.getBodyNode(), pred, c) and
      first(this.getBodyNode(), succ) and
      c instanceof RedoCompletion
    }
  }
}

private class YieldTree extends StandardPreOrderTree, Yield {
  final override AstNode getChildNode(int i) { result = this.getChild() and i = 0 }
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
    TBooleanSuccessor(boolean b) { b in [false, true] } or
    TEmptinessSuccessor(boolean isEmpty) { isEmpty in [false, true] } or
    TMatchingSuccessor(boolean isMatch) { isMatch in [false, true] } or
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
