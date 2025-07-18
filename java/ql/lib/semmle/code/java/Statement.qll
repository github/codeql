/**
 * Provides classes and predicates for working with Java statements.
 */
overlay[local?]
module;

import Expr
import metrics.MetricStmt
private import semmle.code.java.Overlay

/** A common super-class of all statements. */
class Stmt extends StmtParent, ExprParent, @stmt {
  /*abstract*/ override string toString() { result = "stmt" }

  /** Gets a printable representation of this statement. May include more detail than `toString()`. */
  string pp() { result = "stmt" }

  /**
   * Gets the immediately enclosing callable (method or constructor)
   * whose body contains this statement.
   */
  Callable getEnclosingCallable() { stmts(this, _, _, _, result) }

  /** Gets the index of this statement as a child of its parent. */
  int getIndex() { stmts(this, _, _, result, _) }

  /** Gets the parent of this statement. */
  StmtParent getParent() { stmts(this, _, result, _, _) }

  /**
   * Gets the statement containing this statement, if any.
   */
  Stmt getEnclosingStmt() {
    result = this.getParent() or
    result = this.getParent().(SwitchExpr).getEnclosingStmt() or
    result = this.getParent().(WhenExpr).getEnclosingStmt()
  }

  /** Holds if this statement is the child of the specified parent at the specified (zero-based) position. */
  predicate isNthChildOf(StmtParent parent, int index) {
    this.getParent() = parent and this.getIndex() = index
  }

  /** Gets the compilation unit in which this statement occurs. */
  CompilationUnit getCompilationUnit() { result = this.getFile() }

  /** Gets a child of this statement, if any. */
  Stmt getAChild() { result.getParent() = this }

  /** Gets the basic block in which this statement occurs. */
  BasicBlock getBasicBlock() { result.getANode().asStmt() = this }

  /** Gets the `ControlFlowNode` corresponding to this statement. */
  ControlFlowNode getControlFlowNode() { result.asStmt() = this }

  /** Cast this statement to a class that provides access to metrics information. */
  MetricStmt getMetrics() { result = this }

  /** This statement's Halstead ID (used to compute Halstead metrics). */
  string getHalsteadID() { result = "Stmt" }
}

/** A statement parent is any element that can have a statement as its child. */
class StmtParent extends @stmtparent, Top { }

/**
 * An error statement.
 *
 * These may be generated by upgrade or downgrade scripts when databases
 * cannot be fully converted.
 */
class ErrorStmt extends Stmt, @errorstmt {
  override string toString() { result = "<error stmt>" }

  override string getAPrimaryQlClass() { result = "ErrorStmt" }
}

/** A block of statements. */
class BlockStmt extends Stmt, @block {
  /** Gets a statement that is an immediate child of this block. */
  Stmt getAStmt() { result.getParent() = this }

  /** Gets the immediate child statement of this block that occurs at the specified (zero-based) position. */
  Stmt getStmt(int index) { result.getIndex() = index and result.getParent() = this }

  /** Gets the number of immediate child statements in this block. */
  int getNumStmt() { result = count(this.getAStmt()) }

  /** Gets the last statement in this block. */
  Stmt getLastStmt() { result = this.getStmt(this.getNumStmt() - 1) }

  override string pp() { result = "{ ... }" }

  override string toString() { result = "{ ... }" }

  override string getHalsteadID() { result = "BlockStmt" }

  override string getAPrimaryQlClass() { result = "BlockStmt" }
}

/** A block with only a single statement. */
class SingletonBlock extends BlockStmt {
  SingletonBlock() { this.getNumStmt() = 1 }

  /** Gets the single statement in this block. */
  Stmt getStmt() { result = this.getStmt(0) }
}

/**
 * A conditional statement, including `if`, `for`,
 * `while` and `dowhile` statements.
 */
abstract class ConditionalStmt extends Stmt {
  /** Gets the boolean condition of this conditional statement. */
  abstract Expr getCondition();
}

/** An `if` statement. */
class IfStmt extends ConditionalStmt, @ifstmt {
  /** Gets the boolean condition of this `if` statement. */
  override Expr getCondition() { result.isNthChildOf(this, 0) }

  /** Gets the `then` branch of this `if` statement. */
  Stmt getThen() { result.isNthChildOf(this, 1) }

