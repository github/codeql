/**
 * Provides classes for working with statements.
 */

import go

/**
 * A statement.
 */
class Stmt extends @stmt, ExprParent, StmtParent {
  /**
   * Gets the kind of this statement, which is an integer value representing the statement's
   * node type.
   *
   * Note that the mapping from node types to integer kinds is considered an implementation detail
   * and subject to change without notice.
   */
  int getKind() { stmts(this, result, _, _) }

  /**
   * Holds if the execution of this statement may produce observable side effects.
   *
   * Memory allocation is not considered an observable side effect.
   */
  predicate mayHaveSideEffects() { none() }

  /** Gets the first control-flow node in this statement. */
  ControlFlow::Node getFirstControlFlowNode() { result.isFirstNodeOf(this) }
}

/**
 * A bad statement, that is, a statement that could not be parsed.
 */
class BadStmt extends @badstmt, Stmt {
  override string toString() { result = "bad statement" }
}

/**
 * A declaration statement.
 */
class DeclStmt extends @declstmt, Stmt, DeclParent {
  /** Gets the declaration in this statement. */
  Decl getDecl() { result = getDecl(0) }

  override predicate mayHaveSideEffects() { getDecl().mayHaveSideEffects() }

  override string toString() { result = "declaration statement" }
}

/**
 * An empty statement.
 */
class EmptyStmt extends @emptystmt, Stmt {
  override string toString() { result = "empty statement" }
}

/**
 * A labeled statement.
 */
class LabeledStmt extends @labeledstmt, Stmt {
  /** Gets the identifier representing the label. */
  Ident getLabelExpr() { result = getChildExpr(0) }

  /** Gets the label. */
  string getLabel() { result = getLabelExpr().getName() }

  /** Gets the statement that is being labeled. */
  Stmt getStmt() { result = getChildStmt(1) }

  override predicate mayHaveSideEffects() { getStmt().mayHaveSideEffects() }

  override string toString() { result = "labeled statement" }
}

/**
 * An expression statement.
 */
class ExprStmt extends @exprstmt, Stmt {
  /** Gets the expression. */
  Expr getExpr() { result = getChildExpr(0) }

  override predicate mayHaveSideEffects() { getExpr().mayHaveSideEffects() }

  override string toString() { result = "expression statement" }
}

/**
 * A send statement.
 */
class SendStmt extends @sendstmt, Stmt {
  /** Gets the expression representing the channel. */
  Expr getChannel() { result = getChildExpr(0) }

  /** Gets the expression representing the value being sent. */
  Expr getValue() { result = getChildExpr(1) }

  override predicate mayHaveSideEffects() { any() }

  override string toString() { result = "send statement" }
}

/**
 * An increment or decrement statement.
 */
class IncDecStmt extends @incdecstmt, Stmt {
  /** Gets the expression. */
  Expr getExpr() { result = getChildExpr(0) }

  /** Gets the increment or decrement operator. */
  string getOperator() { none() }

  override predicate mayHaveSideEffects() { any() }
}

/**
 * An increment statement.
 */
class IncStmt extends @incstmt, IncDecStmt {
  override string getOperator() { result = "++" }

  override string toString() { result = "increment statement" }
}

/**
 * A decrement statement.
 */
class DecStmt extends @decstmt, IncDecStmt {
  override string getOperator() { result = "--" }

  override string toString() { result = "decrement statement" }
}

/**
 * A (simple or compound) assignment statement.
 */
class Assignment extends @assignment, Stmt {
  /** Gets the `i`th left-hand side of this assignment (0-based). */
  Expr getLhs(int i) {
    i >= 0 and
    result = getChildExpr(-(i + 1))
  }

  /** Gets a left-hand side of this assignment. */
  Expr getAnLhs() { result = getLhs(_) }

  /** Gets the number of left-hand sides of this assignment. */
  int getNumLhs() { result = count(getAnLhs()) }

  /** Gets the unique left-hand side of this assignment, if there is only one. */
  Expr getLhs() { getNumLhs() = 1 and result = getLhs(0) }

  /** Gets the `i`th right-hand side of this assignment (0-based). */
  Expr getRhs(int i) {
    i >= 0 and
    result = getChildExpr(i + 1)
  }

  /** Gets a right-hand side of this assignment. */
  Expr getAnRhs() { result = getRhs(_) }

  /** Gets the number of right-hand sides of this assignment. */
  int getNumRhs() { result = count(getAnRhs()) }

  /** Gets the unique right-hand side of this assignment, if there is only one. */
  Expr getRhs() { getNumRhs() = 1 and result = getRhs(0) }

