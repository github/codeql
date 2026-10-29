// We must wrap the DB types, as these cannot appear in argument lists
class Stmt_ extends @py_stmt {
  string toString() { result = "Stmt" }
}

class StmtList_ extends @py_stmt_list {
  string toString() { result = "StmtList" }
}

query predicate py_stmts_without_typealias(Stmt_ id, int kind, StmtList_ parent, int idx) {
  py_stmts(id, kind, parent, idx) and
  // From the dbscheme:
  //
  // case @py_stmt.kind of
  // ...
  // |   27 = @py_TypeAlias;
  kind != 27
}
