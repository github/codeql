class Annotation extends @annotation {
  string toString() { result = "annotation" }
}

class Method extends @method {
  string toString() { result = "method" }
}

class Expr extends @expr {
  string toString() { result = "expr" }
}

class ParExpr extends Expr, @parexpr {
  override string toString() { result = "(...)" }
}

predicate parExprGetExpr(ParExpr pe, Expr e) { exprs(e, _, _, pe, _) }

from Annotation parentid, Method id2, Expr oldvalue, Expr value
where
  annotValue(parentid, id2, oldvalue) and
  if oldvalue instanceof ParExpr
  then
    parExprGetExpr+(oldvalue, value) and
    not value instanceof ParExpr
  else value = oldvalue
select parentid, id2, value
