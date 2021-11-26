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

private import codeql.ruby.AST
private import codeql.ruby.ast.internal.AST as ASTInternal
private import codeql.ruby.ast.internal.Scope
private import codeql.ruby.ast.Scope
private import codeql.ruby.ast.internal.TreeSitter
private import codeql.ruby.ast.internal.Variable
private import codeql.ruby.controlflow.ControlFlowGraph
private import Completion
import ControlFlowGraphImplShared

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
      first(this.(Trees::EndBlockTree).getBodyChild(0, _), first)
    }

    final override predicate exit(AstNode last, Completion c) {
      last(this.(Trees::EndBlockTree).getLastBodyChild(), last, c)
      or
      last(this.(Trees::EndBlockTree).getBodyChild(_, _), last, c) and
      not c instanceof NormalCompletion
    }
  }

  private class BodyStmtCallableScope extends Range_, ASTInternal::TBodyStmt, Callable {
    final override predicate entry(AstNode first) { this.(Trees::BodyStmtTree).firstInner(first) }

    final override predicate exit(AstNode last, Completion c) {
      this.(Trees::BodyStmtTree).lastInner(last, c)
    }
  }

  private class BraceBlockScope extends Range_, BraceBlock {
    final override predicate entry(AstNode first) {
      first(this.(Trees::BraceBlockTree).getBodyChild(0, _), first)
    }

    final override predicate exit(AstNode last, Completion c) {
      last(this.(Trees::BraceBlockTree).getLastBodyChild(), last, c)
      or
      last(this.(Trees::BraceBlockTree).getBodyChild(_, _), last, c) and
      not c instanceof NormalCompletion
    }
  }
}

/** Holds if `first` is first executed when entering `scope`. */
pragma[nomagic]
predicate succEntry(CfgScope::Range_ scope, AstNode first) { scope.entry(first) }

/** Holds if `last` with completion `c` can exit `scope`. */
pragma[nomagic]
predicate succExit(CfgScope::Range_ scope, AstNode last, Completion c) { scope.exit(last, c) }

/** Defines the CFG by dispatch on the various AST types. */
module Trees {
  private class AliasStmtTree extends StandardPreOrderTree, AliasStmt {
    final override ControlFlowTree getChildElement(int i) {
      result = this.getNewName() and i = 0
      or
      result = this.getOldName() and i = 1
    }
  }

  private class ArgumentListTree extends StandardTree, ArgumentList {
    final override ControlFlowTree getChildElement(int i) { result = this.getElement(i) }

    final override predicate first(AstNode first) { first(this.getFirstChildElement(), first) }

    final override predicate last(AstNode last, Completion c) {
      last(this.getLastChildElement(), last, c)
    }
  }

  private class AssignExprTree extends StandardPostOrderTree, AssignExpr {
    AssignExprTree() {
      exists(Expr left | left = this.getLeftOperand() |
        left instanceof VariableAccess or
        left instanceof ConstantAccess
      )
    }

    final override ControlFlowTree getChildElement(int i) {
      result = this.getLeftOperand() and i = 0
      or
      result = this.getRightOperand() and i = 1
    }
  }

  private class BeginTree extends BodyStmtTree, BeginExpr {
    final override predicate first(AstNode first) { this.firstInner(first) }

    final override predicate last(AstNode last, Completion c) { this.lastInner(last, c) }

    final override predicate propagatesAbnormal(AstNode child) { none() }
  }

  private class BlockArgumentTree extends StandardPostOrderTree, BlockArgument {
    final override ControlFlowTree getChildElement(int i) { result = this.getValue() and i = 0 }
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

  abstract class BodyStmtTree extends StmtSequenceTree, BodyStmt {
    override predicate first(AstNode first) { first = this }

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
      pred = this.getAnEnsurePredecessor(c, true) and
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
    pragma[nomagic]
    AstNode getAnEnsureDescendant() {
      result = this.getEnsure()
      or
      exists(AstNode mid |
        mid = this.getAnEnsureDescendant() and
        result = mid.getAChild() and
        getCfgScope(result) = getCfgScope(mid) and
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
        innerEnsure = this.getAnEnsureDescendant().getAChild() and
        getCfgScope(innerEnsure) = getCfgScope(this) and
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

  private class BooleanLiteralTree extends LeafTree, BooleanLiteral { }

  class BraceBlockTree extends StmtSequenceTree, BraceBlock {
    final override predicate propagatesAbnormal(AstNode child) { none() }

    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getParameter(i) and rescuable = false
      or
      result = StmtSequenceTree.super.getBodyChild(i - this.getNumberOfParameters(), rescuable)
    }

    override predicate first(AstNode first) { first = this }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Normal left-to-right evaluation in the body
      exists(int i |
        last(this.getBodyChild(i, _), pred, c) and
        first(this.getBodyChild(i + 1, _), succ) and
        c instanceof NormalCompletion
      )
    }
  }

  private class CallTree extends StandardPostOrderTree, Call {
    CallTree() {
      // Logical operations are handled separately
      not this instanceof UnaryLogicalOperation and
      not this instanceof BinaryLogicalOperation
    }

