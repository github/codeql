/**
 * Provides classes for working with statements.
 */

import go

/**
 * A statement.
 *
 * Examples:
 *
 * ```go
 * a = 0
 *
 * if x := f(); x < y {
 *   return y - x
 * } else {
 *   return x - y
 * }
 * ```
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
 *
 * Examples:
 *
 * ```go
 * go fmt.Println
 * defer int
 * ```
 */
class BadStmt extends @badstmt, Stmt {
  override string toString() { result = "bad statement" }

  override string getAPrimaryQlClass() { result = "BadStmt" }
}

/**
 * A declaration statement.
 *
 * Examples:
 *
 * ```go
 * var i int
 * const pi = 3.14159
 * type Printer interface{ Print() }
 * ```
 */
class DeclStmt extends @declstmt, Stmt, DeclParent {
  /** Gets the declaration in this statement. */
  Decl getDecl() { result = this.getDecl(0) }

  override predicate mayHaveSideEffects() { this.getDecl().mayHaveSideEffects() }

  override string toString() { result = "declaration statement" }

  override string getAPrimaryQlClass() { result = "DeclStmt" }
}

/**
 * An empty statement.
 *
 * Examples:
 *
 * ```go
 * ;
 * ```
 */
class EmptyStmt extends @emptystmt, Stmt {
  override string toString() { result = "empty statement" }

  override string getAPrimaryQlClass() { result = "EmptyStmt" }
}

/**
 * A labeled statement.
 *
 * Examples:
 *
 * ```go
 * Error: log.Panic("error encountered")
 * ```
 */
class LabeledStmt extends @labeledstmt, Stmt {
  /** Gets the identifier representing the label. */
  Ident getLabelExpr() { result = this.getChildExpr(0) }

  /** Gets the label. */
  string getLabel() { result = this.getLabelExpr().getName() }

  /** Gets the statement that is being labeled. */
  Stmt getStmt() { result = this.getChildStmt(1) }

  override predicate mayHaveSideEffects() { this.getStmt().mayHaveSideEffects() }

  override string toString() { result = "labeled statement" }

  override string getAPrimaryQlClass() { result = "LabeledStmt" }
}

/**
 * An expression statement.
 *
 * Examples:
 *
 * ```go
 * h(x+y)
 * f.Close()
 * <-ch
 * (<-ch)
 * ```
 */
class ExprStmt extends @exprstmt, Stmt {
  /** Gets the expression. */
  Expr getExpr() { result = this.getChildExpr(0) }

  override predicate mayHaveSideEffects() { this.getExpr().mayHaveSideEffects() }

  override string toString() { result = "expression statement" }

  override string getAPrimaryQlClass() { result = "ExprStmt" }
}

/**
 * A send statement.
 *
 * Examples:
 *
 * ```go
 * ch <- 3
 * ```
 */
class SendStmt extends @sendstmt, Stmt {
  /** Gets the expression representing the channel. */
  Expr getChannel() { result = this.getChildExpr(0) }

  /** Gets the expression representing the value being sent. */
  Expr getValue() { result = this.getChildExpr(1) }

  override predicate mayHaveSideEffects() { any() }

  override string toString() { result = "send statement" }

  override string getAPrimaryQlClass() { result = "SendStmt" }
}

/**
 * An increment or decrement statement.
 *
 * Examples:
 *
 * ```go
 * a++
 * b--
 * ```
 */
class IncDecStmt extends @incdecstmt, Stmt {
  /** Gets the expression being incremented or decremented. */
  Expr getOperand() { result = this.getChildExpr(0) }

  /** Gets the increment or decrement operator. */
  string getOperator() { none() }

  override predicate mayHaveSideEffects() { any() }
}

/**
 * An increment statement.
 *
 * Examples:
 *
 * ```go
 * a++
 * ```
 */
class IncStmt extends @incstmt, IncDecStmt {
  override string getOperator() { result = "++" }

  override string toString() { result = "increment statement" }

  override string getAPrimaryQlClass() { result = "IncStmt" }
}

/**
 * A decrement statement.
 *
 * Examples:
 *
 * ```go
 * b--
 * ```
 */
class DecStmt extends @decstmt, IncDecStmt {
  override string getOperator() { result = "--" }

