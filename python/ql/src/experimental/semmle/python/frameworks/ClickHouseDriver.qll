/**
 * Provides classes modeling security-relevant aspects of `clickhouse-driver` and `aioch` PyPI packages.
 * See
 * - https://pypi.org/project/clickhouse-driver/
 * - https://pypi.org/project/aioch/
 * - https://clickhouse-driver.readthedocs.io/en/latest/
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * Provides models for `clickhouse-driver` and `aioch` PyPI packages.
 * See
 * - https://pypi.org/project/clickhouse-driver/
 * - https://pypi.org/project/aioch/
 * - https://clickhouse-driver.readthedocs.io/en/latest/
 */
module ClickHouseDriver {
  /** Gets a reference to the `clickhouse_driver` module. */
  API::Node clickhouse_driver() { result = API::moduleImport("clickhouse_driver") }

  /** Gets a reference to the `aioch` module. This module allows to make async db queries. */
  API::Node aioch() { result = API::moduleImport("aioch") }

  /**
   * `clickhouse_driver` implements PEP249,
   * providing ways to execute SQL statements against a database.
   */
  class ClickHouseDriverPEP249 extends PEP249ModuleApiNode {
    ClickHouseDriverPEP249() { this = clickhouse_driver() }
  }

  module Client {
    /** Gets a reference to a Client call. */
    private DataFlow::Node client_ref() {
      result = clickhouse_driver().getMember("Client").getASubclass*().getAUse()
      or
      result = aioch().getMember("Client").getASubclass*().getAUse()
    }

    /** A direct instantiation of `clickhouse_driver.Client`. */
    private class ClientInstantiation extends DataFlow::CallCfgNode {
      ClientInstantiation() { this.getFunction() = client_ref() }
    }

    /** Gets a reference to an instance of `clickhouse_driver.Client`. */
    private DataFlow::LocalSourceNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof ClientInstantiation
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `clickhouse_driver.Client`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
  }

  /** clickhouse_driver.Client execute methods */
  private string execute_function() {
    result in ["execute_with_progress", "execute", "execute_iter"]
  }

  /** Gets a reference to the `clickhouse_driver.Client.execute` method */
  private DataFlow::LocalSourceNode clickhouse_execute(DataFlow::TypeTracker t) {
    t.startInAttr(execute_function()) and
    result = Client::instance()
    or
    exists(DataFlow::TypeTracker t2 | result = clickhouse_execute(t2).track(t2, t))
  }

  /** Gets a reference to the `clickhouse_driver.Client.execute` method */
  DataFlow::Node clickhouse_execute() {
    clickhouse_execute(DataFlow::TypeTracker::end()).flowsTo(result)
  }

  /** A call to the `clickhouse_driver.Client.execute` method */
  private class ExecuteCall extends SqlExecution::Range, DataFlow::CallCfgNode {
    ExecuteCall() { this.getFunction() = clickhouse_execute() }

    override DataFlow::Node getSql() { result.asCfgNode() = node.getArg(0) }
  }
}
