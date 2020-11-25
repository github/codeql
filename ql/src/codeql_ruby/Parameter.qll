import codeql_ruby.AST
private import codeql_ruby.Generated

/**
 * A parameter to a block, lambda, or method.
 */
abstract class Parameter extends AstNode {
  /**
   * Gets the position of this parameter in the parent block, lambda, or
   * method's parameter list.
   */
  int getPosition() {
    exists(Method m | m.getParameter(result) = this) or
    exists(Block b | b.getParameter(result) = this) or
    exists(Lambda l | l.getParameter(result) = this)
  }
}

/**
 * A parameter that is a block. For example, `&bar` in the following code:
 * ```
 * def foo(&bar)
 *   bar.call if block_given?
 * end
 * ```
 */
class BlockParameter extends @block_parameter, Parameter {
  Generated::BlockParameter generated;

  BlockParameter() { generated = this }

  override string describeQlClass() { result = "BlockParameter" }

  override string toString() { result = "&" + this.getName() }

  /** Gets the name of the parameter. */
  string getName() { result = generated.getName().getValue() }
}

/**
 * A parameter that is destructured. For example, the parameter `(a, b)` in the
 * following code:
 * ```
 * pairs.each do |(a, b)|
 *   puts a + b
 * end
 * ```
 */
class PatternParameter extends @destructured_parameter, Parameter, Pattern {
  Generated::DestructuredParameter generated;

  PatternParameter() { generated = this }

  override string describeQlClass() { result = "PatternParameter" }

  override string toString() { result = "(..., ...)" }

  /**
   * Gets the number of parameters of this destructuring.
   */
  override int getNumberOfElements() { result = count(this.getElement(_)) }

  /**
   * Gets the nth parameter of this pattern.
   */
  override AstNode getElement(int n) { result = generated.getChild(n) }
}

/**
 * A hash-splat (or double-splat) parameter. For example, `**options` in the
 * following code:
 * ```
 * def foo(bar, **options)
 *   ...
 * end
 * ```
 */
class HashSplatParameter extends @hash_splat_parameter, Parameter {
  Generated::HashSplatParameter generated;

  HashSplatParameter() { generated = this }

  override string describeQlClass() { result = "HashSplatParameter" }

  override string toString() { result = "**" + this.getName() }

  /** Gets the name of the parameter. */
  string getName() { result = generated.getName().getValue() }
}

/**
 * TODO
 */
class KeywordParameter extends @keyword_parameter, Parameter {
  Generated::KeywordParameter generated;

  KeywordParameter() { generated = this }

  override string describeQlClass() { result = "KeywordParameter" }

  /** Gets the name of the parameter. */
  string getName() { result = generated.getName().getValue() }

  /**
   * Gets the default value, i.e. the value assigned to the parameter when one
   * is not provided by the caller. If the parameter is mandatory and does not
   * have a default value, this predicate has no result.
   * TODO: better return type (Expr?)
   */
  AstNode getDefaultValue() { result = generated.getValue() }

  override string toString() { result = this.getName() }
}

/**
 * An optional parameter. For example, the parameter `name` in the following
 * code:
 * ```
 * def say_hello(name = 'Anon')
 *   puts "hello #{name}"
 * end
 * ```
 */
class OptionalParameter extends @optional_parameter, Parameter {
  Generated::OptionalParameter generated;

  OptionalParameter() { generated = this }

  override string describeQlClass() { result = "OptionalParameter" }

  override string toString() { result = this.getName() }

  /** Gets the name of the parameter. */
  string getName() { result = generated.getName().getValue() }

  /**
   * Gets the default value, i.e. the value assigned to the parameter when one
   * is not provided by the caller.
   * TODO: better return type (Expr?)
   */
  AstNode getDefaultValue() { result = generated.getValue() }
}

/**
 * A splat parameter. For example, `*values` in the following code:
 * ```
 * def foo(bar, *values)
 *   ...
 * end
 * ```
 */
class SplatParameter extends @splat_parameter, Parameter {
  Generated::SplatParameter generated;

  SplatParameter() { generated = this }

  override string describeQlClass() { result = "SplatParameter" }

  override string toString() { result = this.getName() }

  /** Gets the name of the parameter. */
  string getName() { result = generated.getName().getValue() }
}

/**
 * An identifier that is a parameter in a block, lambda, or method.
 */
class IdentifierParameter extends @token_identifier, Parameter {
  IdentifierParameter() {
    block_parameters_child(_, _, this) or
    destructured_parameter_child(_, _, this) or
    lambda_parameters_child(_, _, this) or
    method_parameters_child(_, _, this)
  }

  override string describeQlClass() { result = "IdentifierParameter" }

  override string toString() { result = this.getName() }

  /** Gets the name of the parameter. */
  string getName() { result = this.(Generated::Identifier).getValue() }
}
