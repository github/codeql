/**
 * @name PHP 8.5+ URI Extension
 * @description Analysis for URI extension usage
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A function call to URI extension functions.
 */
class UriExtensionCall extends TS::PHP::FunctionCallExpression {
  UriExtensionCall() {
    exists(string name | name = this.getFunction().(TS::PHP::Name).getValue() |
      name in [
        "Uri\\create", "Uri\\parse", "Uri\\build",
        "Uri\\normalize", "Uri\\resolve", "Uri\\join"
      ]
    )
  }

  /** Gets the function name */
  string getFunctionName() {
    result = this.getFunction().(TS::PHP::Name).getValue()
  }
}

/**
 * Checks if a call uses the URI extension.
 */
predicate isUriExtensionCall(TS::PHP::FunctionCallExpression call) {
  call instanceof UriExtensionCall
}
