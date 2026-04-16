/**
 * Provides a newtype-based interface layer that mediates between the existing
 * Python AST classes and the shared control-flow library's `AstSig` signature.
 *
 * The newtype unifies Python's `Stmt`, `Expr`, `Scope`, and `StmtList` into a
 * single `AstNode` type. Notably, `StmtList` (which is not an `AstNode` in the
 * existing Python AST) is wrapped as a `BlockStmt` (a subtype of `Stmt`),
 * since the shared CFG library expects statement blocks to be statements.
 */

private import python as Py
private import codeql.controlflow.ControlFlowGraph

private module Ast {
  /** The newtype representing AST nodes for the shared CFG library. */
  private newtype TAstNode =
    TStmtNode(Py::Stmt s) or
    TExprNode(Py::Expr e) or
    TScopeNode(Py::Scope sc) or
    TStmtListNode(Py::StmtList sl)

  /**
   * An AST node for the shared CFG. Each branch of the newtype gets a
   * subclass that overrides `toString` and `getLocation`.
   */
  class Node extends TAstNode {
    string toString() { none() }

    Py::Location getLocation() { none() }

    /** Gets the enclosing scope of this node, if any. */
    ScopeNode getEnclosingScope() { none() }
  }

  class StmtNode extends Node, TStmtNode {
    /** Gets the underlying Python statement. */
    Py::Stmt asStmt() { this = TStmtNode(result) }

    override string toString() { result = this.asStmt().toString() }

    override Py::Location getLocation() { result = this.asStmt().getLocation() }

    /** Gets the enclosing scope of this statement. */
    override ScopeNode getEnclosingScope() { result.asScope() = this.asStmt().getScope() }
  }

  class ExprNode extends Node, TExprNode {
    /** Gets the underlying Python expression. */
    Py::Expr asExpr() { this = TExprNode(result) }

    override string toString() { result = this.asExpr().toString() }

    override Py::Location getLocation() { result = this.asExpr().getLocation() }

    /** Gets the enclosing scope of this expression. */
    override ScopeNode getEnclosingScope() { result.asScope() = this.asExpr().getScope() }
  }

  class ScopeNode extends Node, TScopeNode {
    /** Gets the underlying Python scope. */
    Py::Scope asScope() { this = TScopeNode(result) }

    override string toString() { result = this.asScope().toString() }

    override Py::Location getLocation() { result = this.asScope().getLocation() }

    /** Gets the body of this scope. */
    StmtListNode getBody() { result.asStmtList() = this.asScope().getBody() }

    /** Gets the enclosing scope of this scope, if any. */
    override ScopeNode getEnclosingScope() { result.asScope() = this.asScope().getEnclosingScope() }
  }

  class StmtListNode extends Node, TStmtListNode {
    /** Gets the underlying Python statement list. */
    Py::StmtList asStmtList() { this = TStmtListNode(result) }

    override string toString() { result = this.asStmtList().toString() }

    // StmtList has no native location; approximate with first item's location.
    override Py::Location getLocation() { result = this.asStmtList().getItem(0).getLocation() }

    /** Gets the `n`th (zero-based) statement in this block. */
    StmtNode getItem(int n) { result.asStmt() = this.asStmtList().getItem(n) }

    /** Gets the last statement in this block. */
    StmtNode getLastItem() { result.asStmt() = this.asStmtList().getLastItem() }

    /** Gets the enclosing scope of this statement list. */
    override ScopeNode getEnclosingScope() {
      result.asScope() = this.asStmtList().getParent().(Py::Scope)
      or
      result.asScope() = this.asStmtList().getParent().(Py::Stmt).getScope()
    }
  }

  /** An `if` statement. */
  class IfNode extends StmtNode {
    private Py::If ifStmt;

    IfNode() { ifStmt = this.asStmt() }

    /** Gets the condition of this `if` statement. */
    ExprNode getTest() { result.asExpr() = ifStmt.getTest() }

    /** Gets the if-true branch. */
    StmtListNode getBody() { result.asStmtList() = ifStmt.getBody() }

    /** Gets the if-false branch, if any. */
    StmtListNode getOrelse() { result.asStmtList() = ifStmt.getOrelse() }
  }

