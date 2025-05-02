/**
 * Provides classes modeling security-relevant aspects of the `hdbcli` PyPI package.
 * See https://pypi.org/project/hdbcli/
 */

private import python
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * Provides models for the `hdbcli` PyPI package.
 * See https://pypi.org/project/hdbcli/
 */
private module Hdbcli {
  /**
   * A model of `hdbcli` as a module that implements PEP 249, providing ways to execute SQL statements
   * against a database.
   */
  class HdbcliPEP249 extends PEP249::PEP249ModuleApiNode {
    HdbcliPEP249() { this = API::moduleImport("hdbcli").getMember("dbapi") }
  }
}
