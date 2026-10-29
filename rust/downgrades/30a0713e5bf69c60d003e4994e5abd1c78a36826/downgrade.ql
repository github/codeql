class Element extends @element {
  string toString() { none() }
}

class Expr extends Element, @expr { }

class ClosureExpr extends Expr, @closure_expr { }

class Function extends Element, @function { }

query predicate new_closure_expr_bodies(ClosureExpr ce, Expr e) {
  closure_expr_closure_bodies(ce, e)
}

query predicate new_function_bodies(Function f, Expr e) { function_function_bodies(f, e) }
