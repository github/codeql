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
private import codeql.controlflow.SuccessorType

private module Ast {
  /** The newtype representing AST nodes for the shared CFG library. */
  private newtype TAstNode =
    TStmtNode(Py::Stmt s) or
    TExprNode(Py::Expr e) or
    TScopeNode(Py::Scope sc) or
    TStmtListNode(Py::StmtList sl) or
    /**
     * A synthetic node representing an intermediate pair in a multi-operand
     * `and`/`or` expression. For `a and b and c` (values 0,1,2), we
     * synthesize a right-nested tree: the pair at index 1 represents
     * `b and c`, which becomes the right operand of the outermost pair.
     *
     * Only created for inner pairs (index >= 1); the outermost pair (index 0)
     * is represented by the original `BoolExpr` node via `TExprNode`.
     */
    TBoolExprPair(Py::BoolExpr be, int index) { index = [1 .. count(be.getAValue()) - 2] }

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
    private Py::Stmt stmt;

    StmtNode() { this = TStmtNode(stmt) }

    /** Gets the underlying Python statement. */
    Py::Stmt asStmt() { result = stmt }

    override string toString() { result = stmt.toString() }

    override Py::Location getLocation() { result = stmt.getLocation() }

    /** Gets the enclosing scope of this statement. */
    override ScopeNode getEnclosingScope() { result.asScope() = stmt.getScope() }
  }

  class ExprNode extends Node, TExprNode {
    private Py::Expr expr;

    ExprNode() { this = TExprNode(expr) }

    /** Gets the underlying Python expression. */
    Py::Expr asExpr() { result = expr }

    override string toString() { result = expr.toString() }

    override Py::Location getLocation() { result = expr.getLocation() }

    /** Gets the enclosing scope of this expression. */
    override ScopeNode getEnclosingScope() { result.asScope() = expr.getScope() }
  }

  class ScopeNode extends Node, TScopeNode {
    private Py::Scope scope;

    ScopeNode() { this = TScopeNode(scope) }

    /** Gets the underlying Python scope. */
    Py::Scope asScope() { result = scope }

    override string toString() { result = scope.toString() }

    override Py::Location getLocation() { result = scope.getLocation() }

    /** Gets the body of this scope. */
    StmtListNode getBody() { result.asStmtList() = scope.getBody() }

    /** Gets the enclosing scope of this scope, if any. */
    override ScopeNode getEnclosingScope() { result.asScope() = scope.getEnclosingScope() }
  }

  class StmtListNode extends Node, TStmtListNode {
    private Py::StmtList stmtList;

    StmtListNode() { this = TStmtListNode(stmtList) }

    /** Gets the underlying Python statement list. */
    Py::StmtList asStmtList() { result = stmtList }

    override string toString() { result = stmtList.toString() }

    // StmtList has no native location; approximate with first item's location.
    override Py::Location getLocation() { result = stmtList.getItem(0).getLocation() }

    /** Gets the `n`th (zero-based) statement in this block. */
    StmtNode getItem(int n) { result.asStmt() = stmtList.getItem(n) }

    /** Gets the last statement in this block. */
    StmtNode getLastItem() { result.asStmt() = stmtList.getLastItem() }

    /** Gets the enclosing scope of this statement list. */
    override ScopeNode getEnclosingScope() {
      result.asScope() = stmtList.getParent().(Py::Scope)
      or
      result.asScope() = stmtList.getParent().(Py::Stmt).getScope()
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

  /** A `while` statement. */
  class WhileNode extends StmtNode {
    private Py::While whileStmt;

    WhileNode() { whileStmt = this.asStmt() }

    ExprNode getTest() { result.asExpr() = whileStmt.getTest() }

    StmtListNode getBody() { result.asStmtList() = whileStmt.getBody() }

    StmtListNode getOrelse() { result.asStmtList() = whileStmt.getOrelse() }
  }

  /** A `for` statement. */
  class ForNode extends StmtNode {
    private Py::For forStmt;

    ForNode() { forStmt = this.asStmt() }

    ExprNode getTarget() { result.asExpr() = forStmt.getTarget() }

    ExprNode getIter() { result.asExpr() = forStmt.getIter() }

    StmtListNode getBody() { result.asStmtList() = forStmt.getBody() }

    StmtListNode getOrelse() { result.asStmtList() = forStmt.getOrelse() }
  }

  /** A `return` statement. */
  class ReturnNode extends StmtNode {
    private Py::Return ret;

    ReturnNode() { ret = this.asStmt() }

    ExprNode getValue() { result.asExpr() = ret.getValue() }
  }

  /** A `raise` statement. */
  class RaiseNode extends StmtNode {
    private Py::Raise raise;

    RaiseNode() { raise = this.asStmt() }

    ExprNode getException() { result.asExpr() = raise.getException() }

    ExprNode getCause() { result.asExpr() = raise.getCause() }
  }

  /** A `break` statement. */
  class BreakNode extends StmtNode {
    BreakNode() { this.asStmt() instanceof Py::Break }
  }

  /** A `continue` statement. */
  class ContinueNode extends StmtNode {
    ContinueNode() { this.asStmt() instanceof Py::Continue }
  }

  /** An `assert` statement. */
  class AssertNode extends StmtNode {
    private Py::Assert assertStmt;

    AssertNode() { assertStmt = this.asStmt() }

    ExprNode getTest() { result.asExpr() = assertStmt.getTest() }

    ExprNode getMsg() { result.asExpr() = assertStmt.getMsg() }
  }

  /** A `try` statement. */
  class TryNode extends StmtNode {
    private Py::Try tryStmt;

    TryNode() { tryStmt = this.asStmt() }

    StmtListNode getBody() { result.asStmtList() = tryStmt.getBody() }

    StmtListNode getOrelse() { result.asStmtList() = tryStmt.getOrelse() }

    StmtListNode getFinalbody() { result.asStmtList() = tryStmt.getFinalbody() }

    ExceptionHandlerNode getHandler(int i) { result.asStmt() = tryStmt.getHandler(i) }
  }

  /** An exception handler (`except` or `except*`). */
  class ExceptionHandlerNode extends StmtNode {
    private Py::ExceptionHandler handler;

    ExceptionHandlerNode() { handler = this.asStmt() }

    ExprNode getType() { result.asExpr() = handler.getType() }

    ExprNode getName() { result.asExpr() = handler.getName() }

    StmtListNode getBody() {
      result.asStmtList() = handler.(Py::ExceptStmt).getBody() or
      result.asStmtList() = handler.(Py::ExceptGroupStmt).getBody()
    }
  }

  /** A conditional expression (`x if cond else y`). */
  class IfExpNode extends ExprNode {
    private Py::IfExp ifExp;

    IfExpNode() { ifExp = this.asExpr() }

    ExprNode getTest() { result.asExpr() = ifExp.getTest() }

    ExprNode getBody() { result.asExpr() = ifExp.getBody() }

    ExprNode getOrelse() { result.asExpr() = ifExp.getOrelse() }
  }

  /** A Python binary expression (arithmetic, bitwise, matmul, etc.). */
  class BinaryExprNode extends ExprNode {
    private Py::BinaryExpr binExpr;

    BinaryExprNode() { binExpr = this.asExpr() }

    ExprNode getLeft() { result.asExpr() = binExpr.getLeft() }

    ExprNode getRight() { result.asExpr() = binExpr.getRight() }
  }

  /** A subscript expression (`obj[index]`). */
  class SubscriptNode extends ExprNode {
    private Py::Subscript sub;

    SubscriptNode() { sub = this.asExpr() }

    ExprNode getObject() { result.asExpr() = sub.getObject() }

    ExprNode getIndex() { result.asExpr() = sub.getIndex() }
  }

  /** A tuple literal. */
  class TupleNode extends ExprNode {
    private Py::Tuple tuple;

    TupleNode() { tuple = this.asExpr() }

    ExprNode getElt(int n) { result.asExpr() = tuple.getElt(n) }
  }

  /** A list literal. */
  class ListNode extends ExprNode {
    private Py::List list;

    ListNode() { list = this.asExpr() }

    ExprNode getElt(int n) { result.asExpr() = list.getElt(n) }
  }

  /** A set literal. */
  class SetNode extends ExprNode {
    private Py::Set set;

    SetNode() { set = this.asExpr() }

    ExprNode getElt(int n) { result.asExpr() = set.getElt(n) }
  }

  /** A dict literal. */
  class DictNode extends ExprNode {
    private Py::Dict dict;

    DictNode() { dict = this.asExpr() }

    /**
     * Gets the key of the `n`th item (at child index `2*n`), and the
     * value at child index `2*n + 1`.
     */
    ExprNode getKey(int n) { result.asExpr() = dict.getItem(n).(Py::KeyValuePair).getKey() }

    ExprNode getValue(int n) { result.asExpr() = dict.getItem(n).(Py::KeyValuePair).getValue() }

    int getNumberOfItems() { result = count(dict.getAnItem()) }
  }

  /** A unary expression other than `not` (e.g., `-x`, `+x`, `~x`). */
  class ArithmeticUnaryNode extends ExprNode {
    private Py::UnaryExpr unaryExpr;

    ArithmeticUnaryNode() { unaryExpr = this.asExpr() and not unaryExpr.getOp() instanceof Py::Not }

    ExprNode getOperand() { result.asExpr() = unaryExpr.getOperand() }
  }

  /**
   * A `not` expression. This is a `UnaryExpr` whose operator is `Not`.
   */
  class NotExprNode extends ExprNode {
    private Py::UnaryExpr notExpr;

    NotExprNode() { notExpr = this.asExpr() and notExpr.getOp() instanceof Py::Not }

    ExprNode getOperand() { result.asExpr() = notExpr.getOperand() }
  }

  /**
   * A boolean expression (`and`/`or`) with exactly 2 operands.
   * For 2-operand BoolExprs, the `TExprNode` itself serves as the
   * logical and/or expression.
   */
  class BoolExpr2Node extends ExprNode {
    private Py::BoolExpr boolExpr;

    BoolExpr2Node() { boolExpr = this.asExpr() and count(boolExpr.getAValue()) = 2 }

    predicate isAnd() { boolExpr.getOp() instanceof Py::And }

    predicate isOr() { boolExpr.getOp() instanceof Py::Or }

    ExprNode getLeftOperand() { result.asExpr() = boolExpr.getValue(0) }

    ExprNode getRightOperand() { result.asExpr() = boolExpr.getValue(1) }
  }

  /**
   * The outermost pair of a multi-operand (3+) boolean expression.
   * Represented by the original `BoolExpr` node (`TExprNode`).
   * Left operand is `getValue(0)`, right operand is `TBoolExprPair(be, 1)`.
   */
  class BoolExprOuterNode extends ExprNode {
    private Py::BoolExpr boolExpr;

    BoolExprOuterNode() { boolExpr = this.asExpr() and count(boolExpr.getAValue()) > 2 }

    predicate isAnd() { boolExpr.getOp() instanceof Py::And }

    predicate isOr() { boolExpr.getOp() instanceof Py::Or }

    Node getLeftOperand() { result = TExprNode(boolExpr.getValue(0)) }

    Node getRightOperand() { result = TBoolExprPair(boolExpr, 1) }
  }

  /**
   * A synthetic intermediate node in a multi-operand boolean expression.
   * Pair at index `i` has left=`getValue(i)` and right=pair at `i+1`
   * (or `getValue(n-1)` for the last pair).
   */
  class BoolExprPairNode extends Node, TBoolExprPair {
    private Py::BoolExpr boolExpr;
    private int index;

    BoolExprPairNode() { this = TBoolExprPair(boolExpr, index) }

    override string toString() { result = boolExpr.getOperator() }

    override Py::Location getLocation() { result = boolExpr.getValue(index).getLocation() }

    override ScopeNode getEnclosingScope() {
      result.asScope() = boolExpr.getValue(index).getScope()
    }

    predicate isAnd() { boolExpr.getOp() instanceof Py::And }

    predicate isOr() { boolExpr.getOp() instanceof Py::Or }

    Node getLeftOperand() { result = TExprNode(boolExpr.getValue(index)) }

    Node getRightOperand() {
      // Last pair: right operand is the final value
      index = count(boolExpr.getAValue()) - 2 and
      result = TExprNode(boolExpr.getValue(index + 1))
      or
      // Not last pair: right operand is the next synthetic pair
      index < count(boolExpr.getAValue()) - 2 and
      result = TBoolExprPair(boolExpr, index + 1)
    }
  }

  /** A `True` or `False` literal. */
  class BoolLiteralNode extends ExprNode {
    BoolLiteralNode() { this.asExpr() instanceof Py::True or this.asExpr() instanceof Py::False }

    boolean getBoolValue() {
      this.asExpr() instanceof Py::True and result = true
      or
      this.asExpr() instanceof Py::False and result = false
    }
  }
}

/** Provides an implementation of the AST signature for Python. */
module AstSigImpl implements AstSig<Py::Location> {
  class AstNode = Ast::Node;

  /** Gets the child of `n` at the specified (zero-based) index. */
  AstNode getChild(AstNode n, int index) {
    // IfStmt: condition (0), then branch (1), else branch (2)
    exists(Ast::IfNode ifNode | ifNode = n |
      index = 0 and result = ifNode.getTest()
      or
      index = 1 and result = ifNode.getBody()
      or
      index = 2 and result = ifNode.getOrelse()
    )
    or
    // BlockStmt (StmtList): indexed statements
    result = n.(Ast::StmtListNode).getItem(index)
    or
    // ExprStmt: the expression (0)
    index = 0 and result = n.(Ast::ExprStmtNode).getValue()
    or
    // WhileStmt: condition (0), body (1)
    // Note: Python while/else is not directly supported by the shared library.
    exists(Ast::WhileNode w | w = n |
      index = 0 and result = w.getTest()
      or
      index = 1 and result = w.getBody()
    )
    or
    // ForStmt (mapped as ForeachStmt): collection (0), variable (1), body (2)
    exists(Ast::ForNode f | f = n |
      index = 0 and result = f.getIter()
      or
      index = 1 and result = f.getTarget()
      or
      index = 2 and result = f.getBody()
    )
    or
    // ReturnStmt: the value (0)
    index = 0 and result = n.(Ast::ReturnNode).getValue()
    or
    // Assert: test (0), message (1)
    exists(Ast::AssertNode a | a = n |
      index = 0 and result = a.getTest()
      or
      index = 1 and result = a.getMsg()
    )
    or
    // ThrowStmt (raise): the exception (0), the cause (1)
    exists(Ast::RaiseNode r | r = n |
      index = 0 and result = r.getException()
      or
      index = 1 and result = r.getCause()
    )
    or
    // TryStmt: body (0), handlers (1..n), finally (-1)
    exists(Ast::TryNode t | t = n |
      index = 0 and result = t.getBody()
      or
      result = t.getHandler(index - 1) and index >= 1
    )
    or
    // CatchClause (except handler): type (0), name (1), body (2)
    exists(Ast::ExceptionHandlerNode h | h = n |
      index = 0 and result = h.getType()
      or
      index = 1 and result = h.getName()
      or
      index = 2 and result = h.getBody()
    )
    or
    // ConditionalExpr (IfExp): condition (0), then (1), else (2)
    exists(Ast::IfExpNode ie | ie = n |
      index = 0 and result = ie.getTest()
      or
      index = 1 and result = ie.getBody()
      or
      index = 2 and result = ie.getOrelse()
    )
    or
    // Python BinaryExpr (arithmetic, bitwise, matmul, etc.): left (0), right (1)
    exists(Ast::BinaryExprNode be | be = n |
      index = 0 and result = be.getLeft()
      or
      index = 1 and result = be.getRight()
    )
    or
    // Subscript (obj[index]): object (0), index (1)
    exists(Ast::SubscriptNode sub | sub = n |
      index = 0 and result = sub.getObject()
      or
      index = 1 and result = sub.getIndex()
    )
    or
    // Tuple, List, Set: elements left to right
    result = n.(Ast::TupleNode).getElt(index)
    or
    result = n.(Ast::ListNode).getElt(index)
    or
    result = n.(Ast::SetNode).getElt(index)
    or
    // Dict: key(0), value(0), key(1), value(1), ...
    exists(Ast::DictNode d, int item | d = n |
      index = 2 * item and result = d.getKey(item)
      or
      index = 2 * item + 1 and result = d.getValue(item)
    )
    or
    // Arithmetic unary (-x, +x, ~x): operand (0)
    index = 0 and result = n.(Ast::ArithmeticUnaryNode).getOperand()
    or
    // LogicalNotExpr: operand (0)
    index = 0 and result = n.(Ast::NotExprNode).getOperand()
    or
    // 2-operand BoolExpr: left (0), right (1)
    exists(Ast::BoolExpr2Node be | be = n |
      index = 0 and result = be.getLeftOperand()
      or
      index = 1 and result = be.getRightOperand()
    )
    or
    // Multi-operand BoolExpr (outermost): left (0), right (1)
    exists(Ast::BoolExprOuterNode be | be = n |
      index = 0 and result = be.getLeftOperand()
      or
      index = 1 and result = be.getRightOperand()
    )
    or
    // Synthetic BoolExpr pair: left (0), right (1)
    exists(Ast::BoolExprPairNode bp | bp = n |
      index = 0 and result = bp.getLeftOperand()
      or
      index = 1 and result = bp.getRightOperand()
    )
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

  /** An expression. Includes `TExprNode` and synthetic `TBoolExprPair` nodes. */
  class Expr extends AstNode {
    Expr() { this instanceof Ast::ExprNode or this instanceof Ast::BoolExprPairNode }
  }

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

  // ===== Loop statements =====
  /** A loop statement. */
  class LoopStmt extends Stmt {
    LoopStmt() { this instanceof Ast::WhileNode or this instanceof Ast::ForNode }

    /** Gets the body of this loop statement. */
    Stmt getBody() { none() }
  }

  /** A `while` loop statement. */
  class WhileStmt extends LoopStmt instanceof Ast::WhileNode {
    /** Gets the boolean condition of this `while` loop. */
    Expr getCondition() { result = this.(Ast::WhileNode).getTest() }

    override Stmt getBody() { result = this.(Ast::WhileNode).getBody() }
  }

  /** A `do-while` loop statement. Python has no do-while construct. */
  class DoStmt extends LoopStmt {
    DoStmt() { none() }

    Expr getCondition() { none() }
  }

  /** A C-style `for` loop. Python has no C-style for loop. */
  class ForStmt extends LoopStmt {
    ForStmt() { none() }

    Expr getInit(int index) { none() }

    Expr getCondition() { none() }

    Expr getUpdate(int index) { none() }
  }

  /** A for-each loop (`for x in iterable:`). */
  class ForeachStmt extends LoopStmt {
    ForeachStmt() { this instanceof Ast::ForNode }

    /** Gets the loop variable. */
    Expr getVariable() { result = this.(Ast::ForNode).getTarget() }

    /** Gets the collection being iterated. */
    Expr getCollection() { result = this.(Ast::ForNode).getIter() }

    override Stmt getBody() { result = this.(Ast::ForNode).getBody() }
  }

  // ===== Abrupt completion statements =====
  /** A `break` statement. */
  class BreakStmt extends Stmt, Ast::BreakNode { }

  /** A `continue` statement. */
  class ContinueStmt extends Stmt, Ast::ContinueNode { }

  /** A `return` statement. */
  class ReturnStmt extends Stmt, Ast::ReturnNode {
    /** Gets the expression being returned, if any. */
    Expr getExpr() { result = this.getValue() }
  }

  /** A `raise` statement (mapped to `ThrowStmt`). */
  class ThrowStmt extends Stmt, Ast::RaiseNode {
    /** Gets the expression being raised. */
    Expr getExpr() { result = this.getException() }
  }

  // ===== Try/except =====
  /** A `try` statement. */
  class TryStmt extends Stmt {
    TryStmt() { this instanceof Ast::TryNode }

    Stmt getBody() { result = this.(Ast::TryNode).getBody() }

    CatchClause getCatch(int index) { result = this.(Ast::TryNode).getHandler(index) }

    Stmt getFinally() { result = this.(Ast::TryNode).getFinalbody() }
  }

  AstNode getTryElse(TryStmt try) { result = try.(Ast::TryNode).getOrelse() }

  /** An except clause in a try statement. */
  class CatchClause extends Stmt {
    CatchClause() { this instanceof Ast::ExceptionHandlerNode }

    AstNode getVariable() { result = this.(Ast::ExceptionHandlerNode).getName() }

    Expr getCondition() { none() }

    Stmt getBody() { result = this.(Ast::ExceptionHandlerNode).getBody() }
  }

  // ===== Switch/match — stubs for now =====
  /** A switch/match statement. Not yet implemented for Python. */
  class Switch extends AstNode {
    Switch() { none() }

    Expr getExpr() { none() }

    Case getCase(int index) { none() }

    Stmt getStmt(int index) { none() }
  }

  /** A case in a switch/match. Not yet implemented for Python. */
  class Case extends AstNode {
    Case() { none() }

    AstNode getAPattern() { none() }

    Expr getGuard() { none() }

    AstNode getBody() { none() }
  }

  /** A default case. Not yet implemented for Python. */
  class DefaultCase extends Case { }

  // ===== Expression types =====
  /** A conditional expression (`x if cond else y`). */
  class ConditionalExpr extends Expr, Ast::IfExpNode {
    /** Gets the condition of this expression. */
    Expr getCondition() { result = this.getTest() }

    /** Gets the true branch of this expression. */
    Expr getThen() { result = Ast::IfExpNode.super.getBody() }

    /** Gets the false branch of this expression. */
    Expr getElse() { result = this.getOrelse() }
  }

  /**
   * A binary expression for the shared CFG. In Python, this covers
   * `and`/`or` expressions (both real 2-operand and synthetic pairs).
   */
  class BinaryExpr extends Expr {
    BinaryExpr() {
      this instanceof Ast::BoolExpr2Node or
      this instanceof Ast::BoolExprOuterNode or
      this instanceof Ast::BoolExprPairNode
    }

    /** Gets the left operand. */
    Expr getLeftOperand() {
      result = this.(Ast::BoolExpr2Node).getLeftOperand()
      or
      result = this.(Ast::BoolExprOuterNode).getLeftOperand()
      or
      result = this.(Ast::BoolExprPairNode).getLeftOperand()
    }

    /** Gets the right operand. */
    Expr getRightOperand() {
      result = this.(Ast::BoolExpr2Node).getRightOperand()
      or
      result = this.(Ast::BoolExprOuterNode).getRightOperand()
      or
      result = this.(Ast::BoolExprPairNode).getRightOperand()
    }
  }

  /** A short-circuiting logical `and` expression. */
  class LogicalAndExpr extends BinaryExpr {
    LogicalAndExpr() {
      this.(Ast::BoolExpr2Node).isAnd() or
      this.(Ast::BoolExprOuterNode).isAnd() or
      this.(Ast::BoolExprPairNode).isAnd()
    }
  }

  /** A short-circuiting logical `or` expression. */
  class LogicalOrExpr extends BinaryExpr {
    LogicalOrExpr() {
      this.(Ast::BoolExpr2Node).isOr() or
      this.(Ast::BoolExprOuterNode).isOr() or
      this.(Ast::BoolExprPairNode).isOr()
    }
  }

  /** A null-coalescing expression. Python has no null-coalescing operator. */
  class NullCoalescingExpr extends BinaryExpr {
    NullCoalescingExpr() { none() }
  }

  /** A unary expression. Exists for the `not` subclass. */
  class UnaryExpr extends Expr {
    UnaryExpr() { this instanceof Ast::NotExprNode }

    Expr getOperand() { result = this.(Ast::NotExprNode).getOperand() }
  }

  /** A logical `not` expression. */
  class LogicalNotExpr extends UnaryExpr { }

  /** A boolean literal expression (`True` or `False`). */
  class BooleanLiteral extends Expr, Ast::BoolLiteralNode {
    /** Gets the boolean value of this literal. */
    boolean getValue() { result = this.getBoolValue() }
  }
}

private module Cfg0 = Make0<Py::Location, AstSigImpl>;

private import Cfg0

private module Cfg1 = Make1<Input>;

private import Cfg1

private module Cfg2 = Make2<Input>;

private import Cfg2

private module Input implements InputSig1, InputSig2 {
  predicate cfgCachedStageRef() { CfgCachedStage::ref() }

  private newtype TLabel = TNone()

  class Label extends TLabel {
    string toString() { result = "label" }
  }

  predicate inConditionalContext(AstSigImpl::AstNode n, ConditionKind kind) {
    kind.isBoolean() and
    n = any(Ast::AssertNode a).getTest()
  }

  private string assertThrowTag() { result = "[assert-throw]" }

  predicate additionalNode(AstSigImpl::AstNode n, string tag, NormalSuccessor t) {
    n instanceof Ast::AssertNode and tag = assertThrowTag() and t instanceof DirectSuccessor
  }

  predicate beginAbruptCompletion(
    AstSigImpl::AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
  ) {
    ast instanceof Ast::AssertNode and
    n.isAdditional(ast, assertThrowTag()) and
    c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
    always = true
  }

  predicate endAbruptCompletion(AstSigImpl::AstNode ast, PreControlFlowNode n, AbruptCompletion c) {
    none()
  }

  predicate step(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Ast::AssertNode assertStmt |
      n1.isBefore(assertStmt) and
      n2.isBefore(assertStmt.getTest())
      or
      n1.isAfterTrue(assertStmt.getTest()) and
      n2.isAfter(assertStmt)
      or
      n1.isAfterFalse(assertStmt.getTest()) and
      (
        n2.isBefore(assertStmt.getMsg())
        or
        not exists(assertStmt.getMsg()) and
        n2.isAdditional(assertStmt, assertThrowTag())
      )
      or
      n1.isAfter(assertStmt.getMsg()) and
      n2.isAdditional(assertStmt, assertThrowTag())
    )
  }
}

import CfgCachedStage
import Public

/**
 * Maps a new-CFG AST wrapper node to the corresponding Python AST node, if any.
 * Entry, exit, and synthetic nodes have no corresponding Python AST node.
 */
Py::AstNode astNodeToPyNode(AstSigImpl::AstNode n) {
  result = n.(Ast::ExprNode).asExpr()
  or
  result = n.(Ast::StmtNode).asStmt()
  or
  result = n.(Ast::ScopeNode).asScope()
}
