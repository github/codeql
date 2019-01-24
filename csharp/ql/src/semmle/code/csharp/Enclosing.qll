/**
 * INTERNAL: Do not use.
 *
 * Provides efficient cached predicates for finding enclosing statements and callables.
 *
 * There are a number of difficulties. There can be expressions without
 * enclosing statements (for example initialisers for fields and constructors)
 * or enclosing callables (even if we consider constructor initialisers
 * to be enclosed by constructors, field initialisers don't have callables).
 *
 * The only cases where a `Stmt` has an `Expr` parent are delegate and lambda
 * expressions, which are both callable.
 */

import Stmt
private import semmle.code.csharp.ExprOrStmtParent

/**
 * INTERNAL: Do not use.
 */
cached
module Internal {
  /**
   * INTERNAL: Do not use.
   *
   * Holds if `c` is the enclosing callable of statement `s`.
   */
  cached
  predicate enclosingCallable(Stmt s, Callable c) {
    // Compute the enclosing callable for a statement. This walks up through
    // enclosing statements until it hits a callable. It's unambiguous, since
    // if a statement has no parent statement, it's either the method body
    // or the body of an anonymous function declaration, in each of which cases the
    // non-statement parent is in fact the enclosing callable.
    c.getAChildStmt+() = s
  }

  private Expr getAChildExpr(ExprOrStmtParent p) {
    result = p.getAChildExpr() or
    result = p.(AssignOperation).getExpandedAssignment()
  }

  /**
   * INTERNAL: Do not use.
   *
   * Holds if `s` is the enclosing statement of expression `e`.
   */
  cached
  predicate enclosingStmt(Expr e, Stmt s) {
    // Compute the enclosing statement for an expression. Note that this need
    // not exist, since expressions can occur in contexts where they have no
    // enclosing statement (examples include field initialisers, both inline
    // and explicit on constructor definitions, and annotation arguments).
    getAChildExpr+(s) = e
  }

  private predicate childExprOfCallable(Callable parent, Expr child) {
    child = getAChildExpr(parent)
    or
    exists(Expr mid | childExprOfCallable(parent, mid) |
      not mid instanceof Callable and
      child = getAChildExpr(mid)
    )
  }

  /**
   * INTERNAL: Do not use.
   *
   * Holds if `c` is the enclosing callable of expression `e`.
   */
  cached
  predicate exprEnclosingCallable(Expr e, Callable c) {
    // Compute the enclosing callable of an expression. Note that expressions in
    // lambda functions should have the lambdas as enclosing callables, and their
    // enclosing statement may be the same as the enclosing statement of the
    // lambda; thus, it is *not* safe to go up to the enclosing statement and
    // take its own enclosing callable.
    childExprOfCallable(c, e)
    or
    not childExprOfCallable(_, e) and
    exists(Stmt s | enclosingStmt(e, s) | enclosingCallable(s, c))
  }
}
