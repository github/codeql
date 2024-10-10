private import rust
import codeql.controlflow.Cfg
import Completion
private import Scope as Scope
private import codeql.rust.controlflow.ControlFlowGraph as Cfg

private module CfgInput implements InputSig<Location> {
  private import rust as Rust
  private import Completion as C

  class AstNode = Rust::AstNode;

  class Completion = C::Completion;

  predicate completionIsNormal = C::completionIsNormal/1;

  predicate completionIsSimple = C::completionIsSimple/1;

  predicate completionIsValidFor = C::completionIsValidFor/2;

  /** An AST node with an associated control-flow graph. */
  class CfgScope = Scope::CfgScope;

  CfgScope getCfgScope(AstNode n) { result = Scope::scopeOfAst(n) }

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

/** Holds if `p` is a trivial pattern that is always guaranteed to match. */
predicate trivialPat(Pat p) { p instanceof WildcardPat or p instanceof IdentPat }

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

class LogicalOrTree extends PostOrderTree, LogicalOrExpr {
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

class LogicalAndTree extends PostOrderTree, LogicalAndExpr {
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

class BlockExprTree extends StandardPostOrderTree, BlockExpr {
  override AstNode getChildNode(int i) {
    result = super.getStmtList().getStatement(i)
    or
    not exists(super.getStmtList().getStatement(i)) and
    (exists(super.getStmtList().getStatement(i - 1)) or i = 0) and
    result = super.getStmtList().getTailExpr()
  }

  override predicate propagatesAbnormal(AstNode child) { child = this.getChildNode(_) }
}

class BreakExprTree extends PostOrderTree, BreakExpr {
  override predicate propagatesAbnormal(AstNode child) { child = this.getExpr() }

  override predicate first(AstNode node) {
    first(this.getExpr(), node)
    or
    not this.hasExpr() and node = this
  }

  override predicate last(AstNode last, Completion c) { none() }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    last(super.getExpr(), pred, c) and succ = this
    or
    pred = this and
    c.isValidFor(pred) and
    succ = this.getTarget()
  }
}

class CallExprTree extends StandardPostOrderTree instanceof CallExpr {
  override AstNode getChildNode(int i) {
    i = 0 and result = super.getExpr()
    or
    result = super.getArgList().getArg(i - 1)
  }
}

class CastExprTree extends StandardPostOrderTree instanceof CastExpr {
  override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
}

class ClosureExprTree extends LeafTree instanceof ClosureExpr { }

class ContinueExprTree extends LeafTree, ContinueExpr {
  override predicate last(AstNode last, Completion c) { none() }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    pred = this and
    c.isValidFor(pred) and
    first(this.getTarget().(LoopingExprTree).getLoopContinue(), succ)
  }
}

class ExprStmtTree extends StandardPreOrderTree instanceof ExprStmt {
  override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
}

class FieldExprTree extends StandardPostOrderTree instanceof FieldExpr {
  override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
}

class FunctionTree extends LeafTree instanceof Function { }

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

class IndexExprTree extends StandardPostOrderTree instanceof IndexExpr {
  override AstNode getChildNode(int i) {
    i = 0 and result = super.getBase()
    or
    i = 1 and result = super.getIndex()
  }
}

class ItemTree extends LeafTree, Item { }

// `LetExpr` is a pre-order tree such that the pattern itself ends up
// dominating successors in the graph in the same way that patterns do in
// `match` expressions.
class LetExprTree extends StandardPreOrderTree instanceof LetExpr {
  override AstNode getChildNode(int i) { i = 0 and result = super.getPat() }
}

// We handle `let` statements with trivial patterns separately as they don't
// lead to non-standard control flow. For instance, in `let a = ...` it is not
// interesing to create match edges as it would carry no information.
class LetStmtTreeTrivialPat extends StandardPreOrderTree instanceof LetStmt {
  LetStmtTreeTrivialPat() { trivialPat(super.getPat()) }

  override AstNode getChildNode(int i) {
    i = 0 and result = super.getInitializer()
    or
    i = 1 and result = super.getPat()
  }
}

// `let` statements with interesting patterns that we want to be reflected in
// the CFG.
class LetStmtTree extends PreOrderTree instanceof LetStmt {
  LetStmtTree() { not trivialPat(super.getPat()) }