  override string toString() { result = "decrement statement" }

  override string getAPrimaryQlClass() { result = "DecStmt" }
}

/**
 * A (simple or compound) assignment statement.
 *
 * Examples:
 *
 * ```go
 * x := 1
 * *p = f()
 * a[i] = 23
 * (k) = <-ch  // same as: k = <-ch
 * a += 2
 * ```
 */
class Assignment extends @assignment, Stmt {
  /** Gets the `i`th left-hand side of this assignment (0-based). */
  Expr getLhs(int i) {
    i >= 0 and
    result = this.getChildExpr(-(i + 1))
  }

  /** Gets a left-hand side of this assignment. */
  Expr getAnLhs() { result = this.getLhs(_) }

  /** Gets the number of left-hand sides of this assignment. */
  int getNumLhs() { result = count(this.getAnLhs()) }

  /** Gets the unique left-hand side of this assignment, if there is only one. */
  Expr getLhs() { this.getNumLhs() = 1 and result = this.getLhs(0) }

  /** Gets the `i`th right-hand side of this assignment (0-based). */
  Expr getRhs(int i) {
    i >= 0 and
    result = this.getChildExpr(i + 1)
  }

  /** Gets a right-hand side of this assignment. */
  Expr getAnRhs() { result = this.getRhs(_) }

  /** Gets the number of right-hand sides of this assignment. */
  int getNumRhs() { result = count(this.getAnRhs()) }

  /** Gets the unique right-hand side of this assignment, if there is only one. */
  Expr getRhs() { this.getNumRhs() = 1 and result = this.getRhs(0) }

  /** Holds if this assignment assigns `rhs` to `lhs`. */
  predicate assigns(Expr lhs, Expr rhs) {
    exists(int i | lhs = this.getLhs(i) and rhs = this.getRhs(i))
  }

  /** Gets the assignment operator in this statement. */
  string getOperator() { none() }

  override predicate mayHaveSideEffects() { any() }

  override string toString() { result = "... " + this.getOperator() + " ..." }
}

/**
 * A simple assignment statement, that is, an assignment without a compound operator.
 *
 * Examples:
 *
 * ```go
 * x := 1
 * *p = f()
 * a[i] = 23
 * (k) = <-ch  // same as: k = <-ch
 * ```
 */
class SimpleAssignStmt extends @simpleassignstmt, Assignment {
  override string getAPrimaryQlClass() { result = "SimpleAssignStmt" }
}

/**
 * A plain assignment statement.
 *
 * Examples:
 *
 * ```go
 * *p = f()
 * a[i] = 23
 * (k) = <-ch  // same as: k = <-ch
 * ```
 */
class AssignStmt extends @assignstmt, SimpleAssignStmt {
  override string getOperator() { result = "=" }

  override string getAPrimaryQlClass() { result = "AssignStmt" }
}

/**
 * A define statement.
 *
 * Examples:
 *
 * ```go
 * x := 1
 * ```
 */
class DefineStmt extends @definestmt, SimpleAssignStmt {
  override string getOperator() { result = ":=" }

  override string getAPrimaryQlClass() { result = "DefineStmt" }
}

/**
 * A compound assignment statement.
 *
 * Examples:
 *
 * ```go
 * a += 2
 * a /= 2
 * ```
 */
class CompoundAssignStmt extends @compoundassignstmt, Assignment { }

/**
 * An add-assign statement using `+=`.
 *
 * Examples:
 *
 * ```go
 * a += 2
 * ```
 */
class AddAssignStmt extends @addassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "+=" }

  override string getAPrimaryQlClass() { result = "AddAssignStmt" }
}

/**
 * A subtract-assign statement using `-=`.
 *
 * Examples:
 *
 * ```go
 * a -= 2
 * ```
 */
class SubAssignStmt extends @subassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "-=" }

  override string getAPrimaryQlClass() { result = "SubAssignStmt" }
}

/**
 * A multiply-assign statement using `*=`.
 *
 * Examples:
 *
 * ```go
 * a *= 2
 * ```
 */
class MulAssignStmt extends @mulassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "*=" }

  override string getAPrimaryQlClass() { result = "MulAssignStmt" }
}

