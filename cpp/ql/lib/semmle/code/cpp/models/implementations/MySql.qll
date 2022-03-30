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

/**
 * The `mysql_real_escape_string` family of functions from the MySQL C API.
 */
private class MySqlBarrierFunction extends SqlBarrierFunction {
  MySqlBarrierFunction() {
    this.hasName(["mysql_real_escape_string", "mysql_real_escape_string_quote"])
  }

  override predicate barrierSqlArgument(FunctionInput input, FunctionOutput output) {
    input.isParameterDeref(2) and
    output.isParameterDeref(1)
  }
}
