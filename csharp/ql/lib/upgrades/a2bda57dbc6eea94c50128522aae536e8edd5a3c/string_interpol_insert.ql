class Expr extends @expr {
  string toString() { none() }
}

class TypeOrRef extends @type_or_ref {
  string toString() { none() }
}

class StringLiteral extends Expr, @string_literal_expr { }

class InterpolatedStringExpr extends Expr, @interpolated_string_expr { }

class StringInterpolationInsert extends Expr, @element {
  StringInterpolationInsert() {
    expressions(this, _, _) and
    expr_parent(this, _, any(InterpolatedStringExpr x)) and
    not this instanceof StringLiteral
  }
}

newtype TAddedElement = TInsert(StringInterpolationInsert e)

module Fresh = QlBuiltins::NewEntity<TAddedElement>;

class TNewExpr = @expr or Fresh::EntityId;

class NewExpr extends TNewExpr {
  string toString() { none() }
}

query predicate new_expressions(NewExpr id, int kind, TypeOrRef t) {
  expressions(id, kind, t)
  or
  exists(StringInterpolationInsert e |
    // The type of `e` is just copied even though a null type would be preferred.
    expressions(e, _, t) and
    Fresh::map(TInsert(e)) = id and
    kind = 138
  )
}

query predicate new_expr_parent(NewExpr id, int child, NewExpr parent) {
  // Keep all parent child relationships except for string interpolation inserts
  expr_parent(id, child, parent) and not id instanceof StringInterpolationInsert
  or
  exists(StringInterpolationInsert e, int child0, NewExpr p0, NewExpr new_id |
    expr_parent(e, child0, p0) and new_id = Fresh::map(TInsert(e))
  |
    id = new_id and
    child = child0 and
    parent = p0
    or
    id = e and
    child = 0 and
    parent = new_id
  )
}
