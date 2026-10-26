/**
 * Provides classes modeling security-relevant aspects of the `pymssql` PyPI package.
 * See https://pypi.org/project/pymssql/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * Provides models for the `pymssql` PyPI package.
 * See https://pypi.org/project/pymssql/
 */
private module Pymssql {
  /**
   * A model of `pymssql` as a module that implements PEP 249, providing ways to execute SQL statements
   * against a database.
   */
  class PymssqlPEP249 extends PEP249::PEP249ModuleApiNode {
    PymssqlPEP249() { this = API::moduleImport("pymssql") }
  }
}
