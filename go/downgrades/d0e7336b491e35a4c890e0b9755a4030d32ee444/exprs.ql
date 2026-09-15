class Expr_ extends @expr {
  string toString() { result = "Expr" }
}

class ExprParent_ extends @exprparent {
  string toString() { result = "ExprParent" }
}

// The schema for exprs is:
//
// exprs(unique int id: @expr,
//     int kind: int ref,
//     int parent: @exprparent ref,
//     int idx: int ref);
//
// `@rangeelementexpr` (kind 55) is a synthesized node that groups the loop
// variables (the key and value) of a `range` statement. To downgrade we remove
// those nodes and reparent their children (the key and value expressions)
// directly onto the `range` statement, at the same indices.
from Expr_ id, int kind, ExprParent_ newparent, int idx
where
  exists(ExprParent_ parent | exprs(id, kind, parent, idx) and kind != 55 |
    // A key or value grouped by a range element node: reparent it onto the
    // range statement (the range element node's own parent).
    exists(Expr_ pe | pe = parent and exprs(pe, 55, newparent, _))
    or
    // Any other expression keeps its parent unchanged.
    not exists(Expr_ pe | pe = parent and exprs(pe, 55, _, _)) and
    newparent = parent
  )
select id, kind, newparent, idx
