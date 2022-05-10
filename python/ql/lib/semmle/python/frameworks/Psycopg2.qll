/**
 * Provides classes modeling security-relevant aspects of the `psycopg2` PyPI package.
 * See
 * - https://www.psycopg.org/docs/
 * - https://pypi.org/project/psycopg2/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * Provides models for the `psycopg2` PyPI package.
 * See
 * - https://www.psycopg.org/docs/
 * - https://pypi.org/project/psycopg2/
 */
private module Psycopg2 {
  // ---------------------------------------------------------------------------
  // Psycopg
  // ---------------------------------------------------------------------------
  /**
   * A model of psycopg2 as a module that implements PEP 249, providing ways to execute SQL statements
   * against a database.
   */
  class Psycopg2 extends PEP249::PEP249ModuleApiNode {
    Psycopg2() { this = API::moduleImport("psycopg2") }
  }
}
