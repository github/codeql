/**
 * Provides classes modeling security-relevant aspects of the `aioch` PyPI package (an
 * async-io version of the `clickhouse-driver` PyPI package).
 *
 * See https://pypi.org/project/aioch/
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.ClickhouseDriver

/**
 * INTERNAL: Do not use.
 *
 * Provides models for `aioch` PyPI package (an async-io version of the
 * `clickhouse-driver` PyPI package).
 *
 * See https://pypi.org/project/aioch/
 */
module Aioch {
  /** Provides models for `aioch.Client` class and subclasses. */
  module Client {
    /** Gets a reference to the `aioch.Client` class or any subclass. */
    API::Node subclassRef() {
      result = API::moduleImport("aioch").getMember("Client").getASubclass*()
    }

    /** Gets a reference to an instance of `clickhouse_driver.Client` or any subclass. */
    API::Node instance() { result = subclassRef().getReturn() }
  }

  /**
   * A call to any of the the execute methods on a `aioch.Client`, which are just async
   * versions of the methods in the `clickhouse-driver` PyPI package.
   *
   * See
   * - https://clickhouse-driver.readthedocs.io/en/latest/api.html#clickhouse_driver.Client.execute
   * - https://clickhouse-driver.readthedocs.io/en/latest/api.html#clickhouse_driver.Client.execute_iter
   * - https://clickhouse-driver.readthedocs.io/en/latest/api.html#clickhouse_driver.Client.execute_with_progress
   */
  class ClientExecuteCall extends SqlExecution::Range, DataFlow::CallCfgNode {
    ClientExecuteCall() {
      exists(string methodName | methodName = ClickhouseDriver::getExecuteMethodName() |
        this = Client::instance().getMember(methodName).getACall()
      )
    }

    override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName("query")] }
  }
}
