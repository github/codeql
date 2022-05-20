/**
 * Provides classes modeling security-relevant aspects of the `mysql-connector-python`
 * and `mysql-connector` (old package name) PyPI packages (imported as `mysql`).
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
 * Provides classes modeling security-relevant aspects of the `mysql-connector-python`
 * and `mysql-connector` (old package name) PyPI packages (imported as `mysql`).
 * See
 * - https://dev.mysql.com/doc/connector-python/en/
 * - https://dev.mysql.com/doc/connector-python/en/connector-python-example-connecting.html
 */
private module Mysql {
  // ---------------------------------------------------------------------------
  // mysql
  // ---------------------------------------------------------------------------
  /** Provides models for the `mysql` module. */
  module MysqlMod {
    /**
     * The mysql.connector module
     * See https://dev.mysql.com/doc/connector-python/en/connector-python-example-connecting.html
     */
    class MysqlConnector extends PEP249::PEP249ModuleApiNode {
      MysqlConnector() { this = API::moduleImport("mysql").getMember("connector") }
    }
  }
}
