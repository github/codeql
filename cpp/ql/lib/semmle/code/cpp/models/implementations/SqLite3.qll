/**
 * Provides implementation classes modeling the SQLite C API.
 * See `semmle.code.cpp.models.Models` for usage information.
 */

private import semmle.code.cpp.models.interfaces.Sql
private import semmle.code.cpp.models.interfaces.FunctionInputsAndOutputs

/**
 * The `sqlite3_exec` and `sqlite3_prepare` families of functions from the SQLite C API.
 */
private class SqLite3ExecutionFunction extends SqlExecutionFunction {
  SqLite3ExecutionFunction() {
    this.hasName([
        "sqlite3_exec", "sqlite3_prepare", "sqlite3_prepare_v2", "sqlite3_prepare_v3",
        "sqlite3_prepare16", "sqlite3_prepare16_v2", "sqlite3_prepare16_v3"
      ])
  }

  override predicate hasSqlArgument(FunctionInput input) { input.isParameterDeref(1) }
}
