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
   */
  module PreparedStatement {
    class PreparedStatementConstruction extends SqlConstruction::Range, API::CallNode {
      PreparedStatementConstruction() { this = connection().getMember("prepare").getACall() }

      override DataFlow::Node getSql() { result = this.getParameter(0, "query").getARhs() }
    }

    class PreparedStatementExecution extends SqlExecution::Range, API::CallNode {
      PreparedStatementConstruction prepareCall;

      PreparedStatementExecution() {
        this =
          prepareCall
              .getReturn()
              .getAwaited()
              .getMember(["executemany", "fetch", "fetchrow", "fetchval"])
              .getACall()
      }

      override DataFlow::Node getSql() { result = prepareCall.getSql() }
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
   */
  module Cursor {
    class CursorConstruction extends SqlConstruction::Range, API::CallNode {
      CursorConstruction() { this = connection().getMember("cursor").getACall() }

      override DataFlow::Node getSql() { result = this.getParameter(0, "query").getARhs() }
    }

    /** The creation of a `Cursor` executes the associated query. */
    class CursorCreation extends SqlExecution::Range {
      DataFlow::Node sql;

      CursorCreation() {
        exists(CursorConstruction c |
          sql = c.getSql() and
          this = c.getReturn().getAwaited().getAnImmediateUse()
        )
        or
        exists(PreparedStatement::PreparedStatementConstruction prepareCall |
          sql = prepareCall.getSql() and
          this =
            prepareCall
                .getReturn()
                .getAwaited()
                .getMember("cursor")
                .getReturn()
                .getAwaited()
                .getAnImmediateUse()
        )
      }

      override DataFlow::Node getSql() { result = sql }
    }
  }
}
