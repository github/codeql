class Element extends @element {
  string toString() { none() }
}

class Expr extends @expr {
  string toString() { none() }
}

class Stmt extends @stmt {
  string toString() { none() }
}

predicate isStmtWithInitializer(Stmt stmt) { exists(int kind | stmts(stmt, kind, _) | kind = 29) }

from Expr child, int index, int index_new, Element parent
where
  exprparents(child, index, parent) and
  if isStmtWithInitializer(parent) then index_new = index - 1 else index_new = index
select child, index_new, parent
