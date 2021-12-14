/**
 * INTERNAL: Do not use.
 *
 * Provides logic for calculating the child relation on expressions and statements.
 */

import csharp

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
    expr_parent_adjusted(result, i, this) or
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

private predicate hasNoSourceLocation(Element e) { not e.getALocation() instanceof SourceLocation }

cached
private module Cached {
  cached
  Location bestLocation(Element e) {
    result = e.getALocation().(SourceLocation) and
    not exists(e.getALocation().(SourceLocation).getMappedLocation())
    or
    result = e.getALocation().(SourceLocation).getMappedLocation()
    or
    hasNoSourceLocation(e) and
    result = min(Location l | l = e.getALocation() | l order by l.getFile().toString())
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

  /**
   * The `expr_parent()` relation adjusted for expandable assignments. For example,
   * the assignment `x += y` is extracted as
   *
   * ```
   *          +=
   *           |
   *           2
   *           |
   *           =
   *          / \
   *         1   0
   *        /     \
   *       x       +
   *              / \
   *             1   0
   *            /     \
   *           x       y
   * ```
   *
   * in order to be able to retrieve the expanded assignment `x = x + y` as the 2nd
   * child. This predicate changes the diagram above into
   *
   * ```
   *          +=
   *         /  \
   *        1    0
   *       /      \
   *      x        y
   * ```
   */
  cached
  predicate expr_parent_adjusted(Expr child, int i, ControlFlowElement parent) {
    if parent instanceof AssignOperation
    then
      parent =
        any(AssignOperation ao |
          exists(AssignExpr ae | ae = ao.getExpandedAssignment() |
            i = 0 and
            exists(Expr right |
              // right = `x + y`
              expr_parent(right, 0, ae)
            |
              expr_parent(child, 1, right)
            )
            or
            i = 1 and
            expr_parent(child, 1, ae)
          )
          or
          not ao.hasExpandedAssignment() and
          expr_parent(child, i, parent)
        )
    else expr_parent(child, i, parent)
  }

  private Expr getAChildExpr(ExprOrStmtParent parent) {
    result = parent.getAChildExpr() and
    not result = parent.(DeclarationWithGetSetAccessors).getExpressionBody()
    or
    result = parent.(AssignOperation).getExpandedAssignment()
  }

  private ControlFlowElement getAChild(ExprOrStmtParent parent) {
    result = getAChildExpr(parent)
    or
    result = parent.getAChildStmt()
  }

  pragma[inline]
  private ControlFlowElement enclosingStart(ControlFlowElement cfe) {
    result = cfe
    or
    getAChild(result).(AnonymousFunctionExpr) = cfe
  }

  private predicate parent(ControlFlowElement child, ExprOrStmtParent parent) {
    child = getAChild(parent) and
    not child = any(Callable c).getBody()
  }

  /** Holds if the enclosing body of `cfe` is `body`. */
  cached
  predicate enclosingBody(ControlFlowElement cfe, ControlFlowElement body) {
    body = any(Callable c).getBody() and
    parent*(enclosingStart(cfe), body)
  }

  /** Holds if the enclosing callable of `cfe` is `c`. */
  cached
  predicate enclosingCallable(ControlFlowElement cfe, Callable c) {
    enclosingBody(cfe, c.getBody())
    or
    parent*(enclosingStart(cfe), c.(Constructor).getInitializer())
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
