import codeql_ruby.AST
private import codeql_ruby.Generated
private import Variable
private import Pattern
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
  Callable getCallable() { result.getAParameter() = this }

  /** Gets the zero-based position of this parameter. */
  int getPosition() { result = pos }
}

/**
 * A parameter defined using a pattern.
 *
 * This includes both simple parameters and tuple parameters.
 */
class PatternParameter extends Parameter, Pattern {
  override string toString() { result = Pattern.super.toString() }

  override Location getLocation() { result = Pattern.super.getLocation() }
}

/** A parameter defined using a tuple pattern. */
class TuplePatternParameter extends PatternParameter, TuplePattern {
  override string toString() { result = TuplePattern.super.toString() }

  override string describeQlClass() { result = "TuplePatternParameter" }
}

/** A named parameter. */
class NamedParameter extends Parameter {
  NamedParameter() { not this instanceof TuplePattern }

  /** Gets the name of this parameter. */
  string getName() { none() }

  /** Gets the variable introduced by this parameter. */
  Variable getVariable() { none() }

  /** Gets an access to this parameter. */
  final VariableAccess getAnAccess() { result = this.getVariable().getAnAccess() }
}

/** A simple (normal) parameter. */
class SimpleParameter extends NamedParameter, PatternParameter, VariablePattern {
  override string getName() { result = VariablePattern.super.getName() }

  final override Variable getVariable() { result = TLocalVariable(_, _, this) }

  override string describeQlClass() { result = "SimpleParameter" }

  override string toString() { result = this.getName() }
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
  override Generated::BlockParameter generated;

  final override Variable getVariable() { result = TLocalVariable(_, _, generated.getName()) }

  override string describeQlClass() { result = "BlockParameter" }

  override string toString() { result = "&" + this.getName() }

  override string getName() { result = generated.getName().getValue() }
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
  override Generated::HashSplatParameter generated;

  final override Variable getVariable() { result = TLocalVariable(_, _, generated.getName()) }

  override string describeQlClass() { result = "HashSplatParameter" }

  override string toString() { result = "**" + this.getName() }

  override string getName() { result = generated.getName().getValue() }
}

/**
 * TODO
 */
class KeywordParameter extends @keyword_parameter, NamedParameter {
  override Generated::KeywordParameter generated;

  final override Variable getVariable() { result = TLocalVariable(_, _, generated.getName()) }

  override string describeQlClass() { result = "KeywordParameter" }

  override string getName() { result = generated.getName().getValue() }

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
 * ```rb
 * def say_hello(name = 'Anon')
 *   puts "hello #{name}"
 * end
 * ```
 */
class OptionalParameter extends @optional_parameter, NamedParameter {
  override Generated::OptionalParameter generated;

  final override Variable getVariable() { result = TLocalVariable(_, _, generated.getName()) }

  override string describeQlClass() { result = "OptionalParameter" }

  override string toString() { result = this.getName() }

  override string getName() { result = generated.getName().getValue() }

  /**
   * Gets the default value, i.e. the value assigned to the parameter when one
   * is not provided by the caller.
   * TODO: better return type (Expr?)
   */
  AstNode getDefaultValue() { result = generated.getValue() }
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
  override Generated::SplatParameter generated;

  final override Variable getVariable() { result = TLocalVariable(_, _, generated.getName()) }

  override string describeQlClass() { result = "SplatParameter" }

  override string toString() { result = this.getName() }

  override string getName() { result = generated.getName().getValue() }
}
