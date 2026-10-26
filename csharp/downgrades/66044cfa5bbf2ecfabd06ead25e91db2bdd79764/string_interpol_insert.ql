class Expr extends @expr {
  string toString() { none() }
}

class TypeOrRef extends @type_or_ref {
  string toString() { none() }
}

class InterpolatedStringInsertExpr extends Expr, @interpolated_string_insert_expr { }

private predicate remove_expr(Expr e) {
  exists(InterpolatedStringInsertExpr ie |
    e = ie
    or
    // Alignment
    expr_parent(e, 1, ie)
    or
    // Format
    expr_parent(e, 2, ie)
  )
}

query predicate new_expressions(Expr e, int kind, TypeOrRef t) {
  expressions(e, kind, t) and
  // Remove the syntheetic intert expression and previously un-extracted children
  not remove_expr(e)
}

query predicate new_expr_parent(Expr e, int child, Expr parent) {
  expr_parent(e, child, parent) and
  not remove_expr(e) and
  not remove_expr(parent)
  or
  // Use the string interpolation as parent instead of the synthetic insert expression
  exists(InterpolatedStringInsertExpr ie |
    expr_parent(e, 0, ie) and
    expr_parent(ie, child, parent)
  )
}
