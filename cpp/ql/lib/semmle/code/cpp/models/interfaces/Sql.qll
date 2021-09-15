/**
 * Provides abstract classes for modeling functions that execute and escape SQL query strings.
 * To use this QL library, create a QL class extending `SqlSink` or `SqlBarrier` with a
 * characteristic predicate that selects the function or set of functions you are modeling.
 * Within that class, override the predicates provided by the class to match the way a
 * parameter flows into the function and, in the case of `SqlBarrier`, out of the function.
 */

private import cpp

/**
 * An abstract class that represents a function that executes an SQL query.
 */
abstract class SqlSink extends Function {
  /**
   * Holds if `input` to this function represents SQL code to be executed.
   */
  abstract predicate getAnSqlParameter(FunctionInput input);
}

/**
 * An abstract class that represents a function that escapes an SQL query string.
 */
abstract class SqlBarrier extends Function {
  /**
   * Holds if the `output` escapes the SQL input `input` such that is it safe to pass to
   * an `SqlSink`.
   */
  abstract predicate getAnEscapedParameter(FunctionInput input, FunctionOutput output);
}
