/**
 * Provides classes modeling security-relevant aspects of the `phoenixdb` PyPI package.
 *
 * See
 * - https://github.com/apache/phoenix-queryserver/tree/master/python-phoenixdb
 * - https://pypi.org/project/phoenixdb/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * Provides models for the `phoenixdb` PyPI package.
 *
 * See
 * - https://github.com/apache/phoenix-queryserver/tree/master/python-phoenixdb
 * - https://pypi.org/project/phoenixdb/
 */
private module Phoenixdb {
  /**
   * A model for Phoenixdb as a module that implements PEP 249, providing ways to execute SQL statements
   * against a database.
   */
  class Phoenixdb extends PEP249::PEP249ModuleApiNode {
    Phoenixdb() { this = API::moduleImport("phoenixdb") }
  }
}
