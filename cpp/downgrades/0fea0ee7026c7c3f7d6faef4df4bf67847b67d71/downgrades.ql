/*
 * Approach: replace conversion expressions of kind 389 (= @c11_generic) by
 * conversion expressions of kind 12 (= @parexpr), i.e., a `ParenthesisExpr`,
 * and drop the relation which its child expressions, which are just syntactic
 * sugar. Parenthesis expressions are equally benign as C11 _Generic expressions,
 * and behave similarly in the context of the IR.
 */

class Expr extends @expr {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

class ExprParent extends @exprparent {
  string toString() { none() }
}

query predicate new_exprs(Expr expr, int new_kind, Location loc) {
  exists(int kind | exprs(expr, kind, loc) | if kind = 389 then new_kind = 12 else new_kind = kind)
}

query predicate new_exprparents(Expr expr, int index, ExprParent expr_parent) {
  exprparents(expr, index, expr_parent) and
  (
    not expr_parent instanceof @expr
    or
    exists(int kind | exprs(expr_parent.(Expr), kind, _) | kind != 389)
  )
}