/**
 * A divide-assign statement using `/=`.
 *
 * Examples:
 *
 * ```go
 * a /= 2
 * ```
 */
class QuoAssignStmt extends @quoassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "/=" }

  override string getAPrimaryQlClass() { result = "QuoAssignStmt" }
}

class DivAssignStmt = QuoAssignStmt;

/**
 * A modulo-assign statement using `%=`.
 *
 * Examples:
 *
 * ```go
 * a %= 2
 * ```
 */
class RemAssignStmt extends @remassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "%=" }

  override string getAPrimaryQlClass() { result = "RemAssignStmt" }
}

class ModAssignStmt = RemAssignStmt;

/**
 * An and-assign statement using `&=`.
 *
 * Examples:
 *
 * ```go
 * a &= 2
 * ```
 */
class AndAssignStmt extends @andassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "&=" }

  override string getAPrimaryQlClass() { result = "AndAssignStmt" }
}

/**
 * An or-assign statement using `|=`.
 *
 * Examples:
 *
 * ```go
 * a |= 2
 * ```
 */
class OrAssignStmt extends @orassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "|=" }

  override string getAPrimaryQlClass() { result = "OrAssignStmt" }
}

/**
 * An xor-assign statement using `^=`.
 *
 * Examples:
 *
 * ```go
 * a ^= 2
 * ```
 */
class XorAssignStmt extends @xorassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "^=" }

  override string getAPrimaryQlClass() { result = "XorAssignStmt" }
}

/**
 * A left-shift-assign statement using `<<=`.
 *
 * Examples:
 *
 * ```go
 * a <<= 2
 * ```
 */
class ShlAssignStmt extends @shlassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "<<=" }

  override string getAPrimaryQlClass() { result = "ShlAssignStmt" }
}

class LShiftAssignStmt = ShlAssignStmt;

/**
 * A right-shift-assign statement using `>>=`.
 *
 * Examples:
 *
 * ```go
 * a >>= 2
 * ```
 */
class ShrAssignStmt extends @shrassignstmt, CompoundAssignStmt {
  override string getOperator() { result = ">>=" }

  override string getAPrimaryQlClass() { result = "ShrAssignStmt" }
}

class RShiftAssignStmt = ShrAssignStmt;

/**
 * An and-not-assign statement using `&^=`.
 *
 * Examples:
 *
 * ```go
 * a &^= 2
 * ```
 */
class AndNotAssignStmt extends @andnotassignstmt, CompoundAssignStmt {
  override string getOperator() { result = "&^=" }

  override string getAPrimaryQlClass() { result = "AndNotAssignStmt" }
}

/**
 * A `go` statement.
 *
 * Examples:
 *
 * ```go
 * go fillPixels(row)
 * ```
 */
class GoStmt extends @gostmt, Stmt {
  /** Gets the call. */
  CallExpr getCall() { result = this.getChildExpr(0) }

  override predicate mayHaveSideEffects() { this.getCall().mayHaveSideEffects() }

  override string toString() { result = "go statement" }

  override string getAPrimaryQlClass() { result = "GoStmt" }
}

/**
 * A `defer` statement.
 *
 * Examples:
 *
 * ```go
 * defer mutex.Unlock()
 * ```
 */
class DeferStmt extends @deferstmt, Stmt {
  /** Gets the call being deferred. */
  CallExpr getCall() { result = this.getChildExpr(0) }

  override predicate mayHaveSideEffects() { this.getCall().mayHaveSideEffects() }

  override string toString() { result = "defer statement" }

  override string getAPrimaryQlClass() { result = "DeferStmt" }
}

/**
 * A `return` statement.
 *
 * Examples:
 *
 * ```go
 * return x
 * ```
 */
class ReturnStmt extends @returnstmt, Stmt {
  /** Gets the `i`th returned expression (0-based) */
  Expr getExpr(int i) { result = this.getChildExpr(i) }

  /** Gets a returned expression. */
  Expr getAnExpr() { result = this.getExpr(_) }

  /** Gets the number of returned expressions. */
  int getNumExpr() { result = count(this.getAnExpr()) }

  /** Gets the unique returned expression, if there is only one. */
  Expr getExpr() { this.getNumChild() = 1 and result = this.getExpr(0) }

