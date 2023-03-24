/**
 * Provides classes modeling security-relevant aspects of the `cx_Oracle` PyPI package.
 *
 * See
 * - https://github.com/oracle/python-cx_Oracle
 * - https://pypi.org/project/cx-Oracle/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * Provides models for the `cx_Oracle` PyPI package.
 *
 * See
 * - https://github.com/oracle/python-cx_Oracle
 * - https://pypi.org/project/cx-Oracle/
 */
private module Cx_Oracle {
  /**
   * A model for Cx_Oracle as a module that implements PEP 249, providing ways to execute SQL statements
   * against a database.
   */
  class Cx_Oracle extends PEP249::PEP249ModuleApiNode {
    Cx_Oracle() { this = API::moduleImport("cx_Oracle") }
  }
}
