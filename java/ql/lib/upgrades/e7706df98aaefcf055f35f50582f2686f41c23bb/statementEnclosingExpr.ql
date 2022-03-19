class Expr extends @expr {
  string toString() { result = "expr" }
}

class ParExpr extends Expr, @parexpr {
  override string toString() { result = "(...)" }
}

class Statement extends @stmt {
  string toString() { result = "stmt" }
}

from Expr id, Statement s
where
  statementEnclosingExpr(id, s) and
  not id instanceof ParExpr
select id, s