  /** Gets the `else` branch of this `if` statement. */
  Stmt getElse() { result.isNthChildOf(this, 2) }

  override string pp() {
    result = "if (...) " + this.getThen().pp() + " else " + this.getElse().pp()
    or
    not exists(this.getElse()) and result = "if (...) " + this.getThen().pp()
  }

  override string toString() { result = "if (...)" }

  override string getHalsteadID() { result = "IfStmt" }

  override string getAPrimaryQlClass() { result = "IfStmt" }
}

/** A `for` loop. */
class ForStmt extends ConditionalStmt, @forstmt {
  /**
   * Gets an initializer expression of the loop.
   *
   * This may be an assignment expression or a
   * local variable declaration expression.
   */
  Expr getAnInit() { exists(int index | result.isNthChildOf(this, index) | index <= -1) }

  /** Gets the initializer expression of the loop at the specified (zero-based) position. */
  Expr getInit(int index) {
    result = this.getAnInit() and
    index = -1 - result.getIndex()
  }

  /** Gets the boolean condition of this `for` loop. */
  override Expr getCondition() { result.isNthChildOf(this, 1) }

  /** Gets an update expression of this `for` loop. */
  Expr getAnUpdate() { exists(int index | result.isNthChildOf(this, index) | index >= 3) }

  /** Gets the update expression of this loop at the specified (zero-based) position. */
  Expr getUpdate(int index) {
    result = this.getAnUpdate() and
    index = result.getIndex() - 3
  }

  /** Gets the body of this `for` loop. */
  Stmt getStmt() { result.getParent() = this and result.getIndex() = 2 }

  /**
   * Gets a variable that is used as an iteration variable: it is defined,
   * updated or tested in the head of the `for` statement.
   *
   * This only returns variables that are quite certainly loop variables;
   * for complex iterations, it may not return anything.
   *
   * More precisely, it returns variables that are both accessed in the
   * condition of this `for` statement and updated in the update expression
   * of this for statement but may be initialized elsewhere.
   */
  Variable getAnIterationVariable() {
    // Check that the variable is assigned to, incremented or decremented in the update expression, and...
    exists(Expr update | update = this.getAnUpdate().getAChildExpr*() |
      update.(UnaryAssignExpr).getExpr() = result.getAnAccess() or
      update = result.getAnAssignedValue()
    ) and
    // ...that it is checked or used in the condition.
    this.getCondition().getAChildExpr*() = result.getAnAccess()
  }

  override string pp() { result = "for (...;...;...) " + this.getStmt().pp() }

  override string toString() { result = "for (...;...;...)" }

  override string getHalsteadID() { result = "ForStmt" }

  override string getAPrimaryQlClass() { result = "ForStmt" }
}

/** An enhanced `for` loop. (Introduced in Java 5.) */
class EnhancedForStmt extends Stmt, @enhancedforstmt {
  /** Gets the local variable declaration expression of this enhanced `for` loop. */
  LocalVariableDeclExpr getVariable() { result.getParent() = this }

  /** Gets the expression over which this enhanced `for` loop iterates. */
  Expr getExpr() { result.isNthChildOf(this, 1) }

  /** Gets the body of this enhanced `for` loop. */
  Stmt getStmt() { result.getParent() = this }

  override string pp() { result = "for (... : ...) " + this.getStmt().pp() }

  override string toString() { result = "for (... : ...)" }

  override string getHalsteadID() { result = "EnhancedForStmt" }

  override string getAPrimaryQlClass() { result = "EnhancedForStmt" }
}

/** A `while` loop. */
class WhileStmt extends ConditionalStmt, @whilestmt {
  /** Gets the boolean condition of this `while` loop. */
  override Expr getCondition() { result.getParent() = this }

  /** Gets the body of this `while` loop. */
  Stmt getStmt() { result.getParent() = this }

  override string pp() { result = "while (...) " + this.getStmt().pp() }

  override string toString() { result = "while (...)" }

  override string getHalsteadID() { result = "WhileStmt" }

  override string getAPrimaryQlClass() { result = "WhileStmt" }
}

/** A `do` loop. */
class DoStmt extends ConditionalStmt, @dostmt {
  /** Gets the condition of this `do` loop. */
  override Expr getCondition() { result.getParent() = this }

