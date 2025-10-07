class Stmt extends @stmt {
  string toString() { none() }
}

class Location extends @location_stmt {
  string toString() { none() }
}

from Stmt id, int kind, Location loc, int new_kind
where
  stmts(id, kind, loc) and
  if kind = 40 then new_kind = 4 else new_kind = kind
select id, new_kind, loc
