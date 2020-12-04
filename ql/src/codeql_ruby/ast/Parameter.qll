private import codeql_ruby.AST
private import internal.Pattern
private import internal.TreeSitter
private import internal.Variable

/** A parameter. */
class Parameter extends AstNode {
  private int pos;

  Parameter() {
    this = any(Generated::BlockParameters bp).getChild(pos)
    or
    this = any(Generated::MethodParameters mp).getChild(pos)
    or
    this = any(Generated::LambdaParameters lp).getChild(pos)
  }

  /** Gets the callable that this parameter belongs to. */
  final Callable getCallable() { result.getAParameter() = this }

  /** Gets the zero-based position of this parameter. */
  final int getPosition() { result = pos }

  /** Gets a variable introduced by this parameter. */
  Variable getAVariable() { none() }

  /** Gets the variable named `name` introduced by this parameter. */
  final Variable getVariable(string name) {
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
  override Variable getAVariable() { result = Pattern.super.getAVariable() }
}

/** A parameter defined using a tuple pattern. */
class TuplePatternParameter extends PatternParameter, TuplePattern {
  final override string describeQlClass() { result = "TuplePatternParameter" }
}

/** A named parameter. */
class NamedParameter extends Parameter {
  NamedParameter() { not this instanceof TuplePattern }

  /** Gets the name of this parameter. */
  string getName() { none() }

  /** Gets the variable introduced by this parameter. */
  Variable getVariable() { none() }

  override Variable getAVariable() { result = this.getVariable() }

  /** Gets an access to this parameter. */
  final VariableAccess getAnAccess() { result = this.getVariable().getAnAccess() }
}

/** A simple (normal) parameter. */
class SimpleParameter extends NamedParameter, PatternParameter, VariablePattern {
  final override string getName() { result = range.getVariableName() }

  final override Variable getVariable() { result = TLocalVariable(_, _, this) }

  final override Variable getAVariable() { result = this.getVariable() }

  final override string describeQlClass() { result = "SimpleParameter" }

  final override string toString() { result = this.getName() }
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
  final override Generated::BlockParameter generated;

  final override Variable getVariable() { result = TLocalVariable(_, _, generated.getName()) }

  final override string describeQlClass() { result = "BlockParameter" }

  final override string toString() { result = "&" + this.getName() }

  final override string getName() { result = generated.getName().getValue() }
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
  final override Generated::HashSplatParameter generated;

  final override Variable getVariable() { result = TLocalVariable(_, _, generated.getName()) }

  final override string describeQlClass() { result = "HashSplatParameter" }

  final override string toString() { result = "**" + this.getName() }

  final override string getName() { result = generated.getName().getValue() }
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
  final override Generated::KeywordParameter generated;

  final override Variable getVariable() { result = TLocalVariable(_, _, generated.getName()) }

  final override string describeQlClass() { result = "KeywordParameter" }

  final override string getName() { result = generated.getName().getValue() }

  /**
   * Gets the default value, i.e. the value assigned to the parameter when one
   * is not provided by the caller. If the parameter is mandatory and does not
   * have a default value, this predicate has no result.
   * TODO: better return type (Expr?)
   */
  final AstNode getDefaultValue() { result = generated.getValue() }

  /**
   * Holds if the parameter is optional. That is, there is a default value that
   * is used when the caller omits this parameter.
   */
  final predicate isOptional() { exists(this.getDefaultValue()) }

  final override string toString() { result = this.getName() }
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
  final override Generated::OptionalParameter generated;

  final override Variable getVariable() { result = TLocalVariable(_, _, generated.getName()) }

  final override string describeQlClass() { result = "OptionalParameter" }

  final override string toString() { result = this.getName() }

  final override string getName() { result = generated.getName().getValue() }

  /**
   * Gets the default value, i.e. the value assigned to the parameter when one
   * is not provided by the caller.
   * TODO: better return type (Expr?)
   */
  final AstNode getDefaultValue() { result = generated.getValue() }
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
  final override Generated::SplatParameter generated;

  final override Variable getVariable() { result = TLocalVariable(_, _, generated.getName()) }

  final override string describeQlClass() { result = "SplatParameter" }

  final override string toString() { result = "*" + this.getName() }

  final override string getName() { result = generated.getName().getValue() }
}
