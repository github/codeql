class Sourceline extends @sourceline {
  string toString() { result = "sourceline" }
}

class ParExpr extends Sourceline, @parexpr {
  override string toString() { result = "(...)" }
}

from Sourceline id, int l, int code, int comm
where
  numlines(id, l, code, comm) and
  not id instanceof ParExpr
select id, l, code, comm
