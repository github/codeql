class Stmt extends @stmt {
  string toString() { none() }
}

class Location extends @location_stmt {
  string toString() { none() }
}

predicate isConstevalIf(Stmt stmt) {
  exists(int kind | stmts(stmt, kind, _) | kind = 38 or kind = 39)
}

from Stmt stmt, int kind, int kind_new, Location location
where
  stmts(stmt, kind, location) and
  if isConstevalIf(stmt) then kind_new = 7 else kind_new = kind // Turns consteval if into a block with two block statements in it
select stmt, kind_new, location