  final override predicate propagatesAbnormal(AstNode child) {
    child = [super.getInitializer(), super.getLetElse().getBlockExpr()]
  }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Edge to start of initializer.
    pred = this and first(super.getInitializer(), succ) and completionIsSimple(c)
    or
    // Edge from end of initializer to pattern.
    last(super.getInitializer(), pred, c) and first(super.getPat(), succ)
    or
    // Edge from failed pattern to `else` branch.
    last(super.getPat(), pred, c) and
    first(super.getLetElse().getBlockExpr(), succ) and
    c.(MatchCompletion).failed()
  }

  override predicate last(AstNode node, Completion c) {
    // Edge out of a successfully matched pattern.
    last(super.getPat(), node, c) and c.(MatchCompletion).succeeded()
    // NOTE: No edge out of the `else` branch as that is guaranteed to diverge.
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

// TODO: replace with expanded macro once the extractor supports it
class MacroExprTree extends LeafTree, MacroExpr { }

class MatchArmTree extends ControlFlowTree instanceof MatchArm {
  override predicate propagatesAbnormal(AstNode child) { child = super.getExpr() }

  override predicate first(AstNode node) { node = super.getPat() }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Edge from pattern to guard/arm if match succeeds.
    pred = super.getPat() and
    c.(MatchCompletion).succeeded() and
    (
      first(super.getGuard().getCondition(), succ)
      or
      not super.hasGuard() and first(super.getExpr(), succ)
    )
    or
    // Edge from guard to arm if the guard succeeds.
    last(super.getGuard().getCondition(), pred, c) and
    first(super.getExpr(), succ) and
    c.(BooleanCompletion).succeeded()
  }

  override predicate last(AstNode node, Completion c) {
    node = super.getPat() and c.(MatchCompletion).failed()
    or
    last(super.getGuard().getCondition(), node, c) and c.(BooleanCompletion).failed()
    or
    last(super.getExpr(), node, c)
  }
}

class MatchExprTree extends PostOrderTree instanceof MatchExpr {
  override predicate propagatesAbnormal(AstNode child) {
    child = [super.getExpr(), super.getAnArm().getExpr()]
  }

  override predicate first(AstNode node) { first(super.getExpr(), node) }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Edge from the scrutinee to the first arm.
    last(super.getExpr(), pred, c) and succ = super.getArm(0).getPat()
    or
    // Edge from a failed match/guard in one arm to the beginning of the next arm.
    exists(int i |
      last(super.getArm(i), pred, c) and
      first(super.getArm(i + 1), succ) and
      c.(ConditionalCompletion).failed()
    )
    or
    // Edge from the end of each arm to the match expression.
    last(super.getArm(_).getExpr(), pred, c) and succ = this and completionIsNormal(c)
  }
}

class MethodCallExprTree extends StandardPostOrderTree instanceof MethodCallExpr {
  override AstNode getChildNode(int i) {
    result = super.getReceiver() and
    result = super.getArgList().getArg(i + 1)
  }
}

class NameTree extends LeafTree, Name { }

class NameRefTree extends LeafTree, NameRef { }

class OffsetOfExprTree extends LeafTree instanceof OffsetOfExpr { }

class ParenExprTree extends ControlFlowTree, ParenExpr {
  private ControlFlowTree expr;

  ParenExprTree() { expr = super.getExpr() }

  override predicate propagatesAbnormal(AstNode child) { expr.propagatesAbnormal(child) }

  override predicate first(AstNode first) { expr.first(first) }

  override predicate last(AstNode last, Completion c) { expr.last(last, c) }

  override predicate succ(AstNode pred, AstNode succ, Completion c) { none() }
}

// This covers all patterns as they all extend `Pat`
class PatExprTree extends LeafTree instanceof Pat { }

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

class ReturnExprTree extends PostOrderTree instanceof ReturnExpr {
  override predicate propagatesAbnormal(AstNode child) { child = super.getExpr() }

  override predicate first(AstNode node) {
    first(super.getExpr(), node)
    or
    not super.hasExpr() and node = this
  }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    last(super.getExpr(), pred, c) and succ = this and completionIsNormal(c)
  }
}

class TupleExprTree extends StandardPostOrderTree instanceof TupleExpr {
  override AstNode getChildNode(int i) { result = super.getField(i) }
}

class TypeRefTree extends LeafTree instanceof TypeRef { }

class UnderscoreExprTree extends LeafTree instanceof UnderscoreExpr { }

// NOTE: `yield` is a reserved but unused keyword.
class YieldExprTree extends StandardPostOrderTree instanceof YieldExpr {
  override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
}

// NOTE: `yeet` is experimental and not a part of Rust.
class YeetExprTree extends StandardPostOrderTree instanceof YeetExpr {
  override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
}
