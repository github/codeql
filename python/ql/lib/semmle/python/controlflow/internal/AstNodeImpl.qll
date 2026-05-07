/**
 * Provides classes for the shared control-flow library, mediating between
 * the Python AST and `AstSig`.
 *
 * The `Ast` module wraps Python's `Stmt`, `Expr`, `Scope`, and `Pattern`,
 * and adds two synthetic kinds of node:
 *   - `BlockStmt`, identifying a body slot of a parent AST node (e.g. an
 *     `if`'s then or else branch). `Py::StmtList` itself is not directly
 *     wrapped.
 *   - Intermediate nodes for multi-operand boolean expressions.
 */

private import python as Py
private import codeql.controlflow.ControlFlowGraph
private import codeql.controlflow.SuccessorType
private import codeql.util.Void

/** Provides the Python implementation of the shared CFG `AstSig`. */
module Ast implements AstSig<Py::Location> {
  /**
   * Maps a `(parent, slot)` pair to the `Py::StmtList` that holds the items
   * of the `BlockStmt` for that slot. The slot string distinguishes between
   * the multiple bodies that some parents have (e.g. `if` has `body` and
   * `orelse`).
   */
  private Py::StmtList getBodyStmtList(Py::AstNode parent, string slot) {
    result = parent.(Py::Scope).getBody() and slot = "body"
    or
    result = parent.(Py::If).getBody() and slot = "body"
    or
    result = parent.(Py::If).getOrelse() and slot = "orelse"
    or
    result = parent.(Py::While).getBody() and slot = "body"
    or
    result = parent.(Py::While).getOrelse() and slot = "orelse"
    or
    result = parent.(Py::For).getBody() and slot = "body"
    or
    result = parent.(Py::For).getOrelse() and slot = "orelse"
    or
    result = parent.(Py::With).getBody() and slot = "body"
    or
    result = parent.(Py::Try).getBody() and slot = "body"
    or
    result = parent.(Py::Try).getOrelse() and slot = "orelse"
    or
    result = parent.(Py::Try).getFinalbody() and slot = "finally"
    or
    result = parent.(Py::Case).getBody() and slot = "body"
    or
    result = parent.(Py::ExceptStmt).getBody() and slot = "body"
    or
    result = parent.(Py::ExceptGroupStmt).getBody() and slot = "body"
  }

  private newtype TAstNode =
    TStmt(Py::Stmt s) or
    TExpr(Py::Expr e) or
    TScope(Py::Scope sc) or
    TPattern(Py::Pattern p) or
    /**
     * A synthetic intermediate node in a multi-operand `and`/`or`
     * expression. For `a and b and c` (operands 0, 1, 2) we model the
     * operation as a right-nested tree where the inner pair at index 1
     * represents `b and c` and is the right operand of the outer pair.
     * The outermost pair (index 0) is represented by the underlying
     * `Py::BoolExpr` itself via `TExpr`.
     */
    TBoolExprPair(Py::BoolExpr be, int index) { index = [1 .. count(be.getAValue()) - 2] } or
    /**
     * A synthetic block statement, identifying one body slot of the
     * `parent` AST node. The `slot` string disambiguates among multiple
     * bodies of the same parent (`"body"`, `"orelse"`, `"finally"`).
     */
    TBlockStmt(Py::AstNode parent, string slot) { exists(getBodyStmtList(parent, slot)) }

  /** An AST node visible to the shared CFG. */
  class AstNode extends TAstNode {
    /** Gets a textual representation of this AST node. */
    string toString() { none() }

    /** Gets the location of this AST node. */
    Py::Location getLocation() { none() }

    /** Gets the enclosing callable that contains this node, if any. */
    Callable getEnclosingCallable() { none() }

    /** Gets the underlying Python `Stmt`, if this node wraps one. */
    Py::Stmt asStmt() { this = TStmt(result) }

    /** Gets the underlying Python `Expr`, if this node wraps one. */
    Py::Expr asExpr() { this = TExpr(result) }

    /** Gets the underlying Python `Scope`, if this node wraps one. */
    Py::Scope asScope() { this = TScope(result) }

    /** Gets the underlying Python `Pattern`, if this node wraps one. */
    Py::Pattern asPattern() { this = TPattern(result) }

    /**
     * Gets the child of this AST node at the specified (zero-based)
     * index, in evaluation order. Subclasses with children override
     * this method.
     */
    AstNode getChild(int index) { none() }
  }

  /** Implementation of `AstNode` predicates for `TStmt` nodes. */
  private class TStmtAstNode extends AstNode, TStmt {
    private Py::Stmt s;

    TStmtAstNode() { this = TStmt(s) }

    override string toString() { result = s.toString() }

    override Py::Location getLocation() { result = s.getLocation() }

