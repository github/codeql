/**
 * Provides classes modeling security-relevant aspects of the `pyodbc` PyPI package.
 *
 * See
 * - https://github.com/mkleehammer/pyodbc/wiki
 * - https://pypi.org/project/pyodbc/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * Provides models for the `pyodbc` PyPI package.
 *
 * See
 * - https://github.com/mkleehammer/pyodbc/wiki
 * - https://pypi.org/project/pyodbc/
 */
private module Pyodbc {
  /**
   * A model for Pyodbc as a module that implements PEP 249, providing ways to execute SQL statements
   * against a database.
   */
  class Pyodbc extends PEP249::PEP249ModuleApiNode {
    Pyodbc() { this = API::moduleImport("pyodbc") }
  }
}
