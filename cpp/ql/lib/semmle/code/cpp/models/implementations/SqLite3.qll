private import semmle.code.cpp.models.interfaces.Sql
private import semmle.code.cpp.models.interfaces.FunctionInputsAndOutputs

private class SqLite3Sink extends SqlSink {
  SqLite3Sink() { this.hasName("sqlite3_exec") }

  override predicate getAnSqlParameter(FunctionInput input) { input.isParameterDeref(1) }
}
