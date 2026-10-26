/**
 * Provides classes modeling security-relevant aspects of the `aiomysql` PyPI package.
 * See
 * - https://aiomysql.readthedocs.io/en/stable/index.html
 * - https://pypi.org/project/aiomysql/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/** Provides models for the `aiomysql` PyPI package. */
private module Aiomysql {
  /**
   * Gets a `ConnectionPool` that is created when the result of `aiomysql.create_pool()` is awaited.
   * See https://aiomysql.readthedocs.io/en/stable/pool.html
   */
  API::Node connectionPool() {
    result = API::moduleImport("aiomysql").getMember("create_pool").getReturn().getAwaited()
  }

  /**
   * A Connection that is created when
   * - the result of `aiomysql.connect()` is awaited.
   * - the result of calling `acquire` on a `ConnectionPool` is awaited.
   * See
   * - https://aiomysql.readthedocs.io/en/stable/connection.html#connection
   * - https://aiomysql.readthedocs.io/en/stable/pool.html#Pool.acquire
   */
  class AiomysqlConnection extends PEP249::AsyncDatabaseConnection {
    AiomysqlConnection() {
      this = API::moduleImport("aiomysql").getMember("connect").getReturn().getAwaited()
      or
      this = connectionPool().getMember("acquire").getReturn().getAwaited()
    }
  }

  /**
   * An additional cursor, that is created when
   * - the result of calling `cursor` on a `ConnectionPool` is awaited.
   * See
   * - https://aiomysql.readthedocs.io/en/stable/pool.html##Pool.cursor
   */
  class AiomysqlCursor extends PEP249::AsyncDatabaseCursor {
    AiomysqlCursor() { this = connectionPool().getMember("cursor").getReturn().getAwaited() }
  }

  /**
   * Gets an `Engine` that is created when the result of calling `aiomysql.sa.create_engine` is awaited.
   * See https://aiomysql.readthedocs.io/en/stable/sa.html#engine
   */
  API::Node engine() {
    result =
      API::moduleImport("aiomysql")
          .getMember("sa")
          .getMember("create_engine")
          .getReturn()
          .getAwaited()
  }

  /**
   * Gets an `SAConnection` that is created when the result of calling `acquire` on an `Engine` is awaited.
   * See https://aiomysql.readthedocs.io/en/stable/sa.html#connection
   */
  API::Node saConnection() { result = engine().getMember("acquire").getReturn().getAwaited() }

  /**
   * A query. Calling `execute` on a `SAConnection` constructs a query.
   * See https://aiomysql.readthedocs.io/en/stable/sa.html#aiomysql.sa.SAConnection.execute
   */
  class SAConnectionExecuteCall extends SqlConstruction::Range, API::CallNode {
    SAConnectionExecuteCall() { this = saConnection().getMember("execute").getACall() }

    override DataFlow::Node getSql() { result = this.getParameter(0, "query").asSink() }
  }

  /**
   * An awaited query. Awaiting the result of calling `execute` executes the query.
   * See https://aiomysql.readthedocs.io/en/stable/sa.html#aiomysql.sa.SAConnection.execute
   */
  class AwaitedSAConnectionExecuteCall extends SqlExecution::Range {
    SAConnectionExecuteCall execute;

    AwaitedSAConnectionExecuteCall() { this = execute.getReturn().getAwaited().asSource() }

    override DataFlow::Node getSql() { result = execute.getSql() }
  }
}