  /** Gets the body of this `do` loop. */
  Stmt getStmt() { result.getParent() = this }

  override string pp() { result = "do " + this.getStmt().pp() + " while (...)" }

  override string toString() { result = "do ... while (...)" }

  override string getHalsteadID() { result = "DoStmt" }

  override string getAPrimaryQlClass() { result = "DoStmt" }
}

/**
 * A loop statement, including `for`, enhanced `for`,
 * `while` and `do` statements.
 */
class LoopStmt extends Stmt {
  LoopStmt() {
    this instanceof ForStmt or
    this instanceof EnhancedForStmt or
    this instanceof WhileStmt or
    this instanceof DoStmt
  }

  /** Gets the body of this loop statement. */
  Stmt getBody() {
    result = this.(ForStmt).getStmt() or
    result = this.(EnhancedForStmt).getStmt() or
    result = this.(WhileStmt).getStmt() or
    result = this.(DoStmt).getStmt()
  }

  /** Gets the boolean condition of this loop statement. */
  Expr getCondition() {
    result = this.(ForStmt).getCondition() or
    result = this.(WhileStmt).getCondition() or
    result = this.(DoStmt).getCondition()
  }
}

/** A `try` statement. */
class TryStmt extends Stmt, @trystmt {
  /** Gets the block of the `try` statement. */
  Stmt getBlock() { result.isNthChildOf(this, -1) }

  /** Gets a `catch` clause of this `try` statement. */
  CatchClause getACatchClause() { result.getParent() = this }

  /**
   * Gets the `catch` clause at the specified (zero-based) position
   * in this `try` statement.
   */
  CatchClause getCatchClause(int index) {
    result = this.getACatchClause() and
    result.getIndex() = index
  }

  /** Gets the `finally` block, if any. */
  BlockStmt getFinally() { result.isNthChildOf(this, -2) }

  /** Gets a resource variable declaration, if any. */
  LocalVariableDeclStmt getAResourceDecl() { result.getParent() = this and result.getIndex() <= -3 }

  /** Gets the resource variable declaration at the specified position in this `try` statement. */
  LocalVariableDeclStmt getResourceDecl(int index) {
    result = this.getAResourceDecl() and
    index = -3 - result.getIndex()
  }

  /** Gets a resource expression, if any. */
  VarAccess getAResourceExpr() { result.getParent() = this and result.getIndex() <= -3 }

  /** Gets the resource expression at the specified position in this `try` statement. */
  VarAccess getResourceExpr(int index) {
    result = this.getAResourceExpr() and
    index = -3 - result.getIndex()
  }

  /** Gets a resource in this `try` statement, if any. */
  ExprParent getAResource() { result = this.getAResourceDecl() or result = this.getAResourceExpr() }

  /** Gets the resource at the specified position in this `try` statement. */
  ExprParent getResource(int index) {
    result = this.getResourceDecl(index) or result = this.getResourceExpr(index)
  }

  /** Gets a resource variable, if any, either from a resource variable declaration or resource expression. */
  Variable getAResourceVariable() {
    result = this.getAResourceDecl().getAVariable().getVariable() or
    result = this.getAResourceExpr().getVariable()
  }

  override string pp() { result = "try " + this.getBlock().pp() + " catch (...)" }

  override string toString() { result = "try ..." }

  override string getHalsteadID() { result = "TryStmt" }

  override string getAPrimaryQlClass() { result = "TryStmt" }
}

/** A `catch` clause in a `try` statement. */
class CatchClause extends Stmt, @catchclause {
  /** Gets the block of this `catch` clause. */
  BlockStmt getBlock() { result.getParent() = this }

  /** Gets the `try` statement in which this `catch` clause occurs. */
  TryStmt getTry() { this = result.getACatchClause() }

  /** Gets the parameter of this `catch` clause. */
  LocalVariableDeclExpr getVariable() { result.getParent() = this }

  /** Holds if this `catch` clause is a _multi_-`catch` clause. */
  predicate isMultiCatch() { this.getVariable().getTypeAccess() instanceof UnionTypeAccess }