  override predicate mayHaveSideEffects() { this.getAnExpr().mayHaveSideEffects() }

  override string toString() { result = "return statement" }

  override string getAPrimaryQlClass() { result = "ReturnStmt" }
}

/**
 * A branch statement, for example a `break` or `goto`.
 *
 * Examples:
 *
 * ```go
 * break
 * break OuterLoop
 * continue
 * continue RowLoop
 * goto Error
 * fallthrough
 * ```
 */
class BranchStmt extends @branchstmt, Stmt {
  /** Gets the expression denoting the target label of the branch, if any. */
  Ident getLabelExpr() { result = this.getChildExpr(0) }

  /** Gets the target label of the branch, if any. */
  string getLabel() { result = this.getLabelExpr().getName() }
}

/**
 * A `break` statement.
 *
 * Examples:
 *
 * ```go
 * break
 * break OuterLoop
 * ```
 */
class BreakStmt extends @breakstmt, BranchStmt {
  override string toString() { result = "break statement" }

  override string getAPrimaryQlClass() { result = "BreakStmt" }
}

/**
 * A `continue` statement.
 *
 * Examples:
 *
 * ```go
 * continue
 * continue RowLoop
 * ```
 */
class ContinueStmt extends @continuestmt, BranchStmt {
  override string toString() { result = "continue statement" }

  override string getAPrimaryQlClass() { result = "ContinueStmt" }
}

/**
 * A `goto` statement.
 *
 * Examples:
 *
 * ```go
 * goto Error
 * ```
 */
class GotoStmt extends @gotostmt, BranchStmt {
  override string toString() { result = "goto statement" }

  override string getAPrimaryQlClass() { result = "GotoStmt" }
}

/**
 * A `fallthrough` statement.
 *
 * Examples:
 *
 * ```go
 * fallthrough
 * ```
 */
class FallthroughStmt extends @fallthroughstmt, BranchStmt {
  override string toString() { result = "fallthrough statement" }

  override string getAPrimaryQlClass() { result = "FallthroughStmt" }
}

/**
 * A block statement.
 *
 * Examples:
 *
 * ```go
 * {
 *   fmt.Printf("iteration %d\n", i)
 *   f(i)
 * }
 * ```
 */
class BlockStmt extends @blockstmt, Stmt, ScopeNode {
  /** Gets the `i`th statement in this block (0-based). */
  Stmt getStmt(int i) { result = this.getChildStmt(i) }

  /** Gets a statement in this block. */
  Stmt getAStmt() { result = this.getAChildStmt() }

  /** Gets the number of statements in this block. */
  int getNumStmt() { result = this.getNumChildStmt() }

  override predicate mayHaveSideEffects() { this.getAStmt().mayHaveSideEffects() }

  override string toString() { result = "block statement" }

  override string getAPrimaryQlClass() { result = "BlockStmt" }
}

/**
 * An `if` statement.
 *
 * Examples:
 *
 * ```go
 * if x := f(); x < y {
 *   return y - x
 * } else {
 *   return x - y
 * }
 * ```
 */
class IfStmt extends @ifstmt, Stmt, ScopeNode {
  /** Gets the init statement of this `if` statement, if any. */
  Stmt getInit() { result = this.getChildStmt(0) }

  /** Gets the condition of this `if` statement. */
  Expr getCond() { result = this.getChildExpr(1) }

  /** Gets the "then" branch of this `if` statement. */
  BlockStmt getThen() { result = this.getChildStmt(2) }

  /** Gets the "else" branch of this `if` statement, if any. */
  Stmt getElse() { result = this.getChildStmt(3) }

  override predicate mayHaveSideEffects() {
    this.getInit().mayHaveSideEffects() or
    this.getCond().mayHaveSideEffects() or
    this.getThen().mayHaveSideEffects() or
    this.getElse().mayHaveSideEffects()
  }

  override string toString() { result = "if statement" }

  override string getAPrimaryQlClass() { result = "IfStmt" }
}

/**
 * A `case` or `default` clause in a `switch` statement.
 *
 * Examples:
 *
 * ```go
 * case 0, 1:
 *   a = 1
 *   fallthrough
 *
 * default:
 *   b = 2
 *
 * case func(int) float64:
 *   printFunction(i)
 * ```
 */
