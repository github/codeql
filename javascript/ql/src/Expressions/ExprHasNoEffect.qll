/**
 * Provides classes and predicates for the 'js/useless-expression' query.
 */

import javascript

/**
 * Holds if `e` appears in a syntactic context where its value is discarded.
 */
predicate inVoidContext(Expr e) {
  exists(ExprStmt parent |
    // e is a toplevel expression in an expression statement
    parent = e.getParent() and
    // but it isn't an HTML attribute or a configuration object
    not exists(TopLevel tl | tl = parent.getParent() |
      tl instanceof CodeInAttribute
      or
      // if the toplevel in its entirety is of the form `({ ... })`,
      // it is probably a configuration object (e.g., a require.js build configuration)
      tl.getNumChildStmt() = 1 and e.stripParens() instanceof ObjectExpr
    )
  )
  or
  exists(SeqExpr seq, int i, int n |
    e = seq.getOperand(i) and
    n = seq.getNumOperands()
  |
    i < n - 1 or inVoidContext(seq)
  )
  or
  exists(ForStmt stmt | e = stmt.getUpdate())
  or
  exists(ForStmt stmt | e = stmt.getInit() |
    // Allow the pattern `for(i; i < 10; i++)`
    not e instanceof VarAccess
  )
  or
  exists(LogicalBinaryExpr logical | e = logical.getRightOperand() and inVoidContext(logical))
}
