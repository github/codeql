class ExprParent extends @exprparent {
  string toString() { result = "exprparent" }
}

class Expr extends ExprParent, @expr {
  override string toString() { result = "expr" }
}

class ParExpr extends Expr, @parexpr {
  override string toString() { result = "(...)" }
}

class Type extends @type {
  string toString() { result = "type" }
}

predicate astlink(ExprParent parent, Expr e, int idx, int parens) {
  exprs(e, _, _, parent, idx) and
  parens = 0 and
  not parent instanceof ParExpr and
  e instanceof ParExpr
  or
  exists(ParExpr pe |
    exprs(e, _, _, pe, _) and
    astlink(parent, pe, idx, parens - 1)
  )
}

from Expr id, int kind, Type typeid, ExprParent oldparent, ExprParent parent, int oldidx, int idx
where
  exprs(id, kind, typeid, oldparent, oldidx) and
  not id instanceof ParExpr and
  if oldparent instanceof ParExpr
  then astlink(parent, id, idx, _)
  else (
    parent = oldparent and idx = oldidx
  )
select id, kind, typeid, parent, idx
