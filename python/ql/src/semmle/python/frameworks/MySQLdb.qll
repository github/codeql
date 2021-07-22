/**
 * Provides classes modeling security-relevant aspects of the `MySQLdb` PyPI package.
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
 * Provides models for the `MySQLdb` PyPI package.
 * See
 * - https://mysqlclient.readthedocs.io/index.html
 * - https://pypi.org/project/MySQL-python/
 */
private module MySQLdb {
  // ---------------------------------------------------------------------------
  // MySQLdb
  // ---------------------------------------------------------------------------
  /** MySQLdb implements PEP 249, providing ways to execute SQL statements against a database. */
  class MySQLdb extends PEP249ModuleApiNode {
    MySQLdb() { this = API::moduleImport("MySQLdb") }
  }
}
