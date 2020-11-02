/**
 * Provides classes modeling security-relevant aspects of the `MySQLdb` PyPI package.
 * See
 * - https://mysqlclient.readthedocs.io/index.html
 * - https://pypi.org/project/MySQL-python/
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.semmle.python.Concepts
private import PEP249

/**
 * Provides models for the `MySQLdb` PyPI package.
 * See
 * - https://mysqlclient.readthedocs.io/index.html
 * - https://pypi.org/project/MySQL-python/
 */
module MySQLdb {
  // ---------------------------------------------------------------------------
  // MySQLdb
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `MySQLdb` module. */
  private DataFlow::Node moduleMySQLdb(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("MySQLdb")
    or
    exists(DataFlow::TypeTracker t2 | result = moduleMySQLdb(t2).track(t2, t))
  }

  /** Gets a reference to the `MySQLdb` module. */
  DataFlow::Node moduleMySQLdb() { result = moduleMySQLdb(DataFlow::TypeTracker::end()) }

  class MySQLdb extends PEP249Module {
    MySQLdb() { this = moduleMySQLdb() }
  }
}
