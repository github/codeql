private import semmle.code.cpp.models.interfaces.Sql
private import semmle.code.cpp.models.interfaces.FunctionInputsAndOutputs

private class MySqlExecutionFunction extends SqlExecutionFunction {
  MySqlExecutionFunction() { this.hasName(["mysql_query", "mysql_real_query"]) }

  override predicate hasSqlArgument(FunctionInput input) { input.isParameterDeref(1) }
}
