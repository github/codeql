class ExprParent extends @exprparent {
  string toString() { result = "exprparent" }
}

class Expr extends ExprParent, @expr {
  override string toString() { result = "expr" }
}

class ParExpr extends Expr, @parexpr {
  override string toString() { result = "(...)" }
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

from Expr e, int parentheses
where
  astlink(_, e, _, parentheses) and
  not e instanceof ParExpr
select e, parentheses
