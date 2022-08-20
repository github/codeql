/**
 * Provides classes modeling security-relevant aspects of the `clickhouse-driver` PyPI package.
 * See
 * - https://pypi.org/project/clickhouse-driver/
 * - https://clickhouse-driver.readthedocs.io/en/latest/
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * INTERNAL: Do not use.
 *
 * Provides models for `clickhouse-driver` PyPI package (imported as `clickhouse_driver`).
 * See
 * - https://pypi.org/project/clickhouse-driver/
 * - https://clickhouse-driver.readthedocs.io/en/latest/
 */
module ClickhouseDriver {
  /**
   * A model of `clickhouse-driver`, which implements PEP249,
   * providing ways to execute SQL statements against a database.
   */
  class ClickHouseDriverPEP249 extends PEP249::PEP249ModuleApiNode {
    ClickHouseDriverPEP249() { this = API::moduleImport("clickhouse_driver") }
  }

  /** Provides models for `clickhouse_driver.Client` class and subclasses. */
  module Client {
    /** Gets a reference to the `clickhouse_driver.Client` class or any subclass. */
    API::Node subclassRef() {
      exists(API::Node classRef |
        // canonical definition
        classRef = API::moduleImport("clickhouse_driver").getMember("client").getMember("Client")
        or
        // commonly used alias
        classRef = API::moduleImport("clickhouse_driver").getMember("Client")
      |
        result = classRef.getASubclass*()
      )
    }

    /** Gets a reference to an instance of `clickhouse_driver.Client` or any subclass. */
    API::Node instance() { result = subclassRef().getReturn() }
  }

  /** `clickhouse_driver.Client` execute method names */
  string getExecuteMethodName() { result in ["execute_with_progress", "execute", "execute_iter"] }

  /**
   * A call to any of the the execute methods on a `clickhouse_driver.Client` method
   *
   * See
   * - https://clickhouse-driver.readthedocs.io/en/latest/api.html#clickhouse_driver.Client.execute
   * - https://clickhouse-driver.readthedocs.io/en/latest/api.html#clickhouse_driver.Client.execute_iter
   * - https://clickhouse-driver.readthedocs.io/en/latest/api.html#clickhouse_driver.Client.execute_with_progress
   */
  class ClientExecuteCall extends SqlExecution::Range, DataFlow::CallCfgNode {
    ClientExecuteCall() { this = Client::instance().getMember(getExecuteMethodName()).getACall() }

    override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName("query")] }
  }
}
