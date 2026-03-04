/**
 * Provides classes for PHP parameters.
 */

private import codeql.php.AST
private import internal.TreeSitter

/** A parameter in a function, method, closure, or arrow function. */
class Parameter extends AstNode {
  Parameter() {
    this instanceof SimpleParameter or
    this instanceof VariadicParameter or
    this instanceof PropertyPromotionParameter
  }

  /** Gets the name of this parameter as a variable name node. */
  VariableName getVariableName() { none() }

  /** Gets the string name of this parameter (including `$`). */
  string getNameString() { result = this.getVariableName().getValue() }

  /** Gets the type annotation, if any. */
  TypeNode getType() { none() }

  /** Gets the default value, if any. */
  Expr getDefault() { none() }

  /** Holds if this parameter has a default value. */
  predicate hasDefault() { exists(this.getDefault()) }
}

/** A simple parameter (`$x` or `Type $x`). */
class SimpleParameter extends AstNode, @php_simple_parameter {
  override string getAPrimaryQlClass() { result = "SimpleParameter" }

  /** Gets the variable name. */
  VariableName getVariableName() { php_simple_parameter_def(this, result) }

  /** Gets the type annotation, if any. */
  TypeNode getType() { php_simple_parameter_type(this, result) }

  /** Gets the default value, if any. */
  Expr getDefault() { php_simple_parameter_default_value(this, result) }

  override string toString() { result = this.getVariableName().getValue() }
}

/** A variadic parameter (`...$args`). */
class VariadicParameter extends AstNode, @php_variadic_parameter {
  override string getAPrimaryQlClass() { result = "VariadicParameter" }

  VariableName getVariableName() { php_variadic_parameter_def(this, result) }

  TypeNode getType() { php_variadic_parameter_type(this, result) }

  override string toString() { result = "..." + this.getVariableName().getValue() }
}

/** A property promotion parameter (PHP 8.0+). */
class PropertyPromotionParameter extends AstNode, @php_property_promotion_parameter {
  override string getAPrimaryQlClass() { result = "PropertyPromotionParameter" }

  VariableName getVariableName() { php_property_promotion_parameter_def(this, result, _) }

  TypeNode getType() { php_property_promotion_parameter_type(this, result) }

  Expr getDefault() { php_property_promotion_parameter_default_value(this, result) }

  override string toString() { result = this.getVariableName().getValue() }
}