    override ControlFlowTree getChildElement(int i) { result = this.getArgument(i) }
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

  private class ClassDeclarationTree extends NamespaceTree, ClassDeclaration {
    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getScopeExpr() and i = 0 and rescuable = false
      or
      result = this.getSuperclassExpr() and
      i = count(this.getScopeExpr()) and
      rescuable = true
      or
      result =
        super
            .getBodyChild(i - count(this.getScopeExpr()) - count(this.getSuperclassExpr()),
              rescuable)
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
      not this instanceof ClassDeclaration and
      not this instanceof ModuleDeclaration
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

  private class DesugaredTree extends ControlFlowTree {
    ControlFlowTree desugared;

    DesugaredTree() { desugared = this.getDesugared() }

    final override predicate propagatesAbnormal(AstNode child) {
      desugared.propagatesAbnormal(child)
    }

    final override predicate first(AstNode first) { desugared.first(first) }

    final override predicate last(AstNode last, Completion c) { desugared.last(last, c) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) { none() }
  }

  private class DoBlockTree extends BodyStmtTree, DoBlock {
    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getParameter(i) and rescuable = false
      or
      result = BodyStmtTree.super.getBodyChild(i - this.getNumberOfParameters(), rescuable)
    }

    override predicate propagatesAbnormal(AstNode child) { none() }
  }

  private class EmptyStatementTree extends LeafTree, EmptyStmt { }

  class EndBlockTree extends StmtSequenceTree, EndBlock {
    override predicate first(AstNode first) { first = this }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Normal left-to-right evaluation in the body
      exists(int i |
        last(this.getBodyChild(i, _), pred, c) and
        first(this.getBodyChild(i + 1, _), succ) and
        c instanceof NormalCompletion
      )
    }
  }

  private class ForwardParameterTree extends LeafTree, ForwardParameter { }

  private class GlobalVariableTree extends LeafTree, GlobalVariableAccess { }

  private class HashLiteralTree extends StandardPostOrderTree, HashLiteral {
    final override ControlFlowTree getChildElement(int i) { result = this.getElement(i) }
  }

  private class HashSplatParameterTree extends NonDefaultValueParameterTree, HashSplatParameter { }

  private class HereDocTree extends StandardPreOrderTree, HereDoc {
    final override ControlFlowTree getChildElement(int i) { result = this.getComponent(i) }
  }

  private class InstanceVariableTree extends LeafTree, InstanceVariableAccess { }

  private class KeywordParameterTree extends DefaultValueParameterTree, KeywordParameter {
    final override Expr getDefaultValueExpr() { result = this.getDefaultValue() }

    final override AstNode getAccessNode() { result = this.getDefiningAccess() }
  }

  private class LambdaTree extends BodyStmtTree, Lambda {
    final override predicate propagatesAbnormal(AstNode child) { none() }

    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getParameter(i) and rescuable = false
      or
      result = BodyStmtTree.super.getBodyChild(i - this.getNumberOfParameters(), rescuable)
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

  private class MethodCallTree extends CallTree, MethodCall {
    final override ControlFlowTree getChildElement(int i) {
      result = this.getReceiver() and i = 0
      or
      result = this.getArgument(i - 1)
      or
      result = this.getBlock() and i = 1 + this.getNumberOfArguments()
    }
  }

  private class MethodNameTree extends LeafTree, MethodName, ASTInternal::TTokenMethodName { }

  private class MethodTree extends BodyStmtTree, Method {
    final override predicate propagatesAbnormal(AstNode child) { none() }

    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getParameter(i) and rescuable = false
      or
      result = BodyStmtTree.super.getBodyChild(i - this.getNumberOfParameters(), rescuable)
    }
  }

  private class ModuleDeclarationTree extends NamespaceTree, ModuleDeclaration {
    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getScopeExpr() and i = 0 and rescuable = false
      or
      result = NamespaceTree.super.getBodyChild(i - count(this.getScopeExpr()), rescuable)
    }
  }

  /**
   * Namespaces (i.e. modules or classes) behave like other `BodyStmt`s except they are
   * executed in pre-order rather than post-order. We do this in order to insert a write for
   * `self` before any subsequent reads in the namespace body.
   */
  private class NamespaceTree extends BodyStmtTree, Namespace {
    final override predicate first(AstNode first) { first = this }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      BodyStmtTree.super.succ(pred, succ, c)
      or
      pred = this and
      this.firstInner(succ) and
      c instanceof SimpleCompletion
    }

    final override predicate last(AstNode last, Completion c) {
      this.lastInner(last, c)
      or
      not exists(this.getAChild(_)) and
      last = this and
      c.isValidFor(this)
    }
  }

  private class NilTree extends LeafTree, NilLiteral { }

  private class NumericLiteralTree extends LeafTree, NumericLiteral { }

  private class OptionalParameterTree extends DefaultValueParameterTree, OptionalParameter {
    final override Expr getDefaultValueExpr() { result = this.getDefaultValue() }

    final override AstNode getAccessNode() { result = this.getDefiningAccess() }
  }

