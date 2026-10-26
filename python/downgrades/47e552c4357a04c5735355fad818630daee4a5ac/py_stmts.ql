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
bindingset[new_index]
int old_index(int new_index) {
  not new_index = 7 and
  if new_index < 7 then result = new_index else result + (8 - 7) = new_index
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