class CaseClause extends @caseclause, Stmt, ScopeNode {
  /**
   * Gets the `i`th expression of this `case` clause (0-based).
   *
   * Note that the default clause does not have any expressions.
   */
  Expr getExpr(int i) { result = this.getChildExpr(-(i + 1)) }

  /**
   * Gets an expression of this `case` clause, if any.
   *
   * Note that the default clause does not have any expressions.
   */
  Expr getAnExpr() { result = this.getAChildExpr() }

  /**
   * Gets the number of expressions of this `case` clause.
   *
   * Note that the default clause does not have any expressions.
   */
  int getNumExpr() { result = this.getNumChildExpr() }

  /** Gets the `i`th statement of this `case` clause (0-based). */
  Stmt getStmt(int i) { result = this.getChildStmt(i) }

  /** Gets a statement of this `case` clause. */
  Stmt getAStmt() { result = this.getAChildStmt() }

  /** Gets the number of statements of this `case` clause. */
  int getNumStmt() { result = this.getNumChildStmt() }

  /**
   * Gets the implicitly declared variable for this `case` clause, if any.
   *
   * This exists for case clauses in type switch statements which declare a
   * variable in the guard.
   */
  LocalVariable getImplicitlyDeclaredVariable() {
    not exists(result.getDeclaration()) and result.getScope().(LocalScope).getNode() = this
  }

  override predicate mayHaveSideEffects() {
    this.getAnExpr().mayHaveSideEffects() or
    this.getAStmt().mayHaveSideEffects()
  }

  override string toString() { result = "case clause" }

  override string getAPrimaryQlClass() { result = "CaseClause" }
}

/**
 * A `switch` statement, that is, either an expression switch or a type switch.
 *
 * Examples:
 *
 * ```go
 * switch x := f(); x {
 * case 0, 1:
 *   a = 1
 *   fallthrough
 * default:
 *   b = 2
 * }
 *
 * switch i := x.(type) {
 * default:
 *   printString("don't know the type")
 * case nil:
 *   printString("x is nil")
 * case int:
 *   printInt(i)
 * case func(int) float64:
 *   printFunction(i)
 * }
 * ```
 */
class SwitchStmt extends @switchstmt, Stmt, ScopeNode {
  /** Gets the init statement of this `switch` statement, if any. */
  Stmt getInit() { result = this.getChildStmt(0) }

  /** Gets the body of this `switch` statement. */
  BlockStmt getBody() { result = this.getChildStmt(2) }

  /** Gets the `i`th case clause of this `switch` statement (0-based). */
  CaseClause getCase(int i) { result = this.getBody().getStmt(i) }

  /** Gets a case clause of this `switch` statement. */
  CaseClause getACase() { result = this.getCase(_) }

  /** Gets the number of case clauses in this `switch` statement. */
  int getNumCase() { result = count(this.getACase()) }

  /** Gets the `i`th non-default case clause of this `switch` statement (0-based). */
  CaseClause getNonDefaultCase(int i) {
    result =
      rank[i + 1](CaseClause cc, int j |
        cc = this.getCase(j) and exists(cc.getExpr(_))
      |
        cc order by j
      )
  }

  /** Gets a non-default case clause of this `switch` statement. */
  CaseClause getANonDefaultCase() { result = this.getNonDefaultCase(_) }

  /** Gets the number of non-default case clauses in this `switch` statement. */
  int getNumNonDefaultCase() { result = count(this.getANonDefaultCase()) }

  /** Gets the default case clause of this `switch` statement, if any. */
  CaseClause getDefault() { result = this.getACase() and not exists(result.getExpr(_)) }
}

/**
 * An expression-switch statement.
 *
 * Examples:
 *
 * ```go
 * switch x := f(); x {
 * case 0, 1:
 *   a = 1
 *   fallthrough
 * default:
 *   b = 2
 * }
 * ```
 */
class ExpressionSwitchStmt extends @exprswitchstmt, SwitchStmt {
  /** Gets the switch expression of this `switch` statement. */
  Expr getExpr() { result = this.getChildExpr(1) }

