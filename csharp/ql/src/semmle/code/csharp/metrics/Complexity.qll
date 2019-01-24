import csharp

// Branching points in the sense of cyclomatic complexity are binary,
// so there should be a branching point for each non-default switch
// case (ignoring those that just fall through to the next case).
private predicate branchingSwitchCase(ConstCase sc) {
  // in C# the successor of a case is the expression for the case's value
  not sc = precedingSharedCase(_) and
  not sc = precedingSharedCase(_) and
  not defaultFallThrough(sc)
}

private Stmt precedingSharedCase(@case case) {
  exists(Stmt parent, int n | case = parent.getChild(n) and result = parent.getChild(n - 1))
}

private predicate defaultFallThrough(ConstCase sc) {
  precedingSharedCase(sc) instanceof DefaultCase or
  defaultFallThrough(precedingSharedCase(sc))
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
  n = count(Stmt stmt | branchingStmt(stmt) and stmt.getEnclosingCallable() = c) +
      count(Expr expr | branchingExpr(expr) and expr.getEnclosingCallable() = c) + 1
}
