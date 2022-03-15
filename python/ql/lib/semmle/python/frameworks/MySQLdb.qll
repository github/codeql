/**
 * Provides classes modeling security-relevant aspects of the `MySQL-python` and `mysqlclient` PyPI packages
 * (both imported as `MySQLdb`) -- the `mysqlclient` package is a fork of `MySQL-python`.
 *
 * See
 * - https://mysqlclient.readthedocs.io/index.html
 * - https://pypi.org/project/MySQL-python/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * Provides models for the `MySQL-python` and `mysqlclient` PyPI packages
 * (both imported as `MySQLdb`) -- the `mysqlclient` package is a fork of `MySQL-python`.
 *
 * See
 * - https://mysqlclient.readthedocs.io/index.html
 * - https://pypi.org/project/MySQL-python/
 * - https://pypi.org/project/mysqlclient/
 */
private module MySQLdb {
  // ---------------------------------------------------------------------------
  // MySQLdb
  // ---------------------------------------------------------------------------
  /**
   * A model for MySQLdb as a module that implements PEP 249, providing ways to execute SQL statements
   * against a database.
   */
  class MySQLdb extends PEP249::PEP249ModuleApiNode {
    MySQLdb() { this = API::moduleImport("MySQLdb") }
  }
}
