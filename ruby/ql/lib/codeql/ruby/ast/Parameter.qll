private import codeql.ruby.AST
private import internal.AST
private import internal.Variable
private import internal.Parameter
private import internal.TreeSitter

/** A parameter. */
class Parameter extends AstNode, TParameter {
  /** Gets the callable that this parameter belongs to. */
  final Callable getCallable() { result.getAParameter() = this }

  /** Gets the zero-based position of this parameter. */
  final int getPosition() { this = any(Callable c).getParameter(result) }

  /** Gets a variable introduced by this parameter. */
  LocalVariable getAVariable() { none() }

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
class PatternParameter extends Parameter, Pattern, TPatternParameter {
  override LocalVariable getAVariable() { result = Pattern.super.getAVariable() }
}

/** A parameter defined using a tuple pattern. */
class TuplePatternParameter extends PatternParameter, TuplePattern, TTuplePatternParameter {
  final override LocalVariable getAVariable() { result = TuplePattern.super.getAVariable() }

  final override string getAPrimaryQlClass() { result = "TuplePatternParameter" }

  override AstNode getAChild(string pred) { result = TuplePattern.super.getAChild(pred) }
}

/** A named parameter. */
class NamedParameter extends Parameter, TNamedParameter {
  /** Gets the name of this parameter. */
  string getName() { none() }

  /** Holds if the name of this parameter is `name`. */
  final predicate hasName(string name) { this.getName() = name }

  /** Gets the variable introduced by this parameter. */
  LocalVariable getVariable() { none() }

  override LocalVariable getAVariable() { result = this.getVariable() }

  /** Gets an access to this parameter. */
  final VariableAccess getAnAccess() { result = this.getVariable().getAnAccess() }

  /** Gets the access that defines the underlying local variable. */
  final VariableAccess getDefiningAccess() {
    result = this.getVariable().getDefiningAccess()
    or
    result = this.(SimpleParameterSynthImpl).getDefininingAccess()
  }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getDefiningAccess" and
    result = this.getDefiningAccess()
  }
}

/** A simple (normal) parameter. */
class SimpleParameter extends NamedParameter, PatternParameter, VariablePattern, TSimpleParameter instanceof SimpleParameterImpl {
  final override string getName() { result = SimpleParameterImpl.super.getNameImpl() }

  final override LocalVariable getVariable() {
    result = SimpleParameterImpl.super.getVariableImpl()
  }

  final override LocalVariable getAVariable() { result = this.getVariable() }

  final override string getAPrimaryQlClass() { result = "SimpleParameter" }

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
class BlockParameter extends NamedParameter, TBlockParameter {
  private Ruby::BlockParameter g;

  BlockParameter() { this = TBlockParameter(g) }

  final override string getName() { result = g.getName().getValue() }

  final override LocalVariable getVariable() { result = TLocalVariableReal(_, _, g.getName()) }

  final override string toString() { result = "&" + this.getName() }

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
class HashSplatParameter extends NamedParameter, THashSplatParameter {
  private Ruby::HashSplatParameter g;

  HashSplatParameter() { this = THashSplatParameter(g) }

  final override string getAPrimaryQlClass() { result = "HashSplatParameter" }

  final override LocalVariable getVariable() { result = TLocalVariableReal(_, _, g.getName()) }

  final override string toString() { result = "**" + this.getName() }

  final override string getName() { result = g.getName().getValue() }
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
class KeywordParameter extends NamedParameter, TKeywordParameter {
  private Ruby::KeywordParameter g;

  KeywordParameter() { this = TKeywordParameter(g) }

  final override string getAPrimaryQlClass() { result = "KeywordParameter" }

  final override LocalVariable getVariable() { result = TLocalVariableReal(_, _, g.getName()) }

  /**
   * Gets the default value, i.e. the value assigned to the parameter when one
   * is not provided by the caller. If the parameter is mandatory and does not
   * have a default value, this predicate has no result.
   */
  final Expr getDefaultValue() { toGenerated(result) = g.getValue() }

  /**
   * Holds if the parameter is optional. That is, there is a default value that
   * is used when the caller omits this parameter.
   */
  final predicate isOptional() { exists(this.getDefaultValue()) }

  final override string toString() { result = this.getName() }

  final override string getName() { result = g.getName().getValue() }

  final override Location getLocation() { result = g.getName().getLocation() }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getDefaultValue" and result = this.getDefaultValue()
  }
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
class OptionalParameter extends NamedParameter, TOptionalParameter {
  private Ruby::OptionalParameter g;

  OptionalParameter() { this = TOptionalParameter(g) }

  final override string getAPrimaryQlClass() { result = "OptionalParameter" }

  /**
   * Gets the default value, i.e. the value assigned to the parameter when one
   * is not provided by the caller.
   */
  final Expr getDefaultValue() { toGenerated(result) = g.getValue() }

  final override LocalVariable getVariable() { result = TLocalVariableReal(_, _, g.getName()) }

  final override string toString() { result = this.getName() }

  final override string getName() { result = g.getName().getValue() }

  final override Location getLocation() { result = g.getName().getLocation() }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getDefaultValue" and result = this.getDefaultValue()
  }
}

/**
 * A splat parameter. For example, `*values` in the following code:
 * ```rb
 * def foo(bar, *values)
 *   ...
 * end
 * ```
 */
class SplatParameter extends NamedParameter, TSplatParameter {
  private Ruby::SplatParameter g;

  SplatParameter() { this = TSplatParameter(g) }

  final override string getAPrimaryQlClass() { result = "SplatParameter" }

  final override LocalVariable getVariable() { result = TLocalVariableReal(_, _, g.getName()) }

  final override string toString() { result = "*" + this.getName() }

  final override string getName() { result = g.getName().getValue() }
}

/**
 * A special `...` parameter that forwards positional/keyword/block arguments:
 * ```rb
 * def foo(...)
 * end
 * ```
 */
class ForwardParameter extends Parameter, TForwardParameter {
  final override string getAPrimaryQlClass() { result = "ForwardParameter" }

  final override string toString() { result = "..." }
}
