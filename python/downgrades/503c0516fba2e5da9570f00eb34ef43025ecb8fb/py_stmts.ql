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
bindingset[new_index]
int old_index(int new_index) {
  if new_index < 14 then result = new_index else result + (16 - 14) = new_index
}

// The schema for py_stmts is:
//
// py_stmts(unique int id : @py_stmt,
//   int kind: int ref,
//   int parent : @py_stmt_list ref,
//   int idx : int ref);
from Stmt_ expr, int new_kind, StmtList_ parent, int idx, int old_kind
where
  py_stmts(expr, new_kind, parent, idx) and
  old_kind = old_index(new_kind)
select expr, old_kind, parent, idx