  /** Gets a type caught by this `catch` clause. */
  RefType getACaughtType() {
    exists(Expr ta | ta = this.getVariable().getTypeAccess() |
      result = ta.(TypeAccess).getType() or
      result = ta.(UnionTypeAccess).getAnAlternative().getType()
    )
  }

  override string pp() { result = "catch (...) " + this.getBlock().pp() }

  override string toString() { result = "catch (...)" }

  override string getHalsteadID() { result = "CatchClause" }

  override string getAPrimaryQlClass() { result = "CatchClause" }
}

/** A `switch` statement. */
class SwitchStmt extends Stmt, @switchstmt {
  /** Gets an immediate child statement of this `switch` statement. */
  Stmt getAStmt() { result.getParent() = this }

  /**
   * Gets the immediate child statement of this `switch` statement
   * that occurs at the specified (zero-based) position.
   */
  Stmt getStmt(int index) { result = this.getAStmt() and result.getIndex() = index }

  /**
   * Gets the `i`th case of this `switch` statement,
   * which may be either a normal `case` or a `default`.
   */
  SwitchCase getCase(int i) {
    result =
      rank[i + 1](SwitchCase case, int idx | case.isNthChildOf(this, idx) | case order by idx)
  }

  /**
   * Gets a case of this `switch` statement,
   * which may be either a normal `case` or a `default`.
   */
  SwitchCase getACase() { result.getParent() = this }

  /** Gets a (non-default) constant `case` of this `switch` statement. */
  ConstCase getAConstCase() { result = this.getACase() }

  /** Gets a (non-default) pattern `case` of this `switch` statement. */
  PatternCase getAPatternCase() { result = this.getACase() }

  /**
   * Gets the `default` case of this switch statement, if any.
   *
   * Note this may be `default` or `case null, default`.
   */
  DefaultCase getDefaultCase() { result = this.getACase() }

  /** Gets the expression of this `switch` statement. */
  Expr getExpr() { result.getParent() = this }

  /** Holds if this switch has a case handling a null literal. */
  predicate hasNullCase() {
    this.getAConstCase().getValue(_) instanceof NullLiteral or
    this.getACase() instanceof NullDefaultCase
  }

  override string pp() { result = "switch (...)" }

  override string toString() { result = "switch (...)" }

  override string getHalsteadID() { result = "SwitchStmt" }

  override string getAPrimaryQlClass() { result = "SwitchStmt" }
}

/**
 * A `switch` statement or expression.
 */
class SwitchBlock extends StmtParent {
  SwitchBlock() { this instanceof SwitchStmt or this instanceof SwitchExpr }
}

/**
 * A case of a `switch` statement or expression.
 *
 * This includes both normal `case`s and the `default` case.
 */
class SwitchCase extends Stmt, @case {
  /** Gets the switch statement to which this case belongs, if any. */
  SwitchStmt getSwitch() { result.getACase() = this }

  /**
   * Gets the switch expression to which this case belongs, if any.
   */
  SwitchExpr getSwitchExpr() { result.getACase() = this }

  /**
   * Gets the expression of the surrounding switch that this case is compared
   * against.
   */
  Expr getSelectorExpr() {
    result = this.getSwitch().getExpr() or result = this.getSwitchExpr().getExpr()
  }

  /**
   * Gets this case's ordinal in its switch block.
   */
  int getCaseIndex() {
    this = any(SwitchStmt ss).getCase(result) or this = any(SwitchExpr se).getCase(result)
  }

  /**
   * Holds if this is the `n`th case of switch block `parent`.
   */
  pragma[nomagic]
  predicate isNthCaseOf(SwitchBlock parent, int n) {
    this.getCaseIndex() = n and this.getParent() = parent
  }

  /**
   * Holds if this `case` is a switch labeled rule of the form `... -> ...`.
   */
  predicate isRule() {
    exists(Expr e | e.getParent() = this | e.getIndex() = -1)
    or
    exists(Stmt s | s.getParent() = this | s.getIndex() = -1)
  }

  /**
   * Gets the expression on the right-hand side of the arrow, if any.
   *
   * Note, this predicate gets a value when this switch case is of the form
   * `case e1 -> e2`, where `e2` is neither a block nor a throw statement.
   * This predicate is mutually exclusive with `getRuleStatement`.
   */
  Expr getRuleExpression() {
    result.getParent() = this and result.getIndex() = -1
    or
    exists(ExprStmt es | es.getParent() = this and es.getIndex() = -1 | result = es.getExpr())
  }

