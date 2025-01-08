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
    call.getFunction().(PathExpr).getResolvedPath() =
      [
        "crate::query::query", "crate::query_as::query_as", "crate::query_with::query_with",
        "crate::query_as_with::query_as_with", "crate::query_scalar::query_scalar",
        "crate::query_scalar_with::query_scalar_with", "crate::raw_sql::raw_sql"
      ]
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
    call.(Resolvable).getResolvedPath() = "crate::executor::Executor::execute"
  }

  override DataFlow::Node getSql() { result.asExpr().getExpr() = call.getArgList().getArg(0) }
}
