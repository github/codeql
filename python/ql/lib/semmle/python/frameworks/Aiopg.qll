/**
 * Provides classes modeling security-relevant aspects of the `aiopg` PyPI package.
 * See
 * - https://aiopg.readthedocs.io/en/stable/index.html
 * - https://pypi.org/project/aiopg/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/** Provides models for the `aiopg` PyPI package. */
private module Aiopg {
  /**
   * Gets a `ConnectionPool` that is created when the result of `aiopg.create_pool()` is awaited.
   * See https://aiopg.readthedocs.io/en/stable/core.html#pool
   */
  API::Node connectionPool() {
    result = API::moduleImport("aiopg").getMember("create_pool").getReturn().getAwaited()
  }

  /**
   * A Connection that is created when
   * - the result of `aiopg.connect()` is awaited.
   * - the result of calling `acquire` on a `ConnectionPool` is awaited.
   * See
   * - https://aiopg.readthedocs.io/en/stable/core.html#connection
   * - https://aiopg.readthedocs.io/en/stable/core.html#aiopg.Pool.acquire
   */
  class AiopgConnection extends PEP249::AsyncDatabaseConnection {
    AiopgConnection() {
      this = API::moduleImport("aiopg").getMember("connect").getReturn().getAwaited()
      or
      this = connectionPool().getMember("acquire").getReturn().getAwaited()
    }
  }

  /**
   * An additional cursor, that is created when
   * - the result of calling `cursor` on a `ConnectionPool` is awaited.
   * See
   * - https://aiopg.readthedocs.io/en/stable/core.html#aiopg.Pool.cursor
   */
  class AiopgCursor extends PEP249::AsyncDatabaseCursor {
    AiopgCursor() { this = connectionPool().getMember("cursor").getReturn().getAwaited() }
  }

  /**
   * Gets an `Engine` that is created when the result of calling `aiopg.sa.create_engine` is awaited.
   * See https://aiopg.readthedocs.io/en/stable/sa.html#engine
   */
  API::Node engine() {
    result =
      API::moduleImport("aiopg").getMember("sa").getMember("create_engine").getReturn().getAwaited()
  }

  /**
   * Gets an `SAConnection` that is created when the result of calling `acquire` on an `Engine` is awaited.
   * See https://aiopg.readthedocs.io/en/stable/sa.html#connection
   */
  API::Node saConnection() { result = engine().getMember("acquire").getReturn().getAwaited() }

  /**
   * A query. Calling `execute` on a `SAConnection` constructs a query.
   * See https://aiopg.readthedocs.io/en/stable/sa.html#aiopg.sa.SAConnection.execute
   */
  class SAConnectionExecuteCall extends SqlConstruction::Range, API::CallNode {
    SAConnectionExecuteCall() { this = saConnection().getMember("execute").getACall() }

    override DataFlow::Node getSql() { result = this.getParameter(0, "query").asSink() }
  }

  /**
   * An awaited query. Awaiting the result of calling `execute` executes the query.
   * See https://aiopg.readthedocs.io/en/stable/sa.html#aiopg.sa.SAConnection.execute
   */
  class AwaitedSAConnectionExecuteCall extends SqlExecution::Range {
    SAConnectionExecuteCall execute;

    AwaitedSAConnectionExecuteCall() { this = execute.getReturn().getAwaited().asSource() }

    override DataFlow::Node getSql() { result = execute.getSql() }
  }
}