  /**
   * Gets the statement on the right-hand side of the arrow, if any.
   *
   * Note, this predicate gets a value when this switch case is of the form
   * `case e1 -> { s1; s2; ... }` or `case e1 -> throw ...`.
   * This predicate is mutually exclusive with `getRuleExpression`.
   */
  Stmt getRuleStatement() {
    result.getParent() = this and result.getIndex() = -1 and not result instanceof ExprStmt
  }
}

/**
 * A constant `case` of a switch statement.
 *
 * Note this excludes `case null, default` even though that includes a null constant. It
 * does however include plain `case null`.
 */
class ConstCase extends SwitchCase {
  ConstCase() {
    exists(Expr e | e.getParent() = this and e.getIndex() >= 0 and not e instanceof PatternExpr) and
    // For backward compatibility, we don't include `case null, default:` here, on the assumption
    // this will come as a surprise to CodeQL that predates that statement's validity.
    not isNullDefaultCase(this)
  }

  /** Gets the `case` constant at index 0. */
  Expr getValue() { result.isNthChildOf(this, 0) }

  /**
   * Gets the `case` constant at index `i`.
   */
  Expr getValue(int i) { result.isNthChildOf(this, i) and i >= 0 }

  override string pp() { result = "case ..." }

  override string toString() { result = "case ..." }

  override string getHalsteadID() { result = "ConstCase" }

  override string getAPrimaryQlClass() { result = "ConstCase" }
}

/** A pattern case of a `switch` statement */
class PatternCase extends SwitchCase {
  PatternCase() { exists(PatternExpr pe | pe.isNthChildOf(this, _)) }

  /**
   * DEPRECATED: alias for getPattern(0)
   */
  deprecated PatternExpr getPattern() { result = this.getPattern(0) }

  /**
   * Gets this case's `n`th pattern.
   */
  PatternExpr getPattern(int n) { result.isNthChildOf(this, n) }

  /**
   * Gets any of this case's patterns.
   */
  PatternExpr getAPattern() { result = this.getPattern(_) }

  /**
   * Gets this case's sole pattern, if there is exactly one.
   */
  PatternExpr getUniquePattern() { result = unique(PatternExpr pe | pe = this.getAPattern()) }

  /** Gets the guard applicable to this pattern case, if any. */
  Expr getGuard() { result.isNthChildOf(this, -3) }

  override string pp() { result = "case <Pattern>" }

  override string toString() { result = "case <Pattern>" }

  override string getHalsteadID() { result = "PatternCase" }

  override string getAPrimaryQlClass() { result = "PatternCase" }
}

/**
 * A `default` or `case null, default` case of a `switch` statement or expression.
 */
class DefaultCase extends SwitchCase {
  DefaultCase() {
    isNullDefaultCase(this)
    or
    not exists(Expr e | e.getParent() = this | e.getIndex() >= 0)
  }

  override string pp() { result = "default" }

  override string toString() { result = "default" }

  override string getHalsteadID() { result = "DefaultCase" }

  override string getAPrimaryQlClass() { result = "DefaultCase" }
}

/** A `case null, default` statement of a `switch` statement or expression. */
class NullDefaultCase extends DefaultCase {
  NullDefaultCase() { isNullDefaultCase(this) }

  override string pp() { result = "case null, default" }

  override string toString() { result = "case null, default" }

  override string getHalsteadID() { result = "NullDefaultCase" }

  override string getAPrimaryQlClass() { result = "NullDefaultCase" }
}

/** A `synchronized` statement. */
class SynchronizedStmt extends Stmt, @synchronizedstmt {
  /** Gets the expression on which this `synchronized` statement synchronizes. */
  Expr getExpr() { result.getParent() = this }

  /** Gets the block of this `synchronized` statement. */
  Stmt getBlock() { result.getParent() = this }

  override string pp() { result = "synchronized (...) " + this.getBlock().pp() }

  override string toString() { result = "synchronized (...)" }

  override string getHalsteadID() { result = "SynchronizedStmt" }

