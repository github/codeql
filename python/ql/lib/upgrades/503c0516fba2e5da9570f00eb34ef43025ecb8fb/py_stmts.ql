// First we need to wrap some database types
class Stmt_ extends @py_stmt {
  string toString() { result = "Stmt" }
}

class StmtList_ extends @py_stmt_list {
  string toString() { result = "StmtList" }
}

/**
 * New kinds have been inserted such that
 * `@py_Exec` which used to have index 7 now has index 8.
 * Entries with lower indices are unchanged.
 */
bindingset[old_index]
int new_index(int old_index) {
  if old_index < 7 then result = old_index else result = (8 - 7) + old_index
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
