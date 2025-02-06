/**
 * Provides an implementation for constructing control-flow graphs (CFGs) from
 * abstract syntax trees (ASTs), using the shared library from `codeql.controlflow.Cfg`.
 */

private import codeql.controlflow.Cfg as CfgShared
private import codeql.ruby.AST
private import codeql.ruby.AST as Ast
private import codeql.ruby.ast.internal.AST as AstInternal
private import codeql.ruby.ast.internal.Scope
private import codeql.ruby.ast.internal.Synthesis
private import codeql.ruby.ast.Scope
private import codeql.ruby.ast.internal.TreeSitter
private import codeql.ruby.ast.internal.Variable
private import codeql.ruby.controlflow.ControlFlowGraph
private import Completion

class AstNode extends Ast::AstNode {
  AstNode() { not any(Synthesis s).excludeFromControlFlowTree(this) }
}

private module CfgInput implements CfgShared::InputSig<Location> {
  private import ControlFlowGraphImpl as Impl
  private import Completion as Comp
  private import codeql.ruby.CFG as Cfg

  class AstNode = Impl::AstNode;

  class Completion = Comp::Completion;

  predicate completionIsNormal(Completion c) { c instanceof Comp::NormalCompletion }

  predicate completionIsSimple(Completion c) { c instanceof Comp::SimpleCompletion }

  predicate completionIsValidFor(Completion c, AstNode e) { c.isValidFor(e) }

  class CfgScope = Cfg::CfgScope;

  CfgScope getCfgScope(AstNode n) { result = Impl::getCfgScope(n) }

  predicate scopeFirst(CfgScope scope, AstNode first) { scope.(Impl::CfgScopeImpl).entry(first) }

  predicate scopeLast(CfgScope scope, AstNode last, Completion c) {
    scope.(Impl::CfgScopeImpl).exit(last, c)
  }

  class SuccessorType = Cfg::SuccessorType;

  SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

  predicate successorTypeIsSimple(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::NormalSuccessor
  }

  predicate successorTypeIsCondition(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::ConditionalSuccessor
  }

  predicate isAbnormalExitType(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::RaiseSuccessor or
    t instanceof Cfg::SuccessorTypes::ExitSuccessor
  }

  private predicate id(Ruby::AstNode node1, Ruby::AstNode node2) { node1 = node2 }

  private predicate idOf(Ruby::AstNode node, int id) = equivalenceRelation(id/2)(node, id)

  int idOfAstNode(AstNode node) { idOf(AstInternal::toGeneratedInclSynth(node), result) }

  int idOfCfgScope(CfgScope node) { result = idOfAstNode(node) }
}

private module CfgSplittingInput implements CfgShared::SplittingInputSig<Location, CfgInput> {
  private import Splitting as S

  class SplitKindBase = S::TSplitKind;

  class Split = S::Split;
}

private module ConditionalCompletionSplittingInput implements
  CfgShared::ConditionalCompletionSplittingInputSig<Location, CfgInput, CfgSplittingInput>
{
  import Splitting::ConditionalCompletionSplitting::ConditionalCompletionSplittingInput
}

import CfgShared::MakeWithSplitting<Location, CfgInput, CfgSplittingInput, ConditionalCompletionSplittingInput>

abstract class CfgScopeImpl extends AstNode {
  abstract predicate entry(AstNode first);

  abstract predicate exit(AstNode last, Completion c);
}

private class ToplevelScope extends CfgScopeImpl, Toplevel {
  final override predicate entry(AstNode first) { first(this, first) }

  final override predicate exit(AstNode last, Completion c) { last(this, last, c) }
}

private class EndBlockScope extends CfgScopeImpl, EndBlock {
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

private class BodyStmtCallableScope extends CfgScopeImpl, AstInternal::TBodyStmt, Callable {
  final override predicate entry(AstNode first) { this.(Trees::BodyStmtTree).firstInner(first) }

  final override predicate exit(AstNode last, Completion c) {
    this.(Trees::BodyStmtTree).lastInner(last, c)
  }
}

private class BraceBlockScope extends CfgScopeImpl, BraceBlock {
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

/** Holds if `first` is first executed when entering `scope`. */
pragma[nomagic]
predicate succEntry(CfgScopeImpl scope, AstNode first) { scope.entry(first) }

/** Holds if `last` with completion `c` can exit `scope`. */
pragma[nomagic]
predicate succExit(CfgScopeImpl scope, AstNode last, Completion c) { scope.exit(last, c) }

/** Defines the CFG by dispatch on the various AST types. */
module Trees {
  private class AliasStmtTree extends StandardPreOrderTree instanceof AliasStmt {
    final override ControlFlowTree getChildNode(int i) {
      result = super.getNewName() and i = 0
      or
      result = super.getOldName() and i = 1
    }
  }

