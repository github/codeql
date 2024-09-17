private import rust
import codeql.controlflow.Cfg
import Completion
import codeql.controlflow.Cfg
private import SuccessorType as ST
private import Scope as Scope

module CfgInput implements InputSig<Location> {
  private import rust as Rust
  private import Completion as C
  private import Splitting as S

  class AstNode = Rust::AstNode;

  class Completion = C::Completion;

  predicate completionIsNormal = C::completionIsNormal/1;

  predicate completionIsSimple = C::completionIsSimple/1;

  predicate completionIsValidFor = C::completionIsValidFor/2;

  /** An AST node with an associated control-flow graph. */
  class CfgScope = Scope::CfgScope;

  CfgScope getCfgScope(AstNode n) { result = Scope::scopeOfAst(n) }

  class SplitKindBase = S::TSplitKind;

  class Split = S::Split;

  class SuccessorType = ST::SuccessorType;

  /** Gets a successor type that matches completion `c`. */
  SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

  /**
   * Hold if `c` represents simple (normal) evaluation of a statement or an expression.
   */
  predicate successorTypeIsSimple(SuccessorType t) { t instanceof ST::NormalSuccessor }

  /** Holds if `t` is an abnormal exit type out of a CFG scope. */
  predicate isAbnormalExitType(SuccessorType t) { none() }

  /** Hold if `t` represents a conditional successor type. */
  predicate successorTypeIsCondition(SuccessorType t) { t instanceof ST::BooleanSuccessor }

  /** Gets the maximum number of splits allowed for a given node. */
  int maxSplits() { result = 0 }

  /** Holds if `first` is first executed when entering `scope`. */
  predicate scopeFirst(CfgScope scope, AstNode first) { scope.scopeFirst(first) }

  /** Holds if `scope` is exited when `last` finishes with completion `c`. */
  predicate scopeLast(CfgScope scope, AstNode last, Completion c) { scope.scopeLast(last, c) }
}

module CfgImpl = Make<Location, CfgInput>;

import CfgImpl

/** A trivial pattern that is always guaranteed to match. */
predicate trivialPat(Pat p) { p instanceof WildcardPat or p instanceof IdentPat }

class AwaitExprTree extends StandardPostOrderTree instanceof AwaitExpr {
  override ControlFlowTree getChildNode(int i) { i = 0 and result = super.getExpr() }
}

class BecomeExprTree extends StandardPostOrderTree instanceof BecomeExpr {
  override ControlFlowTree getChildNode(int i) { i = 0 and result = super.getExpr() }
}

class BinaryOpExprTree extends StandardPostOrderTree instanceof BinaryExpr {
  BinaryOpExprTree() { super.getOp() != "&&" and super.getOp() != "||" }

  override ControlFlowTree getChildNode(int i) {
    i = 0 and result = super.getLhs()
    or
    i = 1 and result = super.getRhs()
  }
}

class LogicalOrBinaryOpExprTree extends PreOrderTree instanceof BinaryExpr {
  LogicalOrBinaryOpExprTree() { super.getOp() = "||" }

  final override predicate propagatesAbnormal(AstNode child) {
    child = [super.getRhs(), super.getLhs()]
  }

  // override predicate first(AstNode node) { first(super.getLhs(), node) }
  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Edge to the first node in the lhs
    pred = this and
    first(super.getLhs(), succ) and
    completionIsSimple(c)
    or
    // Edge from the last node in the lhs to the first node in the rhs
    last(super.getLhs(), pred, c) and
    first(super.getRhs(), succ) and
    c.(BooleanCompletion).failed()
  }

  override predicate last(AstNode node, Completion c) {
    // Lhs. as the last node
    last(super.getLhs(), node, c) and
    c.(BooleanCompletion).succeeded()
    or
    // Rhs. as the last node
    last(super.getRhs(), node, c) // and
  }
}

class LogicalAndBinaryOpExprTree extends PreOrderTree instanceof BinaryExpr {
  LogicalAndBinaryOpExprTree() { super.getOp() = "&&" }

  final override predicate propagatesAbnormal(AstNode child) {
    child = [super.getRhs(), super.getLhs()]
  }

  // override predicate first(AstNode node) { first(super.getLhs(), node) }
  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Edge to the first node in the lhs
    pred = this and
    first(super.getLhs(), succ) and
    completionIsSimple(c)
    or
    // Edge from the last node in the lhs to the first node in the rhs
    last(super.getLhs(), pred, c) and
    first(super.getRhs(), succ) and
    c.(BooleanCompletion).succeeded()
  }

  override predicate last(AstNode node, Completion c) {
    // Lhs. as the last node
    last(super.getLhs(), node, c) and
    c.(BooleanCompletion).failed()
    or
    // Rhs. as the last node
    last(super.getRhs(), node, c)
  }
}

