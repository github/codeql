/**
 * Provides implementation classes modeling the ODBC C/C++ API.
 * See `semmle.code.cpp.models.Models` for usage information.
 */

private import semmle.code.cpp.models.interfaces.Sql
private import semmle.code.cpp.models.interfaces.FunctionInputsAndOutputs

/**
 * The `SQLExecDirect`, and `SQLPrepare` from the ODBC C/C++ API:
 * https://learn.microsoft.com/en-us/sql/odbc/reference/syntax/sqlexecdirect-function?view=sql-server-ver16
 * https://learn.microsoft.com/en-us/sql/odbc/reference/syntax/sqlprepare-function?view=sql-server-ver16
 *
 * Note, `SQLExecute` is not included because it operates on a SQLHSTMT type, not a string.
 * The SQLHSTMT parameter for `SQLExecute` is set through a `SQLPrepare`, which is modeled.
 * The other source of input to a `SQLExecute` is via a `SQLBindParameter`, which sanitizes user input,
 * and would be considered a barrier to SQL injection.
 */
private class ODBCExecutionFunction extends SqlExecutionFunction {
  ODBCExecutionFunction() { this.hasGlobalName(["SQLExecDirect", "SQLPrepare"]) }

  override predicate hasSqlArgument(FunctionInput input) { input.isParameterDeref(1) }
}
// NOTE: no need to define a barrier explicitly.
// `SQLBindParameter` is the typical means for sanitizing user input.
//       https://learn.microsoft.com/en-us/sql/odbc/reference/syntax/sqlbindparameter-function?view=sql-server-ver16
// First a query is establisehed via `SQLPrepare`, then parameters are bound via `SQLBindParameter`, before
// the query is executed via `SQLExecute`. We are not modeling SQLExecute, so we do not need to model SQLBindParameter.
