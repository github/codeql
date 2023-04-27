/**
 * Provides classes modeling security-relevant aspects of the `asyncpg` PyPI package.
 * See https://magicstack.github.io/asyncpg/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.data.ModelsAsData

/** Provides models for the `asyncpg` PyPI package. */
private module Asyncpg {
  class AsyncpgModel extends ModelInput::TypeModelCsv {
    override predicate row(string row) {
      // type1;type2;path
      row =
        [
          // a `ConnectionPool` that is created when the result of `asyncpg.create_pool()` is awaited.
          "asyncpg.ConnectionPool;asyncpg;Member[create_pool].ReturnValue.Awaited",
          // a `Connection` that is created when
          // * - the result of `asyncpg.connect()` is awaited.
          // * - the result of calling `acquire` on a `ConnectionPool` is awaited.
          "asyncpg.Connection;asyncpg;Member[connect].ReturnValue.Awaited",
          "asyncpg.Connection;asyncpg;Member[connection].Member[connect].ReturnValue.Awaited",
          "asyncpg.Connection;asyncpg.ConnectionPool;Member[acquire].ReturnValue.Awaited",
          // Creating an internal `~Connection` type that contains both `Connection` and `ConnectionPool`.
          "asyncpg.~Connection;asyncpg.Connection;", //
          "asyncpg.~Connection;asyncpg.ConnectionPool;"
        ]
    }
  }

  class AsyncpgSink extends ModelInput::SinkModelCsv {
    // type;path;kind
    override predicate row(string row) {
      row =
        [
          // `Connection`s and `ConnectionPool`s provide some methods that execute SQL.
          "asyncpg.~Connection;Member[copy_from_query,execute,fetch,fetchrow,fetchval].Argument[0,query:];sql-injection",
          "asyncpg.~Connection;Member[executemany].Argument[0,command:];sql-injection",
          // A model of `Connection` and `ConnectionPool`, which provide some methods that access the file system.
          "asyncpg.~Connection;Member[copy_from_query,copy_from_table].Argument[output:];path-injection",
          "asyncpg.~Connection;Member[copy_to_table].Argument[source:];path-injection",
          // the `PreparedStatement` class in `asyncpg`.
          "asyncpg.Connection;Member[prepare].Argument[0,query:];sql-injection",
        ]
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
      CursorConstruction() {
        this = ModelOutput::getATypeNode("asyncpg.Connection").getMember("cursor").getACall()
      }

      override DataFlow::Node getSql() { result = this.getParameter(0, "query").asSink() }
    }

    /** The creation of a `Cursor` executes the associated query. */
    class CursorCreation extends SqlExecution::Range {
      DataFlow::Node sql;

      CursorCreation() {
        exists(CursorConstruction c |
          sql = c.getSql() and
          this = c.getReturn().getAwaited().asSource()
        )
        or
        exists(API::CallNode prepareCall |
          prepareCall =
            ModelOutput::getATypeNode("asyncpg.Connection").getMember("prepare").getACall()
        |
          sql = prepareCall.getParameter(0, "query").asSink() and
          this =
            prepareCall
                .getReturn()
                .getAwaited()
                .getMember("cursor")
                .getReturn()
                .getAwaited()
                .asSource()
        )
      }

      override DataFlow::Node getSql() { result = sql }
    }
  }
}
