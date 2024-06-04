class Expr extends @expr {
  string toString() { none() }
}

class Type extends @type {
  string toString() { none() }
}

predicate existingType(Expr expr, Type type, int value_category) {
  expr_types(expr, type, value_category)
}

predicate reuseType(Expr reuse, Type type, int value_category) {
  exists(Expr original |
    expr_reuse(reuse, original, value_category) and
    expr_types(original, type, _)
  )
}

from Expr expr, Type type, int value_category
where existingType(expr, type, value_category) or reuseType(expr, type, value_category)
select expr, type, value_category