  /** Holds if this assignment assigns `rhs` to `lhs`. */
  predicate assigns(Expr lhs, Expr rhs) { exists(int i | lhs = getLhs(i) and rhs = getRhs(i)) }

  /** Gets the assignment operator in this statement. */
  string getOperator() { none() }

  override predicate mayHaveSideEffects() { any() }

  override string toString() { result = "... " + getOperator() + " ..." }
}

/**
 * A simple assignment statement, that is, an assignment without a compound operator.
 */
class SimpleAssignStmt extends @simpleassignstmt, Assignment { }

/**
 * A plain assignment statement.
 */
class AssignStmt extends @assignstmt, SimpleAssignStmt {
  override string getOperator() { result = "=" }
}

/**
 * A define statement.
 */
class DefineStmt extends @definestmt, SimpleAssignStmt {
  override string getOperator() { result = ":=" }
}

/**
 * A compound assignment statement.
 */
class CompoundAssignStmt extends @compoundassignstmt, Assignment { }

/**
 * An add-assign statement using `+=`.
 */
class AddAssignStmt extends @addassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "+=" }
}

/**
 * A subtract-assign statement using `-=`.
 */
class SubAssignStmt extends @subassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "-=" }
}

/**
 * A multiply-assign statement using `*=`.
 */
class MulAssignStmt extends @mulassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "*=" }
}

/**
 * A divide-assign statement using `/=`.
 */
class QuoAssignStmt extends @quoassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "/=" }
}

class DivAssignStmt = QuoAssignStmt;

/**
 * A modulo-assign statement using `%=`.
 */
class RemAssignStmt extends @remassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "%=" }
}

class ModAssignStmt = RemAssignStmt;

/**
 * An and-assign statement using `&=`.
 */
class AndAssignStmt extends @andassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "&=" }
}

/**
 * An or-assign statement using `|=`.
 */
class OrAssignStmt extends @orassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "|=" }
}

/**
 * An xor-assign statement using `^=`.
 */
class XorAssignStmt extends @xorassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "^=" }
}

/**
 * A left-shift-assign statement using `<<=`.
 */
class ShlAssignStmt extends @shlassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "<<=" }
}

class LShiftAssignStmt = ShlAssignStmt;

/**
 * A right-shift-assign statement using `>>=`.
 */
class ShrAssignStmt extends @shrassignstmt, CompoundAssignStmt {
  override string getOperator() { result = ">>=" }
}

class RShiftAssignStmt = ShrAssignStmt;

/**
 * An and-not-assign statement using `&^=`.
 */
class AndNotAssignStmt extends @andnotassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "&^=" }
}

/**
 * A `go` statement.
 */
class GoStmt extends @gostmt, Stmt {
  /** Gets the call. */
  CallExpr getCall() { result = getChildExpr(0) }

  override predicate mayHaveSideEffects() { getCall().mayHaveSideEffects() }

  override string toString() { result = "go statement" }
}

/**
 * A `defer` statement.
 */
class DeferStmt extends @deferstmt, Stmt {
  /** Gets the call being deferred. */
  CallExpr getCall() { result = getChildExpr(0) }

  override predicate mayHaveSideEffects() { getCall().mayHaveSideEffects() }

  override string toString() { result = "defer statement" }
}

/**
 * A `return` statement.
 */
class ReturnStmt extends @returnstmt, Stmt {
  /** Gets the `i`th returned expression (0-based) */
  Expr getExpr(int i) { result = getChildExpr(i) }

  /** Gets a returned expression. */
  Expr getAnExpr() { result = getExpr(_) }

  /** Gets the number of returned expressions. */
  int getNumExpr() { result = count(getAnExpr()) }

  /** Gets the unique returned expression, if there is only one. */
  Expr getExpr() { getNumChild() = 1 and result = getExpr(0) }

  override predicate mayHaveSideEffects() { getExpr().mayHaveSideEffects() }

  override string toString() { result = "return statement" }
}

/**
 * A branch statement, for example a `break` or `goto`.
 */
class BranchStmt extends @branchstmt, Stmt {
  /** Gets the expression denoting the target label of the branch, if any. */
  Ident getLabelExpr() { result = getChildExpr(0) }

  /** Gets the target label of the branch, if any. */
  string getLabel() { result = getLabelExpr().getName() }
}

/** A `break` statement. */
class BreakStmt extends @breakstmt, BranchStmt {
  override string toString() { result = "break statement" }
}

/** A `continue` statement. */
class ContinueStmt extends @continuestmt, BranchStmt {
  override string toString() { result = "continue statement" }
}

/** A `goto` statement. */
class GotoStmt extends @gotostmt, BranchStmt {
  override string toString() { result = "goto statement" }
}

