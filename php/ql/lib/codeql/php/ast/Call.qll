/**
 * Provides classes for PHP call expressions.
 */

private import codeql.php.AST
private import internal.TreeSitter

/** A call expression (function call, method call, or static method call). */
class Call extends Expr {
  Call() {
    this instanceof @php_function_call_expression or
    this instanceof @php_member_call_expression or
    this instanceof @php_nullsafe_member_call_expression or
    this instanceof @php_scoped_call_expression
  }

  /** Gets the arguments of this call. */
  Arguments getArguments() { none() }

  /** Gets the `i`th argument expression (unwrapped from Argument wrapper). */
  AstNode getArgument(int i) {
    exists(@php_argument arg |
      php_arguments_child(this.getArguments(), i, arg) and
      php_argument_def(arg, result)
    )
  }

  /** Gets an argument of this call. */
  AstNode getAnArgument() { result = this.getArgument(_) }

  /** Gets the number of arguments. */
  int getNumberOfArguments() { result = this.getArguments().getNumberOfArguments() }
}

/** A function call expression (`func(...)` or `$var(...)`). */
class FunctionCallExpr extends Call, @php_function_call_expression {
  override string getAPrimaryQlClass() { result = "FunctionCallExpr" }

  /** Gets the function being called. */
  AstNode getFunction() { php_function_call_expression_def(this, _, result) }

  /** Gets the arguments list. */
  override Arguments getArguments() { php_function_call_expression_def(this, result, _) }

  /**
   * Gets the name of the function being called, if it is a simple name.
   */
  string getFunctionName() {
    exists(Name n |
      n = this.getFunction() and
      result = n.getValue()
    )
    or
    exists(QualifiedName qn |
      qn = this.getFunction() and
      result = qn.getValue()
    )
  }

  override string toString() { result = this.getFunctionName() + "(...)" }
}

/** A method call expression (`$obj->method(...)`). */
class MethodCallExpr extends Call, @php_member_call_expression {
  override string getAPrimaryQlClass() { result = "MethodCallExpr" }

  /** Gets the object on which the method is called. */
  AstNode getObject() { php_member_call_expression_def(this, _, _, result) }

  /** Gets the name of the method being called. */
  Name getMethodName() { php_member_call_expression_def(this, _, result, _) }

  /** Gets the arguments list. */
  override Arguments getArguments() { php_member_call_expression_def(this, result, _, _) }

  /** Gets the string name of the method being called. */
  string getMethodNameString() { result = this.getMethodName().getValue() }

  override string toString() { result = "...->(" + this.getMethodNameString() + ")(...)"}
}

/** A nullsafe method call expression (`$obj?->method(...)`). */
class NullsafeMethodCallExpr extends Call, @php_nullsafe_member_call_expression {
  override string getAPrimaryQlClass() { result = "NullsafeMethodCallExpr" }

  AstNode getObject() { php_nullsafe_member_call_expression_def(this, _, _, result) }

  Name getMethodName() { php_nullsafe_member_call_expression_def(this, _, result, _) }

  override Arguments getArguments() { php_nullsafe_member_call_expression_def(this, result, _, _) }

  string getMethodNameString() { result = this.getMethodName().getValue() }

  override string toString() { result = "...?->(" + this.getMethodNameString() + ")(...)"}
}

/** A scoped (static) call expression (`ClassName::method(...)`). */
class ScopedCallExpr extends Call, @php_scoped_call_expression {
  override string getAPrimaryQlClass() { result = "ScopedCallExpr" }

  AstNode getScope() { php_scoped_call_expression_def(this, _, _, result) }

  Name getMethodName() { php_scoped_call_expression_def(this, _, result, _) }

  override Arguments getArguments() { php_scoped_call_expression_def(this, result, _, _) }

  string getMethodNameString() { result = this.getMethodName().getValue() }

  override string toString() { result = "...::(" + this.getMethodNameString() + ")(...)"}
}