  override string getAPrimaryQlClass() { result = "SynchronizedStmt" }
}

/** A `return` statement. */
class ReturnStmt extends Stmt, @returnstmt {
  /** Gets the expression returned by this `return` statement, if any. */
  Expr getResult() { result.getParent() = this }

  override string pp() { result = "return ..." }

  override string toString() { result = "return ..." }

  override string getHalsteadID() { result = "ReturnStmt" }

  override string getAPrimaryQlClass() { result = "ReturnStmt" }
}

/** A `throw` statement. */
class ThrowStmt extends Stmt, @throwstmt {
  /** Gets the expression thrown by this `throw` statement. */
  Expr getExpr() { result.getParent() = this }

  override string pp() { result = "throw ..." }

  override string toString() { result = "throw ..." }

  override string getHalsteadID() { result = "ThrowStmt" }

  /** Gets the type of the expression thrown by this `throw` statement. */
  RefType getThrownExceptionType() { result = this.getExpr().getType() }

  /**
   * Gets the `catch` clause that catches the exception
   * thrown by this `throw` statement and occurs
   * in the same method as this `throw` statement,
   * provided such a `catch` exists.
   */
  CatchClause getLexicalCatchIfAny() {
    exists(TryStmt try | try = this.findEnclosing() and result = this.catchClauseForThis(try))
  }

  private Stmt findEnclosing() {
    result = this.getEnclosingStmt()
    or
    exists(Stmt mid |
      mid = this.findEnclosing() and
      not exists(this.catchClauseForThis(mid)) and
      result = mid.getEnclosingStmt()
    )
  }

  private CatchClause catchClauseForThis(TryStmt try) {
    result = try.getACatchClause() and
    result.getEnclosingCallable() = this.getEnclosingCallable() and
    this.getExpr().getType().(RefType).hasSupertype*(result.getVariable().getType()) and
    not this.getEnclosingStmt+() = result
  }

  override string getAPrimaryQlClass() { result = "ThrowStmt" }
}

private class JumpStmt_ = @breakstmt or @yieldstmt or @continuestmt;

/** A `break`, `yield` or `continue` statement. */
class JumpStmt extends Stmt, JumpStmt_ {
  /**
   * Gets the labeled statement that this `break` or
   * `continue` statement refers to, if any.
   */
  LabeledStmt getTargetLabel() {
    this.getEnclosingStmt+() = result and
    namestrings(result.getLabel(), _, this)
  }

  private Stmt getLabelTarget() { result = this.getTargetLabel().getStmt() }

  private Stmt getAPotentialTarget() {
    this.getEnclosingStmt+() = result and
    (
      result instanceof LoopStmt
      or
      this instanceof BreakStmt and result instanceof SwitchStmt
    )
  }

  private StmtParent getEnclosingTarget() {
    result = this.getAPotentialTarget() and
    not exists(Stmt other | other = this.getAPotentialTarget() | other.getEnclosingStmt+() = result)
  }

  /**
   * Gets the statement or `switch` expression that this `break`, `yield` or `continue` jumps to.
   */
  StmtParent getTarget() {
    // Note: This implementation only considers `break` and `continue`; YieldStmt overrides this predicate
    result = this.getLabelTarget()
    or
    not exists(this.getLabelTarget()) and result = this.getEnclosingTarget()
  }
}

/** A `break` statement. */
class BreakStmt extends JumpStmt, @breakstmt {
  /** Gets the label targeted by this `break` statement, if any. */
  string getLabel() { namestrings(result, _, this) }

  /** Holds if this `break` statement has an explicit label. */
  predicate hasLabel() { exists(this.getLabel()) }

  override string pp() {
    if this.hasLabel() then result = "break " + this.getLabel() else result = "break"
  }

  override string toString() { result = "break" }

  override string getHalsteadID() { result = "BreakStmt" }

  override string getAPrimaryQlClass() { result = "BreakStmt" }
}

/**
 * A `yield` statement.
 */
class YieldStmt extends JumpStmt, @yieldstmt {
  /**
   * Gets the value of this `yield` statement.
   */
  Expr getValue() { result.getParent() = this }

