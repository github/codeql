/**
 * INTERNAL: Do not use.
 *
 * Provides logic for calculating the child relation on expressions and statements.
 */

import csharp
private import internal.Location

/**
 * INTERNAL: Do not use.
 *
 * An element that can have a child statement or expression.
 */
class ExprOrStmtParent extends Element, @exprorstmt_parent {
  final override ControlFlowElement getChild(int i) {
    result = this.getChildExpr(i) or
    result = this.getChildStmt(i)
  }

  /** Gets the `i`th child expression of this element (zero-based). */
  final Expr getChildExpr(int i) {
    expr_parent(result, i, this) or
    expr_parent_top_level_adjusted(result, i, this)
  }

  /** Gets a child expression of this element, if any. */
  final Expr getAChildExpr() { result = this.getChildExpr(_) }

  /** Gets the `i`th child statement of this element (zero-based). */
  final Stmt getChildStmt(int i) {
    stmt_parent(result, i, this) or
    stmt_parent_top_level(result, i, this)
  }

  /** Gets a child statement of this element, if any. */
  final Stmt getAChildStmt() { result = this.getChildStmt(_) }
}

/**
 * INTERNAL: Do not use.
 *
 * An element that can have a child top-level expression.
 */
class TopLevelExprParent extends Element, @top_level_expr_parent {
  final override Expr getChild(int i) { result = this.getChildExpr(i) }

  /** Gets the `i`th child expression of this element (zero-based). */
  final Expr getChildExpr(int i) { expr_parent_top_level_adjusted(result, i, this) }

  /** Gets a child expression of this element, if any. */
  final Expr getAChildExpr() { result = this.getChildExpr(_) }
}

/** INTERNAL: Do not use. */
Expr getExpressionBody(Callable c) {
  result = c.getAChildExpr() and
  not result = c.(Constructor).getInitializer() and
  not result = c.(Constructor).getObjectInitializerCall()
}

/** INTERNAL: Do not use. */
BlockStmt getStatementBody(Callable c) { result = c.getAChildStmt() }

private ControlFlowElement getBody(Callable c) {
  result = getExpressionBody(c) or
  result = getStatementBody(c)
}

pragma[nomagic]
private predicate hasNoSourceLocation(Element e) { not exists(getASourceLocation(e)) }

pragma[nomagic]
private Location getFirstSourceLocation(Element e) {
  result =
    min(Location l, string filepath, int startline, int startcolumn, int endline, int endcolumn |
      l = getASourceLocation(e) and
      l.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    |
      l order by filepath, startline, startcolumn, endline, endcolumn
    )
}

cached
private module Cached {
  cached
  Location bestLocation(Element e) {
    (
      if e.(Modifiable).isPartial() or e instanceof Namespace
      then result = getASourceLocation(e)
      else result = getFirstSourceLocation(e)
    )
    or
    hasNoSourceLocation(e) and
    result =
      min(Location l, string filepath |
        l = e.getALocation() and
        l.hasLocationInfo(filepath, _, _, _, _)
      |
        l order by filepath
      )
    or
    not exists(e.getALocation()) and
    result instanceof EmptyLocation
  }

  /**
   * INTERNAL: Do not use.
   *
   * The `expr_parent_top_level()` relation extended to include a relation
   * between getters and expression bodies in properties such as `int P => 0`.
   */
  cached
  predicate expr_parent_top_level_adjusted(Expr child, int i, @top_level_exprorstmt_parent parent) {
    expr_parent_top_level(child, i, parent)
    or
    parent = any(Getter g | expr_parent_top_level(child, i, g.getDeclaration())) and
    i = 0
  }

  private Expr getAChildExpr(ExprOrStmtParent parent) {
    result = parent.getAChildExpr() and
    not result = parent.(DeclarationWithGetSetAccessors).getExpressionBody()
  }

  private ControlFlowElement getAChild(ExprOrStmtParent parent) {
    result = getAChildExpr(parent)
    or
    result = parent.getAChildStmt()
  }

  private predicate parent(ControlFlowElement child, ExprOrStmtParent parent) {
    child = getAChild(parent) and
    not child = getBody(_)
  }

  /** Holds if the enclosing body of `cfe` is `body`. */
  cached
  predicate enclosingBody(ControlFlowElement cfe, ControlFlowElement body) {
    body = getBody(_) and
    parent*(cfe, body)
  }

  /** Holds if the enclosing callable of `cfe` is `c`. */
  cached
  predicate enclosingCallable(ControlFlowElement cfe, Callable c) {
    enclosingBody(cfe, getBody(c))
    or
    parent*(cfe, c.(Constructor).getInitializer())
    or
    parent*(cfe, c.(Constructor).getObjectInitializerCall())
    or
    parent*(cfe, any(AssignExpr init | c.(ObjectInitMethod).initializes(init)))
  }

  /** Holds if the enclosing statement of expression `e` is `s`. */
  cached
  predicate enclosingStmt(Expr e, Stmt s) {
    // Compute the enclosing statement for an expression. Note that this need
    // not exist, since expressions can occur in contexts where they have no
    // enclosing statement (examples include field initialisers, both inline
    // and explicit on constructor definitions, and annotation arguments).
    getAChildExpr+(s) = e
  }
}

import Cached
