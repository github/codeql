private import semmle.code.cpp.models.interfaces.Sql
private import semmle.code.cpp.models.interfaces.FunctionInputsAndOutputs

private class SqLite3ExecutionFunction extends SqlExecutionFunction {
  SqLite3ExecutionFunction() { this.hasName("sqlite3_exec") }

  override predicate hasSqlArgument(FunctionInput input) { input.isParameterDeref(1) }
}