  override predicate mayHaveSideEffects() {
    this.getInit().mayHaveSideEffects() or
    this.getBody().mayHaveSideEffects()
  }

  override string toString() { result = "expression-switch statement" }

  override string getAPrimaryQlClass() { result = "ExpressionSwitchStmt" }
}

/**
 * A type-switch statement.
 *
 * Examples:
 *
 * ```go
 * switch i := x.(type) {
 * default:
 *   printString("don't know the type")     // type of i is type of x (interface{})
 * case nil:
 *   printString("x is nil")                // type of i is type of x (interface{})
 * case int:
 *   printInt(i)                            // type of i is int
 * case func(int) float64:
 *   printFunction(i)                       // type of i is func(int) float64
 * }
 * ```
 */
class TypeSwitchStmt extends @typeswitchstmt, SwitchStmt {
  /** Gets the assign statement of this type-switch statement. */
  SimpleAssignStmt getAssign() { result = this.getChildStmt(1) }

  /** Gets the test statement of this type-switch statement. This is a `SimpleAssignStmt` or `ExprStmt`. */
  Stmt getTest() { result = this.getChildStmt(1) }

  /** Gets the expression whose type is examined by this `switch` statement. */
  Expr getExpr() {
    result = this.getAssign().getRhs() or result = this.getChildStmt(1).(ExprStmt).getExpr()
  }

  override predicate mayHaveSideEffects() { any() }

  override string toString() { result = "type-switch statement" }

  override string getAPrimaryQlClass() { result = "TypeSwitchStmt" }
}

/**
 * A comm clause, that is, a `case` or `default` clause in a `select` statement.
 *
 * Examples:
 *
 * ```go
 * case i1 = <-c1:
 *   print("received ", i1, " from c1\n")
 *
 * case c2 <- i2:
 *   print("sent ", i2, " to c2\n")
 *
 * case i3, ok := (<-c3):  // same as: i3, ok := <-c3
 *   if ok {
 *     print("received ", i3, " from c3\n")
 *   } else {
 *     print("c3 is closed\n")
 *   }
 *
 * default:
 *   print("no communication\n")
 * ```
 */
class CommClause extends @commclause, Stmt, ScopeNode {
  /** Gets the comm statement of this clause, if any. */
  Stmt getComm() { result = this.getChildStmt(0) }

  /** Gets the `i`th statement of this clause (0-based). */
  Stmt getStmt(int i) { i >= 0 and result = this.getChildStmt(i + 1) }

  /** Gets a statement of this clause. */
  Stmt getAStmt() { result = this.getStmt(_) }

  /** Gets the number of statements of this clause. */
  int getNumStmt() { result = count(this.getAStmt()) }

  override predicate mayHaveSideEffects() { this.getAStmt().mayHaveSideEffects() }

  override string toString() { result = "comm clause" }

  override string getAPrimaryQlClass() { result = "CommClause" }
}

/**
 * A receive statement in a comm clause.
 *
 * Examples:
 *
 * ```go
 * i1 = <-c1
 * i3, ok := <-c3
 * i3, ok := (<-c3)
 * ```
 */
class RecvStmt extends Stmt {
  RecvStmt() { this = any(CommClause cc).getComm() and not this instanceof SendStmt }

  /** Gets the `i`th left-hand-side expression of this receive statement, if any. */
  Expr getLhs(int i) { result = this.(Assignment).getLhs(i) }

  /** Gets the number of left-hand-side expressions of this receive statement. */
  int getNumLhs() { result = count(this.getLhs(_)) }

  /** Gets the receive expression of this receive statement. */
  RecvExpr getExpr() {
    result = this.(ExprStmt).getExpr() or
    result = this.(Assignment).getRhs()
  }

  override string getAPrimaryQlClass() { result = "RecvStmt" }
}

/**
 * A `select` statement.
 *
 * Examples:
 *
 * ```go
 * select {
 * case i1 = <-c1:
 *   print("received ", i1, " from c1\n")
 * case c2 <- i2:
 *   print("sent ", i2, " to c2\n")
 * case i3, ok := (<-c3):  // same as: i3, ok := <-c3
 *   if ok {
 *     print("received ", i3, " from c3\n")
 *   } else {
 *     print("c3 is closed\n")
 *   }
 * default:
 *   print("no communication\n")
 * }
 * ```
 */
