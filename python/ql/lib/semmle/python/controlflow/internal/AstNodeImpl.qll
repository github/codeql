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
    string toString() {
      exists(Py::Stmt s | this = TStmt(s) and result = s.toString())
      or
      exists(Py::Expr e | this = TExpr(e) and result = e.toString())
      or
      exists(Py::Scope sc | this = TScope(sc) and result = sc.toString())
      or
      exists(Py::Pattern p | this = TPattern(p) and result = p.toString())
      or
      exists(Py::BoolExpr be | this = TBoolExprPair(be, _) and result = be.getOperator())
      or
      exists(string slot | this = TBlockStmt(_, slot) and result = "block:" + slot)
    }

    /** Gets the location of this AST node. */
    Py::Location getLocation() {
      exists(Py::Stmt s | this = TStmt(s) and result = s.getLocation())
      or
      exists(Py::Expr e | this = TExpr(e) and result = e.getLocation())
      or
      exists(Py::Scope sc | this = TScope(sc) and result = sc.getLocation())
      or
      exists(Py::Pattern p | this = TPattern(p) and result = p.getLocation())
      or
      exists(Py::BoolExpr be, int index |
        this = TBoolExprPair(be, index) and result = be.getValue(index).getLocation()
      )
      or
      // BlockStmt has no native location; approximate with the first
      // item's location.
      exists(Py::AstNode parent, string slot |
        this = TBlockStmt(parent, slot) and
        result = getBodyStmtList(parent, slot).getItem(0).getLocation()
      )
    }

    /** Gets the enclosing callable that contains this node, if any. */
    Callable getEnclosingCallable() {
      exists(Py::Stmt s | this = TStmt(s) and result.asScope() = s.getScope())
      or
      exists(Py::Expr e | this = TExpr(e) and result.asScope() = e.getScope())
      or
      exists(Py::Scope sc | this = TScope(sc) and result.asScope() = sc.getEnclosingScope())
      or
      exists(Py::Pattern p | this = TPattern(p) and result.asScope() = p.getScope())
      or
      exists(Py::BoolExpr be | this = TBoolExprPair(be, _) and result.asScope() = be.getScope())
      or
      exists(Py::AstNode parent | this = TBlockStmt(parent, _) |
        result.asScope() = parent.(Py::Scope)
        or
        result.asScope() = parent.(Py::Stmt).getScope()
      )
    }

    /** Gets the underlying Python `Stmt`, if this node wraps one. */
    Py::Stmt asStmt() { this = TStmt(result) }

    /** Gets the underlying Python `Expr`, if this node wraps one. */
    Py::Expr asExpr() { this = TExpr(result) }

    /** Gets the underlying Python `Scope`, if this node wraps one. */
    Py::Scope asScope() { this = TScope(result) }

    /** Gets the underlying Python `Pattern`, if this node wraps one. */
    Py::Pattern asPattern() { this = TPattern(result) }
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
  }

  /** An expression statement. */
  class ExprStmt extends Stmt {
    private Py::ExprStmt exprStmt;

    ExprStmt() { exprStmt = this.asStmt() }

    /** Gets the expression in this expression statement. */
    Expr getExpr() { result = TExpr(exprStmt.getValue()) }
  }

  /** An assignment statement (`x = y = expr`). */
  additional class AssignStmt extends Stmt {
    private Py::Assign assign;

    AssignStmt() { assign = this.asStmt() }

    Expr getValue() { result = TExpr(assign.getValue()) }

    Expr getTarget(int n) { result = TExpr(assign.getTarget(n)) }

    int getNumberOfTargets() { result = count(assign.getATarget()) }
  }

  /** An augmented assignment statement (`x += expr`). */
  additional class AugAssignStmt extends Stmt {
    private Py::AugAssign augAssign;

    AugAssignStmt() { augAssign = this.asStmt() }

    Expr getOperation() { result = TExpr(augAssign.getOperation()) }
  }

  /** An assignment expression / walrus operator (`x := expr`). */
  additional class NamedExpr extends Expr {
    private Py::AssignExpr assignExpr;

    NamedExpr() { assignExpr = this.asExpr() }

    Expr getValue() { result = TExpr(assignExpr.getValue()) }

    Expr getTarget() { result = TExpr(assignExpr.getTarget()) }
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
  }

  /** A `raise` statement (mapped to `Throw`). */
  class Throw extends Stmt {
    private Py::Raise raise;

    Throw() { raise = this.asStmt() }

    /** Gets the expression being raised. */
    Expr getExpr() { result = TExpr(raise.getException()) }

    /** Gets the cause of this `raise`, if any. */
    Expr getCause() { result = TExpr(raise.getCause()) }
  }

  /** A `with` statement. */
  additional class WithStmt extends Stmt {
    private Py::With withStmt;

    WithStmt() { withStmt = this.asStmt() }

    Expr getContextExpr() { result = TExpr(withStmt.getContextExpr()) }

    Expr getOptionalVars() { result = TExpr(withStmt.getOptionalVars()) }

    Stmt getBody() { result = TBlockStmt(withStmt, "body") }
  }

  /** An `assert` statement. */
  additional class AssertStmt extends Stmt {
    private Py::Assert assertStmt;

    AssertStmt() { assertStmt = this.asStmt() }

    Expr getTest() { result = TExpr(assertStmt.getTest()) }

    Expr getMsg() { result = TExpr(assertStmt.getMsg()) }
  }

  /** A `delete` statement. */
  additional class DeleteStmt extends Stmt {
    private Py::Delete del;

    DeleteStmt() { del = this.asStmt() }

    Expr getTarget(int n) { result = TExpr(del.getTarget(n)) }
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
  }

  /** A `match` statement, mapped to the shared CFG's `Switch`. */
  class Switch extends Stmt {
    private Py::MatchStmt matchStmt;

    Switch() { matchStmt = this.asStmt() }

    Expr getExpr() { result = TExpr(matchStmt.getSubject()) }

    Case getCase(int index) { result = TStmt(matchStmt.getCase(index)) }

    Stmt getStmt(int index) { none() }
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
  }

  /** A subscript expression (`obj[index]`). */
  additional class SubscriptExpr extends Expr {
    private Py::Subscript sub;

    SubscriptExpr() { sub = this.asExpr() }

    Expr getObject() { result = TExpr(sub.getObject()) }

    Expr getIndex() { result = TExpr(sub.getIndex()) }
  }

  /** An attribute access (`obj.name`). */
  additional class AttributeExpr extends Expr {
    private Py::Attribute attr;

    AttributeExpr() { attr = this.asExpr() }

    Expr getObject() { result = TExpr(attr.getObject()) }
  }

  /** A tuple literal. */
  additional class TupleExpr extends Expr {
    private Py::Tuple tuple;

    TupleExpr() { tuple = this.asExpr() }

    Expr getElt(int n) { result = TExpr(tuple.getElt(n)) }
  }

  /** A list literal. */
  additional class ListExpr extends Expr {
    private Py::List list;

    ListExpr() { list = this.asExpr() }

    Expr getElt(int n) { result = TExpr(list.getElt(n)) }
  }

  /** A set literal. */
  additional class SetExpr extends Expr {
    private Py::Set set;

    SetExpr() { set = this.asExpr() }

    Expr getElt(int n) { result = TExpr(set.getElt(n)) }
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
  }

  /** A unary expression other than `not` (e.g., `-x`, `+x`, `~x`). */
  additional class ArithUnaryExpr extends Expr {
    private Py::UnaryExpr unaryExpr;

    ArithUnaryExpr() { unaryExpr = this.asExpr() and not unaryExpr.getOp() instanceof Py::Not }

    Expr getOperand() { result = TExpr(unaryExpr.getOperand()) }
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
  }

  /** A comparison expression (`a < b`, `a < b < c`, etc.). */
  additional class CompareExpr extends Expr {
    private Py::Compare cmp;

    CompareExpr() { cmp = this.asExpr() }

    Expr getLeft() { result = TExpr(cmp.getLeft()) }

    Expr getComparator(int n) { result = TExpr(cmp.getComparator(n)) }
  }

  /** A slice expression (`start:stop:step`). */
  additional class SliceExpr extends Expr {
    private Py::Slice slice;

    SliceExpr() { slice = this.asExpr() }

    Expr getStart() { result = TExpr(slice.getStart()) }

    Expr getStop() { result = TExpr(slice.getStop()) }

    Expr getStep() { result = TExpr(slice.getStep()) }
  }

  /** A starred expression (`*x`). */
  additional class StarredExpr extends Expr {
    private Py::Starred starred;

    StarredExpr() { starred = this.asExpr() }

    Expr getValue() { result = TExpr(starred.getValue()) }
  }

  /** A formatted string literal (`f"...{expr}..."`). */
  additional class FstringExpr extends Expr {
    private Py::Fstring fstring;

    FstringExpr() { fstring = this.asExpr() }

    Expr getValue(int n) { result = TExpr(fstring.getValue(n)) }
  }

  /** A formatted value inside an f-string (`{expr}` or `{expr:spec}`). */
  additional class FormattedValueExpr extends Expr {
    private Py::FormattedValue fv;

    FormattedValueExpr() { fv = this.asExpr() }

    Expr getValue() { result = TExpr(fv.getValue()) }

    Expr getFormatSpec() { result = TExpr(fv.getFormatSpec()) }
  }

  /** A `yield` expression. */
  additional class YieldExpr extends Expr {
    private Py::Yield yield;

    YieldExpr() { yield = this.asExpr() }

    Expr getValue() { result = TExpr(yield.getValue()) }
  }

  /** A `yield from` expression. */
  additional class YieldFromExpr extends Expr {
    private Py::YieldFrom yieldFrom;

    YieldFromExpr() { yieldFrom = this.asExpr() }

    Expr getValue() { result = TExpr(yieldFrom.getValue()) }
  }

  /** An `await` expression. */
  additional class AwaitExpr extends Expr {
    private Py::Await await;

    AwaitExpr() { await = this.asExpr() }

    Expr getValue() { result = TExpr(await.getValue()) }
  }

  /** A class definition expression (has base classes evaluated at definition time). */
  additional class ClassDefExpr extends Expr {
    private Py::ClassExpr classExpr;

    ClassDefExpr() { classExpr = this.asExpr() }

    Expr getBase(int n) { result = TExpr(classExpr.getBase(n)) }
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
  }

  /** Gets the child of `n` at the specified (zero-based) index. */
  AstNode getChild(AstNode n, int index) {
    // BlockStmt: indexed statements
    result = n.(BlockStmt).getStmt(index)
    or
    // IfStmt: condition (0), then (1), else (2)
    exists(IfStmt ifStmt | ifStmt = n |
      index = 0 and result = ifStmt.getCondition()
      or
      index = 1 and result = ifStmt.getThen()
      or
      index = 2 and result = ifStmt.getElse()
    )
    or
    // ExprStmt: the expression (0)
    index = 0 and result = n.(ExprStmt).getExpr()
    or
    // Assign: value (0), targets (1..n)
    exists(AssignStmt a | a = n |
      index = 0 and result = a.getValue()
      or
      result = a.getTarget(index - 1) and index >= 1
    )
    or
    // AugAssign: the operation (0)
    index = 0 and result = n.(AugAssignStmt).getOperation()
    or
    // Walrus (`x := expr`): value (0), target (1)
    exists(NamedExpr ne | ne = n |
      index = 0 and result = ne.getValue()
      or
      index = 1 and result = ne.getTarget()
    )
    or
    // WhileStmt: condition (0), body (1), orelse (2)
    exists(WhileStmt w | w = n |
      index = 0 and result = w.getCondition()
      or
      index = 1 and result = w.getBody()
      or
      index = 2 and result = w.getElse()
    )
    or
    // ForeachStmt: collection (0), variable (1), body (2), orelse (3)
    exists(ForeachStmt f | f = n |
      index = 0 and result = f.getCollection()
      or
      index = 1 and result = f.getVariable()
      or
      index = 2 and result = f.getBody()
      or
      index = 3 and result = f.getElse()
    )
    or
    // ReturnStmt: the value (0)
    index = 0 and result = n.(ReturnStmt).getExpr()
    or
    // AssertStmt: test (0), message (1)
    exists(AssertStmt a | a = n |
      index = 0 and result = a.getTest()
      or
      index = 1 and result = a.getMsg()
    )
    or
    // DeleteStmt: targets left to right
    result = n.(DeleteStmt).getTarget(index)
    or
    // WithStmt: context expr (0), optional vars (1), body (2)
    exists(WithStmt w | w = n |
      index = 0 and result = w.getContextExpr()
      or
      index = 1 and result = w.getOptionalVars()
      or
      index = 2 and result = w.getBody()
    )
    or
    // Throw (raise): exception (0), cause (1)
    exists(Throw r | r = n |
      index = 0 and result = r.getExpr()
      or
      index = 1 and result = r.getCause()
    )
    or
    // TryStmt: body (0), handlers (1..n), else (-2), finally (-1)
    exists(TryStmt t | t = n |
      index = 0 and result = t.getBody()
      or
      result = t.getCatch(index - 1) and index >= 1
      or
      index = -1 and result = t.getFinally()
      or
      index = -2 and result = t.getElse()
    )
    or
    // Switch (match): subject (0), cases (1..n)
    exists(Switch m | m = n |
      index = 0 and result = m.getExpr()
      or
      result = m.getCase(index - 1) and index >= 1
    )
    or
    // Case: pattern (0), guard (1), body (2)
    exists(Case c | c = n |
      index = 0 and result = c.getAPattern()
      or
      index = 1 and result = c.getGuard()
      or
      index = 2 and result = c.getBody()
    )
    or
    // CatchClause (except handler): type (0), name (1), body (2)
    exists(CatchClause h | h = n |
      index = 0 and result = h.getType()
      or
      index = 1 and result = h.getVariable()
      or
      index = 2 and result = h.getBody()
    )
    or
    // ConditionalExpr (IfExp): condition (0), then (1), else (2)
    exists(ConditionalExpr ie | ie = n |
      index = 0 and result = ie.getCondition()
      or
      index = 1 and result = ie.getThen()
      or
      index = 2 and result = ie.getElse()
    )
    or
    // Call: func (0), positional args (1..n), keyword values (n+1..n+k)
    exists(CallExpr call | call = n |
      index = 0 and result = call.getFunc()
      or
      result = call.getPositionalArg(index - 1) and index >= 1
      or
      result = call.getKeywordValue(index - 1 - call.getNumberOfPositionalArgs()) and
      index >= 1 + call.getNumberOfPositionalArgs()
    )
    or
    // Python BinaryExpr (arithmetic, bitwise, matmul, etc.): left (0), right (1)
    exists(ArithBinaryExpr be | be = n |
      index = 0 and result = be.getLeft()
      or
      index = 1 and result = be.getRight()
    )
    or
    // Subscript (obj[index]): object (0), index (1)
    exists(SubscriptExpr sub | sub = n |
      index = 0 and result = sub.getObject()
      or
      index = 1 and result = sub.getIndex()
    )
    or
    // Attribute (obj.name): object (0)
    index = 0 and result = n.(AttributeExpr).getObject()
    or
    // Comprehension/generator: iterable (0)
    index = 0 and result = n.(Comprehension).getIterable()
    or
    // Tuple, List, Set: elements left to right
    result = n.(TupleExpr).getElt(index)
    or
    result = n.(ListExpr).getElt(index)
    or
    result = n.(SetExpr).getElt(index)
    or
    // Dict: key(0), value(0), key(1), value(1), ...
    exists(DictExpr d, int item | d = n |
      index = 2 * item and result = d.getKey(item)
      or
      index = 2 * item + 1 and result = d.getValue(item)
    )
    or
    // Arithmetic unary (-x, +x, ~x): operand (0)
    index = 0 and result = n.(ArithUnaryExpr).getOperand()
    or
    // Compare (a < b < c): left (0), comparators (1..n)
    exists(CompareExpr cmp | cmp = n |
      index = 0 and result = cmp.getLeft()
      or
      result = cmp.getComparator(index - 1) and index >= 1
    )
    or
    // Slice (start:stop:step): start (0), stop (1), step (2)
    exists(SliceExpr sl | sl = n |
      index = 0 and result = sl.getStart()
      or
      index = 1 and result = sl.getStop()
      or
      index = 2 and result = sl.getStep()
    )
    or
    // Starred (*x): value (0)
    index = 0 and result = n.(StarredExpr).getValue()
    or
    // Fstring: values left to right
    result = n.(FstringExpr).getValue(index)
    or
    // FormattedValue ({expr} or {expr:spec}): value (0), format spec (1)
    exists(FormattedValueExpr fv | fv = n |
      index = 0 and result = fv.getValue()
      or
      index = 1 and result = fv.getFormatSpec()
    )
    or
    // Yield: value (0)
    index = 0 and result = n.(YieldExpr).getValue()
    or
    // YieldFrom: value (0)
    index = 0 and result = n.(YieldFromExpr).getValue()
    or
    // Await: value (0)
    index = 0 and result = n.(AwaitExpr).getValue()
    or
    // ClassExpr: base classes left to right
    result = n.(ClassDefExpr).getBase(index)
    or
    // FunctionExpr: defaults left to right, then kw defaults
    exists(FunctionDefExpr fe | fe = n |
      result = fe.getDefault(index)
      or
      result = fe.getKwDefault(index - fe.getNumberOfDefaults())
    )
    or
    // Lambda: defaults left to right, then kw defaults
    exists(LambdaExpr lam | lam = n |
      result = lam.getDefault(index)
      or
      result = lam.getKwDefault(index - lam.getNumberOfDefaults())
    )
    or
    // LogicalNotExpr: operand (0)
    index = 0 and result = n.(LogicalNotExpr).getOperand()
    or
    // BinaryExpr (`and`/`or`): left (0), right (1)
    exists(BinaryExpr be | be = n |
      index = 0 and result = be.getLeftOperand()
      or
      index = 1 and result = be.getRightOperand()
    )
  }
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

  class CallableBodyPartContext = Void;

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