/** A `fallthrough` statement. */
class FallthroughStmt extends @fallthroughstmt, BranchStmt {
  override string toString() { result = "fallthrough statement" }
}

/** A block statement. */
class BlockStmt extends @blockstmt, Stmt, ScopeNode {
  /** Gets the `i`th statement in this block (0-based). */
  Stmt getStmt(int i) { result = getChildStmt(i) }

  /** Gets a statement in this block. */
  Stmt getAStmt() { result = getAChildStmt() }

  /** Gets the number of statements in this block. */
  int getNumStmt() { result = getNumChildStmt() }

  override predicate mayHaveSideEffects() { getAStmt().mayHaveSideEffects() }

  override string toString() { result = "block statement" }
}

/** An `if` statement. */
class IfStmt extends @ifstmt, Stmt, ScopeNode {
  /** Gets the init statement of this `if` statement, if any. */
  Stmt getInit() { result = getChildStmt(0) }

  /** Gets the condition of this `if` statement. */
  Expr getCond() { result = getChildExpr(1) }

  /** Gets the "then" branch of this `if` statement. */
  BlockStmt getThen() { result = getChildStmt(2) }

  /** Gets the "else" branch of this `if` statement, if any. */
  Stmt getElse() { result = getChildStmt(3) }

  override predicate mayHaveSideEffects() {
    getInit().mayHaveSideEffects() or
    getCond().mayHaveSideEffects() or
    getThen().mayHaveSideEffects() or
    getElse().mayHaveSideEffects()
  }

  override string toString() { result = "if statement" }
}

/** A `case` or `default` clause in a `switch` statement. */
class CaseClause extends @caseclause, Stmt, ScopeNode {
  /** Gets the `i`th expression of this `case` clause (0-based). */
  Expr getExpr(int i) { result = getChildExpr(-(i + 1)) }

  /** Gets an expression of this `case` clause. */
  Expr getAnExpr() { result = getAChildExpr() }

  /** Gets the number of expressions of this `case` clause. */
  int getNumExpr() { result = getNumChildExpr() }

  /** Gets the `i`th statement of this `case` clause (0-based). */
  Stmt getStmt(int i) { result = getChildStmt(i) }

  /** Gets a statement of this `case` clause. */
  Stmt getAStmt() { result = getAChildStmt() }

  /** Gets the number of statements of this `case` clause. */
  int getNumStmt() { result = getNumChildStmt() }

  override predicate mayHaveSideEffects() {
    getAnExpr().mayHaveSideEffects() or
    getAStmt().mayHaveSideEffects()
  }

  override string toString() { result = "case clause" }
}

/**
 * A `switch` statement, that is, either an expression switch or a type switch.
 */
class SwitchStmt extends @switchstmt, Stmt, ScopeNode {
  /** Gets the init statement of this `switch` statement, if any. */
  Stmt getInit() { result = getChildStmt(0) }

  /** Gets the body of this `switch` statement. */
  BlockStmt getBody() { result = getChildStmt(2) }

  /** Gets the `i`th case clause of this `switch` statement (0-based). */
  CaseClause getCase(int i) { result = getBody().getStmt(i) }

  /** Gets a case clause of this `switch` statement. */
  CaseClause getACase() { result = getCase(_) }

  /** Gets the number of case clauses in this `switch` statement. */
  int getNumCase() { result = count(getACase()) }

  /** Gets the `i`th non-default case clause of this `switch` statement (0-based). */
  CaseClause getNonDefaultCase(int i) {
    result = rank[i + 1](CaseClause cc, int j |
        cc = getCase(j) and exists(cc.getExpr(_))
      |
        cc order by j
      )
  }

  /** Gets a non-default case clause of this `switch` statement. */
  CaseClause getANonDefaultCase() { result = getNonDefaultCase(_) }

  /** Gets the number of non-default case clauses in this `switch` statement. */
  int getNumNonDefaultCase() { result = count(getANonDefaultCase()) }

  /** Gets the default case clause of this `switch` statement, if any. */
  CaseClause getDefault() { result = getACase() and not exists(result.getExpr(_)) }
}

/**
 * An expression-switch statement.
 */
class ExpressionSwitchStmt extends @exprswitchstmt, SwitchStmt {
  /** Gets the switch expression of this `switch` statement. */
  Expr getExpr() { result = getChildExpr(1) }

  override predicate mayHaveSideEffects() {
    getInit().mayHaveSideEffects() or
    getBody().mayHaveSideEffects()
  }

  override string toString() { result = "expression-switch statement" }
}

/**
 * A type-switch statement.
 */
