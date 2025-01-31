private import rust
import codeql.controlflow.Cfg
import Completion
private import Scope as Scope
private import codeql.rust.controlflow.ControlFlowGraph as Cfg
private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth

private module CfgInput implements InputSig<Location> {
  private import codeql.rust.internal.CachedStages
  private import rust as Rust
  private import Completion as C

  class AstNode = Rust::AstNode;

  class Completion = C::Completion;

  predicate completionIsNormal = C::completionIsNormal/1;

  predicate completionIsSimple = C::completionIsSimple/1;

  predicate completionIsValidFor = C::completionIsValidFor/2;

  /** An AST node with an associated control flow graph. */
  class CfgScope = Scope::CfgScope;

  CfgScope getCfgScope(AstNode n) {
    result = n.getEnclosingCfgScope() and
    Stages::CfgStage::ref()
  }

  class SuccessorType = Cfg::SuccessorType;

  /** Gets a successor type that matches completion `c`. */
  SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

  /**
   * Hold if `c` represents simple (normal) evaluation of a statement or an expression.
   */
  predicate successorTypeIsSimple(SuccessorType t) { t instanceof Cfg::NormalSuccessor }

  /** Holds if `t` is an abnormal exit type out of a CFG scope. */
  predicate isAbnormalExitType(SuccessorType t) { none() }

  /** Hold if `t` represents a conditional successor type. */
  predicate successorTypeIsCondition(SuccessorType t) { t instanceof Cfg::BooleanSuccessor }

  /** Holds if `first` is first executed when entering `scope`. */
  predicate scopeFirst(CfgScope scope, AstNode first) { scope.scopeFirst(first) }

  /** Holds if `scope` is exited when `last` finishes with completion `c`. */
  predicate scopeLast(CfgScope scope, AstNode last, Completion c) { scope.scopeLast(last, c) }

  private predicate id(Raw::AstNode x, Raw::AstNode y) { x = y }

  private predicate idOfDbAstNode(Raw::AstNode x, int y) = equivalenceRelation(id/2)(x, y)

  // TODO: does not work if fresh ipa entities (`ipa: on:`) turn out to be first of the block
  int idOfAstNode(AstNode node) { idOfDbAstNode(Synth::convertAstNodeToRaw(node), result) }

  int idOfCfgScope(CfgScope node) { result = idOfAstNode(node) }
}

private module CfgSplittingInput implements SplittingInputSig<Location, CfgInput> {
  private import Splitting as S

  class SplitKindBase = S::TSplitKind;

  class Split = S::Split;
}

private module ConditionalCompletionSplittingInput implements
  ConditionalCompletionSplittingInputSig<Location, CfgInput, CfgSplittingInput>
{
  import Splitting::ConditionalCompletionSplitting::ConditionalCompletionSplittingInput
}

private module CfgImpl =
  MakeWithSplitting<Location, CfgInput, CfgSplittingInput, ConditionalCompletionSplittingInput>;

import CfgImpl

class CallableScopeTree extends StandardTree, PreOrderTree, PostOrderTree, Scope::CallableScope {
  override predicate propagatesAbnormal(AstNode child) { none() }

  override AstNode getChildNode(int i) {
    i = 0 and
    result = this.getParamList().getSelfParam()
    or
    result = this.getParamList().getParam(i - 1)
    or
    i = this.getParamList().getNumberOfParams() + 1 and
    result = this.getBody()
  }
}

class ParamTree extends StandardPostOrderTree, Param {
  override AstNode getChildNode(int i) { i = 0 and result = this.getPat() }
}

class ExprStmtTree extends StandardPreOrderTree instanceof ExprStmt {
  override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
}

class FormatTemplateVariableAccessTree extends LeafTree, FormatTemplateVariableAccess { }

class ItemTree extends LeafTree, Item {
  ItemTree() {
    not this instanceof MacroCall and
    this = [any(StmtList s).getAStatement(), any(MacroStmts s).getAStatement()]
  }
}

