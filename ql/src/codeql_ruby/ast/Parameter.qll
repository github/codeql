private import codeql_ruby.AST
private import internal.Pattern
private import internal.Variable
private import internal.Parameter

/** A parameter. */
class Parameter extends AstNode {
  override Parameter::Range range;

  /** Gets the callable that this parameter belongs to. */
  final Callable getCallable() { result.getAParameter() = this }

  /** Gets the zero-based position of this parameter. */
  final int getPosition() { result = range.getPosition() }

  /** Gets a variable introduced by this parameter. */
  LocalVariable getAVariable() { result = range.getAVariable() }

  /** Gets the variable named `name` introduced by this parameter. */
  final LocalVariable getVariable(string name) {
    result = this.getAVariable() and
    result.getName() = name
  }
}

/**
 * A parameter defined using a pattern.
 *
 * This includes both simple parameters and tuple parameters.
 */
class PatternParameter extends Parameter, Pattern {
  override PatternParameter::Range range;

  override LocalVariable getAVariable() { result = Pattern.super.getAVariable() }
}

/** A parameter defined using a tuple pattern. */
class TuplePatternParameter extends PatternParameter, TuplePattern {
  override TuplePatternParameter::Range range;

  final override string getAPrimaryQlClass() { result = "TuplePatternParameter" }
}

/** A named parameter. */
class NamedParameter extends Parameter {
  override NamedParameter::Range range;

  /** Gets the name of this parameter. */
  final string getName() { result = range.getName() }

  /** Gets the variable introduced by this parameter. */
  LocalVariable getVariable() { result = range.getVariable() }

  override LocalVariable getAVariable() { result = this.getVariable() }

  /** Gets an access to this parameter. */
  final VariableAccess getAnAccess() { result = this.getVariable().getAnAccess() }
}

/** A simple (normal) parameter. */
class SimpleParameter extends NamedParameter, PatternParameter, VariablePattern {
  override SimpleParameter::Range range;

  final override LocalVariable getVariable() { result = range.getVariable() }

  final override LocalVariable getAVariable() { result = range.getAVariable() }

  final override string getAPrimaryQlClass() { result = "SimpleParameter" }
}

/**
 * A parameter that is a block. For example, `&bar` in the following code:
 * ```rb
 * def foo(&bar)
 *   bar.call if block_given?
 * end
 * ```
 */
class BlockParameter extends @block_parameter, NamedParameter {
  final override BlockParameter::Range range;

  final override LocalVariable getVariable() { result = range.getVariable() }

  final override string getAPrimaryQlClass() { result = "BlockParameter" }
}

/**
 * A hash-splat (or double-splat) parameter. For example, `**options` in the
 * following code:
 * ```rb
 * def foo(bar, **options)
 *   ...
 * end
 * ```
 */
class HashSplatParameter extends @hash_splat_parameter, NamedParameter {
  final override HashSplatParameter::Range range;

  final override string getAPrimaryQlClass() { result = "HashSplatParameter" }
}

/**
 * A keyword parameter, including a default value if the parameter is optional.
 * For example, in the following example, `foo` is a keyword parameter with a
 * default value of `0`, and `bar` is a mandatory keyword parameter with no
 * default value mandatory parameter).
 * ```rb
 * def f(foo: 0, bar:)
 *   foo * 10 + bar
 * end
 * ```
 */
class KeywordParameter extends @keyword_parameter, NamedParameter {
  final override KeywordParameter::Range range;

  final override string getAPrimaryQlClass() { result = "KeywordParameter" }

  /**
   * Gets the default value, i.e. the value assigned to the parameter when one
   * is not provided by the caller. If the parameter is mandatory and does not
   * have a default value, this predicate has no result.
   */
  final Expr getDefaultValue() { result = range.getDefaultValue() }

  /**
   * Holds if the parameter is optional. That is, there is a default value that
   * is used when the caller omits this parameter.
   */
  final predicate isOptional() { exists(this.getDefaultValue()) }
}

/**
 * An optional parameter. For example, the parameter `name` in the following
 * code:
 * ```rb
 * def say_hello(name = 'Anon')
 *   puts "hello #{name}"
 * end
 * ```
 */
class OptionalParameter extends @optional_parameter, NamedParameter {
  final override OptionalParameter::Range range;

  final override string getAPrimaryQlClass() { result = "OptionalParameter" }

  /**
   * Gets the default value, i.e. the value assigned to the parameter when one
   * is not provided by the caller.
   */
  final Expr getDefaultValue() { result = range.getDefaultValue() }
}

/**
 * A splat parameter. For example, `*values` in the following code:
 * ```rb
 * def foo(bar, *values)
 *   ...
 * end
 * ```
 */
class SplatParameter extends @splat_parameter, NamedParameter {
  final override SplatParameter::Range range;

  final override string getAPrimaryQlClass() { result = "SplatParameter" }
}
