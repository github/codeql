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
  private import semmle.python.internal.Awaited

  /** Gets a `ConnectionPool` that is created when the result of `asyncpg.create_pool()` is awaited. */
  API::Node connectionPool() {
    result = API::moduleImport("asyncpg").getMember("create_pool").getReturn().getAwaited()
  }

  /**
   * Gets a `Connection` that is created when
   * - the result of `asyncpg.connect()` is awaited.
   * - the result of calling `aquire` on a `ConnectionPool` is awaited.
   */
  API::Node connection() {
    result = API::moduleImport("asyncpg").getMember("connect").getReturn().getAwaited()
    or
    result = connectionPool().getMember("acquire").getReturn().getAwaited()
  }

  /** `Connection`s and `ConnectionPool`s provide some methods that execute SQL. */
  class SqlExecutionOnConnection extends SqlExecution::Range, DataFlow::MethodCallNode {
    string methodName;

    SqlExecutionOnConnection() {
      methodName in ["copy_from_query", "execute", "fetch", "fetchrow", "fetchval", "executemany"] and
      this.calls([connectionPool().getAUse(), connection().getAUse()], methodName)
    }

    override DataFlow::Node getSql() {
      methodName in ["copy_from_query", "execute", "fetch", "fetchrow", "fetchval"] and
      result in [this.getArg(0), this.getArgByName("query")]
      or
      methodName = "executemany" and
      result in [this.getArg(0), this.getArgByName("command")]
    }
  }

  /** A model of `Connection` and `ConnectionPool`, which provide some methods that access the file system. */
  class FileAccessOnConnection extends FileSystemAccess::Range, DataFlow::MethodCallNode {
    string methodName;

    FileAccessOnConnection() {
      methodName in ["copy_from_query", "copy_from_table", "copy_to_table"] and
      this.calls([connectionPool().getAUse(), connection().getAUse()], methodName)
    }

    // The path argument is keyword only.
    override DataFlow::Node getAPathArgument() {
      methodName in ["copy_from_query", "copy_from_table"] and
      result = this.getArgByName("output")
      or
      methodName = "copy_to_table" and
      result = this.getArgByName("source")
    }
  }

  /**
   * Provides models of the `PreparedStatement` class in `asyncpg`.
   * `PreparedStatement`s are created when the result of calling `prepare(query)` on a connection is awaited.
   * The result of calling `prepare(query)` is a `PreparedStatementFactory` and the argument, `query` needs to
   * be tracked to the place where a `PreparedStatement` is created and then futher to any executing methods.
   * Hence the two type trackers.
   *
   * TODO: Rewrite this, once we have `API::CallNode` available.
   */
  module PreparedStatement {
    class PreparedStatementConstruction extends SqlConstruction::Range, DataFlow::CallCfgNode {
      PreparedStatementConstruction() { this = connection().getMember("prepare").getACall() }

      override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName("query")] }
    }

    private DataFlow::TypeTrackingNode preparedStatementFactory(
      DataFlow::TypeTracker t, DataFlow::Node sql
    ) {
      t.start() and
      sql = result.(PreparedStatementConstruction).getSql()
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

  /**
   * Provides models of the `Cursor` class in `asyncpg`.
   * `Cursor`s are created
   * - when the result of calling `cursor(query)` on a connection is awaited.
   * - when the result of calling `cursor()` on a prepared statement is awaited.
   * The result of calling `cursor` in either case is a `CursorFactory` and the argument, `query` needs to
   * be tracked to the place where a `Cursor` is created, hence the type tracker.
   * The creation of the `Cursor` executes the query.
   *
   * TODO: Rewrite this, once we have `API::CallNode` available.
   */
  module Cursor {
    class CursorConstruction extends SqlConstruction::Range, DataFlow::CallCfgNode {
      CursorConstruction() { this = connection().getMember("cursor").getACall() }

      override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName("query")] }
    }

    private DataFlow::TypeTrackingNode cursorFactory(DataFlow::TypeTracker t, DataFlow::Node sql) {
      // cursor created from connection
      t.start() and
      sql = result.(CursorConstruction).getSql()
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

    /** The creation of a `Cursor` executes the associated query. */
    class CursorCreation extends SqlExecution::Range {
      DataFlow::Node sql;

      CursorCreation() { this = awaited(cursorFactory(sql)) }

      override DataFlow::Node getSql() { result = sql }
    }
  }
}