class LetStmtTree extends PreOrderTree, LetStmt {
  final override predicate propagatesAbnormal(AstNode child) {
    child = [this.getInitializer(), this.getLetElse().getBlockExpr()]
  }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Edge to start of initializer.
    pred = this and first(this.getInitializer(), succ) and completionIsSimple(c)
    or
    // Edge to pattern when there is no initializer.
    pred = this and
    first(this.getPat(), succ) and
    completionIsSimple(c) and
    not this.hasInitializer()
    or
    // Edge from end of initializer to pattern.
    last(this.getInitializer(), pred, c) and first(this.getPat(), succ) and completionIsNormal(c)
    or
    // Edge from failed pattern to `else` branch.
    last(this.getPat(), pred, c) and
    first(this.getLetElse().getBlockExpr(), succ) and
    c.(MatchCompletion).failed()
  }

  override predicate last(AstNode node, Completion c) {
    // Edge out of a successfully matched pattern.
    last(this.getPat(), node, c) and c.(MatchCompletion).succeeded()
    // NOTE: No edge out of the `else` branch as that is guaranteed to diverge.
  }
}

class MacroCallTree extends StandardPostOrderTree, MacroCall {
  override AstNode getChildNode(int i) { i = 0 and result = this.getExpanded() }
}

class MacroStmtsTree extends StandardPreOrderTree, MacroStmts {
  override AstNode getChildNode(int i) {
    result = this.getStatement(i)
    or
    i = this.getNumberOfStatements() and
    result = this.getExpr()
  }
}

class MatchArmTree extends ControlFlowTree, MatchArm {
  override predicate propagatesAbnormal(AstNode child) { child = this.getExpr() }

  override predicate first(AstNode node) { first(this.getPat(), node) }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Edge from pattern to guard/arm if match succeeds.
    last(this.getPat(), pred, c) and
    c.(MatchCompletion).succeeded() and
    (
      first(this.getGuard().getCondition(), succ)
      or
      not this.hasGuard() and first(this.getExpr(), succ)
    )
    or
    // Edge from guard to arm if the guard succeeds.
    last(this.getGuard().getCondition(), pred, c) and
    first(this.getExpr(), succ) and
    c.(BooleanCompletion).succeeded()
  }

  override predicate last(AstNode node, Completion c) {
    last(this.getPat(), node, c) and c.(MatchCompletion).failed()
    or
    last(this.getGuard().getCondition(), node, c) and c.(BooleanCompletion).failed()
    or
    last(this.getExpr(), node, c)
  }
}

class NameTree extends LeafTree, Name { }

class NameRefTree extends LeafTree, NameRef { }

class SelfParamTree extends StandardPostOrderTree, SelfParam {
  override AstNode getChildNode(int i) { i = 0 and result = this.getName() }
}

class TypeReprTree extends LeafTree instanceof TypeRepr { }

/**
 * Provides `ControlFlowTree`s for expressions.
 *
 * Since expressions construct values, they are modeled in post-order, except for
 * `LetExpr`s.
 */
module ExprTrees {
  class ArrayExprTree extends StandardPostOrderTree, ArrayExpr {
    override AstNode getChildNode(int i) { result = this.getExpr(i) }
  }

  class AsmExprTree extends LeafTree instanceof AsmExpr { }

