class Expr extends @expr {
  string toString() { result = "expr" }
}

class ParExpr extends Expr, @parexpr {
  override string toString() { result = "(...)" }
}

class Callable extends @callable {
  string toString() { result = "callable" }
}

from Expr id, Callable c
where
  callableEnclosingExpr(id, c) and
  not id instanceof ParExpr
select id, c