  /** An expression statement. */
  class ExprStmtNode extends StmtNode {
    private Py::ExprStmt exprStmt;

    ExprStmtNode() { exprStmt = this.asStmt() }

    /** Gets the expression in this statement. */
    ExprNode getValue() { result.asExpr() = exprStmt.getValue() }
  }
}

/** Provides an implementation of the AST signature for Python. */
module AstSigImpl implements AstSig<Py::Location> {
  class AstNode = Ast::Node;

  /** Gets the child of `n` at the specified (zero-based) index. */
  AstNode getChild(AstNode n, int index) {
    exists(Ast::IfNode ifNode | ifNode = n |
      index = 0 and result = ifNode.getTest()
      or
      index = 1 and result = ifNode.getBody()
      or
      index = 2 and result = ifNode.getOrelse()
    )
    or
    result = n.(Ast::StmtListNode).getItem(index)
    or
    index = 0 and result = n.(Ast::ExprStmtNode).getValue()
  }

  Callable getEnclosingCallable(AstNode node) { result = node.getEnclosingScope() }

  /**
   * A callable: a function, class, or module scope.
   *
   * In Python, all three are executable scopes with statement bodies.
   */
  class Callable extends Ast::ScopeNode { }

  /** Gets the body of callable `c`. */
  AstNode callableGetBody(Callable c) { result = c.getBody() }

  /** A statement. Includes both wrapped `Stmt` nodes and `StmtList` blocks. */
  class Stmt extends AstNode {
    Stmt() { this instanceof Ast::StmtNode or this instanceof Ast::StmtListNode }
  }

  /** An expression. */
  class Expr extends Ast::ExprNode { }

  /** A block of statements, wrapping Python's `StmtList`. */
  class BlockStmt extends Stmt, Ast::StmtListNode {
    /** Gets the `n`th (zero-based) statement in this block. */
    Stmt getStmt(int n) { result = Ast::StmtListNode.super.getItem(n) }

    /** Gets the last statement in this block. */
    Stmt getLastStmt() { result = Ast::StmtListNode.super.getLastItem() }
  }

  /** An expression statement. */
  class ExprStmt extends Stmt, Ast::ExprStmtNode {
    /** Gets the expression in this expression statement. */
    Expr getExpr() { result = this.getValue() }
  }

  /**
   * An `if` statement.
   *
   * Python's `elif` chains are represented as nested `If` nodes in the
   * else branch's `StmtList`. The shared CFG library handles this naturally:
   * `getElse()` returns the `BlockStmt` wrapping the else branch, and if that
   * block contains a single `If`, the result is a chained conditional.
   */
  class IfStmt extends Stmt, Ast::IfNode {
    /** Gets the condition of this `if` statement. */
    Expr getCondition() { result = this.getTest() }

    /** Gets the `then` (true) branch of this `if` statement. */
    Stmt getThen() { result = Ast::IfNode.super.getBody() }

    /** Gets the `else` (false) branch of this `if` statement, if any. */
    Stmt getElse() { result = this.getOrelse() }
  }

  // ===== Stub types for constructs not yet implemented =====
  /** A loop statement. Not yet implemented for Python. */
  class LoopStmt extends Stmt {
    LoopStmt() { none() }

    /** Gets the body of this loop statement. */
    Stmt getBody() { none() }
  }

  /** A `while` loop statement. Not yet implemented for Python. */
  class WhileStmt extends LoopStmt {
    /** Gets the boolean condition of this `while` loop. */
    Expr getCondition() { none() }
  }

  /** A `do-while` loop statement. Python has no do-while construct. */
  class DoStmt extends LoopStmt {
    /** Gets the boolean condition of this `do-while` loop. */
    Expr getCondition() { none() }
  }

  /** A C-style `for` loop. Python has no C-style for loop. */
  class ForStmt extends LoopStmt {
    /** Gets the initializer expression at the specified position. */
    Expr getInit(int index) { none() }

    /** Gets the boolean condition of this `for` loop. */
    Expr getCondition() { none() }

    /** Gets the update expression at the specified position. */
    Expr getUpdate(int index) { none() }
  }

