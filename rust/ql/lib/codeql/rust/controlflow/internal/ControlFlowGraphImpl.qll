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

class BinaryOpExprTree extends StandardPostOrderTree instanceof BinaryOpExpr {
  BinaryOpExprTree() { super.getOp() != "&&" and super.getOp() != "||" }

  override ControlFlowTree getChildNode(int i) {
    i = 0 and result = super.getLhs()
    or
    i = 1 and result = super.getRhs()
  }
}

class LogicalOrBinaryOpExprTree extends PreOrderTree instanceof BinaryOpExpr {
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
    c.(BooleanCompletion).getValue() = false
  }

  override predicate last(AstNode node, Completion c) {
    // Lhs. as the last node
    last(super.getLhs(), node, c) and
    c.(BooleanCompletion).getValue() = true
    or
    // Rhs. as the last node
    last(super.getRhs(), node, c) // and
  }
}

class LogicalAndBinaryOpExprTree extends PreOrderTree instanceof BinaryOpExpr {
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
    c.(BooleanCompletion).getValue() = true
  }

  override predicate last(AstNode node, Completion c) {
    // Lhs. as the last node
    last(super.getLhs(), node, c) and
    c.(BooleanCompletion).getValue() = false
    or
    // Rhs. as the last node
    last(super.getRhs(), node, c)
  }
}

class BlockExprTree extends StandardPostOrderTree instanceof BlockExpr {
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
  override ControlFlowTree getChildNode(int i) { result = super.getArg(i) }
}

class ClosureExprTree extends LeafTree instanceof ClosureExpr { }

class ContinueExprTree extends LeafTree instanceof ContinueExpr { }

class ExprStmtTree extends StandardPostOrderTree instanceof ExprStmt {
  override ControlFlowTree getChildNode(int i) { i = 0 and result = super.getExpr() }
}

class FunctionTree extends LeafTree instanceof Function { }

class IfExprTree extends PostOrderTree instanceof IfExpr {
  override predicate first(AstNode node) { first(super.getCondition(), node) }

  override predicate propagatesAbnormal(AstNode child) {
    child = [super.getCondition(), super.getThen(), super.getElse()]
  }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Edges from the condition to the branches
    last(super.getCondition(), pred, c) and
    (
      first(super.getThen(), succ) and c.(BooleanCompletion).getValue() = true
      or
      first(super.getElse(), succ) and c.(BooleanCompletion).getValue() = false
      or
      not super.hasElse() and succ = this and c.(BooleanCompletion).getValue() = false
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

class LetExprTree extends StandardPostOrderTree instanceof LetExpr {
  override ControlFlowTree getChildNode(int i) { i = 0 and result = super.getExpr() }
}

class LetStmtTree extends StandardPostOrderTree instanceof LetStmt {
  override ControlFlowTree getChildNode(int i) {
    // TODO: For now we ignore the else branch (`super.getElse`). This branch
    // is guaranteed to be diverging so will need special treatment in the CFG.
    i = 0 and result = super.getInitializer()
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

class PathExprTree extends LeafTree instanceof PathExpr { }

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

// A leaf tree for unimplemented nodes in the AST.
class UnimplementedTree extends LeafTree instanceof Unimplemented { }
