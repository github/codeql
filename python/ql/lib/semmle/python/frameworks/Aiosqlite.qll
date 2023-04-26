/**
 * Provides classes modeling security-relevant aspects of the `aiosqlite` PyPI package.
 * See
 * - https://pypi.org/project/aiosqlite/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/** Provides models for the `aiosqlite` PyPI package. */
private module Aiosqlite {
  /**
   * A model of `aiosqlite` as a module that implements PEP 249 using asyncio, providing
   * ways to execute SQL statements against a database.
   */
  class AiosqlitePEP249 extends PEP249::AsyncPEP249ModuleApiNode {
    AiosqlitePEP249() { this = API::moduleImport("aiosqlite") }
  }

  /**
   * An additional cursor, that is return from the coroutine Connection.execute,
   * see https://aiosqlite.omnilib.dev/en/latest/api.html#aiosqlite.Connection.execute
   */
  class AiosqliteCursor extends PEP249::AsyncDatabaseCursor {
    AiosqliteCursor() {
      this =
        API::moduleImport("aiosqlite")
            .getMember("connect")
            .getReturn()
            .getAwaited()
            .getMember("execute")
            .getReturn()
            .getAwaited()
    }
  }
}