    override Callable getEnclosingCallable() { result.asScope() = s.getScope() }
  }

  /** Implementation of `AstNode` predicates for `TExpr` nodes. */
  private class TExprAstNode extends AstNode, TExpr {
    private Py::Expr e;

    TExprAstNode() { this = TExpr(e) }

    override string toString() { result = e.toString() }

    override Py::Location getLocation() { result = e.getLocation() }

    override Callable getEnclosingCallable() { result.asScope() = e.getScope() }
  }

  /** Implementation of `AstNode` predicates for `TScope` nodes. */
  private class TScopeAstNode extends AstNode, TScope {
    private Py::Scope sc;

    TScopeAstNode() { this = TScope(sc) }

    override string toString() { result = sc.toString() }

    override Py::Location getLocation() { result = sc.getLocation() }

    override Callable getEnclosingCallable() { result.asScope() = sc.getEnclosingScope() }
  }

  /** Implementation of `AstNode` predicates for `TPattern` nodes. */
  private class TPatternAstNode extends AstNode, TPattern {
    private Py::Pattern p;

    TPatternAstNode() { this = TPattern(p) }

    override string toString() { result = p.toString() }

    override Py::Location getLocation() { result = p.getLocation() }

    override Callable getEnclosingCallable() { result.asScope() = p.getScope() }
  }

  /** Implementation of `AstNode` predicates for synthetic `TBoolExprPair` nodes. */
  private class TBoolExprPairAstNode extends AstNode, TBoolExprPair {
    private Py::BoolExpr be;
    private int index;

    TBoolExprPairAstNode() { this = TBoolExprPair(be, index) }

    override string toString() { result = be.getOperator() }

    override Py::Location getLocation() { result = be.getValue(index).getLocation() }

    override Callable getEnclosingCallable() { result.asScope() = be.getScope() }
  }

  /** Implementation of `AstNode` predicates for synthetic `TBlockStmt` nodes. */
  private class TBlockStmtAstNode extends AstNode, TBlockStmt {
    private Py::AstNode parent;
    private string slot;

    TBlockStmtAstNode() { this = TBlockStmt(parent, slot) }

    override string toString() { result = "block:" + slot }

    // BlockStmt has no native location; approximate with the first
    // item's location.
    override Py::Location getLocation() {
      result = getBodyStmtList(parent, slot).getItem(0).getLocation()
    }

    override Callable getEnclosingCallable() {
      result.asScope() = parent.(Py::Scope)
      or
      result.asScope() = parent.(Py::Stmt).getScope()
    }
  }

  /** Gets the immediately enclosing callable that contains `node`. */
  Callable getEnclosingCallable(AstNode node) { result = node.getEnclosingCallable() }

  /**
   * A callable: a function, class, or module scope.
   *
   * In Python, all three are executable scopes with statement bodies.
   */
  class Callable extends AstNode, TScope { }

  /** Gets the body of callable `c`. */
  AstNode callableGetBody(Callable c) { result = TBlockStmt(c.asScope(), "body") }

  /**
   * A parameter of a callable.
   *
   * TODO: Implement in order to include parameters in the CFG.
   */
  class Parameter extends AstNode {
    Parameter() { none() }

    Expr getDefaultValue() { none() }
  }

  /** Gets the `index`th parameter of callable `c`. */
  Parameter callableGetParameter(Callable c, int index) { none() }

  /** A statement. */
  class Stmt extends AstNode {
    Stmt() { this instanceof TStmt or this instanceof TBlockStmt }
  }

  /** An expression. */
  class Expr extends AstNode {
    Expr() { this instanceof TExpr or this instanceof TBoolExprPair }
  }

  /** A pattern in a `match` statement. */
  additional class Pattern extends AstNode, TPattern { }

  /**
   * A block statement, modeling the body of a parent AST node as a
   * sequence of statements.
   */
  class BlockStmt extends Stmt, TBlockStmt {
    private Py::AstNode parent;
    private string slot;

    BlockStmt() { this = TBlockStmt(parent, slot) }

    /** Gets the `n`th (zero-based) statement in this block. */
    Stmt getStmt(int n) { result = TStmt(getBodyStmtList(parent, slot).getItem(n)) }

    /** Gets the last statement in this block. */
    Stmt getLastStmt() { result = TStmt(getBodyStmtList(parent, slot).getLastItem()) }

    override AstNode getChild(int index) { result = this.getStmt(index) }
  }

  /** An expression statement. */
  class ExprStmt extends Stmt {
    private Py::ExprStmt exprStmt;

    ExprStmt() { exprStmt = this.asStmt() }

    /** Gets the expression in this expression statement. */
    Expr getExpr() { result = TExpr(exprStmt.getValue()) }

    override AstNode getChild(int index) { index = 0 and result = this.getExpr() }
  }

