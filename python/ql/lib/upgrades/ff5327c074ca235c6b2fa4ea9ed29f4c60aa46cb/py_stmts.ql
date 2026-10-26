// First we need to wrap some database types
class Location extends @location {
  /** Gets the start line of this location */
  int getStartLine() {
    locations_default(this, _, result, _, _, _) or
    locations_ast(this, _, result, _, _, _)
  }

  string toString() { result = "<some file>" + ":" + this.getStartLine().toString() }
}

class Stmt_ extends @py_stmt {
  string toString() { result = "Stmt" }

  Location getLocation() { py_locations(result, this) }
}

class StmtList_ extends @py_stmt_list {
  string toString() { result = "StmtList" }
}

/**
 * New kinds have been inserted such that
 * `@py_Nonlocal` which used to have index 14 now has index 16.
 * Entries with lower indices are unchanged.
 */
bindingset[old_index]
int new_index(int old_index) {
  if old_index < 14 then result = old_index else result = (16 - 14) + old_index
}

// The schema for py_stmts is:
//
// py_stmts(unique int id : @py_stmt,
//   int kind: int ref,
//   int parent : @py_stmt_list ref,
//   int idx : int ref);
from Stmt_ expr, int old_kind, StmtList_ parent, int idx, int new_kind
where
  py_stmts(expr, old_kind, parent, idx) and
  new_kind = new_index(old_kind)
select expr, new_kind, parent, idx
