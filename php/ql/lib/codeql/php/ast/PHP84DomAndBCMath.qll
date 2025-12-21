/**
 * @name PHP 8.4+ DOM and BCMath
 * @description Analysis for DOM and BCMath improvements
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A call to BCMath functions.
 */
class BcMathCall extends TS::PHP::FunctionCallExpression {
  BcMathCall() {
    exists(string name | name = this.getFunction().(TS::PHP::Name).getValue() |
      name.matches("bc%")
    )
  }

  /** Gets the function name */
  string getFunctionName() {
    result = this.getFunction().(TS::PHP::Name).getValue()
  }
}

/**
 * Checks if a call uses BCMath functions.
 */
predicate isBcMathCall(TS::PHP::FunctionCallExpression call) {
  call instanceof BcMathCall
}

/**
 * A call using the new DOM API (Dom\HTMLDocument, etc.).
 */
class DomApiCall extends TS::PHP::ScopedCallExpression {
  DomApiCall() {
    exists(string scope | scope = this.getScope().(TS::PHP::QualifiedName).toString() |
      scope.matches("Dom\\%") or scope.matches("\\Dom\\%")
    )
  }

  /** Gets the class name being called */
  string getClassName() {
    result = this.getScope().(TS::PHP::QualifiedName).toString()
  }
}