  private class PairTree extends StandardPostOrderTree, Pair {
    final override ControlFlowTree getChildElement(int i) {
      result = this.getKey() and i = 0
      or
      result = this.getValue() and i = 1
    }
  }

  private class RangeLiteralTree extends StandardPostOrderTree, RangeLiteral {
    final override ControlFlowTree getChildElement(int i) {
      result = this.getBegin() and i = 0
      or
      result = this.getEnd() and i = 1
    }
  }

  private class RedoStmtTree extends LeafTree, RedoStmt { }

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
          c.isValidFor(this)
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
    final override ControlFlowTree getChildElement(int i) { result = this.getValue() and i = 0 }
  }

  private class SimpleParameterTree extends NonDefaultValueParameterTree, SimpleParameter { }

  // Corner case: For duplicated '_' parameters, only the first occurence has a defining
  // access. For subsequent parameters we simply include the parameter itself in the CFG
  private class SimpleParameterTreeDupUnderscore extends LeafTree, SimpleParameter {
    SimpleParameterTreeDupUnderscore() { not exists(this.getDefiningAccess()) }
  }

  private class SingletonClassTree extends BodyStmtTree, SingletonClass {
    final override predicate first(AstNode first) {
      this.firstInner(first)
      or
      not exists(this.getAChild(_)) and
      first = this
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      BodyStmtTree.super.succ(pred, succ, c)
      or
      succ = this and
      this.lastInner(pred, c)
    }

    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      (
        result = this.getValue() and i = 0 and rescuable = false
        or
        result = BodyStmtTree.super.getBodyChild(i - 1, rescuable)
      )
    }
  }

  private class SingletonMethodTree extends BodyStmtTree, SingletonMethod {
    final override predicate propagatesAbnormal(AstNode child) { none() }

    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getParameter(i) and rescuable = false
      or
      result = BodyStmtTree.super.getBodyChild(i - this.getNumberOfParameters(), rescuable)
    }

    override predicate first(AstNode first) { first(this.getObject(), first) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      BodyStmtTree.super.succ(pred, succ, c)
      or
      last(this.getObject(), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class SplatParameterTree extends NonDefaultValueParameterTree, SplatParameter { }

  class StmtSequenceTree extends PostOrderTree, StmtSequence {
    override predicate propagatesAbnormal(AstNode child) { child = this.getAStmt() }

    override predicate first(AstNode first) { first(this.getStmt(0), first) }

    /** Gets the `i`th child in the body of this body statement. */
    AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getStmt(i) and
      rescuable = true
    }

    final AstNode getLastBodyChild() {
      exists(int i |
        result = this.getBodyChild(i, _) and
        not exists(this.getBodyChild(i + 1, _))
      )
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Normal left-to-right evaluation in the body
      exists(int i |
        last(this.getBodyChild(i, _), pred, c) and
        first(this.getBodyChild(i + 1, _), succ) and
        c instanceof NormalCompletion
      )
      or
      succ = this and
      last(this.getLastBodyChild(), pred, c) and
      c instanceof NormalCompletion
    }
  }

  private class StringConcatenationTree extends StandardTree, StringConcatenation {
    final override ControlFlowTree getChildElement(int i) { result = this.getString(i) }

    final override predicate first(AstNode first) { first(this.getFirstChildElement(), first) }

    final override predicate last(AstNode last, Completion c) {
      last(this.getLastChildElement(), last, c)
    }
  }

  private class StringlikeLiteralTree extends StandardPostOrderTree, StringlikeLiteral {
    StringlikeLiteralTree() { not this instanceof HereDoc }

    final override ControlFlowTree getChildElement(int i) { result = this.getComponent(i) }
  }

  private class ToplevelTree extends BodyStmtTree, Toplevel {
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = this.getBeginBlock(i) and rescuable = true
      or
      result = BodyStmtTree.super.getBodyChild(i - count(this.getABeginBlock()), rescuable)
    }

    final override predicate first(AstNode first) { this.firstInner(first) }

    final override predicate last(AstNode last, Completion c) { this.lastInner(last, c) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      BodyStmtTree.super.succ(pred, succ, c)
    }
  }

  private class TuplePatternTree extends StandardPostOrderTree, TuplePattern {
    final override ControlFlowTree getChildElement(int i) { result = this.getElement(i) }
  }

  private class UndefStmtTree extends StandardPreOrderTree, UndefStmt {
    final override ControlFlowTree getChildElement(int i) { result = this.getMethodName(i) }
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
}

private Scope parent(Scope n) {
  result = n.getOuterScope() and
  not n instanceof CfgScope::Range_
}

cached
private CfgScope getCfgScopeImpl(AstNode n) { result = parent*(scopeOfInclSynth(n)) }

/** Gets the CFG scope of node `n`. */
pragma[inline]
CfgScope getCfgScope(AstNode n) {
  exists(AstNode n0 |
    pragma[only_bind_into](n0) = n and
    pragma[only_bind_into](result) = getCfgScopeImpl(n0)
  )
}

cached
private module Cached {
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
}

import Cached
