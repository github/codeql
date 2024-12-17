/**
 * Provides modeling for the `SQLx` library.
 */

private import rust
private import codeql.rust.Concepts
private import codeql.rust.dataflow.DataFlow

/**
 * A call to `sqlx::query` and variations.
 */
private class SqlxQuery extends SqlConstruction::Range {
  CallExpr call;

  SqlxQuery() {
    this.asExpr().getExpr() = call and
    exists(PathExpr path, string name |
      call.getFunction() = path and
      name =
        [
          "query", "query_as", "query_with", "query_as_with", "query_scalar", "query_scalar_with",
          "raw_sql"
        ] and
      path.resolvesToStandardPath("sqlx::" + name, name)
    )
  }

  override DataFlow::Node getSql() { result.asExpr().getExpr() = call.getArgList().getArg(0) }
}

/**
 * A call to `sqlx::Executor::execute`.
 */
private class SqlxExecute extends SqlExecution::Range {
  MethodCallExpr call;

  SqlxExecute() {
    this.asExpr().getExpr() = call and
    call.(Resolvable).resolvesToStandardPath("sqlx::executor", "Executor", "execute")
  }

  override DataFlow::Node getSql() { result.asExpr().getExpr() = call.getArgList().getArg(0) }
}
