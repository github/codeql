/**
 * Provides modeling for the `SQLx` library.
 */

private import rust
private import codeql.rust.Concepts
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.internal.TypeInference
private import codeql.rust.internal.Type

/**
 * A call to `sqlx::query` and variations.
 */
private class SqlxQuery extends SqlConstruction::Range {
  CallExpr call;

  SqlxQuery() {
    this.asExpr().getExpr() = call and
    call.getStaticTarget().(Addressable).getCanonicalPath() =
      [
        "sqlx_core::query::query", "sqlx_core::query_as::query_as",
        "sqlx_core::query_with::query_with", "sqlx_core::query_as_with::query_as_with",
        "sqlx_core::query_scalar::query_scalar", "sqlx_core::query_scalar_with::query_scalar_with",
        "sqlx_core::raw_sql::raw_sql"
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
    call.getStaticTarget().(Addressable).getCanonicalPath() =
      "sqlx_core::executor::Executor::execute"
  }

  override DataFlow::Node getSql() { result.asExpr().getExpr() = call.getArgList().getArg(0) }
}
