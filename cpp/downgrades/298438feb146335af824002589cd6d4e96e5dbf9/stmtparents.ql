class Element extends @element {
  string toString() { none() }
}

class Stmt extends @stmt {
  string toString() { none() }
}

predicate isStmtWithInitializer(Stmt stmt) { exists(int kind | stmts(stmt, kind, _) | kind = 29) }

from Stmt child, int index, int index_new, Element parent
where
  stmtparents(child, index, parent) and
  (
    not isStmtWithInitializer(parent)
    or
    index > 0
  ) and
  if isStmtWithInitializer(parent) then index_new = index - 1 else index_new = index
select child, index_new, parent