// NOTE: This covers both normal blocks `BlockExpr`, async blocks
// `AsyncBlockExpr`, and unsafe blocks `UnsafeBlockExpr`.
class BaseBlockExprTree extends StandardPostOrderTree instanceof BlockExprBase {
  override ControlFlowTree getChildNode(int i) {
    result = super.getStatement(i)
    or
    not exists(super.getStatement(i)) and
    (exists(super.getStatement(i - 1)) or i = 0) and
    result = super.getTail()
  }
}

class BreakExprTree extends PostOrderTree instanceof BreakExpr {
  override predicate propagatesAbnormal(AstNode child) { child = super.getExpr() }

  override predicate first(AstNode node) {
    first(super.getExpr(), node)
    or
    not super.hasExpr() and node = this
  }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    last(super.getExpr(), pred, c) and succ = this
  }
}

class CallExprTree extends StandardPostOrderTree instanceof CallExpr {
  override ControlFlowTree getChildNode(int i) {
    result = super.getCallee() and
    result = super.getArg(i + 1)
  }
}

class CastExprTree extends StandardPostOrderTree instanceof CastExpr {
  override ControlFlowTree getChildNode(int i) { i = 0 and result = super.getExpr() }
}

class ClosureExprTree extends LeafTree instanceof ClosureExpr { }

class ConstExprTree extends LeafTree instanceof ConstExpr { }

class ContinueExprTree extends LeafTree instanceof ContinueExpr { }

class ElementListExprTree extends StandardPostOrderTree instanceof ElementListExpr {
  override ControlFlowTree getChildNode(int i) { i = 0 and result = super.getElement(i) }
}

class ExprStmtTree extends StandardPreOrderTree instanceof ExprStmt {
  override ControlFlowTree getChildNode(int i) { i = 0 and result = super.getExpr() }
}

class FieldExprTree extends StandardPostOrderTree instanceof BecomeExpr {
  override ControlFlowTree getChildNode(int i) { i = 0 and result = super.getExpr() }
}

class FunctionTree extends LeafTree instanceof Function { }

class IfExprTree extends PostOrderTree instanceof IfExpr {
  override predicate first(AstNode node) { first(super.getCondition(), node) }

  override predicate propagatesAbnormal(AstNode child) {
    child = [super.getCondition(), super.getThen(), super.getElse()]
  }

  ConditionalCompletion conditionCompletion(Completion c) {
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
  override ControlFlowTree getChildNode(int i) {
    i = 0 and result = super.getBase()
    or
    i = 1 and result = super.getIndex()
  }
}

// `LetExpr` is a pre-order tree such that the pattern itself ends up
// dominating successors in the graph in the same way that patterns do in
// `match` expressions.
class LetExprTree extends StandardPreOrderTree instanceof LetExpr {
  override ControlFlowTree getChildNode(int i) { i = 0 and result = super.getPat() }
}

// We handle `let` statements with trivial patterns separately as they don't
// lead to non-standard control flow. For instance, in `let a = ...` it is not
// interesing to create match edges as it would carry no information.
class LetStmtTreeTrivialPat extends StandardPreOrderTree instanceof LetStmt {
  LetStmtTreeTrivialPat() { trivialPat(super.getPat()) }

  override ControlFlowTree getChildNode(int i) {
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
    child = super.getInitializer() or child = super.getElse()
  }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Edge to start of initializer.
    pred = this and first(super.getInitializer(), succ) and completionIsSimple(c)
    or
    // Edge from end of initializer to pattern.
    last(super.getInitializer(), pred, c) and succ = super.getPat()
    or
    // Edge from failed pattern to `else` branch.
    pred = super.getPat() and first(super.getElse(), succ) and c.(MatchCompletion).failed()
  }

  override predicate last(AstNode node, Completion c) {
    // Edge out of a successfully matched pattern.
    node = super.getPat() and c.(MatchCompletion).succeeded()
    // NOTE: No edge out of the `else` branch as that is guaranteed to diverge.
  }
}

class LiteralExprTree extends LeafTree instanceof LiteralExpr { }

class LoopExprTree extends PostOrderTree instanceof LoopExpr {
  override predicate propagatesAbnormal(AstNode child) { none() }

