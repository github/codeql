private import codeql.ruby.AST
private import internal.AST
private import internal.Variable
private import internal.Parameter
private import internal.TreeSitter

/** A parameter. */
class Parameter extends AstNode, TParameter {
  /** Gets the callable that this parameter belongs to. */
  final Callable getCallable() {
    result.getAParameter() = this
    or
    exists(DestructuredParameter parent |
      this = parent.getAnElement() and
      result = parent.getCallable()
    )
  }

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
 * A parameter defined using destructuring. For example
 *
 * ```rb
 * def tuples((a,b))
 *   puts "#{a} #{b}"
 * end
 * ```
 */
class DestructuredParameter extends Parameter, TDestructuredParameter {
  private DestructuredParameterImpl getImpl() { result = toGenerated(this) }

  private Ruby::AstNode getChild(int i) { result = this.getImpl().getChildNode(i) }

  /** Gets the `i`th element in this destructured parameter. */
  final AstNode getElement(int i) {
    exists(Ruby::AstNode c | c = this.getChild(i) | toGenerated(result) = c)
  }

  /** Gets an element in this destructured parameter. */
  final AstNode getAnElement() { result = this.getElement(_) }

  override LocalVariable getAVariable() {
    result = this.getAnElement().(LocalVariableWriteAccess).getVariable()
    or
    result = this.getAnElement().(DestructuredParameter).getAVariable()
  }

  override string toString() { result = "(..., ...)" }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getElement" and result = this.getElement(_)
  }

  final override string getAPrimaryQlClass() { result = "DestructuredParameter" }
}

/**
 * DEPRECATED
 *
 * A parameter defined using a pattern.
 *
 * This includes both simple parameters and tuple parameters.
 */
deprecated class PatternParameter extends Parameter, Pattern, TPatternParameter {
  override LocalVariable getAVariable() { result = Pattern.super.getAVariable() }
}

/**
 * DEPRECATED
 *
 * A parameter defined using a tuple pattern.
 */
deprecated class TuplePatternParameter extends PatternParameter, TuplePattern,
  TDestructuredParameter {
  final override LocalVariable getAVariable() { result = TuplePattern.super.getAVariable() }
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
class SimpleParameter extends NamedParameter, TSimpleParameter instanceof SimpleParameterImpl {
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

  /** Gets the name of this parameter, if any. */
  final override string getName() { result = g.getName().getValue() }

  final override LocalVariable getVariable() {
    result = TLocalVariableReal(_, _, g.getName()) or
    result = TLocalVariableSynth(this, 0)
  }

  final override string toString() {
    result = "&" + this.getName()
    or
    not exists(this.getName()) and result = "&"
  }

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
 * A `nil` hash splat (`**nil`) indicating that there are no keyword parameters or keyword patterns.
 * For example:
 * ```rb
 * def foo(bar, **nil)
 *   case bar
 *   in { x:, **nil } then puts x
 *   end
 * end
 * ```
 */
class HashSplatNilParameter extends Parameter, THashSplatNilParameter {
  final override string getAPrimaryQlClass() { result = "HashSplatNilParameter" }

  final override string toString() { result = "**nil" }
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
