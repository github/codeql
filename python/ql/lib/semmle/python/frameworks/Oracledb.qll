/**
 * Provides classes modeling security-relevant aspects of the `oracledb` PyPI package.
 *
 * See
 * - https://python-oracledb.readthedocs.io/en/latest/index.html
 * - https://pypi.org/project/oracledb/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * Provides models for the `oracledb` PyPI package.
 *
 * See
 * - https://python-oracledb.readthedocs.io/en/latest/index.html
 * - https://pypi.org/project/oracledb/
 */
private module Oracledb {
  /**
   * A model for oracledb as a module that implements PEP 249, providing ways to execute SQL statements
   * against a database.
   */
  class Oracledb extends PEP249::PEP249ModuleApiNode {
    Oracledb() { this = API::moduleImport("oracledb") }
  }
}