  class AwaitExprTree extends StandardPostOrderTree instanceof AwaitExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }

  // NOTE: `become` is a reserved but unused keyword.
  class BecomeExprTree extends StandardPostOrderTree instanceof BecomeExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }

  class BinaryOpExprTree extends StandardPostOrderTree instanceof BinaryExpr {
    BinaryOpExprTree() { not this instanceof BinaryLogicalOperation }

    override AstNode getChildNode(int i) {
      i = 0 and result = super.getLhs()
      or
      i = 1 and result = super.getRhs()
    }
  }

  class LogicalOrExprTree extends PostOrderTree, LogicalOrExpr {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getAnOperand() }

    override predicate first(AstNode node) { first(this.getLhs(), node) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Edge from lhs to rhs
      last(this.getLhs(), pred, c) and
      c.(BooleanCompletion).failed() and
      first(this.getRhs(), succ)
      or
      // Edge from lhs to this
      last(this.getLhs(), pred, c) and
      c.(BooleanCompletion).succeeded() and
      succ = this
      or
      // Edge from rhs to this
      last(this.getRhs(), pred, c) and
      succ = this and
      completionIsNormal(c)
    }
  }

  class LogicalAndExprTree extends PostOrderTree, LogicalAndExpr {
    final override predicate propagatesAbnormal(AstNode child) { child = this.getAnOperand() }

    override predicate first(AstNode node) { first(this.getLhs(), node) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Edge from lhs to rhs
      last(this.getLhs(), pred, c) and
      c.(BooleanCompletion).succeeded() and
      first(this.getRhs(), succ)
      or
      // Edge from lhs to this
      last(this.getLhs(), pred, c) and
      c.(BooleanCompletion).failed() and
      succ = this
      or
      // Edge from rhs to this
      last(this.getRhs(), pred, c) and
      succ = this and
      completionIsNormal(c)
    }
  }

  private AstNode getBlockChildNode(BlockExpr b, int i) {
    result = b.getStmtList().getStatement(i)
    or
    i = b.getStmtList().getNumberOfStatements() and
    result = b.getStmtList().getTailExpr()
  }

  class AsyncBlockExprTree extends StandardTree, PreOrderTree, PostOrderTree, AsyncBlockExpr {
    override AstNode getChildNode(int i) { result = getBlockChildNode(this, i) }

    override predicate propagatesAbnormal(AstNode child) { none() }
  }

  class BlockExprTree extends StandardPostOrderTree, BlockExpr {
    BlockExprTree() { not this.isAsync() }

    override AstNode getChildNode(int i) { result = getBlockChildNode(this, i) }

    override predicate propagatesAbnormal(AstNode child) { child = this.getChildNode(_) }
  }

  class BreakExprTree extends StandardPostOrderTree, BreakExpr {
    override AstNode getChildNode(int i) { i = 0 and result = this.getExpr() }

    override predicate last(AstNode last, Completion c) { none() }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      super.succ(pred, succ, c)
      or
      pred = this and c.isValidFor(pred) and succ = this.getTarget()
    }
  }

  class CallExprTree extends StandardPostOrderTree instanceof CallExpr {
    override AstNode getChildNode(int i) {
      i = 0 and result = super.getFunction()
      or
      result = super.getArgList().getArg(i - 1)
    }
  }

  class CastExprTree extends StandardPostOrderTree instanceof CastExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }

  class ContinueExprTree extends LeafTree, ContinueExpr {
    override predicate last(AstNode last, Completion c) { none() }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      c.isValidFor(pred) and
      first(this.getTarget().(LoopingExprTree).getLoopContinue(), succ)
    }
  }

  class FieldExprTree extends StandardPostOrderTree instanceof FieldExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }

  class IfExprTree extends PostOrderTree instanceof IfExpr {
    override predicate first(AstNode node) { first(super.getCondition(), node) }

    override predicate propagatesAbnormal(AstNode child) {
      child = [super.getCondition(), super.getThen(), super.getElse()]
    }

    private ConditionalCompletion conditionCompletion(Completion c) {
      if super.getCondition() instanceof LetExpr
      then result = c.(MatchCompletion)
      else result = c.(BooleanCompletion)
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Edges from the condition to the branches
      last(super.getCondition(), pred, c) and
      (
        first(super.getThen(), succ) and this.conditionCompletion(c).succeeded()
        or
        first(super.getElse(), succ) and this.conditionCompletion(c).failed()
        or
        not super.hasElse() and succ = this and this.conditionCompletion(c).failed()
      )
      or
      // An edge from the then branch to the last node
      last(super.getThen(), pred, c) and
      succ = this and
      completionIsNormal(c)
      or
      // An edge from the else branch to the last node
      last(super.getElse(), pred, c) and
      succ = this and
      completionIsNormal(c)
    }
  }

  class FormatArgsExprTree extends StandardPostOrderTree, FormatArgsExpr {
    override AstNode getChildNode(int i) {
      i = -1 and result = this.getTemplate()
      or
      result = this.getArg(i).getExpr()
      or
      result =
        any(FormatTemplateVariableAccess v, Format f, int index, int kind |
          f = this.getFormat(index) and
          (
            v.getArgument() = f.getArgumentRef() and kind = 0
            or
            v.getArgument() = f.getWidthArgument() and kind = 1
            or
            v.getArgument() = f.getPrecisionArgument() and kind = 2
          ) and
          i = this.getNumberOfArgs() + index * 3 + kind
        |
          v
        )
    }
  }

  class IndexExprTree extends StandardPostOrderTree instanceof IndexExpr {
    override AstNode getChildNode(int i) {
      i = 0 and result = super.getBase()
      or
      i = 1 and result = super.getIndex()
    }
  }

  // `LetExpr` is a pre-order tree such that the pattern itself ends up
  // dominating successors in the graph in the same way that patterns do in
  // `match` expressions.
  class LetExprTree extends StandardPreOrderTree, LetExpr {
    override AstNode getChildNode(int i) {
      i = 0 and
      result = this.getScrutinee()
      or
      i = 1 and
      result = this.getPat()
    }
  }

  class LiteralExprTree extends LeafTree instanceof LiteralExpr { }

  abstract class LoopingExprTree extends PostOrderTree {
    override predicate propagatesAbnormal(AstNode child) { child = this.getLoopBody() }

    abstract BlockExpr getLoopBody();

    /**
     * Gets the node to execute when continuing the loop; either after
     * executing the last node in the body or after an explicit `continue`.
     */
    abstract AstNode getLoopContinue();

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Edge back to the start for final expression and continue expressions
      last(this.getLoopBody(), pred, c) and
      completionIsNormal(c) and
      first(this.getLoopContinue(), succ)
    }
  }

  class LoopExprTree extends LoopingExprTree instanceof LoopExpr {
    override BlockExpr getLoopBody() { result = LoopExpr.super.getLoopBody() }

    override AstNode getLoopContinue() { result = this.getLoopBody() }

    override predicate first(AstNode node) { first(this.getLoopBody(), node) }
  }

  class WhileExprTree extends LoopingExprTree instanceof WhileExpr {
    override BlockExpr getLoopBody() { result = WhileExpr.super.getLoopBody() }

    override AstNode getLoopContinue() { result = super.getCondition() }

    override predicate propagatesAbnormal(AstNode child) {
      super.propagatesAbnormal(child)
      or
      child = super.getCondition()
    }

    override predicate first(AstNode node) { first(super.getCondition(), node) }

    private ConditionalCompletion conditionCompletion(Completion c) {
      if super.getCondition() instanceof LetExpr
      then result = c.(MatchCompletion)
      else result = c.(BooleanCompletion)
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      super.succ(pred, succ, c)
      or
      last(super.getCondition(), pred, c) and
      this.conditionCompletion(c).succeeded() and
      first(this.getLoopBody(), succ)
      or
      last(super.getCondition(), pred, c) and
      this.conditionCompletion(c).failed() and
      succ = this
    }
  }

  class ForExprTree extends LoopingExprTree instanceof ForExpr {
    override BlockExpr getLoopBody() { result = ForExpr.super.getLoopBody() }

    override AstNode getLoopContinue() { result = super.getPat() }

    override predicate propagatesAbnormal(AstNode child) {
      super.propagatesAbnormal(child)
      or
      child = super.getIterable()
    }

    override predicate first(AstNode node) { first(super.getIterable(), node) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      super.succ(pred, succ, c)
      or
      last(super.getIterable(), pred, c) and
      first(super.getPat(), succ) and
      completionIsNormal(c)
      or
      last(super.getPat(), pred, c) and
      c.(MatchCompletion).succeeded() and
      first(this.getLoopBody(), succ)
      or
      last(super.getPat(), pred, c) and
      c.(MatchCompletion).failed() and
      succ = this
    }
  }

  class MacroExprTree extends StandardPostOrderTree, MacroExpr {
    override AstNode getChildNode(int i) { i = 0 and result = this.getMacroCall() }
  }

  class MatchExprTree extends PostOrderTree instanceof MatchExpr {
    override predicate propagatesAbnormal(AstNode child) {
      child = [super.getScrutinee(), super.getAnArm().getExpr()]
    }

    override predicate first(AstNode node) { first(super.getScrutinee(), node) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Edge from the scrutinee to the first arm or to the match expression if no arms.
      last(super.getScrutinee(), pred, c) and
      (
        first(super.getArm(0).getPat(), succ)
        or
        not exists(super.getArm(0)) and succ = this
      ) and
      completionIsNormal(c)
      or
      // Edge from a failed pattern or guard in one arm to the beginning of the next arm.
      exists(int i |
        (
          last(super.getArm(i).getPat(), pred, c) or
          last(super.getArm(i).getGuard().getCondition(), pred, c)
        ) and
        first(super.getArm(i + 1), succ) and
        c.(ConditionalCompletion).failed()
      )
      or
      // Edge from the end of each arm to the match expression.
      last(super.getArm(_).getExpr(), pred, c) and succ = this and completionIsNormal(c)
    }
  }

  class MethodCallExprTree extends StandardPostOrderTree, MethodCallExpr {
    override AstNode getChildNode(int i) {
      if i = 0 then result = this.getReceiver() else result = this.getArgList().getArg(i - 1)
    }
  }

  class OffsetOfExprTree extends LeafTree instanceof OffsetOfExpr { }

  class ParenExprTree extends ControlFlowTree, ParenExpr {
    private ControlFlowTree expr;

    ParenExprTree() { expr = super.getExpr() }

    override predicate propagatesAbnormal(AstNode child) { expr.propagatesAbnormal(child) }

    override predicate first(AstNode first) { expr.first(first) }

    override predicate last(AstNode last, Completion c) { expr.last(last, c) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) { none() }
  }

  class PathExprTree extends LeafTree instanceof PathExpr { }

  class PrefixExprTree extends StandardPostOrderTree instanceof PrefixExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }

  class RangeExprTree extends StandardPostOrderTree instanceof RangeExpr {
    override AstNode getChildNode(int i) {
      i = 0 and result = super.getStart()
      or
      i = 1 and result = super.getEnd()
    }
  }

  class RecordExprTree extends StandardPostOrderTree instanceof RecordExpr {
    override AstNode getChildNode(int i) {
      result = super.getRecordExprFieldList().getField(i).getExpr()
    }
  }

  class RefExprTree extends StandardPostOrderTree instanceof RefExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }

  class ReturnExprTree extends StandardPostOrderTree instanceof ReturnExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }

  class TryExprTree extends StandardPostOrderTree instanceof TryExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }

  class TupleExprTree extends StandardPostOrderTree instanceof TupleExpr {
    override AstNode getChildNode(int i) { result = super.getField(i) }
  }

  class UnderscoreExprTree extends LeafTree instanceof UnderscoreExpr { }

  // NOTE: `yield` is a reserved but unused keyword.
  class YieldExprTree extends StandardPostOrderTree instanceof YieldExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }

  // NOTE: `yeet` is experimental and not a part of Rust.
  class YeetExprTree extends StandardPostOrderTree instanceof YeetExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }
}

