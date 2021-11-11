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

/** Provides models for the `aiomysql` PyPI package. */
private module Aiomysql {
  private import semmle.python.internal.Awaited

  /**
   * A `ConectionPool` is created when the result of `aiomysql.create_pool()` is awaited.
   * See https://aiomysql.readthedocs.io/en/stable/pool.html
   */
  API::Node connectionPool() {
    result = API::moduleImport("aiomysql").getMember("create_pool").getReturn().getAwaited()
  }

  /**
   * A `Connection` is created when
   * - the result of `aiomysql.connect()` is awaited.
   * - the result of calling `aquire` on a `ConnectionPool` is awaited.
   * See https://aiomysql.readthedocs.io/en/stable/connection.html#connection
   */
  API::Node connection() {
    result = API::moduleImport("aiomysql").getMember("connect").getReturn().getAwaited()
    or
    result = connectionPool().getMember("acquire").getReturn().getAwaited()
  }

  /**
   * A `Cursor` is created when
   * - the result of calling `cursor` on a `ConnectionPool` is awaited.
   * - the result of calling `cursor` on a `Connection` is awaited.
   * See https://aiomysql.readthedocs.io/en/stable/cursors.html
   */
  API::Node cursor() {
    result = connectionPool().getMember("cursor").getReturn().getAwaited()
    or
    result = connection().getMember("cursor").getReturn().getAwaited()
  }

  /**
   * Calling `execute` on a `Cursor` constructs a query.
   * See https://aiomysql.readthedocs.io/en/stable/cursors.html#Cursor.execute
   */
  class CursorExecuteCall extends SqlConstruction::Range, DataFlow::CallCfgNode {
    CursorExecuteCall() { this = cursor().getMember("execute").getACall() }

    override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName("operation")] }
  }

  /**
   * This is only needed to connect the argument to the execute call with the subsequnt awaiting.
   * It should be obsolete once we have `API::CallNode` available.
   */
  private DataFlow::TypeTrackingNode cursorExecuteCall(DataFlow::TypeTracker t, DataFlow::Node sql) {
    // cursor created from connection
    t.start() and
    sql = result.(CursorExecuteCall).getSql()
    or
    exists(DataFlow::TypeTracker t2 | result = cursorExecuteCall(t2, sql).track(t2, t))
  }

  DataFlow::Node cursorExecuteCall(DataFlow::Node sql) {
    cursorExecuteCall(DataFlow::TypeTracker::end(), sql).flowsTo(result)
  }

  /**
   * Awaiting the result of calling `execute` executes the query.
   * See https://aiomysql.readthedocs.io/en/stable/cursors.html#Cursor.execute
   */
  class AwaitedCursorExecuteCall extends SqlExecution::Range {
    DataFlow::Node sql;

    AwaitedCursorExecuteCall() { this = awaited(cursorExecuteCall(sql)) }

    override DataFlow::Node getSql() { result = sql }
  }

  /**
   * An `Engine` is created when the result of calling `aiomysql.sa.create_engine` is awaited.
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
   * A `SAConnection` is created when the result of calling `aquire` on an `Engine` is awaited.
   * See https://aiomysql.readthedocs.io/en/stable/sa.html#connection
   */
  API::Node saConnection() { result = engine().getMember("acquire").getReturn().getAwaited() }

  /**
   * Calling `execute` on a `SAConnection` constructs a query.
   * See https://aiomysql.readthedocs.io/en/stable/sa.html#aiomysql.sa.SAConnection.execute
   */
  class SAConnectionExecuteCall extends SqlConstruction::Range, DataFlow::CallCfgNode {
    SAConnectionExecuteCall() { this = saConnection().getMember("execute").getACall() }

    override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName("query")] }
  }

  /**
   * This is only needed to connect the argument to the execute call with the subsequnt awaiting.
   * It should be obsolete once we have `API::CallNode` available.
   */
  private DataFlow::TypeTrackingNode saConnectionExecuteCall(
    DataFlow::TypeTracker t, DataFlow::Node sql
  ) {
    // saConnection created from engine
    t.start() and
    sql = result.(SAConnectionExecuteCall).getSql()
    or
    exists(DataFlow::TypeTracker t2 | result = saConnectionExecuteCall(t2, sql).track(t2, t))
  }

  DataFlow::Node saConnectionExecuteCall(DataFlow::Node sql) {
    saConnectionExecuteCall(DataFlow::TypeTracker::end(), sql).flowsTo(result)
  }

  /**
   * Awaiting the result of calling `execute` executes the query.
   * See https://aiomysql.readthedocs.io/en/stable/sa.html#aiomysql.sa.SAConnection.execute
   */
  class AwaitedSAConnectionExecuteCall extends SqlExecution::Range {
    DataFlow::Node sql;

    AwaitedSAConnectionExecuteCall() { this = awaited(saConnectionExecuteCall(sql)) }

    override DataFlow::Node getSql() { result = sql }
  }
}
