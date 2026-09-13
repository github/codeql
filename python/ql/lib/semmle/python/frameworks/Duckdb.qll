/**
 * Provides classes modeling security-relevant aspects of the `duckdb` PyPI package.
 * See
 * - https://duckdb.org/docs/stable/clients/python/overview
 * - https://pypi.org/project/duckdb/
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249

/**
 * Provides models for the `duckdb` PyPI package.
 * See
 * - https://duckdb.org/docs/stable/clients/python/overview
 * - https://pypi.org/project/duckdb/
 */
private module Duckdb {
  /**
   * A model of `duckdb` as a module that implements PEP 249, providing ways to execute SQL statements
   * against a database.
   */
  class DuckdbPEP249 extends PEP249::PEP249ModuleApiNode {
    DuckdbPEP249() { this = API::moduleImport("duckdb") }
  }

  /**
   * A call to one of the module level functions `duckdb.sql`, `duckdb.execute` or
   * `duckdb.executemany`, all of which immediately execute a SQL statement on the
   * default connection.
   *
   * See https://duckdb.org/docs/stable/clients/python/overview
   */
  class ModuleLevelExecuteCall extends SqlExecution::Range, API::CallNode {
    ModuleLevelExecuteCall() {
      this = API::moduleImport("duckdb").getMember(["sql", "execute", "executemany"]).getACall()
    }

    override DataFlow::Node getSql() { result in [this.getArg(0), this.getArgByName("query")] }
  }
}
