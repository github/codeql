/**
 * This file provides classes for working with various SQL libraries and frameworks.
 */

private import cpp
private import semmle.code.cpp.models.interfaces.FunctionInputsAndOutputs

/**
 * An abstract class that represents SQL parameters and escaping functions.
 *
 * To add support for a new SQL framework, extend this class with
 * a subclass whose characteristic predicate is a unique singleton string.
 * For example, write
 *
 *  ```ql
 * class MySqlFunctionality extends SqlFunctionality {
 *   MySqlFunctionality() { this = "MySqlFunctionality" }
 *   // Override `getAnSqlParameter`.
 *   // Optionally override `getAnEscapedParameter`.
 * }
 * ```
 */
abstract class SqlFunctionality extends string {
  bindingset[this]
  SqlFunctionality() { any() }

  /**
   * Holds if `input` to the function `func` represents data that is passed to an SQL server.
   */
  abstract predicate getAnSqlParameter(Function func, FunctionInput input);

  /**
   * Holds if the `output` from `func` escapes the SQL input `input` such that is it safe to pass to
   * an SQL server.
   */
  predicate getAnEscapedParameter(Function func, FunctionInput input, FunctionOutput output) {
    none()
  }
}

private class MySqlFunctionality extends SqlFunctionality {
  MySqlFunctionality() { this = "MySqlFunctionality" }

  override predicate getAnSqlParameter(Function func, FunctionInput input) {
    func.hasName(["mysql_query", "mysql_real_query"]) and
    input.isParameterDeref(1)
  }
}

private class SqLite3Functionality extends SqlFunctionality {
  SqLite3Functionality() { this = "SqLite3Functionality" }

  override predicate getAnSqlParameter(Function func, FunctionInput input) {
    func.hasName("sqlite3_exec") and
    input.isParameterDeref(1)
  }
}

private module PostgreSql {
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

  class PostgreSqlFunctionality extends SqlFunctionality {
    PostgreSqlFunctionality() { this = "PostgreSqlFunctionality" }

    override predicate getAnSqlParameter(Function func, FunctionInput input) {
      exists(int argIndex, UserType t |
        func.getDeclaringType() = t and
        // transaction exec and connection prepare variations
        (
          pqxxTransationClassNames(t.getName(), t.getNamespace().getName()) and
          pqxxTransactionSqlArgument(func.getName(), argIndex)
          or
          pqxxConnectionClassNames(t.getName(), t.getNamespace().getName()) and
          pqxxConnectionSqlArgument(func.getName(), argIndex)
        ) and
        input.isParameterDeref(argIndex)
      )
    }

    override predicate getAnEscapedParameter(
      Function func, FunctionInput input, FunctionOutput output
    ) {
      exists(int argIndex, UserType t |
        func.getDeclaringType() = t and
        // transaction and connection escape functions
        (
          pqxxTransationClassNames(t.getName(), t.getNamespace().getName()) or
          pqxxConnectionClassNames(t.getName(), t.getNamespace().getName())
        ) and
        pqxxEscapeArgument(func.getName(), argIndex) and
        input.isParameterDeref(argIndex) and
        output.isReturnValueDeref()
      )
    }
  }
}

private import PostgreSql
