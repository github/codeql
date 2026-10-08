class Expr extends @expr {
  string toString() { none() }
}

class ExprParent extends @exprparent {
  string toString() { none() }
}

class RangeStmt extends @rangestmt {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

newtype TAddedExpr = TRangeElement(RangeStmt stmt)

module Fresh = QlBuiltins::NewEntity<TAddedExpr>;

class TNewExpr = @expr or Fresh::EntityId;

class NewExpr extends TNewExpr {
  string toString() { none() }
}

class TNewExprParent = @exprparent or Fresh::EntityId;

class NewExprParent extends TNewExprParent {
  string toString() { none() }
}

class TNewLocatable = @locatable or Fresh::EntityId;

class NewLocatable extends TNewLocatable {
  string toString() { none() }
}

predicate isRangeElementChild(ExprParent parent, int idx, RangeStmt range) {
  parent = range and
  idx in [0 .. 1]
}

query predicate new_exprs(NewExpr id, int kind, NewExprParent parent, int idx) {
  exists(RangeStmt range |
    id = Fresh::map(TRangeElement(range)) and
    kind = 55 and
    parent = range and
    idx = 0
  )
  or
  exists(Expr oldId, int oldKind, ExprParent oldParent, int oldIdx |
    exprs(oldId, oldKind, oldParent, oldIdx) and
    id = oldId and
    kind = oldKind and
    idx = oldIdx
  |
    exists(RangeStmt range | isRangeElementChild(oldParent, oldIdx, range) |
      parent = Fresh::map(TRangeElement(range))
    )
    or
    not isRangeElementChild(oldParent, oldIdx, _) and
    parent = oldParent
  )
}

query predicate new_has_location(NewLocatable locatable, Location location) {
  has_location(locatable, location)
  or
  exists(RangeStmt range |
    locatable = Fresh::map(TRangeElement(range)) and
    has_location(range, location)
  )
}
