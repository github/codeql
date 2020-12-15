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
private import PEP249

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
  /** Gets a reference to the `psycopg2` module. */
  private DataFlow::Node psycopg2(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("psycopg2")
    or
    exists(DataFlow::TypeTracker t2 | result = psycopg2(t2).track(t2, t))
  }

  /** Gets a reference to the `psycopg2` module. */
  DataFlow::Node psycopg2() { result = psycopg2(DataFlow::TypeTracker::end()) }

  /** psycopg2 implements PEP 249, providing ways to execute SQL statements against a database. */
  class Psycopg2 extends PEP249Module {
    Psycopg2() { this = psycopg2() }
  }
}