  /** A for-each loop. Not yet implemented for Python. */
  class ForeachStmt extends LoopStmt {
    /** Gets the loop variable. */
    Expr getVariable() { none() }

    /** Gets the collection being iterated. */
    Expr getCollection() { none() }
  }

  /** A `break` statement. Not yet implemented for Python. */
  class BreakStmt extends Stmt {
    BreakStmt() { none() }
  }

  /** A `continue` statement. Not yet implemented for Python. */
  class ContinueStmt extends Stmt {
    ContinueStmt() { none() }
  }

  /** A `return` statement. Not yet implemented for Python. */
  class ReturnStmt extends Stmt {
    ReturnStmt() { none() }

    /** Gets the expression being returned, if any. */
    Expr getExpr() { none() }
  }

  /** A `throw`/`raise` statement. Not yet implemented for Python. */
  class ThrowStmt extends Stmt {
    ThrowStmt() { none() }

    /** Gets the expression being thrown. */
    Expr getExpr() { none() }
  }

  /** A `try` statement. Not yet implemented for Python. */
  class TryStmt extends Stmt {
    TryStmt() { none() }

    /** Gets the body of this `try` statement. */
    Stmt getBody() { none() }

    /** Gets the `catch` clause at the specified position. */
    CatchClause getCatch(int index) { none() }

    /** Gets the `finally` block of this `try` statement, if any. */
    Stmt getFinally() { none() }
  }

  /** A catch clause. Not yet implemented for Python. */
  class CatchClause extends AstNode {
    CatchClause() { none() }

    /** Gets the variable declared by this catch clause. */
    AstNode getVariable() { none() }

    /** Gets the guard condition, if any. */
    Expr getCondition() { none() }

    /** Gets the body of this catch clause. */
    Stmt getBody() { none() }
  }

  /** A switch/match statement. Not yet implemented for Python. */
  class Switch extends AstNode {
    Switch() { none() }

    /** Gets the expression being switched on. */
    Expr getExpr() { none() }

    /** Gets the case at the specified position. */
    Case getCase(int index) { none() }

    /** Gets the statement at the specified position. */
    Stmt getStmt(int index) { none() }
  }

  /** A case in a switch/match. Not yet implemented for Python. */
  class Case extends AstNode {
    Case() { none() }

    /** Gets a pattern being matched. */
    AstNode getAPattern() { none() }

    /** Gets the guard expression, if any. */
    Expr getGuard() { none() }

    /** Gets the body of this case. */
    AstNode getBody() { none() }
  }

  /** A default case. Not yet implemented for Python. */
  class DefaultCase extends Case { }

  /** A ternary conditional expression. Not yet implemented for Python. */
  class ConditionalExpr extends Expr {
    ConditionalExpr() { none() }

    /** Gets the condition of this expression. */
    Expr getCondition() { none() }

    /** Gets the true branch of this expression. */
    Expr getThen() { none() }

    /** Gets the false branch of this expression. */
    Expr getElse() { none() }
  }

  /** A binary expression. Not yet implemented for Python. */
  class BinaryExpr extends Expr {
    BinaryExpr() { none() }

    /** Gets the left operand. */
    Expr getLeftOperand() { none() }

    /** Gets the right operand. */
    Expr getRightOperand() { none() }
  }

  /** A short-circuiting logical AND expression. Not yet implemented for Python. */
  class LogicalAndExpr extends BinaryExpr { }

  /** A short-circuiting logical OR expression. Not yet implemented for Python. */
  class LogicalOrExpr extends BinaryExpr { }

  /** A null-coalescing expression. Python has no null-coalescing operator. */
  class NullCoalescingExpr extends BinaryExpr { }

  /** A unary expression. Not yet implemented for Python. */
  class UnaryExpr extends Expr {
    UnaryExpr() { none() }

    /** Gets the operand. */
    Expr getOperand() { none() }
  }

  /** A logical NOT expression. Not yet implemented for Python. */
  class LogicalNotExpr extends UnaryExpr { }

  /** A boolean literal expression. Not yet implemented for Python. */
  class BooleanLiteral extends Expr {
    BooleanLiteral() { none() }

    /** Gets the boolean value of this literal. */
    boolean getValue() { none() }
  }
}