  private class ArgumentListTree extends StandardPostOrderTree instanceof ArgumentList {
    final override ControlFlowTree getChildNode(int i) { result = super.getElement(i) }
  }

  private class AssignExprTree extends StandardPostOrderTree instanceof AssignExpr {
    AssignExprTree() {
      exists(Expr left | left = super.getLeftOperand() |
        left instanceof VariableAccess or
        left instanceof ConstantAccess
      )
    }

    final override ControlFlowTree getChildNode(int i) {
      result = super.getLeftOperand() and i = 0
      or
      result = super.getRightOperand() and i = 1
    }
  }

  private class BeginTree extends BodyStmtTree instanceof BeginExpr {
    final override predicate first(AstNode first) { this.firstInner(first) }

    final override predicate last(AstNode last, Completion c) { this.lastInner(last, c) }

    final override predicate propagatesAbnormal(AstNode child) { none() }
  }

  private class BlockArgumentTree extends StandardPostOrderTree instanceof BlockArgument {
    final override ControlFlowTree getChildNode(int i) { result = super.getValue() and i = 0 }
  }

  abstract private class NonDefaultValueParameterTree extends ControlFlowTree instanceof NamedParameter
  {
    final override predicate first(AstNode first) {
      super.getDefiningAccess().(ControlFlowTree).first(first)
      or
      not exists(super.getDefiningAccess()) and first = this
    }

    final override predicate last(AstNode last, Completion c) {
      super.getDefiningAccess().(ControlFlowTree).last(last, c)
      or
      not exists(super.getDefiningAccess()) and
      last = this and
      c.isValidFor(this)
    }

    override predicate propagatesAbnormal(AstNode child) {
      super.getDefiningAccess().(ControlFlowTree).propagatesAbnormal(child)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) { none() }
  }

  private class BlockParameterTree extends NonDefaultValueParameterTree instanceof BlockParameter {
  }

  abstract class BodyStmtTree extends StmtSequenceTree instanceof BodyStmt {
    /** Gets a rescue clause in this block. */
    final RescueClause getARescue() { result = super.getRescue(_) }

    /** Gets the `ensure` clause in this block, if any. */
    final StmtSequence getEnsure() { result = super.getEnsure() }

    override predicate first(AstNode first) { first = this }

    predicate firstInner(AstNode first) {
      first(this.getBodyChild(0, _), first)
      or
      not exists(this.getBodyChild(_, _)) and
      (
        first(super.getRescue(_), first)
        or
        not exists(super.getRescue(_)) and
        first(super.getEnsure(), first)
      )
    }