class TypeSwitchStmt extends @typeswitchstmt, SwitchStmt {
  /** Gets the assign statement of this type-switch statement. */
  SimpleAssignStmt getAssign() { result = getChildStmt(1) }

  /** Gets the expression whose type is examined by this `switch` statement. */
  Expr getExpr() { result = getAssign().getRhs() or result = getChildStmt(1).(ExprStmt).getExpr() }

  override predicate mayHaveSideEffects() { any() }

  override string toString() { result = "type-switch statement" }
}

/**
 * A comm clause, that is, a `case` or `default` clause in a `select` statement.
 */
class CommClause extends @commclause, Stmt, ScopeNode {
  /** Gets the comm statement of this clause, if any. */
  Stmt getComm() { result = getChildStmt(0) }

  /** Gets the `i`th statement of this clause (0-based). */
  Stmt getStmt(int i) { i >= 0 and result = getChildStmt(i + 1) }

  /** Gets a statement of this clause. */
  Stmt getAStmt() { result = getStmt(_) }

  /** Gets the number of statements of this clause. */
  int getNumStmt() { result = count(getAStmt()) }

  override predicate mayHaveSideEffects() { getAStmt().mayHaveSideEffects() }

  override string toString() { result = "comm clause" }
}

/**
 * A receive statement in a comm clause.
 */
class RecvStmt extends Stmt {
  RecvStmt() { this = any(CommClause cc).getComm() and not this instanceof SendStmt }

  /** Gets the `i`th left-hand-side expression of this receive statement, if any. */
  Expr getLhs(int i) { result = this.(Assignment).getLhs(i) }

  /** Gets the number of left-hand-side expressions of this receive statement. */
  int getNumLhs() { result = count(getLhs(_)) }

  /** Gets the receive expression of this receive statement. */
  ArrowExpr getExpr() {
    result = this.(ExprStmt).getExpr() or
    result = this.(Assignment).getRhs()
  }
}

/**
 * A `select` statement.
 */
class SelectStmt extends @selectstmt, Stmt {
  /** Gets the body of this `select` statement. */
  BlockStmt getBody() { result = getChildStmt(0) }

  /**
   * Gets the `i`th comm clause (that is, `case` or `default` clause) in this `select` statement.
   */
  CommClause getCommClause(int i) { result = getBody().getStmt(i) }

  /**
   * Gets a comm clause in this `select` statement.
   */
  CommClause getACommClause() { result = getCommClause(_) }

  /** Gets the `i`th `case` clause in this `select` statement. */
  CommClause getNonDefaultCommClause(int i) {
    result = rank[i + 1](CommClause cc, int j |
        cc = getCommClause(j) and exists(cc.getComm())
      |
        cc order by j
      )
  }

  int getNumNonDefaultCommClause() { result = count(getNonDefaultCommClause(_)) }

  CommClause getDefaultCommClause() {
    result = getCommClause(_) and
    not exists(result.getComm())
  }

  override predicate mayHaveSideEffects() { any() }

  override string toString() { result = "select statement" }
}

/**
 * A loop, that is, either a `for` statement or a `range` statement.
 */
class LoopStmt extends @loopstmt, Stmt, ScopeNode {
  /** Gets the body of this loop. */
  BlockStmt getBody() { none() }
}

/**
 * A `for` statement.
 */
class ForStmt extends @forstmt, LoopStmt {
  /** Gets the init statement of this `for` statement, if any. */
  Stmt getInit() { result = getChildStmt(0) }

  /** Gets the condition of this `for` statement. */
  Expr getCond() { result = getChildExpr(1) }

  /** Gets the post statement of this `for` statement. */
  Stmt getPost() { result = getChildStmt(2) }

  override BlockStmt getBody() { result = getChildStmt(3) }

  override predicate mayHaveSideEffects() {
    getInit().mayHaveSideEffects() or
    getCond().mayHaveSideEffects() or
    getPost().mayHaveSideEffects() or
    getBody().mayHaveSideEffects()
  }

  override string toString() { result = "for statement" }
}

/**
 * A `range` statement.
 */
class RangeStmt extends @rangestmt, LoopStmt {
  /** Gets the expression denoting the key of this `range` statement. */
  Expr getKey() { result = getChildExpr(0) }

  /** Get the expression denoting the value of this `range` statement. */
  Expr getValue() { result = getChildExpr(1) }

  /** Gets the domain of this `range` statement. */
  Expr getDomain() { result = getChildExpr(2) }

  override BlockStmt getBody() { result = getChildStmt(3) }

  override predicate mayHaveSideEffects() { any() }

  override string toString() { result = "range statement" }
}
