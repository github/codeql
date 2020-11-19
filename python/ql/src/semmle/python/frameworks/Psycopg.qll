/**
 * Provides classes modeling security-relevant aspects of the `Psycopg` PyPI package.
 * See
 * - https://www.psycopg.org/docs/
 * - https://pypi.org/project/psycopg2/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import PEP249

/**
 * Provides models for the `Psycopg` PyPI package.
 * See
 * - https://www.psycopg.org/docs/
 * - https://pypi.org/project/psycopg2/
 */
module Psycopg {
  // ---------------------------------------------------------------------------
  // Psycopg
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `Psycopg` module. */
  private DataFlow::Node modulePsycopg(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("psycopg2")
    or
    exists(DataFlow::TypeTracker t2 | result = modulePsycopg(t2).track(t2, t))
  }

  /** Gets a reference to the `Psycopg` module. */
  DataFlow::Node modulePsycopg() { result = modulePsycopg(DataFlow::TypeTracker::end()) }

  /** Psycopg implements PEP 249, providing ways to execute SQL statements against a database. */
  class Psycopg extends PEP249Module {
    Psycopg() { this = modulePsycopg() }
  }
}