    predicate lastInner(AstNode last, Completion c) {
      exists(boolean ensurable | last = this.getAnEnsurePredecessor(c, ensurable) |
        not super.hasEnsure()
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
      not exists(super.getRescue(_)) and
      this.lastEnsure0(last, c)
      or
      last([super.getEnsure().(AstNode), this.getBodyChild(_, false)], last, c) and
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
      first(super.getRescue(0), succ) and
      c instanceof RaiseCompletion
      or
      // Flow from one `rescue` clause to the next when there is no match
      exists(RescueTree rescue, int i | rescue = super.getRescue(i) |
        rescue.lastNoMatch(pred, c) and
        first(super.getRescue(i + 1), succ)
      )
      or
      // Flow from body to `else` block when no exception
      this.lastBody(pred, c, _) and
      first(super.getElse(), succ) and
      c instanceof NormalCompletion
      or
      // Flow into `ensure` block
      pred = this.getAnEnsurePredecessor(c, true) and
      first(super.getEnsure(), succ)
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
        not exists(super.getElse())
        or
        // Any completion will continue to the `ensure` block when there are no `rescue`
        // blocks
        not exists(super.getRescue(_))
      )
      or
      // Last element from any matching `rescue` block continues to the `ensure` block
      last(super.getRescue(_), result, c) and
      ensurable = true
      or
      // If the last `rescue` block does not match, continue to the `ensure` block
      exists(int lst, MatchingCompletion mc |
        super.getRescue(lst).(RescueTree).lastNoMatch(result, mc) and
        mc.getValue() = false and
        not exists(super.getRescue(lst + 1)) and
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
      last(super.getElse(), result, c) and
      ensurable = true
    }

    pragma[nomagic]
    private predicate lastEnsure0(AstNode last, Completion c) { last(super.getEnsure(), last, c) }

    /**
     * Gets a descendant that belongs to the `ensure` block of this block, if any.
     * Nested `ensure` blocks are not included.
     */
    pragma[nomagic]
    AstNode getAnEnsureDescendant() {
      result = super.getEnsure()
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
        innerEnsure = innerBlock.getEnsure()
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

  private class BooleanLiteralTree extends LeafTree instanceof BooleanLiteral { }

  class BraceBlockTree extends StmtSequenceTree instanceof BraceBlock {
    final override predicate propagatesAbnormal(AstNode child) { none() }

    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = super.getParameter(i) and rescuable = false
      or
      result = super.getLocalVariable(i - super.getNumberOfParameters()) and rescuable = false
      or
      result =
        StmtSequenceTree.super
            .getBodyChild(i - super.getNumberOfParameters() - count(super.getALocalVariable()),
              rescuable)
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

  private class CallTree extends StandardPostOrderTree instanceof Call {
    CallTree() {
      // Logical operations are handled separately
      not this instanceof UnaryLogicalOperation and
      not this instanceof BinaryLogicalOperation and
      // Calls with the `&.` operator are desugared
      not this.(MethodCall).isSafeNavigation()
    }

    override ControlFlowTree getChildNode(int i) { result = super.getArgument(i) }
  }

  private class CaseTree extends PostOrderTree instanceof CaseExpr, AstInternal::TCaseExpr {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getValue() or child = super.getABranch()
    }

    final override predicate first(AstNode first) {
      first(super.getValue(), first)
      or
      not exists(super.getValue()) and first(super.getBranch(0), first)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getValue(), pred, c) and
      first(super.getBranch(0), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i, WhenTree branch | branch = super.getBranch(i) |
        pred = branch and
        first(super.getBranch(i + 1), succ) and
        c.isValidFor(branch) and
        c.(ConditionalCompletion).getValue() = false
      )
      or
      succ = this and
      c instanceof NormalCompletion and
      (
        last(super.getValue(), pred, c) and not exists(super.getABranch())
        or
        last(super.getABranch().(WhenClause).getBody(), pred, c)
        or
        exists(int i, ControlFlowTree lastBranch |
          lastBranch = super.getBranch(i) and
          not exists(super.getBranch(i + 1)) and
          last(lastBranch, pred, c)
        )
      )
    }
  }

  private class CaseMatchTree extends PostOrderTree instanceof CaseExpr, AstInternal::TCaseMatch {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getValue() or child = super.getABranch()
    }

    final override predicate first(AstNode first) { first(super.getValue(), first) }

    final override predicate last(AstNode last, Completion c) {
      super.last(last, c)
      or
      not exists(super.getElseBranch()) and
      exists(MatchingCompletion lc, AstNode lastBranch |
        lastBranch = max(int i | | super.getBranch(i) order by i) and
        lc.getValue() = false and
        last(lastBranch, last, lc) and
        c instanceof RaiseCompletion and
        not c instanceof NestedCompletion
      )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getValue(), pred, c) and
      first(super.getBranch(0), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i, AstNode branch | branch = super.getBranch(i) |
        last(branch, pred, c) and
        first(super.getBranch(i + 1), succ) and
        c.(MatchingCompletion).getValue() = false
      )
      or
      succ = this and
      c instanceof NormalCompletion and
      (
        last(super.getABranch(), pred, c) and
        not c.(MatchingCompletion).getValue() = false
        or
        last(super.getElseBranch(), pred, c)
      )
    }
  }

  private class PatternVariableAccessTree extends LocalVariableAccessTree instanceof LocalVariableWriteAccess,
    CasePattern
  {
    final override predicate last(AstNode last, Completion c) {
      super.last(last, c) and
      c.(MatchingCompletion).getValue() = true
    }
  }

  private class ArrayPatternTree extends ControlFlowTree instanceof ArrayPattern {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getClass() or
      child = super.getPrefixElement(_) or
      child = super.getRestVariableAccess() or
      child = super.getSuffixElement(_)
    }

    final override predicate first(AstNode first) {
      first(super.getClass(), first)
      or
      not exists(super.getClass()) and first = this
    }

    final override predicate last(AstNode last, Completion c) {
      c.(MatchingCompletion).getValue() = false and
      (
        last = this and
        c.isValidFor(this)
        or
        exists(AstNode node |
          node = super.getClass() or
          node = super.getPrefixElement(_) or
          node = super.getSuffixElement(_)
        |
          last(node, last, c)
        )
      )
      or
      c.(MatchingCompletion).getValue() = true and
      last = this and
      c.isValidFor(this) and
      not exists(super.getPrefixElement(_)) and
      not exists(super.getRestVariableAccess())
      or
      c.(MatchingCompletion).getValue() = true and
      last(max(int i | | super.getPrefixElement(i) order by i), last, c) and
      not exists(super.getRestVariableAccess())
      or
      last(super.getRestVariableAccess(), last, c) and
      not exists(super.getSuffixElement(_))
      or
      c.(MatchingCompletion).getValue() = true and
      last(max(int i | | super.getSuffixElement(i) order by i), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getClass(), pred, c) and
      succ = this and
      c.(MatchingCompletion).getValue() = true
      or
      exists(AstNode next |
        pred = this and
        c.(MatchingCompletion).getValue() = true and
        first(next, succ)
      |
        next = super.getPrefixElement(0)
        or
        not exists(super.getPrefixElement(_)) and
        next = super.getRestVariableAccess()
      )
      or
      last(max(int i | | super.getPrefixElement(i) order by i), pred, c) and
      first(super.getRestVariableAccess(), succ) and
      c.(MatchingCompletion).getValue() = true
      or
      exists(int i |
        last(super.getPrefixElement(i), pred, c) and
        first(super.getPrefixElement(i + 1), succ) and
        c.(MatchingCompletion).getValue() = true
      )
      or
      last(super.getRestVariableAccess(), pred, c) and
      first(super.getSuffixElement(0), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i |
        last(super.getSuffixElement(i), pred, c) and
        first(super.getSuffixElement(i + 1), succ) and
        c.(MatchingCompletion).getValue() = true
      )
    }
  }

