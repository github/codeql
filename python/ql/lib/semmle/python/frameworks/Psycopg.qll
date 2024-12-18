/**
 * Provides classes modeling security-relevant aspects of the `psycopg` PyPI package.
 * See
 * - https://www.psycopg.org/psycopg3/docs/
 * - https://pypi.org/project/psycopg/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * Provides models for the `psycopg` PyPI package.
 * See
 * - https://www.psycopg.org/psycopg3/docs/
 * - https://pypi.org/project/psycopg/
 */
private module Psycopg {
  // ---------------------------------------------------------------------------
  // Psycopg
  // ---------------------------------------------------------------------------
  /**
   * A model of `psycopg` as a module that implements PEP 249, providing ways to execute SQL statements
   * against a database.
   */
  class Psycopg extends PEP249::PEP249ModuleApiNode {
    Psycopg() { this = API::moduleImport("psycopg") }
  }
}
