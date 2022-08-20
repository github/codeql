/**
 * Provides classes modeling security-relevant aspects of the `PyMySQL` PyPI package.
 * See https://pypi.org/project/PyMySQL/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * Provides models for the `PyMySQL` PyPI package.
 * See https://pypi.org/project/PyMySQL/
 */
private module PyMySql {
  /**
   * A model of PyMySQL as a module that implements PEP 249, providing ways to execute SQL statements
   * against a database.
   */
  class PyMySQLPEP249 extends PEP249::PEP249ModuleApiNode {
    PyMySQLPEP249() { this = API::moduleImport("pymysql") }
  }
}