class SelectStmt extends @selectstmt, Stmt {
  /** Gets the body of this `select` statement. */
  BlockStmt getBody() { result = this.getChildStmt(0) }

  /**
   * Gets the `i`th comm clause (that is, `case` or `default` clause) in this `select` statement.
   */
  CommClause getCommClause(int i) { result = this.getBody().getStmt(i) }

  /**
   * Gets a comm clause in this `select` statement.
   */
  CommClause getACommClause() { result = this.getCommClause(_) }

  /** Gets the `i`th `case` clause in this `select` statement. */
  CommClause getNonDefaultCommClause(int i) {
    result =
      rank[i + 1](CommClause cc, int j |
        cc = this.getCommClause(j) and exists(cc.getComm())
      |
        cc order by j
      )
  }

  /** Gets the number of `case` clauses in this `select` statement. */
  int getNumNonDefaultCommClause() { result = count(this.getNonDefaultCommClause(_)) }

  /** Gets the `default` clause in this `select` statement, if any. */
  CommClause getDefaultCommClause() {
    result = this.getCommClause(_) and
    not exists(result.getComm())
  }

  override predicate mayHaveSideEffects() { any() }

  override string toString() { result = "select statement" }

  override string getAPrimaryQlClass() { result = "SelectStmt" }
}

/**
 * A loop, that is, either a `for` statement or a `range` statement.
 *
 * Examples:
 *
 * ```go
 * for a < b {
 *   a *= 2
 * }
 *
 * for i := 0; i < 10; i++ {
 *   f(i)
 * }
 *
 * for key, value := range mymap {
 *   fmt.Printf("mymap[%s] = %d\n", key, value)
 * }
 * ```
 */
class LoopStmt extends @loopstmt, Stmt, ScopeNode {
  /** Gets the body of this loop. */
  BlockStmt getBody() { none() }
}

/**
 * A `for` statement.
 *
 * Examples:
 *
 * ```go
 * for a < b {
 *   a *= 2
 * }
 *
 * for i := 0; i < 10; i++ {
 *   f(i)
 * }
 * ```
 */
class ForStmt extends @forstmt, LoopStmt {
  /** Gets the init statement of this `for` statement, if any. */
  Stmt getInit() { result = this.getChildStmt(0) }

  /** Gets the condition of this `for` statement. */
  Expr getCond() { result = this.getChildExpr(1) }

  /** Gets the post statement of this `for` statement. */
  Stmt getPost() { result = this.getChildStmt(2) }

  override BlockStmt getBody() { result = this.getChildStmt(3) }

  override predicate mayHaveSideEffects() {
    this.getInit().mayHaveSideEffects() or
    this.getCond().mayHaveSideEffects() or
    this.getPost().mayHaveSideEffects() or
    this.getBody().mayHaveSideEffects()
  }

  override string toString() { result = "for statement" }

  override string getAPrimaryQlClass() { result = "ForStmt" }
}

/**
 * A `range` statement.
 *
 * Examples:
 *
 * ```go
 * for key, value := range mymap {
 *   fmt.Printf("mymap[%s] = %d\n", key, value)
 * }
 *
 * for _, value = range array {
 *   fmt.Printf("array contains: %d\n", value)
 * }
 *
 * for index, _ := range str {
 *   fmt.Printf("str[%d] = ?\n", index)
 * }
 *
 * for value = range ch {
 *   fmt.Printf("value from channel: %d\n", value)
 * }
 * ```
 */
class RangeStmt extends @rangestmt, LoopStmt {
  /** Gets the expression denoting the key of this `range` statement. */
  Expr getKey() { result = this.getChildExpr(0) }

  /** Get the expression denoting the value of this `range` statement. */
  Expr getValue() { result = this.getChildExpr(1) }

  /** Gets the domain of this `range` statement. */
  Expr getDomain() { result = this.getChildExpr(2) }

  override BlockStmt getBody() { result = this.getChildStmt(3) }

  override predicate mayHaveSideEffects() { any() }

  override string toString() { result = "range statement" }

  override string getAPrimaryQlClass() { result = "RangeStmt" }
}
