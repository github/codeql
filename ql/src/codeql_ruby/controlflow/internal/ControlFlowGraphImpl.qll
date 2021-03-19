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

private import codeql_ruby.AST
private import codeql_ruby.ast.internal.AST as ASTInternal
private import codeql_ruby.ast.internal.Scope
private import codeql_ruby.ast.Scope
private import codeql_ruby.ast.internal.TreeSitter
private import codeql_ruby.ast.internal.Variable
private import codeql_ruby.controlflow.ControlFlowGraph
private import Completion
private import SuccessorTypes
private import Splitting

module CfgScope {
  abstract class Range_ extends AstNode {
    abstract predicate entry(AstNode first);

    abstract predicate exit(AstNode last, Completion c);
  }

  private class ToplevelScope extends Range_, Toplevel {
    final override predicate entry(AstNode first) { first(this, first) }

    final override predicate exit(AstNode last, Completion c) { last(this, last, c) }
  }

  private class EndBlockScope extends Range_, EndBlock {
    final override predicate entry(AstNode first) {
      first(this.(Trees::EndBlockTree).getFirstChildNode(), first)
    }

    final override predicate exit(AstNode last, Completion c) {
      last(this.(Trees::EndBlockTree).getLastChildNode(), last, c)
    }
  }

  private class MethodScope extends Range_, Method {
    final override predicate entry(AstNode first) { this.(Trees::BodyStmtTree).firstInner(first) }

    final override predicate exit(AstNode last, Completion c) {
      this.(Trees::BodyStmtTree).lastInner(last, c)
    }
  }

  private class SingletonMethodScope extends Range_, SingletonMethod {
    final override predicate entry(AstNode first) { this.(Trees::BodyStmtTree).firstInner(first) }

    final override predicate exit(AstNode last, Completion c) {
      this.(Trees::BodyStmtTree).lastInner(last, c)
    }
  }

  private class DoBlockScope extends Range_, DoBlock {
    final override predicate entry(AstNode first) { this.(Trees::BodyStmtTree).firstInner(first) }

    final override predicate exit(AstNode last, Completion c) {
      this.(Trees::BodyStmtTree).lastInner(last, c)
    }
  }

  private class BraceBlockScope extends Range_, BraceBlock {
    final override predicate entry(AstNode first) {
      first(this.(Trees::BraceBlockTree).getFirstChildNode(), first)
    }

    final override predicate exit(AstNode last, Completion c) {
      last(this.(Trees::BraceBlockTree).getLastChildNode(), last, c)
    }
  }

  private class LambdaScope extends Range_, Lambda {
    final override predicate entry(AstNode first) { this.(Trees::BodyStmtTree).firstInner(first) }

    final override predicate exit(AstNode last, Completion c) {
      this.(Trees::BodyStmtTree).lastInner(last, c)
    }
  }
}

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
predicate succEntry(CfgScope::Range_ scope, AstNode first) {
  exists(AstNode n |
    scope.entry(n) and
    succImplIfHidden*(n, first) and
    not isHidden(first)
  )
}