  /**
   * Gets the `switch` expression target of this `yield` statement.
   */
  override SwitchExpr getTarget() {
    // Get the innermost enclosing SwitchExpr; this works because getParent() is defined for Stmt and
    // therefore won't proceed after the innermost SwitchExpr (due to it being an Expr)
    result = this.getParent+()
  }

  override string pp() { result = "yield ..." }

  override string toString() { result = "yield ..." }

  override string getHalsteadID() { result = "YieldStmt" }

  override string getAPrimaryQlClass() { result = "YieldStmt" }
}

/** A `continue` statement. */
class ContinueStmt extends JumpStmt, @continuestmt {
  /** Gets the label targeted by this `continue` statement, if any. */
  string getLabel() { namestrings(result, _, this) }

  /** Holds if this `continue` statement has an explicit label. */
  predicate hasLabel() { exists(this.getLabel()) }

  override string pp() {
    if this.hasLabel() then result = "continue " + this.getLabel() else result = "continue"
  }

  override string toString() { result = "continue" }

  override string getHalsteadID() { result = "ContinueStmt" }

  override string getAPrimaryQlClass() { result = "ContinueStmt" }
}

/** The empty statement. */
class EmptyStmt extends Stmt, @emptystmt {
  override string pp() { result = ";" }

  override string toString() { result = ";" }

  override string getHalsteadID() { result = "EmptyStmt" }

  override string getAPrimaryQlClass() { result = "EmptyStmt" }
}

/**
 * An expression statement.
 *
 * Certain kinds of expressions may be used as statements by appending a semicolon.
 */
class ExprStmt extends Stmt, @exprstmt {
  /** Gets the expression of this expression statement. */
  Expr getExpr() { result.getParent() = this }

  override string pp() { result = "<Expr>;" }

  override string toString() { result = "<Expr>;" }

  override string getHalsteadID() { result = "ExprStmt" }

  /** Holds if this statement represents a field declaration with an initializer. */
  predicate isFieldDecl() {
    this.getEnclosingCallable() instanceof InitializerMethod and
    exists(FieldDeclaration fd, Location fdl, Location sl |
      fdl = fd.getLocation() and sl = this.getLocation()
    |
      fdl.getFile() = sl.getFile() and
      fdl.getStartLine() = sl.getStartLine() and
      fdl.getStartColumn() = sl.getStartColumn()
    )
  }

  override string getAPrimaryQlClass() { result = "ExprStmt" }
}

/** A labeled statement. */
class LabeledStmt extends Stmt, @labeledstmt {
  /** Gets the statement of this labeled statement. */
  Stmt getStmt() { result.getParent() = this }

  /** Gets the label of this labeled statement. */
  string getLabel() { namestrings(result, _, this) }

  override string pp() { result = this.getLabel() + ": " + this.getStmt().pp() }

  override string getHalsteadID() { result = this.getLabel() + ":" }

  override string toString() { result = "<Label>: ..." }

  override string getAPrimaryQlClass() { result = "LabeledStmt" }
}

/** An `assert` statement. */
class AssertStmt extends Stmt, @assertstmt {
  /** Gets the boolean expression of this `assert` statement. */
  Expr getExpr() { exprs(result, _, _, this, _) and result.getIndex() = 0 }

  /** Gets the assertion message expression, if any. */
  Expr getMessage() { exprs(result, _, _, this, _) and result.getIndex() = 1 }

  override string pp() {
    if exists(this.getMessage()) then result = "assert ... : ..." else result = "assert ..."
  }

  override string toString() { result = "assert ..." }

  override string getHalsteadID() { result = "AssertStmt" }

  override string getAPrimaryQlClass() { result = "AssertStmt" }
}

/** A statement that declares one or more local variables. */
class LocalVariableDeclStmt extends Stmt, @localvariabledeclstmt {
  /** Gets a declared variable. */
  LocalVariableDeclExpr getAVariable() { result.getParent() = this }

  /** Gets the variable declared at the specified (one-based) position in this local variable declaration statement. */
  LocalVariableDeclExpr getVariable(int index) {
    result = this.getAVariable() and
    result.getIndex() = index
  }

  /** Gets an index of a variable declared in this local variable declaration statement. */
  int getAVariableIndex() { exists(this.getVariable(result)) }

  override string pp() { result = "var ...;" }

  override string toString() { result = "var ...;" }