  /** An assignment statement (`x = y = expr`). */
  additional class AssignStmt extends Stmt {
    private Py::Assign assign;

    AssignStmt() { assign = this.asStmt() }

    Expr getValue() { result = TExpr(assign.getValue()) }

    Expr getTarget(int n) { result = TExpr(assign.getTarget(n)) }

    int getNumberOfTargets() { result = count(assign.getATarget()) }

    override AstNode getChild(int index) {
      index = 0 and result = this.getValue()
      or
      result = this.getTarget(index - 1) and index >= 1
    }
  }

  /** An augmented assignment statement (`x += expr`). */
  additional class AugAssignStmt extends Stmt {
    private Py::AugAssign augAssign;

    AugAssignStmt() { augAssign = this.asStmt() }

    Expr getOperation() { result = TExpr(augAssign.getOperation()) }

    override AstNode getChild(int index) { index = 0 and result = this.getOperation() }
  }

  /** An assignment expression / walrus operator (`x := expr`). */
  additional class NamedExpr extends Expr {
    private Py::AssignExpr assignExpr;

    NamedExpr() { assignExpr = this.asExpr() }

    Expr getValue() { result = TExpr(assignExpr.getValue()) }

    Expr getTarget() { result = TExpr(assignExpr.getTarget()) }

    override AstNode getChild(int index) {
      index = 0 and result = this.getValue()
      or
      index = 1 and result = this.getTarget()
    }
  }

  /**
   * An `if` statement.
   *
   * Python's `elif` chains are represented as nested `If` nodes in the
   * else branch's `StmtList`. The shared CFG library handles this
   * naturally: `getElse()` returns the `BlockStmt` wrapping the else
   * branch, and if that block contains a single `If`, the result is
   * a chained conditional.
   */
  class IfStmt extends Stmt {
    private Py::If ifStmt;

    IfStmt() { ifStmt = this.asStmt() }

    /** Gets the underlying Python `If` statement. */
    Py::If asIf() { result = ifStmt }

    /** Gets the condition of this `if` statement. */
    Expr getCondition() { result = TExpr(ifStmt.getTest()) }

    /** Gets the `then` (true) branch of this `if` statement. */
    Stmt getThen() { result = TBlockStmt(ifStmt, "body") }

    /** Gets the `else` (false) branch, if any. */
    Stmt getElse() { result = TBlockStmt(ifStmt, "orelse") }

    override AstNode getChild(int index) {
      index = 0 and result = this.getCondition()
      or
      index = 1 and result = this.getThen()
      or
      index = 2 and result = this.getElse()
    }
  }

  /** A loop statement. */
  class LoopStmt extends Stmt {
    LoopStmt() { this.asStmt() instanceof Py::While or this.asStmt() instanceof Py::For }

    /** Gets the body of this loop statement. */
    Stmt getBody() { none() }
  }

  /** A `while` loop statement. */
  class WhileStmt extends LoopStmt {
    private Py::While whileStmt;

    WhileStmt() { whileStmt = this.asStmt() }

    /** Gets the boolean condition of this `while` loop. */
    Expr getCondition() { result = TExpr(whileStmt.getTest()) }

    override Stmt getBody() { result = TBlockStmt(whileStmt, "body") }

    /** Gets the `else` branch of this `while` loop, if any. */
    Stmt getElse() { result = TBlockStmt(whileStmt, "orelse") }

    override AstNode getChild(int index) {
      index = 0 and result = this.getCondition()
      or
      index = 1 and result = this.getBody()
      or
      index = 2 and result = this.getElse()
    }
  }

  /**
   * A `do-while` loop statement. Python has no do-while construct.
   */
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
    private Py::For forStmt;

    ForeachStmt() { forStmt = this.asStmt() }

    /** Gets the loop variable. */
    Expr getVariable() { result = TExpr(forStmt.getTarget()) }

    /** Gets the collection being iterated. */
    Expr getCollection() { result = TExpr(forStmt.getIter()) }

    override Stmt getBody() { result = TBlockStmt(forStmt, "body") }

    /** Gets the `else` branch of this `for` loop, if any. */
    Stmt getElse() { result = TBlockStmt(forStmt, "orelse") }

