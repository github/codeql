/**
 * Provides classes modeling security-relevant aspects of the `asyncpg` PyPI package.
 * See https://magicstack.github.io/asyncpg/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/** Provides models for the `asyncpg` PyPI package. */
private module Asyncpg {
  API::Node connectionPool() {
    result = API::moduleImport("asyncpg").getMember("create_pool").getReturn().getAwaited()
  }

  API::Node connection() {
    result = API::moduleImport("asyncpg").getMember("connect").getReturn().getAwaited()
    or
    result = connectionPool().getMember("acquire").getReturn().getAwaited()
  }

  private string queryMethodName(string queryArg) {
    result in ["copy_from_query", "execute", "fetch", "fetchrow", "fetchval"] and
    queryArg = "query"
    or
    result = "executemany" and
    queryArg = "command"
  }

  class SqlExecutionOnConnection extends SqlExecution::Range, DataFlow::MethodCallNode {
    string queryArg;

    SqlExecutionOnConnection() {
      this.calls([connectionPool().getAUse(), connection().getAUse()], queryMethodName(queryArg))
    }

    override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName(queryArg)] }
  }

  /**
   * Holds if `result` is the result of awaiting `n`.
   */
  pragma[inline]
  DataFlow::Node awaited(DataFlow::Node awaitedValue) {
    // `await` x
    // - `awaitedValue` is `x`
    // - `result` is `await x`
    exists(Await await |
      result.asExpr() = await and
      await.getValue() = awaitedValue.asExpr()
    )
    or
    // `async for x in l`
    // - `awaitedValue` is local source of `l`
    // - `result` is `l`
    exists(AsyncFor asyncFor, DataFlow::Node awaited |
      result.asExpr() = asyncFor.getTarget() and
      asyncFor.getIter() = awaited.asExpr() and
      awaited.getALocalSource() = awaitedValue
    )
    or
    // `async with x as y`
    // - `awaitedValue` is local source of `x`
    // - `result` is `x`
    exists(AsyncWith asyncWith, DataFlow::Node awaited |
      result.asExpr() = asyncWith.getContextExpr() and
      asyncWith.getOptionalVars() = awaited.asExpr() and
      awaited.getALocalSource() = awaitedValue
    )
  }

  module PreparedStatement {
    private DataFlow::TypeTrackingNode preparedStatementFactory(
      DataFlow::TypeTracker t, DataFlow::Node sql
    ) {
      t.start() and
      result = connection().getMember("prepare").getACall() and
      sql in [
          result.(DataFlow::CallCfgNode).getArg(0),
          result.(DataFlow::CallCfgNode).getArgByName("query")
        ]
      or
      exists(DataFlow::TypeTracker t2 | result = preparedStatementFactory(t2, sql).track(t2, t))
    }

    DataFlow::Node preparedStatementFactory(DataFlow::Node sql) {
      preparedStatementFactory(DataFlow::TypeTracker::end(), sql).flowsTo(result)
    }

    private DataFlow::TypeTrackingNode preparedStatement(DataFlow::TypeTracker t, DataFlow::Node sql) {
      t.start() and
      result = awaited(preparedStatementFactory(sql))
      or
      exists(DataFlow::TypeTracker t2 | result = preparedStatement(t2, sql).track(t2, t))
    }

    DataFlow::Node preparedStatement(DataFlow::Node sql) {
      preparedStatement(DataFlow::TypeTracker::end(), sql).flowsTo(result)
    }

    class PreparedStatementExecution extends SqlExecution::Range, DataFlow::MethodCallNode {
      DataFlow::Node sql;

      PreparedStatementExecution() {
        this.calls(preparedStatement(sql), ["executemany", "fetch", "fetchrow", "fetchval"])
      }

      override DataFlow::Node getSql() { result = sql }
    }
  }

  module Cursor {
    private DataFlow::TypeTrackingNode cursorFactory(DataFlow::TypeTracker t, DataFlow::Node sql) {
      // cursor created from connection
      t.start() and
      result = connection().getMember("cursor").getACall() and
      sql in [
          result.(DataFlow::CallCfgNode).getArg(0),
          result.(DataFlow::CallCfgNode).getArgByName("query")
        ]
      or
      // cursor created from prepared statement
      t.start() and
      result.(DataFlow::MethodCallNode).calls(PreparedStatement::preparedStatement(sql), "cursor")
      or
      exists(DataFlow::TypeTracker t2 | result = cursorFactory(t2, sql).track(t2, t))
    }

    DataFlow::Node cursorFactory(DataFlow::Node sql) {
      cursorFactory(DataFlow::TypeTracker::end(), sql).flowsTo(result)
    }

    class CursorCreation extends SqlExecution::Range {
      DataFlow::Node sql;

      CursorCreation() { this = awaited(cursorFactory(sql)) }

      override DataFlow::Node getSql() { result = sql }
    }
  }
}
