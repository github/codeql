/**
 * @name PHP 8.0+ Named Arguments
 * @description Analysis for named arguments in function calls
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A named argument in a function call (name: value).
 */
class NamedArgument extends TS::PHP::Argument {
  NamedArgument() {
    exists(this.getName())
  }

  /** Gets the argument name */
  string getArgumentName() {
    result = this.getName().(TS::PHP::Name).getValue()
  }

  /** Gets the argument value */
  TS::PHP::AstNode getArgumentValue() {
    result = this.getChild()
  }
}

/**
 * Checks if a function call uses named arguments.
 */
predicate usesNamedArguments(TS::PHP::FunctionCallExpression call) {
  exists(NamedArgument arg | arg.getParent+() = call)
}

/**
 * Checks if a method call uses named arguments.
 */
predicate methodUsesNamedArguments(TS::PHP::MemberCallExpression call) {
  exists(NamedArgument arg | arg.getParent+() = call)
}

/**
 * Gets the number of named arguments in a call.
 */
int countNamedArguments(TS::PHP::FunctionCallExpression call) {
  result = count(NamedArgument arg | arg.getParent+() = call)
}
