/**
 * Provides implementation classes modeling the MySql C API.
 * See `semmle.code.cpp.models.Models` for usage information.
 */

private import semmle.code.cpp.models.interfaces.Sql
private import semmle.code.cpp.models.interfaces.FunctionInputsAndOutputs

/**
 * The `mysql_query` family of functions from the MySQL C API.
 */
private class MySqlExecutionFunction extends SqlExecutionFunction {
  MySqlExecutionFunction() {
    this.hasName(["mysql_query", "mysql_real_query", "mysql_real_query_nonblocking"])
  }

  override predicate hasSqlArgument(FunctionInput input) { input.isParameterDeref(1) }
}
