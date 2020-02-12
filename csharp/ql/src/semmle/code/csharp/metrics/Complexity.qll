import csharp

// Branching points in the sense of cyclomatic complexity are binary,
// so there should be a branching point for each non-default switch
// case (ignoring those that just fall through to the next case).
private predicate branchingSwitchCase(ConstCase c) {
  // in C# the successor of a case is the expression for the case's value
  not c = precedingSharedCase(_) and
  not c = precedingSharedCase(_) and
  not defaultFallThrough(c)
}

private Stmt precedingSharedCase(Case case) {
  exists(Stmt parent, int n | case = parent.getChild(n) and result = parent.getChild(n - 1))
}

private predicate defaultFallThrough(Case c) {
  precedingSharedCase(c) instanceof DefaultCase or
  defaultFallThrough(precedingSharedCase(c))
}

/** A branching statement used for the computation of cyclomatic complexity */
private predicate branchingStmt(Stmt stmt) {
  stmt instanceof IfStmt or
  stmt instanceof LoopStmt or
  branchingSwitchCase(stmt) or
  stmt instanceof CatchClause
}

/** A branching expression used for the computation of cyclomatic complexity */
private predicate branchingExpr(Expr expr) {
  expr instanceof ConditionalExpr or
  expr instanceof LogicalAndExpr or
  expr instanceof LogicalOrExpr or
  expr instanceof NullCoalescingExpr
}

/**
 * the number of branching statements (if, while, do, for, foreach
 *    switch, case, catch) plus the number of branching
 *    expressions (?, &amp;&amp;, ||, ??) plus one.
 *    Callables with a high cyclomatic complexity (> 10) are
 *    hard to test and maintain, given their large number of
 *    possible execution paths. They should be refactored.
 */
predicate cyclomaticComplexity(/* this */ Callable c, int n) {
  n =
    count(Stmt stmt | branchingStmt(stmt) and stmt.getEnclosingCallable() = c) +
      count(Expr expr | branchingExpr(expr) and expr.getEnclosingCallable() = c) + 1
}
