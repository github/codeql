/**
 * Provides classes modeling security-relevant aspects of the `PyMySQL` PyPI package.
 * See https://pypi.org/project/PyMySQL/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import PEP249

/**
 * Provides models for the `PyMySQL` PyPI package.
 * See https://pypi.org/project/PyMySQL/
 */
private module PyMySQL {
  /** Gets a reference to the `pymysql` module. */
  private DataFlow::Node pymysql(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("pymysql")
    or
    exists(DataFlow::TypeTracker t2 | result = pymysql(t2).track(t2, t))
  }

  /** Gets a reference to the `pymysql` module. */
  DataFlow::Node pymysql() { result = pymysql(DataFlow::TypeTracker::end()) }

  /** PyMySQL implements PEP 249, providing ways to execute SQL statements against a database. */
  class PyMySQLPEP249 extends PEP249Module {
    PyMySQLPEP249() { this = pymysql() }
  }
}
