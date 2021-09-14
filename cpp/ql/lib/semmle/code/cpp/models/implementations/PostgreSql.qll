private import semmle.code.cpp.models.interfaces.Sql
private import semmle.code.cpp.models.interfaces.FunctionInputsAndOutputs

private predicate pqxxTransactionSqlArgument(string function, int arg) {
  function = "exec" and arg = 0
  or
  function = "exec0" and arg = 0
  or
  function = "exec1" and arg = 0
  or
  function = "exec_n" and arg = 1
  or
  function = "exec_params" and arg = 0
  or
  function = "exec_params0" and arg = 0
  or
  function = "exec_params1" and arg = 0
  or
  function = "exec_params_n" and arg = 1
  or
  function = "query_value" and arg = 0
  or
  function = "stream" and arg = 0
}

private predicate pqxxConnectionSqlArgument(string function, int arg) {
  function = "prepare" and arg = 1
}

private predicate pqxxTransationClassNames(string className, string namespace) {
  namespace = "pqxx" and
  className in [
      "dbtransaction", "nontransaction", "basic_robusttransaction", "robusttransaction",
      "subtransaction", "transaction", "basic_transaction", "transaction_base", "work"
    ]
}

private predicate pqxxConnectionClassNames(string className, string namespace) {
  namespace = "pqxx" and
  className in ["connection_base", "basic_connection", "connection"]
}

private predicate pqxxEscapeArgument(string function, int arg) {
  arg = 0 and
  function in ["esc", "esc_raw", "quote", "quote_raw", "quote_name", "quote_table", "esc_like"]
}

private class PostgreSqlSink extends SqlSink {
  PostgreSqlSink() {
    exists(Class c |
      this.getDeclaringType() = c and
      // transaction exec and connection prepare variations
      (
        pqxxTransationClassNames(c.getName(), c.getNamespace().getName()) and
        pqxxTransactionSqlArgument(this.getName(), _)
        or
        pqxxConnectionSqlArgument(this.getName(), _) and
        pqxxConnectionClassNames(c.getName(), c.getNamespace().getName())
      )
    )
  }

  override predicate getAnSqlParameter(FunctionInput input) {
    exists(int argIndex |
      pqxxTransactionSqlArgument(this.getName(), argIndex)
      or
      pqxxConnectionSqlArgument(this.getName(), argIndex)
    |
      input.isParameterDeref(argIndex)
    )
  }
}

private class PostgreSqlBarrier extends SqlBarrier {
  PostgreSqlBarrier() {
    exists(Class c |
      this.getDeclaringType() = c and
      // transaction and connection escape functions
      (
        pqxxTransationClassNames(c.getName(), c.getNamespace().getName()) or
        pqxxConnectionClassNames(c.getName(), c.getNamespace().getName())
      ) and
      pqxxEscapeArgument(this.getName(), _)
    )
  }

  override predicate getAnEscapedParameter(FunctionInput input, FunctionOutput output) {
    exists(int argIndex |
      input.isParameterDeref(argIndex) and
      output.isReturnValueDeref()
    )
  }
}
