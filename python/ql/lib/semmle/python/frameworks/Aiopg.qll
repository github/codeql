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

/** Provides models for the `aiopg` PyPI package. */
private module Aiopg {
  private import semmle.python.internal.Awaited

  /** A `ConectionPool` is created when the result of `aiopg.create_pool()` is awaited. */
  API::Node connectionPool() {
    result = API::moduleImport("aiopg").getMember("create_pool").getReturn().getAwaited()
  }

  /**
   * A `Connection` is created when
   * - the result of `aiopg.connect()` is awaited.
   * - the result of calling `aquire` on a `ConnectionPool` is awaited.
   */
  API::Node connection() {
    result = API::moduleImport("aiopg").getMember("connect").getReturn().getAwaited()
    or
    result = connectionPool().getMember("acquire").getReturn().getAwaited()
  }

  /**
   * A `Cursor` is created when
   * - the result of calling `cursor` on a `ConnectionPool` is awaited.
   * - the result of calling `cursor` on a `Connection` is awaited.
   */
  API::Node cursor() {
    result = connectionPool().getMember("cursor").getReturn().getAwaited()
    or
    result = connection().getMember("cursor").getReturn().getAwaited()
  }

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

  /** Awaiting the result of calling `execute` executes the query. */
  class AwaitedCursorExecuteCall extends SqlExecution::Range {
    DataFlow::Node sql;

    AwaitedCursorExecuteCall() { this = awaited(cursorExecuteCall(sql)) }

    override DataFlow::Node getSql() { result = sql }
  }
}
