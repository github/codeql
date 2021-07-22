/**
 * Provides classes modeling security-relevant aspects of the `mysql-connector-python` package.
 * See
 * - https://dev.mysql.com/doc/connector-python/en/
 * - https://dev.mysql.com/doc/connector-python/en/connector-python-example-connecting.html
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * Provides models for the `mysql-connector-python` package.
 * See
 * - https://dev.mysql.com/doc/connector-python/en/
 * - https://dev.mysql.com/doc/connector-python/en/connector-python-example-connecting.html
 */
private module MysqlConnectorPython {
  // ---------------------------------------------------------------------------
  // mysql
  // ---------------------------------------------------------------------------
  /** Provides models for the `mysql` module. */
  module mysql {
    /**
     * The mysql.connector module
     * See https://dev.mysql.com/doc/connector-python/en/connector-python-example-connecting.html
     */
    class MysqlConnector extends PEP249ModuleApiNode {
      MysqlConnector() { this = API::moduleImport("mysql").getMember("connector") }
    }
  }
}
