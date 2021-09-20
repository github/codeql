/**
 * Provides abstract classes for modeling functions that execute and escape SQL query strings.
 * To use this QL library, create a QL class extending `SqlExecutionFunction` or `SqlEscapeFunction`
 * with a characteristic predicate that selects the function or set of functions you are modeling.
 * Within that class, override the predicates provided by the class to match the way a
 * parameter flows into the function and, in the case of `SqlEscapeFunction`, out of the function.
 */

private import cpp

/**
 * An abstract class that represents a function that executes an SQL query.
 */
abstract class SqlExecutionFunction extends Function {
  /**
   * Holds if `input` to this function represents SQL code to be executed.
   */
  abstract predicate hasSqlArgument(FunctionInput input);
}

/**
 * An abstract class that represents a function that escapes an SQL query string.
 */
abstract class SqlEscapeFunction extends Function {
  /**
   * Holds if the `output` escapes the SQL input `input` such that is it safe to pass to
   * an `SqlExecutionFunction`.
   */
  abstract predicate escapesSqlArgument(FunctionInput input, FunctionOutput output);
}
