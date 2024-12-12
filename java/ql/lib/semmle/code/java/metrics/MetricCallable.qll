/**
 * Provides classes and predicates for computing metrics on Java methods and constructors.
 */

import semmle.code.java.Member

/** This class provides access to metrics information for callables. */
class MetricCallable extends Callable {
  /**
   * Gets a callable on which this callable depends.
   *
   * A callable `m` depends on another callable `n`
   * if there exists a call to `n` from within `m`,
   * taking overriding into account.
   */
  MetricCallable getADependency() { this.polyCalls(result) }

  /**
   * The afferent coupling of a callable is defined as
   * the number of callables that depend on this callable.
   *
   * This may also be referred to as the "fan-in" or
   * "incoming dependencies" of a callable.
   */
  int getAfferentCoupling() { result = count(MetricCallable m | m.getADependency() = this) }

  /**
   * The efferent coupling of a callable is defined as
   * the number of callables on which this callable depends.
   *
   * This may also be referred to as the "fan-out" or
   * "outgoing dependencies" of a callable.
   */
  int getEfferentCoupling() { result = count(MetricCallable m | this.getADependency() = m) }

  /**
   * The cyclomatic complexity of a callable is defined as the number
   * of branching statements (`if`, `while`, `do`, `for`, `switch`, `case`, `catch`)
   * plus the number of branching expressions (`?`, `&&` and `||`)
   * plus one.
   */
  int getCyclomaticComplexity() {
    result =
      count(Stmt stmt | branchingStmt(stmt) and stmt.getEnclosingCallable() = this) +
        count(Expr expr | branchingExpr(expr) and expr.getEnclosingCallable() = this) + 1
  }

  /**
   * The Halstead length of a callable is estimated as the sum of the number of statements
   * and expressions within the callable, plus one for the callable itself.
   */
  int getHalsteadLength() {
    result =
      count(Stmt s | s.getEnclosingCallable() = this) +
        count(Expr e | e.getEnclosingCallable() = this) + 1
  }

  /**
   * The Halstead vocabulary of a callable is estimated as the number of unique Halstead IDs
   * of all statements and expressions within the callable.
   */
  int getHalsteadVocabulary() {
    result =
      count(string id |
        exists(Stmt s | s.getEnclosingCallable() = this and id = s.getHalsteadID())
        or
        exists(Expr e | e.getEnclosingCallable() = this and id = e.getHalsteadID())
      )
  }
}

// Branching points in the sense of cyclomatic complexity are binary,
// so there should be a branching point for each non-default switch
// case (ignoring those that just fall through to the next case).
private predicate branchingSwitchCase(ConstCase sc) {
  not sc.getControlFlowNode().getASuccessor().asStmt() instanceof SwitchCase and
  not defaultFallThrough(sc)
}

private predicate defaultFallThrough(ConstCase sc) {
  exists(DefaultCase default | default.getControlFlowNode().getASuccessor().asStmt() = sc)
  or
  defaultFallThrough(sc.getControlFlowNode().getAPredecessor().asStmt())
}

/** Holds if `stmt` is a branching statement used for the computation of cyclomatic complexity. */
private predicate branchingStmt(Stmt stmt) {
  stmt instanceof IfStmt or
  stmt instanceof WhileStmt or
  stmt instanceof DoStmt or
  stmt instanceof ForStmt or
  stmt instanceof EnhancedForStmt or
  stmt instanceof PatternCase or
  branchingSwitchCase(stmt) or
  stmt instanceof CatchClause
}

/** Holds if `expr` is a branching expression used for the computation of cyclomatic complexity. */
private predicate branchingExpr(Expr expr) {
  expr instanceof ConditionalExpr or
  expr instanceof AndLogicalExpr or
  expr instanceof OrLogicalExpr
}
