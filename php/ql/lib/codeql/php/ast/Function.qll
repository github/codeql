/**
 * Provides classes for PHP functions, closures, and arrow functions.
 */

private import codeql.php.AST
private import internal.TreeSitter

/** A callable (function, method, closure, or arrow function). */
class Callable extends AstNode {
  Callable() {
    this instanceof FunctionDef or
    this instanceof MethodDecl or
    this instanceof AnonymousFunction or
    this instanceof ArrowFunction
  }

  /** Gets the formal parameters node. */
  FormalParameters getParameters() {
    result = this.(FunctionDef).getParameters()
    or
    result = this.(MethodDecl).getParameters()
    or
    result = this.(AnonymousFunction).getParameters()
    or
    result = this.(ArrowFunction).getParameters()
  }

  /** Gets the `i`th parameter. */
  Parameter getParameter(int i) { result = this.getParameters().getParameter(i) }

  /** Gets a parameter. */
  Parameter getAParameter() { result = this.getParameter(_) }

  /** Gets the number of parameters. */
  int getNumberOfParameters() { result = this.getParameters().getNumberOfParameters() }
}

/** A function definition. */
class FunctionDef extends Stmt, @php_function_definition {
  override string getAPrimaryQlClass() { result = "FunctionDef" }

  /** Gets the name of this function. */
  Name getName() { php_function_definition_def(this, _, result, _) }

  /** Gets the string name of this function. */
  string getNameString() { result = this.getName().getValue() }

  /** Gets the formal parameters. */
  FormalParameters getParameters() { php_function_definition_def(this, _, _, result) }

  /** Gets the body of this function. */
  CompoundStmt getBody() { php_function_definition_def(this, result, _, _) }

  /** Gets the return type annotation, if any. */
  TypeNode getReturnType() { php_function_definition_return_type(this, result) }

  override string toString() { result = "function " + this.getNameString() }
}

/** A method declaration within a class, interface, trait, or enum. */
class MethodDecl extends AstNode, @php_method_declaration {
  override string getAPrimaryQlClass() { result = "MethodDecl" }

  /** Gets the name. */
  Name getName() { php_method_declaration_def(this, result, _) }

  /** Gets the string name. */
  string getNameString() { result = this.getName().getValue() }

  /** Gets the formal parameters. */
  FormalParameters getParameters() { php_method_declaration_def(this, _, result) }

  /** Gets the body, if any (abstract methods have no body). */
  CompoundStmt getBody() { php_method_declaration_body(this, result) }

  /** Gets the return type annotation, if any. */
  TypeNode getReturnType() { php_method_declaration_return_type(this, result) }

  override string toString() { result = "method " + this.getNameString() }
}

/** An anonymous function (closure). */
class AnonymousFunction extends Expr, @php_anonymous_function {
  override string getAPrimaryQlClass() { result = "AnonymousFunction" }

  FormalParameters getParameters() { php_anonymous_function_def(this, _, result) }

  CompoundStmt getBody() { php_anonymous_function_def(this, result, _) }

  TypeNode getReturnType() { php_anonymous_function_return_type(this, result) }

  override string toString() { result = "function (...) { ... }" }
}

/** An arrow function (`fn($x) => $x + 1`). */
class ArrowFunction extends Expr, @php_arrow_function {
  override string getAPrimaryQlClass() { result = "ArrowFunction" }

  FormalParameters getParameters() { php_arrow_function_def(this, _, result) }

  Expr getBody() { php_arrow_function_def(this, result, _) }

  TypeNode getReturnType() { php_arrow_function_return_type(this, result) }

  override string toString() { result = "fn(...) => ..." }
}

/** A formal parameters list. */
class FormalParameters extends AstNode, @php_formal_parameters {
  override string getAPrimaryQlClass() { result = "FormalParameters" }

  AstNode getParameter(int i) { php_formal_parameters_child(this, i, result) }

  AstNode getAParameter() { result = this.getParameter(_) }

  int getNumberOfParameters() {
    result = count(int i | php_formal_parameters_child(this, i, _))
  }

  override string toString() { result = "(...)" }
}
