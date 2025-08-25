/**
 * Provides classes modeling security-relevant aspects of the `asyncpg` PyPI package.
 * See https://magicstack.github.io/asyncpg/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.data.ModelsAsData

/** Provides models for the `asyncpg` PyPI package. */
private module Asyncpg {
  /**
   * Provides models of the `Cursor` class in `asyncpg`.
   * `Cursor`s are created
   * - when the result of calling `cursor(query)` on a connection is awaited.
   * - when the result of calling `cursor()` on a prepared statement is awaited.
   * The result of calling `cursor` in either case is a `CursorFactory` and the argument, `query` needs to
   * be tracked to the place where a `Cursor` is created, hence the type tracker.
   * The creation of the `Cursor` executes the query.
   */
  module Cursor {
    class CursorConstruction extends SqlConstruction::Range, API::CallNode {
      CursorConstruction() {
        this = ModelOutput::getATypeNode("asyncpg.Connection").getMember("cursor").getACall()
      }

      override DataFlow::Node getSql() { result = this.getParameter(0, "query").asSink() }
    }

    /** The creation of a `Cursor` executes the associated query. */
    class CursorCreation extends SqlExecution::Range {
      DataFlow::Node sql;

      CursorCreation() {
        exists(CursorConstruction c |
          sql = c.getSql() and
          this = c.getReturn().getAwaited().asSource()
        )
        or
        exists(API::CallNode prepareCall |
          prepareCall =
            ModelOutput::getATypeNode("asyncpg.Connection").getMember("prepare").getACall()
        |
          sql = prepareCall.getParameter(0, "query").asSink() and
          this =
            prepareCall
                .getReturn()
                .getAwaited()
                .getMember("cursor")
                .getReturn()
                .getAwaited()
                .asSource()
        )
      }

      override DataFlow::Node getSql() { result = sql }
    }
  }
}
