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
  private newtype TAstNode =
    TPyStmt(Py::Stmt s) or
    TPyExpr(Py::Expr e) { not e instanceof Py::BoolExpr } or
    TScope(Py::Scope sc) or
    TPattern(Py::Pattern p) or
    /**
     * A synthetic node representing an operand pair of an `and`/`or`
     * expression. For `a and b and c` (operands 0, 1, 2) we model the
     * operation as a right-nested tree: pair 0 represents the whole
     * expression with left=a and right=pair 1; pair 1 represents
     * `b and c` with left=b and right=c. Each Python `Py::BoolExpr`
     * with `n` operands has `n - 1` such pairs (indices `0 .. n - 2`).
     */
    TBoolExprPair(Py::BoolExpr be, int index) { index = [0 .. count(be.getAValue()) - 2] } or
    /**
     * A synthetic block statement, wrapping a `Py::StmtList`. Each list of
     * statements that represents an imperative block (a function/class/module
     * body, an `if`/`while`/`for` branch, a `try`/`except`/`finally` body,
     * etc.) becomes one `BlockStmt` node in the CFG. `Py::StmtList`s used
     * in other roles - `Try.getHandlers()` (iterated via `getCatch`) and
     * `MatchStmt.getCases()` (iterated via `getCase`) - are excluded, as
     * the shared library's `Try`/`Switch` logic walks their items
     * individually.
     */
    TBlockStmt(Py::StmtList sl) {
      not sl = any(Py::Try t).getHandlers() and
      not sl = any(Py::MatchStmt m).getCases()
    }

  /**
   * The union of `TPyStmt` (wrapping `Py::Stmt`) and `TBlockStmt` (wrapping
   * `Py::StmtList`). Both represent the kinds of node that can appear in
   * a `Stmt` position in the CFG.
   */
  private class TStmt = TPyStmt or TBlockStmt;

  /**
   * The union of `TPyExpr` (wrapping non-boolean `Py::Expr`) and
   * `TBoolExprPair` (synthetic operand pairs of `and`/`or` expressions).
   * Both represent the kinds of node that can appear in an `Expr`
   * position in the CFG.
   */
  private class TExpr = TPyExpr or TBoolExprPair;

  /**
   * An AST node visible to the shared CFG.
   *
   * This is the abstract implementation class. It enforces that each
   * concrete subclass provides `toString`, `getLocation`, and
   * `getEnclosingCallable` (one subclass per `TAstNode` newtype branch).
   * The public alias `AstNode` is what users (and the `AstSig` signature)
   * see; subclasses inside this module extend `AstNodeImpl` directly.
   */
  abstract private class AstNodeImpl extends TAstNode {
    /** Gets a textual representation of this AST node. */
    abstract string toString();

    /** Gets the location of this AST node. */
    abstract Py::Location getLocation();

    /** Gets the enclosing callable that contains this node, if any. */
    abstract Callable getEnclosingCallable();

    /** Gets the underlying Python `Stmt`, if this node wraps one. */
    Py::Stmt asStmt() { this = TPyStmt(result) }

    /**
     * Gets the underlying Python `Expr`, if this node wraps one. Boolean
     * expressions are represented by `TBoolExprPair(_, 0)`; this
     * predicate also recovers the underlying `Py::BoolExpr` from such a
     * representation.
     */
    Py::Expr asExpr() {
      this = TPyExpr(result)
      or
      this = TBoolExprPair(result, 0)
    }

    /** Gets the underlying Python `Scope`, if this node wraps one. */
    Py::Scope asScope() { this = TScope(result) }

    /** Gets the underlying Python `Pattern`, if this node wraps one. */
    Py::Pattern asPattern() { this = TPattern(result) }

    /** Gets the underlying Python `StmtList`, if this node is a `BlockStmt`. */
    Py::StmtList asStmtList() { this = TBlockStmt(result) }

    /**
     * Gets the child of this AST node at the specified (zero-based)
     * index, in evaluation order. Subclasses with children override
     * this method.
     */
    AstNode getChild(int index) { none() }
  }

  /** An AST node visible to the shared CFG. */
  final class AstNode = AstNodeImpl;

  /** Gets the immediately enclosing callable that contains `node`. */
  Callable getEnclosingCallable(AstNode node) { result = node.getEnclosingCallable() }

  /**
   * A callable: a function, class, or module scope.
   *
   * In Python, all three are executable scopes with statement bodies.
   */
  class Callable extends AstNodeImpl, TScope {
    private Py::Scope sc;

    Callable() { this = TScope(sc) }

    override string toString() { result = sc.toString() }

    override Py::Location getLocation() { result = sc.getLocation() }

    override Callable getEnclosingCallable() { result.asScope() = sc.getEnclosingScope() }
  }

  /** Gets the body of callable `c`. */
  AstNode callableGetBody(Callable c) { result.asStmtList() = c.asScope().getBody() }

  /**
   * A parameter of a callable.
   *
   * TODO: Implement in order to include parameters in the CFG.
   */
  class Parameter extends AstNodeImpl {
    Parameter() { none() }

    override string toString() { none() }

    override Py::Location getLocation() { none() }

    override Callable getEnclosingCallable() { none() }

    Expr getDefaultValue() { none() }
  }

  /** Gets the `index`th parameter of callable `c`. */
  Parameter callableGetParameter(Callable c, int index) { none() }

  /** A statement. */
  class Stmt extends AstNodeImpl, TStmt {
    // For `TPyStmt` instances, delegate to the wrapped Python statement.
    // `BlockStmt` (the only `TBlockStmt` subclass) provides its own overrides.
    override string toString() { result = this.asStmt().toString() }

    override Py::Location getLocation() { result = this.asStmt().getLocation() }

    override Callable getEnclosingCallable() { result.asScope() = this.asStmt().getScope() }
  }

  /** An expression. */
  class Expr extends AstNodeImpl, TExpr {
    // For `TPyExpr` instances, delegate to the wrapped Python expression.
    // `BinaryExpr` (the only `TBoolExprPair` subclass) provides its own overrides.
    override string toString() { result = this.asExpr().toString() }

    override Py::Location getLocation() { result = this.asExpr().getLocation() }

    override Callable getEnclosingCallable() { result.asScope() = this.asExpr().getScope() }
  }

  /** A pattern in a `match` statement. */
  additional class Pattern extends AstNodeImpl, TPattern {
    private Py::Pattern p;

    Pattern() { this = TPattern(p) }

    override string toString() { result = p.toString() }

    override Py::Location getLocation() { result = p.getLocation() }

    override Callable getEnclosingCallable() { result.asScope() = p.getScope() }
  }

  /**
   * A block statement, modeling the body of a parent AST node as a
   * sequence of statements.
   */
  class BlockStmt extends Stmt, TBlockStmt {
    private Py::StmtList sl;

    BlockStmt() { this = TBlockStmt(sl) }

    /** Gets the `n`th (zero-based) statement in this block. */
    Stmt getStmt(int n) { result.asStmt() = sl.getItem(n) }

    /** Gets the last statement in this block. */
    Stmt getLastStmt() { result.asStmt() = sl.getLastItem() }

    override string toString() { result = sl.toString() }

    // `Py::StmtList` has no native location; approximate with the first
    // item's location.
    override Py::Location getLocation() { result = sl.getItem(0).getLocation() }

    override Callable getEnclosingCallable() {
      result.asScope() = sl.getParent().(Py::Scope)
      or
      result.asScope() = sl.getParent().(Py::Stmt).getScope()
    }

    override AstNode getChild(int index) { result = this.getStmt(index) }
  }

  /** An expression statement. */
  class ExprStmt extends Stmt {
    private Py::ExprStmt exprStmt;

    ExprStmt() { this = TPyStmt(exprStmt) }

    /** Gets the expression in this expression statement. */
    Expr getExpr() { result.asExpr() = exprStmt.getValue() }

    override AstNode getChild(int index) { index = 0 and result = this.getExpr() }
  }

  /** An assignment statement (`x = y = expr`). */
  additional class AssignStmt extends Stmt {
    private Py::Assign assign;

    AssignStmt() { this = TPyStmt(assign) }

    Expr getValue() { result.asExpr() = assign.getValue() }

    Expr getTarget(int n) { result.asExpr() = assign.getTarget(n) }

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

    AugAssignStmt() { this = TPyStmt(augAssign) }

    Expr getOperation() { result.asExpr() = augAssign.getOperation() }

    override AstNode getChild(int index) { index = 0 and result = this.getOperation() }
  }

  /** An assignment expression / walrus operator (`x := expr`). */
  additional class NamedExpr extends Expr {
    private Py::AssignExpr assignExpr;

    NamedExpr() { this = TPyExpr(assignExpr) }

    Expr getValue() { result.asExpr() = assignExpr.getValue() }

    Expr getTarget() { result.asExpr() = assignExpr.getTarget() }

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

    IfStmt() { this = TPyStmt(ifStmt) }

    /** Gets the underlying Python `If` statement. */
    Py::If asIf() { result = ifStmt }

    /** Gets the condition of this `if` statement. */
    Expr getCondition() { result.asExpr() = ifStmt.getTest() }

    /** Gets the `then` (true) branch of this `if` statement. */
    Stmt getThen() { result.asStmtList() = ifStmt.getBody() }

    /** Gets the `else` (false) branch, if any. */
    Stmt getElse() { result.asStmtList() = ifStmt.getOrelse() }

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
    LoopStmt() {
      this = TPyStmt(any(Py::While w))
      or
      this = TPyStmt(any(Py::For f))
    }

    /** Gets the body of this loop statement. */
    Stmt getBody() { none() }
  }

  /** A `while` loop statement. */
  class WhileStmt extends LoopStmt {
    private Py::While whileStmt;

    WhileStmt() { this = TPyStmt(whileStmt) }

    /** Gets the boolean condition of this `while` loop. */
    Expr getCondition() { result.asExpr() = whileStmt.getTest() }

    override Stmt getBody() { result.asStmtList() = whileStmt.getBody() }

    /** Gets the `else` branch of this `while` loop, if any. */
    Stmt getElse() { result.asStmtList() = whileStmt.getOrelse() }

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

    ForeachStmt() { this = TPyStmt(forStmt) }

    /** Gets the loop variable. */
    Expr getVariable() { result.asExpr() = forStmt.getTarget() }

    /** Gets the collection being iterated. */
    Expr getCollection() { result.asExpr() = forStmt.getIter() }

    override Stmt getBody() { result.asStmtList() = forStmt.getBody() }

    /** Gets the `else` branch of this `for` loop, if any. */
    Stmt getElse() { result.asStmtList() = forStmt.getOrelse() }

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
    BreakStmt() { this = TPyStmt(any(Py::Break b)) }
  }

  /** A `continue` statement. */
  class ContinueStmt extends Stmt {
    ContinueStmt() { this = TPyStmt(any(Py::Continue c)) }
  }

  /** A `goto` statement. Python has no goto. */
  class GotoStmt extends Stmt {
    GotoStmt() { none() }
  }

  /** A `return` statement. */
  class ReturnStmt extends Stmt {
    private Py::Return ret;

    ReturnStmt() { this = TPyStmt(ret) }

    /** Gets the expression being returned, if any. */
    Expr getExpr() { result.asExpr() = ret.getValue() }

    override AstNode getChild(int index) { index = 0 and result = this.getExpr() }
  }

  /** A `raise` statement (mapped to `Throw`). */
  class Throw extends Stmt {
    private Py::Raise raise;

    Throw() { this = TPyStmt(raise) }

    /** Gets the expression being raised. */
    Expr getExpr() { result.asExpr() = raise.getException() }

    /** Gets the cause of this `raise`, if any. */
    Expr getCause() { result.asExpr() = raise.getCause() }

    override AstNode getChild(int index) {
      index = 0 and result = this.getExpr()
      or
      index = 1 and result = this.getCause()
    }
  }

  /** A `with` statement. */
  additional class WithStmt extends Stmt {
    private Py::With withStmt;

    WithStmt() { this = TPyStmt(withStmt) }

    Expr getContextExpr() { result.asExpr() = withStmt.getContextExpr() }

    Expr getOptionalVars() { result.asExpr() = withStmt.getOptionalVars() }

    Stmt getBody() { result.asStmtList() = withStmt.getBody() }

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

    AssertStmt() { this = TPyStmt(assertStmt) }

    Expr getTest() { result.asExpr() = assertStmt.getTest() }

    Expr getMsg() { result.asExpr() = assertStmt.getMsg() }

    override AstNode getChild(int index) {
      index = 0 and result = this.getTest()
      or
      index = 1 and result = this.getMsg()
    }
  }

  /** A `delete` statement. */
  additional class DeleteStmt extends Stmt {
    private Py::Delete del;

    DeleteStmt() { this = TPyStmt(del) }

    Expr getTarget(int n) { result.asExpr() = del.getTarget(n) }

    override AstNode getChild(int index) { result = this.getTarget(index) }
  }

  /** A `try` statement. */
  class TryStmt extends Stmt {
    private Py::Try tryStmt;

    TryStmt() { this = TPyStmt(tryStmt) }

    Stmt getBody() { result.asStmtList() = tryStmt.getBody() }

    /** Gets the `else` branch of this `try` statement, if any. */
    Stmt getElse() { result.asStmtList() = tryStmt.getOrelse() }

    Stmt getFinally() { result.asStmtList() = tryStmt.getFinalbody() }

    CatchClause getCatch(int index) { result.asStmt() = tryStmt.getHandler(index) }

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

    CatchClause() { this = TPyStmt(handler) }

    /** Gets the type expression of this exception handler. */
    Expr getType() { result.asExpr() = handler.getType() }

    /** Gets the variable name of this exception handler, if any. */
    AstNode getVariable() { result.asExpr() = handler.getName() }

    /** Holds: catch clauses do not have a `Condition` in Python's model. */
    Expr getCondition() { none() }

    /** Gets the body of this exception handler. */
    Stmt getBody() {
      result.asStmtList() = handler.(Py::ExceptStmt).getBody()
      or
      result.asStmtList() = handler.(Py::ExceptGroupStmt).getBody()
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

    Switch() { this = TPyStmt(matchStmt) }

    Expr getExpr() { result.asExpr() = matchStmt.getSubject() }

    Case getCase(int index) { result.asStmt() = matchStmt.getCase(index) }

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

    Case() { this = TPyStmt(caseStmt) }

    AstNode getAPattern() { result.asPattern() = caseStmt.getPattern() }

    Expr getGuard() { result.asExpr() = caseStmt.getGuard().(Py::Guard).getTest() }

    AstNode getBody() { result.asStmtList() = caseStmt.getBody() }

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

    ConditionalExpr() { this = TPyExpr(ifExp) }

    /** Gets the condition of this expression. */
    Expr getCondition() { result.asExpr() = ifExp.getTest() }

    /** Gets the true branch of this expression. */
    Expr getThen() { result.asExpr() = ifExp.getBody() }

    /** Gets the false branch of this expression. */
    Expr getElse() { result.asExpr() = ifExp.getOrelse() }

    override AstNode getChild(int index) {
      index = 0 and result = this.getCondition()
      or
      index = 1 and result = this.getThen()
      or
      index = 2 and result = this.getElse()
    }
  }

  /**
   * A binary expression for the shared CFG. In Python, this covers all
   * `and`/`or` expression operand pairs.
   */
  class BinaryExpr extends Expr, TBoolExprPair {
    private Py::BoolExpr be;
    private int index;

    BinaryExpr() { this = TBoolExprPair(be, index) }

    /** Gets the underlying Python `BoolExpr`. */
    Py::BoolExpr getBoolExpr() { result = be }

    /** Gets the (zero-based) index of this pair within its `BoolExpr`. */
    int getIndex() { result = index }

    override string toString() { result = be.getOperator() }

    override Py::Location getLocation() { result = be.getValue(index).getLocation() }

    override Callable getEnclosingCallable() { result.asScope() = be.getScope() }

    /** Gets the left operand of this binary expression. */
    Expr getLeftOperand() { result.asExpr() = be.getValue(index) }

    /** Gets the right operand of this binary expression. */
    Expr getRightOperand() {
      // Last pair: right operand is the final value.
      index = count(be.getAValue()) - 2 and result.asExpr() = be.getValue(index + 1)
      or
      // Non-last pair: right operand is the next synthetic pair.
      index < count(be.getAValue()) - 2 and
      exists(BinaryExpr next |
        next.getBoolExpr() = be and next.getIndex() = index + 1 and result = next
      )
    }

    override AstNode getChild(int childIndex) {
      childIndex = 0 and result = this.getLeftOperand()
      or
      childIndex = 1 and result = this.getRightOperand()
    }
  }

  /** A short-circuiting logical `and` expression. */
  class LogicalAndExpr extends BinaryExpr {
    LogicalAndExpr() { this.getBoolExpr().getOp() instanceof Py::And }
  }

  /** A short-circuiting logical `or` expression. */
  class LogicalOrExpr extends BinaryExpr {
    LogicalOrExpr() { this.getBoolExpr().getOp() instanceof Py::Or }
  }

  /** A null-coalescing expression. Python has no null-coalescing operator. */
  class NullCoalescingExpr extends BinaryExpr {
    NullCoalescingExpr() { none() }
  }

  /**
   * A unary expression. Currently only used for the `not` subclass.
   */
  class UnaryExpr extends Expr {
    UnaryExpr() { exists(Py::UnaryExpr u | this = TPyExpr(u) and u.getOp() instanceof Py::Not) }

    /** Gets the operand of this unary expression. */
    Expr getOperand() { result.asExpr() = this.asExpr().(Py::UnaryExpr).getOperand() }

    override AstNode getChild(int index) { index = 0 and result = this.getOperand() }
  }

  /** A logical `not` expression. */
  class LogicalNotExpr extends UnaryExpr { }

  /**
   * An assignment expression.
   *
   * Empty in Python: `x = y` and `x += y` are statements (`AssignStmt` and
   * `AugAssignStmt`), not expressions, and the walrus `x := y` is modeled
   * separately as `NamedExpr`. The shared library's `Assignment` extends
   * `BinaryExpr`, so it cannot share instances with our `Stmt`-based
   * assignment forms.
   */
  class Assignment extends BinaryExpr {
    Assignment() { none() }
  }

  /** A simple assignment expression. Empty in Python (see `Assignment`). */
  class AssignExpr extends Assignment { }

  /** A compound assignment expression. Empty in Python (see `Assignment`). */
  class CompoundAssignment extends Assignment { }

  /**
   * A short-circuiting logical AND compound assignment expression (`&&=`).
   * Python has no such operator.
   */
  class AssignLogicalAndExpr extends CompoundAssignment { }

  /**
   * A short-circuiting logical OR compound assignment expression (`||=`).
   * Python has no such operator.
   */
  class AssignLogicalOrExpr extends CompoundAssignment { }

  /**
   * A short-circuiting null-coalescing compound assignment expression
   * (`??=`). Python has no such operator.
   */
  class AssignNullCoalescingExpr extends CompoundAssignment { }

  /** A boolean literal expression (`True` or `False`). */
  class BooleanLiteral extends Expr {
    BooleanLiteral() { this = TPyExpr(any(Py::True t)) or this = TPyExpr(any(Py::False f)) }

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

    ArithBinaryExpr() { this = TPyExpr(binExpr) }

    Expr getLeft() { result.asExpr() = binExpr.getLeft() }

    Expr getRight() { result.asExpr() = binExpr.getRight() }

    override AstNode getChild(int index) {
      index = 0 and result = this.getLeft()
      or
      index = 1 and result = this.getRight()
    }
  }

  /** A call expression (`func(args...)`). */
  additional class CallExpr extends Expr {
    private Py::Call call;

    CallExpr() { this = TPyExpr(call) }

    Expr getFunc() { result.asExpr() = call.getFunc() }

    Expr getPositionalArg(int n) { result.asExpr() = call.getPositionalArg(n) }

    int getNumberOfPositionalArgs() { result = count(call.getAPositionalArg()) }

    Expr getKeywordValue(int n) {
      result.asExpr() = call.getNamedArg(n).(Py::Keyword).getValue()
      or
      result.asExpr() = call.getNamedArg(n).(Py::DictUnpacking).getValue()
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

    SubscriptExpr() { this = TPyExpr(sub) }

    Expr getObject() { result.asExpr() = sub.getObject() }

    Expr getIndex() { result.asExpr() = sub.getIndex() }

    override AstNode getChild(int index) {
      index = 0 and result = this.getObject()
      or
      index = 1 and result = this.getIndex()
    }
  }

  /** An attribute access (`obj.name`). */
  additional class AttributeExpr extends Expr {
    private Py::Attribute attr;

    AttributeExpr() { this = TPyExpr(attr) }

    Expr getObject() { result.asExpr() = attr.getObject() }

    override AstNode getChild(int index) { index = 0 and result = this.getObject() }
  }

  /** A tuple literal. */
  additional class TupleExpr extends Expr {
    private Py::Tuple tuple;

    TupleExpr() { this = TPyExpr(tuple) }

    Expr getElt(int n) { result.asExpr() = tuple.getElt(n) }

    override AstNode getChild(int index) { result = this.getElt(index) }
  }

  /** A list literal. */
  additional class ListExpr extends Expr {
    private Py::List list;

    ListExpr() { this = TPyExpr(list) }

    Expr getElt(int n) { result.asExpr() = list.getElt(n) }

    override AstNode getChild(int index) { result = this.getElt(index) }
  }

  /** A set literal. */
  additional class SetExpr extends Expr {
    private Py::Set set;

    SetExpr() { this = TPyExpr(set) }

    Expr getElt(int n) { result.asExpr() = set.getElt(n) }

    override AstNode getChild(int index) { result = this.getElt(index) }
  }

  /** A dict literal. */
  additional class DictExpr extends Expr {
    private Py::Dict dict;

    DictExpr() { this = TPyExpr(dict) }

    /**
     * Gets the key of the `n`th item (at child index `2*n`); the value is
     * at child index `2*n + 1`.
     */
    Expr getKey(int n) { result.asExpr() = dict.getItem(n).(Py::KeyValuePair).getKey() }

    Expr getValue(int n) { result.asExpr() = dict.getItem(n).(Py::KeyValuePair).getValue() }

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

    ArithUnaryExpr() { this = TPyExpr(unaryExpr) and not unaryExpr.getOp() instanceof Py::Not }

    Expr getOperand() { result.asExpr() = unaryExpr.getOperand() }

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
      exists(Py::Expr c | this = TPyExpr(c) |
        iterable = c.(Py::ListComp).getIterable()
        or
        iterable = c.(Py::SetComp).getIterable()
        or
        iterable = c.(Py::DictComp).getIterable()
        or
        iterable = c.(Py::GeneratorExp).getIterable()
      )
    }

    Expr getIterable() { result.asExpr() = iterable }

    override AstNode getChild(int index) { index = 0 and result = this.getIterable() }
  }

  /** A comparison expression (`a < b`, `a < b < c`, etc.). */
  additional class CompareExpr extends Expr {
    private Py::Compare cmp;

    CompareExpr() { this = TPyExpr(cmp) }

    Expr getLeft() { result.asExpr() = cmp.getLeft() }

    Expr getComparator(int n) { result.asExpr() = cmp.getComparator(n) }

    override AstNode getChild(int index) {
      index = 0 and result = this.getLeft()
      or
      result = this.getComparator(index - 1) and index >= 1
    }
  }

  /** A slice expression (`start:stop:step`). */
  additional class SliceExpr extends Expr {
    private Py::Slice slice;

    SliceExpr() { this = TPyExpr(slice) }

    Expr getStart() { result.asExpr() = slice.getStart() }

    Expr getStop() { result.asExpr() = slice.getStop() }

    Expr getStep() { result.asExpr() = slice.getStep() }

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

    StarredExpr() { this = TPyExpr(starred) }

    Expr getValue() { result.asExpr() = starred.getValue() }

    override AstNode getChild(int index) { index = 0 and result = this.getValue() }
  }

  /** A formatted string literal (`f"...{expr}..."`). */
  additional class FstringExpr extends Expr {
    private Py::Fstring fstring;

    FstringExpr() { this = TPyExpr(fstring) }

    Expr getValue(int n) { result.asExpr() = fstring.getValue(n) }

    override AstNode getChild(int index) { result = this.getValue(index) }
  }

  /** A formatted value inside an f-string (`{expr}` or `{expr:spec}`). */
  additional class FormattedValueExpr extends Expr {
    private Py::FormattedValue fv;

    FormattedValueExpr() { this = TPyExpr(fv) }

    Expr getValue() { result.asExpr() = fv.getValue() }

    Expr getFormatSpec() { result.asExpr() = fv.getFormatSpec() }

    override AstNode getChild(int index) {
      index = 0 and result = this.getValue()
      or
      index = 1 and result = this.getFormatSpec()
    }
  }

  /** A `yield` expression. */
  additional class YieldExpr extends Expr {
    private Py::Yield yield;

    YieldExpr() { this = TPyExpr(yield) }

    Expr getValue() { result.asExpr() = yield.getValue() }

    override AstNode getChild(int index) { index = 0 and result = this.getValue() }
  }

  /** A `yield from` expression. */
  additional class YieldFromExpr extends Expr {
    private Py::YieldFrom yieldFrom;

    YieldFromExpr() { this = TPyExpr(yieldFrom) }

    Expr getValue() { result.asExpr() = yieldFrom.getValue() }

    override AstNode getChild(int index) { index = 0 and result = this.getValue() }
  }

  /** An `await` expression. */
  additional class AwaitExpr extends Expr {
    private Py::Await await;

    AwaitExpr() { this = TPyExpr(await) }

    Expr getValue() { result.asExpr() = await.getValue() }

    override AstNode getChild(int index) { index = 0 and result = this.getValue() }
  }

  /** A class definition expression (has base classes evaluated at definition time). */
  additional class ClassDefExpr extends Expr {
    private Py::ClassExpr classExpr;

    ClassDefExpr() { this = TPyExpr(classExpr) }

    Expr getBase(int n) { result.asExpr() = classExpr.getBase(n) }

    override AstNode getChild(int index) { result = this.getBase(index) }
  }

  /** A function definition expression (has default args evaluated at definition time). */
  additional class FunctionDefExpr extends Expr {
    private Py::FunctionExpr funcExpr;

    FunctionDefExpr() { this = TPyExpr(funcExpr) }

    /**
     * Gets the `n`th default for a positional argument, in evaluation
     * order. Note that `Args.getDefault(int)` is indexed by argument
     * position (with gaps for arguments without defaults), so we must
     * renumber here to obtain contiguous indices.
     */
    Expr getDefault(int n) {
      result.asExpr() =
        rank[n + 1](Py::Expr d, int i | d = funcExpr.getArgs().getDefault(i) | d order by i)
    }

    /** Gets the `n`th default for a keyword-only argument, in evaluation order. */
    Expr getKwDefault(int n) {
      result.asExpr() =
        rank[n + 1](Py::Expr d, int i | d = funcExpr.getArgs().getKwDefault(i) | d order by i)
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

    LambdaExpr() { this = TPyExpr(lambda) }

    /** Gets the `n`th default for a positional argument, in evaluation order. */
    Expr getDefault(int n) {
      result.asExpr() =
        rank[n + 1](Py::Expr d, int i | d = lambda.getArgs().getDefault(i) | d order by i)
    }

    /** Gets the `n`th default for a keyword-only argument, in evaluation order. */
    Expr getKwDefault(int n) {
      result.asExpr() =
        rank[n + 1](Py::Expr d, int i | d = lambda.getArgs().getKwDefault(i) | d order by i)
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