/** Holds if `last` with completion `c` can exit `scope`. */
pragma[nomagic]
predicate succExit(CfgScope::Range_ scope, AstNode last, Completion c) {
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
  abstract ControlFlowTree getChildNode(int i);

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

  override predicate propagatesAbnormal(AstNode child) { child = this.getChildNode(_) }

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

// TODO: remove this class; it should be replaced with an implicit non AST node
private class ForIn extends AstNode, ASTInternal::TForIn {
  final override string toString() { result = "In" }
}

// TODO: remove this class; it should be replaced with an implicit non AST node
private class ForRange extends ForExpr {
  override AstNode getAChild(string pred) {
    result = ForExpr.super.getAChild(pred)
    or
    pred = "<in>" and
    result = this.getIn()
  }

  ForIn getIn() {
    result = ASTInternal::TForIn(ASTInternal::toGenerated(this).(Generated::For).getValue())
  }
}

// TODO: remove this predicate
predicate isValidFor(Completion c, ControlFlowTree node) {
  c instanceof SimpleCompletion and isHidden(node)
  or
  c.isValidFor(node)
}

abstract private class StandardPreOrderTree extends StandardNode, PreOrderTree {
  final override predicate last(AstNode last, Completion c) {
    last(this.getLastChildNode(), last, c)
    or
    not exists(this.getLastChildNode()) and
    isValidFor(c, this) and
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
    isValidFor(c, last)
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
  override predicate propagatesAbnormal(AstNode child) { none() }

  override predicate succ(AstNode pred, AstNode succ, Completion c) { none() }
}

abstract class ScopeTree extends StandardNode, LeafTree {
  final override predicate propagatesAbnormal(AstNode child) { none() }

  final override predicate succ(AstNode pred, AstNode succ, Completion c) {
    StandardNode.super.succ(pred, succ, c)
  }
}

/** Defines the CFG by dispatch on the various AST types. */
module Trees {
  private class AliasStmtTree extends StandardPreOrderTree, AliasStmt {
    final override ControlFlowTree getChildNode(int i) {
      result = this.getNewName() and i = 0
      or
      result = this.getOldName() and i = 1
    }
  }

  private class ArgumentListTree extends StandardPostOrderTree, ArgumentList {
    final override ControlFlowTree getChildNode(int i) { result = this.getElement(i) }

    override predicate isHidden() { any() }
  }

  private class ArrayLiteralTree extends StandardPostOrderTree, ArrayLiteral {
    final override ControlFlowTree getChildNode(int i) { result = this.getElement(i) }
  }

  private class AssignOperationTree extends StandardPostOrderTree, AssignOperation {
    final override ControlFlowTree getChildNode(int i) {
      result = this.getLeftOperand() and i = 0
      or
      result = this.getRightOperand() and i = 1
    }
  }

  private class AssignmentTree extends StandardPostOrderTree, AssignExpr {
    final override ControlFlowTree getChildNode(int i) {
      result = this.getLeftOperand() and i = 0
      or
      result = this.getRightOperand() and i = 1
    }
  }

  private class BeginTree extends BodyStmtPreOrderTree, BeginExpr {
    override predicate isHidden() { any() }
  }

  private class BinaryOperationTree extends StandardPostOrderTree, BinaryOperation {
    // Logical AND and OR are handled separately
    BinaryOperationTree() { not this instanceof BinaryLogicalOperation }

    final override ControlFlowTree getChildNode(int i) {
      result = this.getLeftOperand() and i = 0
      or
      result = this.getRightOperand() and i = 1
    }
  }

  private class BlockArgumentTree extends StandardPostOrderTree, BlockArgument {
    final override ControlFlowTree getChildNode(int i) { result = this.getValue() and i = 0 }
  }

  abstract private class NonDefaultValueParameterTree extends ControlFlowTree, NamedParameter {
    final override predicate first(AstNode first) {
      this.getDefiningAccess().(ControlFlowTree).first(first)
    }

    final override predicate last(AstNode last, Completion c) {
      this.getDefiningAccess().(ControlFlowTree).last(last, c)
    }

    override predicate propagatesAbnormal(AstNode child) {
      this.getDefiningAccess().(ControlFlowTree).propagatesAbnormal(child)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) { none() }
  }

  private class BlockParameterTree extends NonDefaultValueParameterTree, BlockParameter { }

  /**
   * TODO: make all StmtSequence tree classes post-order, and simplify class
   * hierarchy.
   */
  abstract class BodyStmtTree extends StmtSequenceTree, BodyStmt {
    predicate firstInner(AstNode first) {
      first(this.getBodyChild(0, _), first)
      or
      not exists(this.getBodyChild(_, _)) and
      (
        first(this.getRescue(_), first)
        or
        not exists(this.getRescue(_)) and
        first(this.getEnsure(), first)
      )
    }

    predicate lastInner(AstNode last, Completion c) {
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
          this.lastEnsure(last, nec.getAnInnerCompatibleCompletion(), nec.getOuterCompletion(),
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

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      this instanceof PreOrderTree and
      pred = this and
      c instanceof SimpleCompletion and
      this.firstInner(succ)
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

    /**
     * Gets a descendant that belongs to the `ensure` block of this block, if any.
     * Nested `ensure` blocks are not included.
     */
    AstNode getAnEnsureDescendant() {
      result = this.getEnsure()
      or
      exists(AstNode mid |
        mid = this.getAnEnsureDescendant() and
        result = getAChildInScope(mid, getCfgScope(mid)) and
        not exists(BodyStmt nestedBlock |
          result = nestedBlock.getEnsure() and
          nestedBlock != this
        )
      )
    }

    /**
     * Holds if `innerBlock` has an `ensure` block and is immediately nested inside the
     * `ensure` block of this block.
     */
    private predicate nestedEnsure(BodyStmtTree innerBlock) {
      exists(StmtSequence innerEnsure |
        innerEnsure = getAChildInScope(this.getAnEnsureDescendant(), getCfgScope(this)) and
        innerEnsure = innerBlock.(BodyStmt).getEnsure()
      )
    }

    /**
     * Gets the `ensure`-nesting level of this block. That is, the number of `ensure`
     * blocks that this block is nested under.
     */
    int getNestLevel() { result = count(BodyStmtTree outer | outer.nestedEnsure+(this)) }

    pragma[nomagic]
    private predicate lastEnsure(
      AstNode last, NormalCompletion ensure, Completion outer, int nestLevel
    ) {
      this.lastEnsure0(last, ensure) and
      exists(
        this.getAnEnsurePredecessor(any(Completion c0 | outer = c0.getOuterCompletion()), true)
      ) and
      nestLevel = this.getNestLevel()
    }

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
  }

  abstract class BodyStmtPreOrderTree extends BodyStmtTree, PreOrderTree {
    final override predicate last(AstNode last, Completion c) {
      this.lastInner(last, c)
      or
      not exists(this.getAChild(_)) and
      last = this and
      isValidFor(c, this)
    }
  }

  abstract class BodyStmtPostOrderTree extends BodyStmtTree, PostOrderTree {
    override predicate first(AstNode first) { first = this }
  }

  private class BooleanLiteralTree extends LeafTree, BooleanLiteral { }

  class BraceBlockTree extends ScopeTree, BraceBlock {
    final override ControlFlowTree getChildNode(int i) {
      result = this.getParameter(i)
      or
      result = this.getStmt(i - this.getNumberOfParameters())
    }
  }

  private class CaseTree extends PreOrderTree, CaseExpr {
    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getValue() or child = this.getABranch()
    }

    final override predicate last(AstNode last, Completion c) {
      last(this.getValue(), last, c) and not exists(this.getABranch())
      or
      last(this.getAWhenBranch().getBody(), last, c)
      or
      exists(int i, ControlFlowTree lastBranch |
        lastBranch = this.getBranch(i) and
        not exists(this.getBranch(i + 1)) and
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
        next = this.getBranch(0)
      )
      or
      last(this.getValue(), pred, c) and
      first(this.getBranch(0), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i, WhenTree branch | branch = this.getBranch(i) |
        last(branch.getLastPattern(), pred, c) and
        first(this.getBranch(i + 1), succ) and
        c.(ConditionalCompletion).getValue() = false
      )
    }
  }

  private class CharacterTree extends LeafTree, CharacterLiteral { }

  private class ClassTree extends BodyStmtPreOrderTree, Class {
    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getScopeExpr() and i = 0 and rescuable = false
      or
      result = this.getSuperclassExpr() and
      i = count(this.getScopeExpr()) and
      rescuable = true
      or
      result = this.getStmt(i - count(this.getScopeExpr()) - count(this.getSuperclassExpr())) and
      rescuable = true
    }
  }

  private class ClassVariableTree extends LeafTree, ClassVariableAccess { }

  private class ConditionalExprTree extends PostOrderTree, ConditionalExpr {
    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getCondition() or child = this.getBranch(_)
    }

    final override predicate first(AstNode first) { first(this.getCondition(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      exists(boolean b |
        last(this.getCondition(), pred, c) and
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

  private class ConditionalLoopTree extends PostOrderTree, ConditionalLoop {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getCondition() }

    final override predicate first(AstNode first) { first(this.getCondition(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(this.getCondition(), pred, c) and
      this.entersLoopWhenConditionIs(c.(BooleanCompletion).getValue()) and
      first(this.getBody(), succ)
      or
      last(this.getBody(), pred, c) and
      first(this.getCondition(), succ) and
      c.continuesLoop()
      or
      last(this.getBody(), pred, c) and
      first(this.getBody(), succ) and
      c instanceof RedoCompletion
      or
      succ = this and
      (
        last(this.getCondition(), pred, c) and
        this.entersLoopWhenConditionIs(c.(BooleanCompletion).getValue().booleanNot())
        or
        last(this.getBody(), pred, c) and
        not c.continuesLoop() and
        not c instanceof BreakCompletion and
        not c instanceof RedoCompletion
        or
        last(this.getBody(), pred, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion())
      )
    }
  }

  private class ConstantAccessTree extends PostOrderTree, ConstantAccess {
    ConstantAccessTree() {
      not this instanceof Class and
      not this instanceof Module
    }

    final override predicate propagatesAbnormal(AstNode child) { child = this.getScopeExpr() }

    final override predicate first(AstNode first) {
      first(this.getScopeExpr(), first)
      or
      not exists(this.getScopeExpr()) and
      first = this
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(this.getScopeExpr(), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  /** A parameter that may have a default value. */
  abstract class DefaultValueParameterTree extends ControlFlowTree {
    abstract Expr getDefaultValueExpr();

    abstract AstNode getAccessNode();

    predicate hasDefaultValue() { exists(this.getDefaultValueExpr()) }

    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getDefaultValueExpr() or child = this.getAccessNode()
    }

    final override predicate first(AstNode first) { first = this.getAccessNode() }

    final override predicate last(AstNode last, Completion c) {
      last(this.getDefaultValueExpr(), last, c) and
      c instanceof NormalCompletion
      or
      last = this.getAccessNode() and
      (
        not this.hasDefaultValue() and
        c instanceof SimpleCompletion
        or
        this.hasDefaultValue() and
        c.(MatchingCompletion).getValue() = true
      )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this.getAccessNode() and
      first(this.getDefaultValueExpr(), succ) and
      c.(MatchingCompletion).getValue() = false
    }
  }

  private class DoBlockTree extends BodyStmtPostOrderTree, DoBlock {
    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getParameter(i) and rescuable = false
      or
      result = BodyStmtPostOrderTree.super.getBodyChild(i - this.getNumberOfParameters(), rescuable)
    }
  }

  private class EmptyStatementTree extends LeafTree, EmptyStmt { }

  class EndBlockTree extends ScopeTree, EndBlock {
    final override ControlFlowTree getChildNode(int i) { result = this.getStmt(i) }
  }

  private class ForInTree extends LeafTree, ForIn { }

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
   *           in------<-----
   *           / \           \
   *          /   \          |
   *         /     \         |
   *        /       \        |
   *     empty    non-empty  |
   *       |          \      |
   *      for          \     |
   *       |          arg    |
   *       |            |    |
   *  puts "done"   puts arg |
   *                     \___/
   * ```
   */
  private class ForTree extends PostOrderTree, ForRange {
    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getPattern() or child = this.getValue()
    }

    final override predicate first(AstNode first) { first(this.getValue(), first) }

    /**
     * for pattern in array do body end
     * ```
     * array +-> in +--[non empty]--> pattern -> body -> in
     *              |--[empty]--> for
     * ```
     */
    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(this.getValue(), pred, c) and
      first(this.getIn(), succ) and
      c instanceof SimpleCompletion
      or
      last(this.getIn(), pred, c) and
      first(this.getPattern(), succ) and
      c.(EmptinessCompletion).getValue() = false
      or
      last(this.getPattern(), pred, c) and
      first(this.getBody(), succ) and
      c instanceof NormalCompletion
      or
      last(this.getBody(), pred, c) and
      first(this.getIn(), succ) and
      c.continuesLoop()
      or
      last(this.getBody(), pred, c) and
      first(this.getBody(), succ) and
      c instanceof RedoCompletion
      or
      succ = this and
      (
        last(this.getIn(), pred, c) and
        c.(EmptinessCompletion).getValue() = true
        or
        last(this.getBody(), pred, c) and
        not c.continuesLoop() and
        not c instanceof BreakCompletion and
        not c instanceof RedoCompletion
        or
        last(this.getBody(), pred, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion())
      )
    }
  }

  private class GlobalVariableTree extends LeafTree, GlobalVariableAccess { }

  private class HashLiteralTree extends StandardPostOrderTree, HashLiteral {
    final override ControlFlowTree getChildNode(int i) { result = this.getElement(i) }
  }

  private class HashSplatArgumentTree extends StandardPostOrderTree, HashSplatArgument {
    final override ControlFlowTree getChildNode(int i) { result = this.getValue() and i = 0 }
  }

  private class HashSplatParameterTree extends NonDefaultValueParameterTree, HashSplatParameter { }

  private class HereDocTree extends StandardPreOrderTree, HereDoc {
    final override ControlFlowTree getChildNode(int i) { result = this.getComponent(i) }
  }

  private class InstanceVariableTree extends LeafTree, InstanceVariableAccess { }

  private class KeywordParameterTree extends DefaultValueParameterTree, KeywordParameter {
    final override Expr getDefaultValueExpr() { result = this.getDefaultValue() }

    final override AstNode getAccessNode() { result = this.getDefiningAccess() }
  }

  private class LambdaTree extends BodyStmtPostOrderTree, Lambda {
    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getParameter(i) and rescuable = false
      or
      result = BodyStmtPostOrderTree.super.getBodyChild(i - this.getNumberOfParameters(), rescuable)
    }
  }

  private class LocalVariableAccessTree extends LeafTree, LocalVariableAccess { }

  private class LogicalAndTree extends PostOrderTree, LogicalAndExpr {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getAnOperand() }

    final override predicate first(AstNode first) { first(this.getLeftOperand(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(this.getLeftOperand(), pred, c) and
      c instanceof TrueCompletion and
      first(this.getRightOperand(), succ)
      or
      last(this.getLeftOperand(), pred, c) and
      c instanceof FalseCompletion and
      succ = this
      or
      last(this.getRightOperand(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class LogicalNotTree extends PostOrderTree, NotExpr {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getOperand() }

    final override predicate first(AstNode first) { first(this.getOperand(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      succ = this and
      last(this.getOperand(), pred, c) and
      c instanceof NormalCompletion
    }
  }

  private class LogicalOrTree extends PostOrderTree, LogicalOrExpr {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getAnOperand() }

    final override predicate first(AstNode first) { first(this.getLeftOperand(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(this.getLeftOperand(), pred, c) and
      c instanceof FalseCompletion and
      first(this.getRightOperand(), succ)
      or
      last(this.getLeftOperand(), pred, c) and
      c instanceof TrueCompletion and
      succ = this
      or
      last(this.getRightOperand(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class MethodCallTree extends StandardPostOrderTree, MethodCall {
    final override ControlFlowTree getChildNode(int i) {
      result = this.getReceiver() and i = 0
      or
      result = this.getArgument(i - count(this.getReceiver()))
      or
      result = this.getBlock() and i = count(this.getReceiver()) + this.getNumberOfArguments()
    }
  }

  private class MethodNameTree extends LeafTree, MethodName, ASTInternal::TTokenMethodName { }

  private class MethodTree extends BodyStmtPostOrderTree, Method {
    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getParameter(i) and rescuable = false
      or
      result = BodyStmtPostOrderTree.super.getBodyChild(i - this.getNumberOfParameters(), rescuable)
    }
  }

  private class ModuleTree extends BodyStmtPreOrderTree, Module {
    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getScopeExpr() and i = 0 and rescuable = false
      or
      result = BodyStmtPreOrderTree.super.getBodyChild(i - count(this.getScopeExpr()), rescuable)
    }
  }

  private class NilTree extends LeafTree, NilLiteral { }

  private class NumericLiteralTree extends LeafTree, NumericLiteral { }

  private class OptionalParameterTree extends DefaultValueParameterTree, OptionalParameter {
    final override Expr getDefaultValueExpr() { result = this.getDefaultValue() }

    final override AstNode getAccessNode() { result = this.getDefiningAccess() }
  }

  private class PairTree extends StandardPostOrderTree, Pair {
    final override ControlFlowTree getChildNode(int i) {
      result = this.getKey() and i = 0
      or
      result = this.getValue() and i = 1
    }
  }

  private class RangeLiteralTree extends StandardPostOrderTree, RangeLiteral {
    final override ControlFlowTree getChildNode(int i) {
      result = this.getBegin() and i = 0
      or
      result = this.getEnd() and i = 1
    }
  }

  private class RedoStmtTree extends LeafTree, RedoStmt { }

  /** A block that may contain `rescue`/`ensure`. */
  private class RescueModifierTree extends PreOrderTree, RescueModifierExpr {
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

  private class RescueTree extends PreOrderTree, RescueClause {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getAnException() }

    private Expr getLastException() {
      exists(int i | result = this.getException(i) and not exists(this.getException(i + 1)))
    }

    predicate lastMatch(AstNode last, Completion c) {
      last(this.getBody(), last, c)
      or
      not exists(this.getBody()) and
      (
        last(this.getVariableExpr(), last, c)
        or
        not exists(this.getVariableExpr()) and
        (
          last(this.getAnException(), last, c) and
          c.(MatchingCompletion).getValue() = true
          or
          not exists(this.getAnException()) and
          last = this and
          isValidFor(c, this)
        )
      )
    }

    predicate lastNoMatch(AstNode last, Completion c) {
      last(this.getLastException(), last, c) and
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
        next = this.getException(0)
        or
        not exists(this.getException(0)) and
        (
          next = this.getVariableExpr()
          or
          not exists(this.getVariableExpr()) and
          next = this.getBody()
        )
      )
      or
      exists(AstNode next |
        last(this.getAnException(), pred, c) and
        first(next, succ) and
        c.(MatchingCompletion).getValue() = true
      |
        next = this.getVariableExpr()
        or
        not exists(this.getVariableExpr()) and
        next = this.getBody()
      )
      or
      exists(int i |
        last(this.getException(i), pred, c) and
        c.(MatchingCompletion).getValue() = false and
        first(this.getException(i + 1), succ)
      )
      or
      last(this.getVariableExpr(), pred, c) and
      first(this.getBody(), succ) and
      c instanceof NormalCompletion
    }
  }

  private class RetryStmtTree extends LeafTree, RetryStmt { }

  private class ReturningStmtTree extends StandardPostOrderTree, ReturningStmt {
    final override ControlFlowTree getChildNode(int i) { result = this.getValue() and i = 0 }
  }

  private class SelfTree extends LeafTree, Self { }

  private class SimpleParameterTree extends NonDefaultValueParameterTree, SimpleParameter { }

  // Corner case: For duplicated '_' parameters, only the first occurence has a defining
  // access. For subsequent parameters we simply include the parameter itself in the CFG
  private class SimpleParameterTreeDupUnderscore extends LeafTree, SimpleParameter {
    SimpleParameterTreeDupUnderscore() { not exists(this.getDefiningAccess()) }
  }

  /**
   * Control-flow tree for any post-order StmtSequence that doesn't have a more
   * specific implementation.
   * TODO: make all StmtSequence tree classes post-order, and simplify class
   * hierarchy.
   */
  private class SimplePostOrderStmtSequenceTree extends StmtSequenceTree, PostOrderTree {
    SimplePostOrderStmtSequenceTree() {
      this instanceof StringInterpolationComponent or
      this instanceof ParenthesizedExpr
    }

    final override predicate first(AstNode first) { first(this.getStmt(0), first) }

    override predicate propagatesAbnormal(AstNode child) { child = this.getAStmt() }
  }

  /**
   * Control-flow tree for any pre-order StmtSequence that doesn't have a more
   * specific implementation.
   * TODO: make all StmtSequence tree classes post-order, and simplify class
   * hierarchy.
   */
  private class SimplePreOrderStmtSequenceTree extends StmtSequenceTree, PreOrderTree {
    SimplePreOrderStmtSequenceTree() {
      not this instanceof BodyStmtTree and
      not this instanceof EndBlock and
      not this instanceof StringInterpolationComponent and
      not this instanceof Block and
      not this instanceof ParenthesizedExpr
    }

    override predicate propagatesAbnormal(AstNode child) { child = this.getAStmt() }

    override predicate isHidden() {
      // TODO: unhide, or avoid using Generated types
      ASTInternal::toGenerated(this) instanceof Generated::Else or
      ASTInternal::toGenerated(this) instanceof Generated::Then or
      ASTInternal::toGenerated(this) instanceof Generated::Do
    }

    final AstNode getLastChildNode() { result = this.getStmt(this.getNumberOfStatements() - 1) }

    final override predicate last(AstNode last, Completion c) {
      last(this.getLastChildNode(), last, c)
      or
      not exists(this.getLastChildNode()) and
      isValidFor(c, this) and
      last = this
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      StmtSequenceTree.super.succ(pred, succ, c)
    }
  }

  private class SingletonClassTree extends BodyStmtPreOrderTree, SingletonClass {
    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      (
        result = this.getValue() and i = 0 and rescuable = false
        or
        result = BodyStmtPreOrderTree.super.getBodyChild(i - 1, rescuable)
      )
    }
  }

  private class SingletonMethodTree extends BodyStmtPostOrderTree, SingletonMethod {
    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getParameter(i) and rescuable = false
      or
      result = BodyStmtPostOrderTree.super.getBodyChild(i - this.getNumberOfParameters(), rescuable)
    }

    override predicate first(AstNode first) { first(this.getObject(), first) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      BodyStmtPostOrderTree.super.succ(pred, succ, c)
      or
      last(this.getObject(), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class SplatArgumentTree extends StandardPostOrderTree, SplatArgument {
    final override ControlFlowTree getChildNode(int i) { result = this.getValue() and i = 0 }
  }

  private class SplatParameterTree extends NonDefaultValueParameterTree, SplatParameter { }

  abstract class StmtSequenceTree extends ControlFlowTree, StmtSequence {
    override predicate propagatesAbnormal(AstNode child) { none() }

    /** Gets the `i`th child in the body of this body statement. */
    AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getStmt(i) and
      rescuable = true
    }

    AstNode getLastBodyChild() {
      exists(int i |
        result = this.getBodyChild(i, _) and
        not exists(this.getBodyChild(i + 1, _))
      )
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      this instanceof PreOrderTree and
      pred = this and
      first(this.getBodyChild(0, _), succ) and
      c instanceof SimpleCompletion
      or
      this instanceof PostOrderTree and
      succ = this and
      last(this.getLastBodyChild(), pred, c) and
      c instanceof NormalCompletion
      or
      // Normal left-to-right evaluation in the body
      exists(int i |
        last(this.getBodyChild(i, _), pred, c) and
        first(this.getBodyChild(i + 1, _), succ) and
        c instanceof NormalCompletion
      )
    }
  }

  private class StringConcatenationTree extends StandardPostOrderTree, StringConcatenation {
    final override ControlFlowTree getChildNode(int i) { result = this.getString(i) }

    override predicate isHidden() { any() }
  }

  private class StringTextComponentTree extends LeafTree, StringTextComponent {
    override predicate isHidden() { any() }
  }

  private class StringEscapeSequenceComponentTree extends LeafTree, StringEscapeSequenceComponent {
    override predicate isHidden() { any() }
  }

  private class StringlikeLiteralTree extends StandardPostOrderTree, StringlikeLiteral {
    StringlikeLiteralTree() { not this instanceof HereDoc }

    final override ControlFlowTree getChildNode(int i) { result = this.getComponent(i) }
  }

  private class SuperCallTree extends StandardPostOrderTree, SuperCall {
    final override ControlFlowTree getChildNode(int i) { result = this.getArgument(i) }
  }

  private class ToplevelTree extends BodyStmtPreOrderTree, Toplevel {
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getBeginBlock(i) and rescuable = true
      or
      result = BodyStmtPreOrderTree.super.getBodyChild(i - count(this.getABeginBlock()), rescuable)
    }

    override predicate isHidden() { any() }
  }

  private class TuplePatternTree extends StandardPostOrderTree, TuplePattern {
    final override ControlFlowTree getChildNode(int i) { result = this.getElement(i) }
  }

  private class UnaryOperationTree extends StandardPostOrderTree, UnaryOperation {
    // Logical NOT is handled separately
    UnaryOperationTree() { not this instanceof NotExpr }

    final override ControlFlowTree getChildNode(int i) { result = this.getOperand() and i = 0 }
  }

  private class UndefStmtTree extends StandardPreOrderTree, UndefStmt {
    final override ControlFlowTree getChildNode(int i) { result = this.getMethodName(i) }
  }

  private class WhenTree extends PreOrderTree, WhenExpr {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getAPattern() }

    final Expr getLastPattern() {
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
      exists(int i, Expr p, boolean b |
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

  // TODO: make post-order
  private class YieldCallTree extends StandardPreOrderTree, YieldCall {
    final override ControlFlowTree getChildNode(int i) { result = this.getArgument(i) }
  }

  /** Gets a child of `n` that is in CFG scope `scope`. */
  pragma[noinline]
  private AstNode getAChildInScope(AstNode n, CfgScope scope) {
    result.getParent() = n and
    scope = getCfgScope(result)
  }
}

private Scope parent(Scope n) {
  result = n.getOuterScope() and
  not n instanceof CfgScope::Range_
}

cached
private module Cached {
  /** Gets the CFG scope of node `n`. */
  cached
  CfgScope getCfgScope(AstNode n) {
    result = parent*(ASTInternal::fromGenerated(scopeOf(ASTInternal::toGenerated(n))))
  }

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
    TAstCfgNode(AstNode n, Splits splits) {
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
      result = TAstCfgNode(succElement, succSplits)
    )
    or
    exists(AstNode predNode, Splits predSplits | pred = TAstCfgNode(predNode, predSplits) |
      exists(CfgScope scope, boolean normal |
        succExitSplits(predNode, predSplits, scope, t) and
        (if isAbnormalExitType(t) then normal = false else normal = true) and
        result = TAnnotatedExitNode(scope, normal)
      )
      or
      exists(AstNode succElement, Splits succSplits, Completion c |
        succSplits(predNode, predSplits, succElement, succSplits, c) and
        t = c.getAMatchingSuccessorType() and
        result = TAstCfgNode(succElement, succSplits)
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