  override string getHalsteadID() { result = "LocalVariableDeclStmt" }

  override string getAPrimaryQlClass() { result = "LocalVariableDeclStmt" }
}

/** A statement that declares a local class or interface. */
class LocalTypeDeclStmt extends Stmt, @localtypedeclstmt {
  /** Gets the local type declared by this statement. */
  LocalClassOrInterface getLocalType() { isLocalClassOrInterface(result, this) }

  private string getDeclKeyword() {
    result = "class" and this.getLocalType() instanceof Class
    or
    result = "interface" and this.getLocalType() instanceof Interface
  }

  override string pp() { result = this.getDeclKeyword() + " " + this.getLocalType().toString() }

  override string toString() { result = this.getDeclKeyword() + " ..." }

  override string getHalsteadID() { result = "LocalTypeDeclStmt" }

  override string getAPrimaryQlClass() { result = "LocalTypeDeclStmt" }
}

/** An explicit `this(...)` constructor invocation. */
class ThisConstructorInvocationStmt extends Stmt, ConstructorCall, @constructorinvocationstmt {
  /** Gets an argument of this constructor invocation. */
  override Expr getAnArgument() { result.getIndex() >= 0 and result.getParent() = this }

  /** Gets the argument at the specified (zero-based) position in this constructor invocation. */
  override Expr getArgument(int index) {
    result = this.getAnArgument() and
    result.getIndex() = index
  }

  /** Gets a type argument of this constructor invocation. */
  Expr getATypeArgument() { result.getIndex() <= -2 and result.getParent() = this }

  /** Gets the type argument at the specified (zero-based) position in this constructor invocation. */
  Expr getTypeArgument(int index) {
    result = this.getATypeArgument() and
    (-2 - result.getIndex()) = index
  }

  /** Gets the constructor invoked by this constructor invocation. */
  override Constructor getConstructor() { callableBinding(this, result) }

  override Expr getQualifier() { none() }

  /** Gets the immediately enclosing callable of this constructor invocation. */
  override Callable getEnclosingCallable() { result = Stmt.super.getEnclosingCallable() }

  /** Gets the immediately enclosing statement of this constructor invocation. */
  override Stmt getEnclosingStmt() { result = this }

  override string pp() { result = "this(...)" }

  override string toString() { result = "this(...)" }

  override string getHalsteadID() { result = "ConstructorInvocationStmt" }

  override string getAPrimaryQlClass() { result = "ThisConstructorInvocationStmt" }
}

/** An explicit `super(...)` constructor invocation. */
class SuperConstructorInvocationStmt extends Stmt, ConstructorCall, @superconstructorinvocationstmt {
  /** Gets an argument of this constructor invocation. */
  override Expr getAnArgument() { result.getIndex() >= 0 and result.getParent() = this }

  /** Gets the argument at the specified (zero-based) position in this constructor invocation. */
  override Expr getArgument(int index) {
    result = this.getAnArgument() and
    result.getIndex() = index
  }

  /** Gets a type argument of this constructor invocation. */
  Expr getATypeArgument() { result.getIndex() <= -2 and result.getParent() = this }

  /** Gets the type argument at the specified (zero-based) position in this constructor invocation. */
  Expr getTypeArgument(int index) {
    result = this.getATypeArgument() and
    (-2 - result.getIndex()) = index
  }

  /** Gets the constructor invoked by this constructor invocation. */
  override Constructor getConstructor() { callableBinding(this, result) }

  /** Gets the qualifier expression of this `super(...)` constructor invocation, if any. */
  override Expr getQualifier() { result.isNthChildOf(this, -1) }

  /** Gets the immediately enclosing callable of this constructor invocation. */
  override Callable getEnclosingCallable() { result = Stmt.super.getEnclosingCallable() }

  /** Gets the immediately enclosing statement of this constructor invocation. */
  override Stmt getEnclosingStmt() { result = this }

  override string pp() { result = "super(...)" }

  override string toString() { result = "super(...)" }

  override string getHalsteadID() { result = "SuperConstructorInvocationStmt" }

  override string getAPrimaryQlClass() { result = "SuperConstructorInvocationStmt" }
}

overlay[local]
private class DiscardableStmt extends DiscardableLocatable, @stmt { }
