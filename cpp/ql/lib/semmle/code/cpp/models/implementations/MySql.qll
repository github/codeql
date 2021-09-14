private import semmle.code.cpp.models.interfaces.Sql
private import semmle.code.cpp.models.interfaces.FunctionInputsAndOutputs

private class MySqlSink extends SqlSink {
  MySqlSink() { this.hasName(["mysql_query", "mysql_real_query"]) }

  override predicate getAnSqlParameter(FunctionInput input) { input.isParameterDeref(1) }
}