    override AstNode getChild(int index) {
      index = 0 and result = this.getCollection()
      or
      index = 1 and result = this.getVariable()
      or
      index = 2 and result = this.getBody()
      or
      index = 3 and result = this.getElse()
    }
  }

  /** A `break` statement. */
  class BreakStmt extends Stmt {
    BreakStmt() { this.asStmt() instanceof Py::Break }
  }

  /** A `continue` statement. */
  class ContinueStmt extends Stmt {
    ContinueStmt() { this.asStmt() instanceof Py::Continue }
  }

  /** A `goto` statement. Python has no goto. */
  class GotoStmt extends Stmt {
    GotoStmt() { none() }
  }

  /** A `return` statement. */
  class ReturnStmt extends Stmt {
    private Py::Return ret;

    ReturnStmt() { ret = this.asStmt() }

    /** Gets the expression being returned, if any. */
    Expr getExpr() { result = TExpr(ret.getValue()) }

    override AstNode getChild(int index) { index = 0 and result = this.getExpr() }
  }

  /** A `raise` statement (mapped to `Throw`). */
  class Throw extends Stmt {
    private Py::Raise raise;

    Throw() { raise = this.asStmt() }

    /** Gets the expression being raised. */
    Expr getExpr() { result = TExpr(raise.getException()) }

    /** Gets the cause of this `raise`, if any. */
    Expr getCause() { result = TExpr(raise.getCause()) }

    override AstNode getChild(int index) {
      index = 0 and result = this.getExpr()
      or
      index = 1 and result = this.getCause()
    }
  }

  /** A `with` statement. */
  additional class WithStmt extends Stmt {
    private Py::With withStmt;

    WithStmt() { withStmt = this.asStmt() }

    Expr getContextExpr() { result = TExpr(withStmt.getContextExpr()) }

    Expr getOptionalVars() { result = TExpr(withStmt.getOptionalVars()) }

    Stmt getBody() { result = TBlockStmt(withStmt, "body") }

    override AstNode getChild(int index) {
      index = 0 and result = this.getContextExpr()
      or
      index = 1 and result = this.getOptionalVars()
      or
      index = 2 and result = this.getBody()
    }
  }

  /** An `assert` statement. */
  additional class AssertStmt extends Stmt {
    private Py::Assert assertStmt;

    AssertStmt() { assertStmt = this.asStmt() }

    Expr getTest() { result = TExpr(assertStmt.getTest()) }

    Expr getMsg() { result = TExpr(assertStmt.getMsg()) }

    override AstNode getChild(int index) {
      index = 0 and result = this.getTest()
      or
      index = 1 and result = this.getMsg()
    }
  }

  /** A `delete` statement. */
  additional class DeleteStmt extends Stmt {
    private Py::Delete del;

    DeleteStmt() { del = this.asStmt() }

    Expr getTarget(int n) { result = TExpr(del.getTarget(n)) }

    override AstNode getChild(int index) { result = this.getTarget(index) }
  }

  /** A `try` statement. */
  class TryStmt extends Stmt {
    private Py::Try tryStmt;

    TryStmt() { tryStmt = this.asStmt() }

    Stmt getBody() { result = TBlockStmt(tryStmt, "body") }

    /** Gets the `else` branch of this `try` statement, if any. */
    Stmt getElse() { result = TBlockStmt(tryStmt, "orelse") }

    Stmt getFinally() { result = TBlockStmt(tryStmt, "finally") }

    CatchClause getCatch(int index) { result = TStmt(tryStmt.getHandler(index)) }

    override AstNode getChild(int index) {
      index = 0 and result = this.getBody()
      or
      result = this.getCatch(index - 1) and index >= 1
      or
      index = -1 and result = this.getFinally()
      or
      index = -2 and result = this.getElse()
    }
  }

  /**
   * Gets the `else` branch of `try` statement `try`, if any.
   */
  AstNode getTryElse(TryStmt try) { result = try.getElse() }

  /**
   * Gets the `else` branch of `while` loop `loop`, if any.
   */
  AstNode getWhileElse(WhileStmt loop) { result = loop.getElse() }

  /**
   * Gets the `else` branch of `for` loop `loop`, if any.
   */
  AstNode getForeachElse(ForeachStmt loop) { result = loop.getElse() }

  /** An exception handler (`except` or `except*`). */
  class CatchClause extends Stmt {
    private Py::ExceptionHandler handler;

    CatchClause() { handler = this.asStmt() }

    /** Gets the type expression of this exception handler. */
    Expr getType() { result = TExpr(handler.getType()) }

    /** Gets the variable name of this exception handler, if any. */
    AstNode getVariable() { result = TExpr(handler.getName()) }

    /** Holds: catch clauses do not have a `Condition` in Python's model. */
    Expr getCondition() { none() }

    /** Gets the body of this exception handler. */
    Stmt getBody() {
      result = TBlockStmt(handler.(Py::ExceptStmt), "body")
      or
      result = TBlockStmt(handler.(Py::ExceptGroupStmt), "body")
    }

    override AstNode getChild(int index) {
      index = 0 and result = this.getType()
      or
      index = 1 and result = this.getVariable()
      or
      index = 2 and result = this.getBody()
    }
  }

  /** A `match` statement, mapped to the shared CFG's `Switch`. */
  class Switch extends Stmt {
    private Py::MatchStmt matchStmt;

    Switch() { matchStmt = this.asStmt() }

    Expr getExpr() { result = TExpr(matchStmt.getSubject()) }

    Case getCase(int index) { result = TStmt(matchStmt.getCase(index)) }

    Stmt getStmt(int index) { none() }

    override AstNode getChild(int index) {
      index = 0 and result = this.getExpr()
      or
      result = this.getCase(index - 1) and index >= 1
    }
  }

  /** A `case` clause in a match statement. */
  class Case extends Stmt {
    private Py::Case caseStmt;

    Case() { caseStmt = this.asStmt() }

    AstNode getAPattern() { result = TPattern(caseStmt.getPattern()) }

    Expr getGuard() { result = TExpr(caseStmt.getGuard().(Py::Guard).getTest()) }

    AstNode getBody() { result = TBlockStmt(caseStmt, "body") }

    /** Holds if this case is a wildcard pattern (`case _:`). */
    predicate isWildcard() { caseStmt.getPattern() instanceof Py::MatchWildcardPattern }

    override AstNode getChild(int index) {
      index = 0 and result = this.getAPattern()
      or
      index = 1 and result = this.getGuard()
      or
      index = 2 and result = this.getBody()
    }
  }

  /** A wildcard case (`case _:`). */
  class DefaultCase extends Case {
    DefaultCase() { this.isWildcard() }
  }

  /** A conditional expression (`x if cond else y`). */
  class ConditionalExpr extends Expr {
    private Py::IfExp ifExp;

    ConditionalExpr() { ifExp = this.asExpr() }

    /** Gets the condition of this expression. */
    Expr getCondition() { result = TExpr(ifExp.getTest()) }

    /** Gets the true branch of this expression. */
    Expr getThen() { result = TExpr(ifExp.getBody()) }

    /** Gets the false branch of this expression. */
    Expr getElse() { result = TExpr(ifExp.getOrelse()) }

    override AstNode getChild(int index) {
      index = 0 and result = this.getCondition()
      or
      index = 1 and result = this.getThen()
      or
      index = 2 and result = this.getElse()
    }
  }

  /**
   * A binary expression for the shared CFG. In Python, this covers
   * `and`/`or` expressions (both real 2-operand and synthetic pairs).
   */
  class BinaryExpr extends Expr {
    BinaryExpr() {
      exists(Py::BoolExpr be | this = TExpr(be) and count(be.getAValue()) >= 2)
      or
      this instanceof TBoolExprPair
    }

    /** Gets the left operand of this binary expression. */
    Expr getLeftOperand() {
      exists(Py::BoolExpr be | this = TExpr(be) and result = TExpr(be.getValue(0)))
      or
      exists(Py::BoolExpr be, int i |
        this = TBoolExprPair(be, i) and result = TExpr(be.getValue(i))
      )
    }

    /** Gets the right operand of this binary expression. */
    Expr getRightOperand() {
      // 2-operand BoolExpr: right operand is value(1).
      exists(Py::BoolExpr be |
        this = TExpr(be) and
        count(be.getAValue()) = 2 and
        result = TExpr(be.getValue(1))
      )
      or
      // 3+ operand BoolExpr (outermost): right operand is the synthetic
      // pair at index 1.
      exists(Py::BoolExpr be |
        this = TExpr(be) and
        count(be.getAValue()) > 2 and
        result = TBoolExprPair(be, 1)
      )
      or
      // Last synthetic pair: right operand is the final value.
      exists(Py::BoolExpr be, int i, int n |
        this = TBoolExprPair(be, i) and
        n = count(be.getAValue()) and
        i = n - 2 and
        result = TExpr(be.getValue(i + 1))
      )
      or
      // Non-last synthetic pair: right operand is the next pair.
      exists(Py::BoolExpr be, int i, int n |
        this = TBoolExprPair(be, i) and
        n = count(be.getAValue()) and
        i < n - 2 and
        result = TBoolExprPair(be, i + 1)
      )
    }

    override AstNode getChild(int index) {
      index = 0 and result = this.getLeftOperand()
      or
      index = 1 and result = this.getRightOperand()
    }
  }

  /** A short-circuiting logical `and` expression. */
  class LogicalAndExpr extends BinaryExpr {
    LogicalAndExpr() {
      exists(Py::BoolExpr be |
        be.getOp() instanceof Py::And and
        (this = TExpr(be) or this = TBoolExprPair(be, _))
      )
    }
  }

  /** A short-circuiting logical `or` expression. */
  class LogicalOrExpr extends BinaryExpr {
    LogicalOrExpr() {
      exists(Py::BoolExpr be |
        be.getOp() instanceof Py::Or and
        (this = TExpr(be) or this = TBoolExprPair(be, _))
      )
    }
  }

  /** A null-coalescing expression. Python has no null-coalescing operator. */
  class NullCoalescingExpr extends BinaryExpr {
    NullCoalescingExpr() { none() }
  }

  /**
   * A unary expression. Currently only used for the `not` subclass.
   */
  class UnaryExpr extends Expr {
    UnaryExpr() { this.asExpr().(Py::UnaryExpr).getOp() instanceof Py::Not }

    /** Gets the operand of this unary expression. */
    Expr getOperand() { result = TExpr(this.asExpr().(Py::UnaryExpr).getOperand()) }

    override AstNode getChild(int index) { index = 0 and result = this.getOperand() }
  }

  /** A logical `not` expression. */
  class LogicalNotExpr extends UnaryExpr { }

  /** An assignment expression. Python's walrus is modelled separately. */
  class Assignment extends BinaryExpr {
    Assignment() { none() }
  }

  class AssignExpr extends Assignment { }

  class CompoundAssignment extends Assignment { }

  class AssignLogicalAndExpr extends CompoundAssignment { }

  class AssignLogicalOrExpr extends CompoundAssignment { }

  class AssignNullCoalescingExpr extends CompoundAssignment { }

  /** A boolean literal expression (`True` or `False`). */
  class BooleanLiteral extends Expr {
    BooleanLiteral() { this.asExpr() instanceof Py::True or this.asExpr() instanceof Py::False }

    /** Gets the boolean value of this literal. */
    boolean getValue() {
      this.asExpr() instanceof Py::True and result = true
      or
      this.asExpr() instanceof Py::False and result = false
    }
  }

  /** A pattern match expression. Python has no `instanceof`-style pattern match expression. */
  class PatternMatchExpr extends Expr {
    PatternMatchExpr() { none() }

    Expr getExpr() { none() }

    AstNode getPattern() { none() }
  }

  // ===== Python-specific expression classes (used by `getChild`) =====
  /** A Python binary expression (arithmetic, bitwise, matmul, etc.). */
  additional class ArithBinaryExpr extends Expr {
    private Py::BinaryExpr binExpr;

    ArithBinaryExpr() { binExpr = this.asExpr() }

    Expr getLeft() { result = TExpr(binExpr.getLeft()) }

    Expr getRight() { result = TExpr(binExpr.getRight()) }

    override AstNode getChild(int index) {
      index = 0 and result = this.getLeft()
      or
      index = 1 and result = this.getRight()
    }
  }

  /** A call expression (`func(args...)`). */
  additional class CallExpr extends Expr {
    private Py::Call call;

    CallExpr() { call = this.asExpr() }

    Expr getFunc() { result = TExpr(call.getFunc()) }

    Expr getPositionalArg(int n) { result = TExpr(call.getPositionalArg(n)) }

    int getNumberOfPositionalArgs() { result = count(call.getAPositionalArg()) }

    Expr getKeywordValue(int n) {
      result = TExpr(call.getNamedArg(n).(Py::Keyword).getValue())
      or
      result = TExpr(call.getNamedArg(n).(Py::DictUnpacking).getValue())
    }

    int getNumberOfNamedArgs() { result = count(call.getANamedArg()) }

    override AstNode getChild(int index) {
      index = 0 and result = this.getFunc()
      or
      result = this.getPositionalArg(index - 1) and index >= 1
      or
      result = this.getKeywordValue(index - 1 - this.getNumberOfPositionalArgs()) and
      index >= 1 + this.getNumberOfPositionalArgs()
    }
  }

  /** A subscript expression (`obj[index]`). */
  additional class SubscriptExpr extends Expr {
    private Py::Subscript sub;

    SubscriptExpr() { sub = this.asExpr() }

    Expr getObject() { result = TExpr(sub.getObject()) }

    Expr getIndex() { result = TExpr(sub.getIndex()) }

    override AstNode getChild(int index) {
      index = 0 and result = this.getObject()
      or
      index = 1 and result = this.getIndex()
    }
  }

  /** An attribute access (`obj.name`). */
  additional class AttributeExpr extends Expr {
    private Py::Attribute attr;

    AttributeExpr() { attr = this.asExpr() }

    Expr getObject() { result = TExpr(attr.getObject()) }

    override AstNode getChild(int index) { index = 0 and result = this.getObject() }
  }

  /** A tuple literal. */
  additional class TupleExpr extends Expr {
    private Py::Tuple tuple;

    TupleExpr() { tuple = this.asExpr() }

    Expr getElt(int n) { result = TExpr(tuple.getElt(n)) }

    override AstNode getChild(int index) { result = this.getElt(index) }
  }

  /** A list literal. */
  additional class ListExpr extends Expr {
    private Py::List list;

    ListExpr() { list = this.asExpr() }

    Expr getElt(int n) { result = TExpr(list.getElt(n)) }

    override AstNode getChild(int index) { result = this.getElt(index) }
  }

  /** A set literal. */
  additional class SetExpr extends Expr {
    private Py::Set set;

    SetExpr() { set = this.asExpr() }

    Expr getElt(int n) { result = TExpr(set.getElt(n)) }

    override AstNode getChild(int index) { result = this.getElt(index) }
  }

  /** A dict literal. */
  additional class DictExpr extends Expr {
    private Py::Dict dict;

    DictExpr() { dict = this.asExpr() }

    /**
     * Gets the key of the `n`th item (at child index `2*n`); the value is
     * at child index `2*n + 1`.
     */
    Expr getKey(int n) { result = TExpr(dict.getItem(n).(Py::KeyValuePair).getKey()) }

    Expr getValue(int n) { result = TExpr(dict.getItem(n).(Py::KeyValuePair).getValue()) }

    int getNumberOfItems() { result = count(dict.getAnItem()) }

    override AstNode getChild(int index) {
      exists(int item |
        index = 2 * item and result = this.getKey(item)
        or
        index = 2 * item + 1 and result = this.getValue(item)
      )
    }
  }

  /** A unary expression other than `not` (e.g., `-x`, `+x`, `~x`). */
  additional class ArithUnaryExpr extends Expr {
    private Py::UnaryExpr unaryExpr;

    ArithUnaryExpr() { unaryExpr = this.asExpr() and not unaryExpr.getOp() instanceof Py::Not }

    Expr getOperand() { result = TExpr(unaryExpr.getOperand()) }

    override AstNode getChild(int index) { index = 0 and result = this.getOperand() }
  }

  /**
   * A comprehension or generator expression. The iterable is evaluated in
   * the enclosing scope; the body runs in a nested synthetic function
   * scope handled by its own CFG.
   */
  additional class Comprehension extends Expr {
    private Py::Expr iterable;

    Comprehension() {
      iterable = this.asExpr().(Py::ListComp).getIterable()
      or
      iterable = this.asExpr().(Py::SetComp).getIterable()
      or
      iterable = this.asExpr().(Py::DictComp).getIterable()
      or
      iterable = this.asExpr().(Py::GeneratorExp).getIterable()
    }

    Expr getIterable() { result = TExpr(iterable) }

    override AstNode getChild(int index) { index = 0 and result = this.getIterable() }
  }

  /** A comparison expression (`a < b`, `a < b < c`, etc.). */
  additional class CompareExpr extends Expr {
    private Py::Compare cmp;

    CompareExpr() { cmp = this.asExpr() }

    Expr getLeft() { result = TExpr(cmp.getLeft()) }

    Expr getComparator(int n) { result = TExpr(cmp.getComparator(n)) }

    override AstNode getChild(int index) {
      index = 0 and result = this.getLeft()
      or
      result = this.getComparator(index - 1) and index >= 1
    }
  }

  /** A slice expression (`start:stop:step`). */
  additional class SliceExpr extends Expr {
    private Py::Slice slice;

    SliceExpr() { slice = this.asExpr() }

    Expr getStart() { result = TExpr(slice.getStart()) }

    Expr getStop() { result = TExpr(slice.getStop()) }

    Expr getStep() { result = TExpr(slice.getStep()) }

    override AstNode getChild(int index) {
      index = 0 and result = this.getStart()
      or
      index = 1 and result = this.getStop()
      or
      index = 2 and result = this.getStep()
    }
  }

  /** A starred expression (`*x`). */
  additional class StarredExpr extends Expr {
    private Py::Starred starred;

    StarredExpr() { starred = this.asExpr() }

    Expr getValue() { result = TExpr(starred.getValue()) }

    override AstNode getChild(int index) { index = 0 and result = this.getValue() }
  }

  /** A formatted string literal (`f"...{expr}..."`). */
  additional class FstringExpr extends Expr {
    private Py::Fstring fstring;

    FstringExpr() { fstring = this.asExpr() }

    Expr getValue(int n) { result = TExpr(fstring.getValue(n)) }

    override AstNode getChild(int index) { result = this.getValue(index) }
  }

  /** A formatted value inside an f-string (`{expr}` or `{expr:spec}`). */
  additional class FormattedValueExpr extends Expr {
    private Py::FormattedValue fv;

    FormattedValueExpr() { fv = this.asExpr() }

    Expr getValue() { result = TExpr(fv.getValue()) }

    Expr getFormatSpec() { result = TExpr(fv.getFormatSpec()) }

    override AstNode getChild(int index) {
      index = 0 and result = this.getValue()
      or
      index = 1 and result = this.getFormatSpec()
    }
  }

  /** A `yield` expression. */
  additional class YieldExpr extends Expr {
    private Py::Yield yield;

    YieldExpr() { yield = this.asExpr() }

    Expr getValue() { result = TExpr(yield.getValue()) }

    override AstNode getChild(int index) { index = 0 and result = this.getValue() }
  }

  /** A `yield from` expression. */
  additional class YieldFromExpr extends Expr {
    private Py::YieldFrom yieldFrom;

    YieldFromExpr() { yieldFrom = this.asExpr() }

    Expr getValue() { result = TExpr(yieldFrom.getValue()) }

    override AstNode getChild(int index) { index = 0 and result = this.getValue() }
  }

  /** An `await` expression. */
  additional class AwaitExpr extends Expr {
    private Py::Await await;

    AwaitExpr() { await = this.asExpr() }

    Expr getValue() { result = TExpr(await.getValue()) }

    override AstNode getChild(int index) { index = 0 and result = this.getValue() }
  }

  /** A class definition expression (has base classes evaluated at definition time). */
  additional class ClassDefExpr extends Expr {
    private Py::ClassExpr classExpr;

    ClassDefExpr() { classExpr = this.asExpr() }

    Expr getBase(int n) { result = TExpr(classExpr.getBase(n)) }

    override AstNode getChild(int index) { result = this.getBase(index) }
  }

  /** A function definition expression (has default args evaluated at definition time). */
  additional class FunctionDefExpr extends Expr {
    private Py::FunctionExpr funcExpr;

    FunctionDefExpr() { funcExpr = this.asExpr() }

    /**
     * Gets the `n`th default for a positional argument, in evaluation
     * order. Note that `Args.getDefault(int)` is indexed by argument
     * position (with gaps for arguments without defaults), so we must
     * renumber here to obtain contiguous indices.
     */
    Expr getDefault(int n) {
      result =
        TExpr(rank[n + 1](Py::Expr d, int i | d = funcExpr.getArgs().getDefault(i) | d order by i))
    }

    /** Gets the `n`th default for a keyword-only argument, in evaluation order. */
    Expr getKwDefault(int n) {
      result =
        TExpr(rank[n + 1](Py::Expr d, int i | d = funcExpr.getArgs().getKwDefault(i) | d order by i))
    }

    int getNumberOfDefaults() { result = count(funcExpr.getArgs().getADefault()) }

    override AstNode getChild(int index) {
      result = this.getDefault(index)
      or
      result = this.getKwDefault(index - this.getNumberOfDefaults())
    }
  }

  /** A lambda expression (has default args evaluated at definition time). */
  additional class LambdaExpr extends Expr {
    private Py::Lambda lambda;

    LambdaExpr() { lambda = this.asExpr() }

    /** Gets the `n`th default for a positional argument, in evaluation order. */
    Expr getDefault(int n) {
      result =
        TExpr(rank[n + 1](Py::Expr d, int i | d = lambda.getArgs().getDefault(i) | d order by i))
    }

    /** Gets the `n`th default for a keyword-only argument, in evaluation order. */
    Expr getKwDefault(int n) {
      result =
        TExpr(rank[n + 1](Py::Expr d, int i | d = lambda.getArgs().getKwDefault(i) | d order by i))
    }

    int getNumberOfDefaults() { result = count(lambda.getArgs().getADefault()) }

    override AstNode getChild(int index) {
      result = this.getDefault(index)
      or
      result = this.getKwDefault(index - this.getNumberOfDefaults())
    }
  }

  /** Gets the child of `n` at the specified (zero-based) index. */
  AstNode getChild(AstNode n, int index) { result = n.getChild(index) }
}

private module Cfg0 = Make0<Py::Location, Ast>;

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

  class CallableContext = Void;

  predicate inConditionalContext(Ast::AstNode n, ConditionKind kind) {
    kind.isBoolean() and
    n = any(Ast::AssertStmt a).getTest()
  }

  private string assertThrowTag() { result = "[assert-throw]" }

  predicate additionalNode(Ast::AstNode n, string tag, NormalSuccessor t) {
    n instanceof Ast::AssertStmt and tag = assertThrowTag() and t instanceof DirectSuccessor
  }

  predicate beginAbruptCompletion(
    Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
  ) {
    ast instanceof Ast::AssertStmt and
    n.isAdditional(ast, assertThrowTag()) and
    c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
    always = true
  }

  predicate endAbruptCompletion(Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c) {
    none()
  }

  predicate step(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Ast::AssertStmt assertStmt |
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
 * Maps a CFG AST wrapper node to the corresponding Python AST node, if any.
 * Entry, exit, and synthetic nodes have no corresponding Python AST node.
 */
Py::AstNode astNodeToPyNode(Ast::AstNode n) {
  result = n.asExpr()
  or
  result = n.asStmt()
  or
  result = n.asScope()
}