  private class FindPatternTree extends ControlFlowTree instanceof FindPattern {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getClass() or
      child = super.getPrefixVariableAccess() or
      child = super.getElement(_) or
      child = super.getSuffixVariableAccess()
    }

    final override predicate first(AstNode first) {
      first(super.getClass(), first)
      or
      not exists(super.getClass()) and first = this
    }

    final override predicate last(AstNode last, Completion c) {
      last(super.getSuffixVariableAccess(), last, c)
      or
      last(max(int i | | super.getElement(i) order by i), last, c) and
      not exists(super.getSuffixVariableAccess())
      or
      c.(MatchingCompletion).getValue() = false and
      (
        last = this and
        c.isValidFor(this)
        or
        exists(AstNode node | node = super.getClass() or node = super.getElement(_) |
          last(node, last, c)
        )
      )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getClass(), pred, c) and
      succ = this and
      c.(MatchingCompletion).getValue() = true
      or
      exists(AstNode next |
        pred = this and
        c.(MatchingCompletion).getValue() = true and
        first(next, succ)
      |
        next = super.getPrefixVariableAccess()
        or
        not exists(super.getPrefixVariableAccess()) and
        next = super.getElement(0)
      )
      or
      last(super.getPrefixVariableAccess(), pred, c) and
      first(super.getElement(0), succ) and
      c instanceof SimpleCompletion
      or
      c.(MatchingCompletion).getValue() = true and
      exists(int i |
        last(super.getElement(i), pred, c) and
        first(super.getElement(i + 1), succ)
      )
      or
      c.(MatchingCompletion).getValue() = true and
      last(max(int i | | super.getElement(i) order by i), pred, c) and
      first(super.getSuffixVariableAccess(), succ)
    }
  }

  private class HashPatternTree extends ControlFlowTree instanceof HashPattern {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getClass() or
      child = super.getValue(_) or
      child = super.getRestVariableAccess()
    }

    final override predicate first(AstNode first) {
      first(super.getClass(), first)
      or
      not exists(super.getClass()) and first = this
    }

    final override predicate last(AstNode last, Completion c) {
      c.(MatchingCompletion).getValue() = false and
      (
        last = this and
        c.isValidFor(this)
        or
        exists(AstNode node |
          node = super.getClass() or
          node = super.getValue(_)
        |
          last(node, last, c)
        )
      )
      or
      c.(MatchingCompletion).getValue() = true and
      last = this and
      not exists(super.getValue(_)) and
      not exists(super.getRestVariableAccess())
      or
      c.(MatchingCompletion).getValue() = true and
      last(max(int i | | super.getValue(i) order by i), last, c) and
      not exists(super.getRestVariableAccess())
      or
      last(super.getRestVariableAccess(), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getClass(), pred, c) and
      succ = this and
      c.(MatchingCompletion).getValue() = true
      or
      exists(AstNode next |
        pred = this and
        c.(MatchingCompletion).getValue() = true and
        first(next, succ)
      |
        next = super.getValue(0)
        or
        not exists(super.getValue(_)) and
        next = super.getRestVariableAccess()
      )
      or
      last(max(int i | | super.getValue(i) order by i), pred, c) and
      first(super.getRestVariableAccess(), succ) and
      c.(MatchingCompletion).getValue() = true
      or
      exists(int i |
        last(super.getValue(i), pred, c) and
        first(super.getValue(i + 1), succ) and
        c.(MatchingCompletion).getValue() = true
      )
    }
  }

  private class LineLiteralTree extends LeafTree instanceof LineLiteral { }

  private class FileLiteralTree extends LeafTree instanceof FileLiteral { }

  private class EncodingLiteralTree extends LeafTree instanceof EncodingLiteral { }

  private class AlternativePatternTree extends PreOrderTree instanceof AlternativePattern {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getAnAlternative() }

    final override predicate last(AstNode last, Completion c) {
      last(super.getAnAlternative(), last, c) and
      c.(MatchingCompletion).getValue() = true
      or
      last(max(int i | | super.getAlternative(i) order by i), last, c) and
      c.(MatchingCompletion).getValue() = false
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(super.getAlternative(0), succ) and
      c instanceof SimpleCompletion
      or
      exists(int i |
        last(super.getAlternative(i), pred, c) and
        first(super.getAlternative(i + 1), succ) and
        c.(MatchingCompletion).getValue() = false
      )
    }
  }

  private class AsPatternTree extends PreOrderTree instanceof AsPattern {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getPattern() }

    final override predicate last(AstNode last, Completion c) {
      last(super.getPattern(), last, c) and
      c.(MatchingCompletion).getValue() = false
      or
      last(super.getVariableAccess(), last, any(SimpleCompletion x)) and
      c.(MatchingCompletion).getValue() = true and
      not c instanceof NestedCompletion
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(super.getPattern(), succ) and
      c instanceof SimpleCompletion
      or
      last(super.getPattern(), pred, c) and
      first(super.getVariableAccess(), succ) and
      c.(MatchingCompletion).getValue() = true
    }
  }

  private class ParenthesizedPatternTree extends StandardPreOrderTree instanceof ParenthesizedPattern
  {
    override ControlFlowTree getChildNode(int i) { result = super.getPattern() and i = 0 }
  }

  private class ReferencePatternTree extends StandardPreOrderTree instanceof ReferencePattern {
    override ControlFlowTree getChildNode(int i) { result = super.getExpr() and i = 0 }
  }

  private class InClauseTree extends PreOrderTree instanceof InClause {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getPattern() or
      child = super.getCondition()
    }

    private predicate lastCondition(AstNode last, BooleanCompletion c, boolean flag) {
      last(super.getCondition(), last, c) and
      (
        flag = true and super.hasIfCondition()
        or
        flag = false and super.hasUnlessCondition()
      )
    }

    final override predicate last(AstNode last, Completion c) {
      last(super.getPattern(), last, c) and
      c.(MatchingCompletion).getValue() = false
      or
      exists(BooleanCompletion bc, boolean flag, MatchingCompletion mc |
        this.lastCondition(last, bc, flag) and
        c =
          any(NestedMatchingCompletion nmc |
            nmc.getInnerCompletion() = bc and nmc.getOuterCompletion() = mc
          )
      |
        mc.getValue() = false and
        bc.getValue() = flag.booleanNot()
        or
        not exists(super.getBody()) and
        mc.getValue() = true and
        bc.getValue() = flag
      )
      or
      last(super.getBody(), last, c)
      or
      not exists(super.getBody()) and
      not exists(super.getCondition()) and
      last(super.getPattern(), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(super.getPattern(), succ) and
      c instanceof SimpleCompletion
      or
      exists(Expr next |
        last(super.getPattern(), pred, c) and
        c.(MatchingCompletion).getValue() = true and
        first(next, succ)
      |
        next = super.getCondition()
        or
        not exists(super.getCondition()) and next = super.getBody()
      )
      or
      exists(boolean flag |
        this.lastCondition(pred, c, flag) and
        c.(BooleanCompletion).getValue() = flag and
        first(super.getBody(), succ)
      )
    }
  }

  private class CharacterTree extends LeafTree instanceof CharacterLiteral { }

  private class ClassDeclarationTree extends NamespaceTree instanceof ClassDeclaration {
    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = super.getScopeExpr() and i = 0 and rescuable = false
      or
      result = super.getSuperclassExpr() and
      i = count(super.getScopeExpr()) and
      rescuable = true
      or
      result =
        super
            .getBodyChild(i - count(super.getScopeExpr()) - count(super.getSuperclassExpr()),
              rescuable)
    }
  }

  private class ClassVariableTree extends LeafTree instanceof ClassVariableAccess { }

  private class ConditionalExprTree extends PostOrderTree instanceof ConditionalExpr {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getCondition() or child = super.getBranch(_)
    }

    final override predicate first(AstNode first) { first(super.getCondition(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      exists(boolean b |
        last(super.getCondition(), pred, c) and
        b = c.(BooleanCompletion).getValue()
      |
        first(super.getBranch(b), succ)
        or
        not exists(super.getBranch(b)) and
        succ = this
      )
      or
      last(super.getBranch(_), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class ConditionalLoopTree extends PostOrderTree instanceof ConditionalLoop {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getCondition() }

    final override predicate first(AstNode first) { first(super.getCondition(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getCondition(), pred, c) and
      super.entersLoopWhenConditionIs(c.(BooleanCompletion).getValue()) and
      first(super.getBody(), succ)
      or
      last(super.getBody(), pred, c) and
      first(super.getCondition(), succ) and
      c.continuesLoop()
      or
      last(super.getBody(), pred, c) and
      first(super.getBody(), succ) and
      c instanceof RedoCompletion
      or
      succ = this and
      (
        last(super.getCondition(), pred, c) and
        super.entersLoopWhenConditionIs(c.(BooleanCompletion).getValue().booleanNot())
        or
        last(super.getBody(), pred, c) and
        not c.continuesLoop() and
        not c instanceof BreakCompletion and
        not c instanceof RedoCompletion
        or
        last(super.getBody(), pred, c.(NestedBreakCompletion).getAnInnerCompatibleCompletion())
      )
    }
  }

  private class ConstantAccessTree extends PostOrderTree instanceof ConstantAccess {
    ConstantAccessTree() {
      not this instanceof ClassDeclaration and
      not this instanceof ModuleDeclaration and
      // constant accesses with scope expression in compound assignments are desugared
      not (
        this = any(AssignOperation op).getLeftOperand() and
        exists(super.getScopeExpr())
      )
    }

    final override predicate propagatesAbnormal(AstNode child) { child = super.getScopeExpr() }

    final override predicate first(AstNode first) {
      first(super.getScopeExpr(), first)
      or
      not exists(super.getScopeExpr()) and
      first = this
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getScopeExpr(), pred, c) and
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
        c.(MatchingCompletion).getValue() = true and
        c.isValidFor(this)
      )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this.getAccessNode() and
      first(this.getDefaultValueExpr(), succ) and
      c.(MatchingCompletion).getValue() = false
    }
  }

  private class DestructuredParameterTree extends StandardPostOrderTree instanceof DestructuredParameter
  {
    final override ControlFlowTree getChildNode(int i) { result = super.getElement(i) }
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

  private class DoBlockTree extends BodyStmtTree instanceof DoBlock {
    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = super.getParameter(i) and rescuable = false
      or
      result = super.getLocalVariable(i - super.getNumberOfParameters()) and rescuable = false
      or
      result =
        BodyStmtTree.super
            .getBodyChild(i - super.getNumberOfParameters() - count(super.getALocalVariable()),
              rescuable)
    }

    override predicate propagatesAbnormal(AstNode child) { none() }
  }

  private class EmptyStatementTree extends LeafTree instanceof EmptyStmt { }

  class EndBlockTree extends StmtSequenceTree instanceof EndBlock {
    override predicate first(AstNode first) { first = this }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Normal left-to-right evaluation in the body
      exists(int i |
        last(super.getBodyChild(i, _), pred, c) and
        first(super.getBodyChild(i + 1, _), succ) and
        c instanceof NormalCompletion
      )
    }
  }

  private class ForwardedArgumentsTree extends LeafTree instanceof ForwardedArguments { }

  private class ForwardParameterTree extends LeafTree instanceof ForwardParameter { }

  private class GlobalVariableTree extends LeafTree instanceof GlobalVariableAccess { }

  private class HashSplatNilParameterTree extends LeafTree instanceof HashSplatNilParameter { }

  private class HashSplatParameterTree extends NonDefaultValueParameterTree instanceof HashSplatParameter
  { }

  private class HereDocTree extends StandardPostOrderTree instanceof HereDoc {
    final override ControlFlowTree getChildNode(int i) { result = super.getComponent(i) }
  }

  private class InstanceVariableTree extends StandardPostOrderTree instanceof InstanceVariableAccess
  {
    final override ControlFlowTree getChildNode(int i) { result = super.getReceiver() and i = 0 }
  }

  private class KeywordParameterTree extends DefaultValueParameterTree instanceof KeywordParameter {
    final override Expr getDefaultValueExpr() { result = super.getDefaultValue() }

    final override AstNode getAccessNode() { result = super.getDefiningAccess() }
  }

  private class LambdaTree extends BodyStmtTree instanceof Lambda {
    final override predicate propagatesAbnormal(AstNode child) { none() }

    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = super.getParameter(i) and rescuable = false
      or
      result = BodyStmtTree.super.getBodyChild(i - super.getNumberOfParameters(), rescuable)
    }
  }

  private class LocalVariableAccessTree extends LeafTree instanceof LocalVariableAccess { }

  private class LogicalAndTree extends PostOrderTree instanceof LogicalAndExpr {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getAnOperand() }

    final override predicate first(AstNode first) { first(super.getLeftOperand(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getLeftOperand(), pred, c) and
      c instanceof TrueCompletion and
      first(super.getRightOperand(), succ)
      or
      last(super.getLeftOperand(), pred, c) and
      c instanceof FalseCompletion and
      succ = this
      or
      last(super.getRightOperand(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class LogicalNotTree extends PostOrderTree instanceof NotExpr {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getOperand() }

    final override predicate first(AstNode first) { first(super.getOperand(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      succ = this and
      last(super.getOperand(), pred, c) and
      c instanceof NormalCompletion
    }
  }

  private class LogicalOrTree extends PostOrderTree instanceof LogicalOrExpr {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getAnOperand() }

    final override predicate first(AstNode first) { first(super.getLeftOperand(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getLeftOperand(), pred, c) and
      c instanceof FalseCompletion and
      first(super.getRightOperand(), succ)
      or
      last(super.getLeftOperand(), pred, c) and
      c instanceof TrueCompletion and
      succ = this
      or
      last(super.getRightOperand(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class MethodCallTree extends CallTree instanceof MethodCall {
    final override ControlFlowTree getChildNode(int i) {
      result = super.getReceiver() and i = 0
      or
      result = super.getArgument(i - 1)
      or
      result = super.getBlock() and i = 1 + super.getNumberOfArguments()
    }
  }

  private class MethodNameTree extends LeafTree instanceof MethodName, AstInternal::TTokenMethodName
  { }

  private class MethodTree extends BodyStmtTree instanceof Method {
    final override predicate propagatesAbnormal(AstNode child) { none() }

    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = super.getParameter(i) and rescuable = false
      or
      result = BodyStmtTree.super.getBodyChild(i - super.getNumberOfParameters(), rescuable)
    }
  }

  private class ModuleDeclarationTree extends NamespaceTree instanceof ModuleDeclaration {
    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = super.getScopeExpr() and i = 0 and rescuable = false
      or
      result = NamespaceTree.super.getBodyChild(i - count(super.getScopeExpr()), rescuable)
    }
  }

  /**
   * Namespaces (i.e. modules or classes) behave like other `BodyStmt`s except they are
   * executed in pre-order rather than post-order. We do this in order to insert a write for
   * `self` before any subsequent reads in the namespace body.
   */
  private class NamespaceTree extends BodyStmtTree instanceof Namespace {
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

  private class NilTree extends LeafTree instanceof NilLiteral { }

  private class NumericLiteralTree extends LeafTree instanceof NumericLiteral { }

  private class OptionalParameterTree extends DefaultValueParameterTree instanceof OptionalParameter
  {
    final override Expr getDefaultValueExpr() { result = super.getDefaultValue() }

    final override AstNode getAccessNode() { result = super.getDefiningAccess() }
  }

  private class PairTree extends StandardPostOrderTree instanceof Pair {
    final override ControlFlowTree getChildNode(int i) {
      result = super.getKey() and i = 0
      or
      result = super.getValue() and i = 1
    }
  }

  private class RangeLiteralTree extends StandardPostOrderTree instanceof RangeLiteral {
    final override ControlFlowTree getChildNode(int i) {
      result = super.getBegin() and i = 0
      or
      result = super.getEnd() and i = 1
    }
  }

  private class RedoStmtTree extends LeafTree instanceof RedoStmt { }

  private class RescueModifierTree extends PostOrderTree instanceof RescueModifierExpr {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getHandler() }

    final override predicate first(AstNode first) { first(super.getBody(), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getBody(), pred, c) and
      (
        c instanceof RaiseCompletion and
        first(super.getHandler(), succ)
        or
        not c instanceof RaiseCompletion and
        succ = this
      )
      or
      last(super.getHandler(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class RescueTree extends PostOrderTree instanceof RescueClause {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getAnException() or
      child = super.getBody()
    }

    final override predicate first(AstNode first) {
      first(super.getException(0), first)
      or
      not exists(super.getException(0)) and
      (
        first(super.getVariableExpr(), first)
        or
        not exists(super.getVariableExpr()) and
        (
          first(super.getBody(), first)
          or
          not exists(super.getBody()) and first = this
        )
      )
    }

    private Expr getLastException() {
      exists(int i | result = super.getException(i) and not exists(super.getException(i + 1)))
    }

    predicate lastNoMatch(AstNode last, Completion c) {
      last(this.getLastException(), last, c) and
      c.(MatchingCompletion).getValue() = false
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getAnException(), pred, c) and
      c.(MatchingCompletion).getValue() = true and
      (
        first(super.getVariableExpr(), succ)
        or
        not exists(super.getVariableExpr()) and
        (
          first(super.getBody(), succ)
          or
          not exists(super.getBody()) and succ = this
        )
      )
      or
      exists(int i |
        last(super.getException(i), pred, c) and
        c.(MatchingCompletion).getValue() = false and
        first(super.getException(i + 1), succ)
      )
      or
      last(super.getVariableExpr(), pred, c) and
      c instanceof NormalCompletion and
      (
        first(super.getBody(), succ)
        or
        not exists(super.getBody()) and succ = this
      )
      or
      last(super.getBody(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class RetryStmtTree extends LeafTree instanceof RetryStmt { }

  private class ReturningStmtTree extends StandardPostOrderTree instanceof ReturningStmt {
    final override ControlFlowTree getChildNode(int i) { result = super.getValue() and i = 0 }
  }

  private class SimpleParameterTree extends NonDefaultValueParameterTree instanceof SimpleParameter {
  }

  // Corner case: For duplicated '_' parameters, only the first occurrence has a defining
  // access. For subsequent parameters we simply include the parameter itself in the CFG
  private class SimpleParameterTreeDupUnderscore extends LeafTree instanceof SimpleParameter {
    SimpleParameterTreeDupUnderscore() { not exists(this.getDefiningAccess()) }
  }

  private class SingletonClassTree extends BodyStmtTree instanceof SingletonClass {
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
        result = super.getValue() and i = 0 and rescuable = false
        or
        result = BodyStmtTree.super.getBodyChild(i - 1, rescuable)
      )
    }
  }

  private class SingletonMethodTree extends BodyStmtTree instanceof SingletonMethod {
    final override predicate propagatesAbnormal(AstNode child) { none() }

    /** Gets the `i`th child in the body of this block. */
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = super.getParameter(i) and rescuable = false
      or
      result = BodyStmtTree.super.getBodyChild(i - super.getNumberOfParameters(), rescuable)
    }

    override predicate first(AstNode first) { first(super.getObject(), first) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      BodyStmtTree.super.succ(pred, succ, c)
      or
      last(super.getObject(), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class SplatParameterTree extends NonDefaultValueParameterTree instanceof SplatParameter {
  }

  class StmtSequenceTree extends PostOrderTree instanceof StmtSequence {
    override predicate propagatesAbnormal(AstNode child) { child = super.getAStmt() }

    override predicate first(AstNode first) {
      // If this sequence contains any statements, go to the first one.
      first(super.getStmt(0), first)
      or
      // Otherwise, treat this node as a leaf node.
      not exists(super.getStmt(0)) and first = this
    }

    /** Gets the `i`th child in the body of this body statement. */
    AstNode getBodyChild(int i, boolean rescuable) {
      result = super.getStmt(i) and
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

  private class StringConcatenationTree extends StandardPostOrderTree instanceof StringConcatenation
  {
    final override ControlFlowTree getChildNode(int i) { result = super.getString(i) }
  }

  private class StringlikeLiteralTree extends StandardPostOrderTree instanceof StringlikeLiteral {
    StringlikeLiteralTree() { not this instanceof HereDoc }

    final override ControlFlowTree getChildNode(int i) { result = super.getComponent(i) }
  }

  private class StringComponentTree extends LeafTree instanceof StringComponent {
    StringComponentTree() {
      // Interpolations contain `StmtSequence`s, so they shouldn't be treated as leaf nodes.
      not this instanceof StringInterpolationComponent and
      // In the interests of brevity we treat regexes as string literals when constructing the CFG.
      // Thus we must exclude regex interpolations here too.
      not this instanceof RegExpInterpolationComponent
    }
  }

  private class ToplevelTree extends BodyStmtTree instanceof Toplevel {
    final override AstNode getBodyChild(int i, boolean rescuable) {
      result = super.getBeginBlock(i) and rescuable = true
      or
      result = BodyStmtTree.super.getBodyChild(i - count(super.getABeginBlock()), rescuable)
    }

    final override predicate first(AstNode first) { super.firstInner(first) }

    final override predicate last(AstNode last, Completion c) { super.lastInner(last, c) }
  }

  private class UndefStmtTree extends StandardPreOrderTree instanceof UndefStmt {
    final override ControlFlowTree getChildNode(int i) { result = super.getMethodName(i) }
  }

  private class WhenTree extends ControlFlowTree instanceof WhenClause {
    final override predicate propagatesAbnormal(AstNode child) {
      child = [super.getAPattern(), super.getBody()]
    }

    final Expr getLastPattern() {
      exists(int i |
        result = super.getPattern(i) and
        not exists(super.getPattern(i + 1))
      )
    }

    final override predicate first(AstNode first) { first(super.getPattern(0), first) }

    final override predicate last(AstNode last, Completion c) {
      last = this and
      c.isValidFor(this) and
      c.(ConditionalCompletion).getValue() = false
      or
      last(super.getBody(), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      c.isValidFor(this) and
      c.(ConditionalCompletion).getValue() = true and
      first(super.getBody(), succ)
      or
      exists(int i, Expr p, boolean b |
        p = super.getPattern(i) and
        last(p, pred, c) and
        b = c.(ConditionalCompletion).getValue()
      |
        b = true and
        succ = this
        or
        b = false and
        first(super.getPattern(i + 1), succ)
        or
        not exists(super.getPattern(i + 1)) and
        succ = this
      )
    }
  }
}

private Scope parent(Scope n) {
  result = n.getOuterScope() and
  not n instanceof CfgScopeImpl
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