  override predicate first(AstNode node) { first(super.getBody(), node) }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Edge back to the start for final expression and continue expressions
    last(super.getBody(), pred, c) and
    (completionIsNormal(c) or c instanceof ContinueCompletion) and
    this.first(succ)
    or
    // Edge for exiting the loop with a break expressions
    last(super.getBody(), pred, c) and
    c instanceof BreakCompletion and
    succ = this
  }

  override predicate last(AstNode last, Completion c) {
    super.last(last, c)
    or
    last(super.getBody(), last, c) and
    not completionIsNormal(c) and
    not isLoopCompletion(c)
  }
}

class MatchArmTree extends ControlFlowTree instanceof MatchArm {
  override predicate propagatesAbnormal(AstNode child) { child = super.getExpr() }

  override predicate first(AstNode node) { node = super.getPat() }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Edge from pattern to guard/arm if match succeeds.
    pred = super.getPat() and
    c.(MatchCompletion).succeeded() and
    (if super.hasGuard() then first(super.getGuard(), succ) else first(super.getExpr(), succ))
    or
    // Edge from guard to arm if the guard succeeds.
    last(super.getGuard(), pred, c) and
    first(super.getExpr(), succ) and
    c.(BooleanCompletion).succeeded()
  }

  override predicate last(AstNode node, Completion c) {
    node = super.getPat() and c.(MatchCompletion).failed()
    or
    last(super.getGuard(), node, c) and c.(BooleanCompletion).failed()
    or
    last(super.getExpr(), node, c)
  }
}

class MatchExprTree extends PostOrderTree instanceof MatchExpr {
  override predicate propagatesAbnormal(AstNode child) { child = super.getABranch().getExpr() }

  override predicate first(AstNode node) { first(super.getExpr(), node) }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Edge from the scrutinee to the first arm.
    last(super.getExpr(), pred, c) and succ = super.getBranch(0).getPat()
    or
    // Edge from a failed match/guard in one arm to the beginning of the next arm.
    exists(int i |
      last(super.getBranch(i), pred, c) and
      first(super.getBranch(i + 1), succ) and
      c.(ConditionalCompletion).failed()
    )
    or
    exists(int i | last(super.getBranch(i), pred, c) and succ = this and completionIsSimple(c))
  }
}

class MethodCallExprTree extends StandardPostOrderTree instanceof MethodCallExpr {
  override ControlFlowTree getChildNode(int i) {
    result = super.getReceiver() and
    result = super.getArg(i + 1)
  }
}

class OffsetOfExprTree extends LeafTree instanceof OffsetOfExpr { }

class PatExprTree extends LeafTree instanceof Pat { }

class PathExprTree extends LeafTree instanceof PathExpr { }

class RecordExprTree extends StandardPostOrderTree instanceof RecordExpr {
  override ControlFlowTree getChildNode(int i) { result = super.getFld(i).getExpr() }
}

class RefExprTree extends StandardPostOrderTree instanceof RefExpr {
  override ControlFlowTree getChildNode(int i) { i = 0 and result = super.getExpr() }
}

class RepeatExprTree extends StandardPostOrderTree instanceof RepeatExpr {
  override ControlFlowTree getChildNode(int i) {
    i = 0 and result = super.getInitializer()
    or
    i = 1 and result = super.getRepeat()
  }
}

class ReturnExprTree extends PostOrderTree instanceof ReturnExpr {
  override predicate propagatesAbnormal(AstNode child) { child = super.getExpr() }

  override predicate first(AstNode node) {
    first(super.getExpr(), node)
    or
    not super.hasExpr() and node = this
  }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    last(super.getExpr(), pred, c) and succ = this
  }
}

class TupleExprTree extends StandardPostOrderTree instanceof TupleExpr {
  override ControlFlowTree getChildNode(int i) { result = super.getExpr(i) }
}

class UnderscoreExprTree extends LeafTree instanceof UnderscoreExpr { }

class UnaryOpExprTree extends StandardPostOrderTree instanceof PrefixExpr {
  override ControlFlowTree getChildNode(int i) { i = 0 and result = super.getExpr() }
}

// A leaf tree for unimplemented nodes in the AST.
class UnimplementedTree extends LeafTree instanceof Unimplemented { }

class YieldExprTree extends StandardPostOrderTree instanceof YieldExpr {
  override ControlFlowTree getChildNode(int i) { i = 0 and result = super.getExpr() }
}

class YeetExprTree extends StandardPostOrderTree instanceof YeetExpr {
  override ControlFlowTree getChildNode(int i) { i = 0 and result = super.getExpr() }
}