/**
 * Provides `ControlFlowTree`s for patterns.
 *
 * Since patterns destruct values, they are modeled in pre-order, except for
 * `LiteralPat`s, `OrPat`s, and `IdentPat`s.
 */
module PatternTrees {
  abstract class StandardPatTree extends StandardTree {
    abstract Pat getPat(int i);

    Pat getPatRanked(int i) {
      result = rank[i + 1](Pat pat, int j | pat = this.getPat(j) | pat order by j)
    }

    override AstNode getChildNode(int i) { result = this.getPat(i) }
  }

  abstract class PreOrderPatTree extends StandardPatTree, StandardPreOrderTree {
    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      c.(MatchCompletion).succeeded() and
      (
        StandardPatTree.super.succ(pred, succ, c)
        or
        pred = this and first(this.getFirstChildNode(), succ) and completionIsValidFor(c, this)
      )
    }

    override predicate last(AstNode node, Completion c) {
      super.last(node, c)
      or
      c.(MatchCompletion).failed() and
      completionIsValidFor(c, this) and
      (node = this or last(this.getPatRanked(_), node, c))
    }
  }

  abstract class PostOrderPatTree extends StandardPatTree, StandardPostOrderTree { }

  class IdentPatTree extends PostOrderPatTree, IdentPat {
    override Pat getPat(int i) { i = 0 and result = this.getPat() }

    override predicate last(AstNode node, Completion c) {
      super.last(node, c)
      or
      last(this.getPat(), node, c) and c.(MatchCompletion).failed()
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      super.succ(pred, succ, c) and c.(MatchCompletion).succeeded()
    }
  }

  class BoxPatTree extends PreOrderPatTree, BoxPat {
    override Pat getPat(int i) { i = 0 and result = this.getPat() }
  }

  class RestPatTree extends LeafTree, RestPat { }

  class LiteralPatTree extends StandardPostOrderTree, LiteralPat {
    override AstNode getChildNode(int i) { i = 0 and result = this.getLiteral() }
  }

  class MacroPatTree extends PreOrderPatTree, MacroPat {
    override Pat getPat(int i) { i = 0 and result = this.getMacroCall().getExpanded() }
  }

  class OrPatTree extends PostOrderPatTree instanceof OrPat {
    override Pat getPat(int i) { result = OrPat.super.getPat(i) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Failed patterns advance normally between children
      c.(MatchCompletion).failed() and super.succ(pred, succ, c)
      or
      // Successful pattern step to this
      c.(MatchCompletion).succeeded() and succ = this and last(this.getPat(_), pred, c)
    }
  }

  class ParenPatTree extends ControlFlowTree, ParenPat {
    private ControlFlowTree pat;

    ParenPatTree() { pat = this.getPat() }

    override predicate propagatesAbnormal(AstNode child) { pat.propagatesAbnormal(child) }

    override predicate first(AstNode first) { pat.first(first) }

    override predicate last(AstNode last, Completion c) { pat.last(last, c) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) { none() }
  }

  class PathPatTree extends LeafTree, PathPat { }

  class WildcardPatTree extends LeafTree, WildcardPat { }

  class RangePatTree extends PreOrderPatTree, RangePat {
    override Pat getPat(int i) {
      i = 0 and result = this.getStart()
      or
      i = 1 and result = this.getEnd()
    }
  }

  class RecordPatTree extends PreOrderPatTree, RecordPat {
    override Pat getPat(int i) {
      result = this.getRecordPatFieldList().getField(i).getPat()
      or
      i = this.getRecordPatFieldList().getNumberOfFields() and
      result = this.getRecordPatFieldList().getRestPat()
    }
  }

  class RefPatTree extends PreOrderPatTree, RefPat {
    override Pat getPat(int i) { i = 0 and result = super.getPat() }
  }

  class SlicePatTree extends PreOrderPatTree instanceof SlicePat {
    override Pat getPat(int i) { result = SlicePat.super.getPat(i) }
  }

  class TuplePatTree extends PreOrderPatTree, TuplePat {
    override Pat getPat(int i) { result = this.getField(i) }
  }

  class TupleStructPatTree extends PreOrderPatTree, TupleStructPat {
    override Pat getPat(int i) { result = this.getField(i) }
  }

  class ConstBlockPatTree extends LeafTree, ConstBlockPat { } // todo?
}
