private import codeql_ruby.AST
private import internal.Call

/**
 * A call.
 */
class Call extends Expr {
  override Call::Range range;

  override string getAPrimaryQlClass() { result = "Call" }

  /**
   * Gets the `n`th argument of this method call. In the following example, the
   * result for n=0 is the `IntegerLiteral` 0, while for n=1 the result is a
   * `Pair` (whose `getKey` returns the `SymbolLiteral` for `bar`, and
   * `getValue` returns the `IntegerLiteral` 1). Keyword arguments like this
   * can be accessed more naturally using the
   * `getKeywordArgument(string keyword)` predicate.
   * ```rb
   * foo(0, bar: 1)
   * yield 0, bar: 1
   * ```
   */
  final Expr getArgument(int n) { result = range.getArgument(n) }

  /**
   * Gets an argument of this method call.
   */
  final Expr getAnArgument() { result = this.getArgument(_) }

  /**
   * Gets the value of the keyword argument whose key is `keyword`, if any. For
   * example, the result for `getKeywordArgument("qux")` in the following
   * example is the `IntegerLiteral` 123.
   * ```rb
   * foo :bar "baz", qux: 123
   * ```
   */
  final Expr getKeywordArgument(string keyword) {
    exists(Pair p |
      p = this.getAnArgument() and
      p.getKey().(SymbolLiteral).getValueText() = keyword and
      result = p.getValue()
    )
  }

  /**
   * Gets the number of arguments of this method call.
   */
  final int getNumberOfArguments() { result = count(this.getAnArgument()) }
}

/**
 * A method call.
 */
class MethodCall extends Call {
  override MethodCall::Range range;

  override string getAPrimaryQlClass() { result = "MethodCall" }

  /**
   * Gets the receiver of this call, if any. For example:
   *
   * ```rb
   * foo.bar
   * Baz::qux
   * corge()
   * ```
   *
   * The result for the call to `bar` is the `Expr` for `foo`; the result for
   * the call to `qux` is the `Expr` for `Baz`; for the call to `corge` there
   * is no result.
   */
  final Expr getReceiver() { result = range.getReceiver() }

  /**
   * Gets the name of the method being called. For example, in:
   *
   * ```rb
   * foo.bar x, y
   * ```
   *
   * the result is `"bar"`.
   */
  final string getMethodName() { result = range.getMethodName() }

  /**
   * Gets the block of this method call, if any.
   * ```rb
   * foo.each { |x| puts x }
   * ```
   */
  final Block getBlock() { result = range.getBlock() }
}

/**
 * A call to a setter method.
 * ```rb
 * self.foo = 10
 * a[0] = 10
 * ```
 */
class SetterMethodCall extends MethodCall, LhsExpr {
  final override SetterMethodCall::Range range;

  final override string getAPrimaryQlClass() { result = "SetterMethodCall" }
}

/**
 * An element reference; a call to the `[]` method.
 * ```rb
 * a[0]
 * ```
 */
class ElementReference extends MethodCall, @element_reference {
  final override ElementReference::Range range;

  final override string getAPrimaryQlClass() { result = "ElementReference" }
}

/**
 * A call to `yield`.
 * ```rb
 * yield x, y
 * ```
 */
class YieldCall extends Call, @yield {
  final override YieldCall::Range range;

  final override string getAPrimaryQlClass() { result = "YieldCall" }
}

/**
 * A call to `super`.
 * ```rb
 * class Foo < Bar
 *   def baz
 *     super
 *   end
 * end
 * ```
 */
class SuperCall extends MethodCall {
  final override SuperCall::Range range;

  final override string getAPrimaryQlClass() { result = "SuperCall" }
}

/**
 * A block argument in a method call.
 * ```rb
 * foo(&block)
 * ```
 */
class BlockArgument extends Expr, @block_argument {
  final override BlockArgument::Range range;

  final override string getAPrimaryQlClass() { result = "BlockArgument" }

  /**
   * Gets the underlying expression representing the block. In the following
   * example, the result is the `Expr` for `bar`:
   * ```rb
   * foo(&bar)
   * ```
   */
  final Expr getValue() { result = range.getValue() }
}

/**
 * A splat argument in a method call.
 * ```rb
 * foo(*args)
 * ```
 */
class SplatArgument extends Expr, @splat_argument {
  final override SplatArgument::Range range;

  final override string getAPrimaryQlClass() { result = "SplatArgument" }

  /**
   * Gets the underlying expression. In the following example, the result is
   * the `Expr` for `bar`:
   * ```rb
   * foo(*bar)
   * ```
   */
  final Expr getValue() { result = range.getValue() }
}

/**
 * A hash-splat (or 'double-splat') argument in a method call.
 * ```rb
 * foo(**options)
 * ```
 */
class HashSplatArgument extends Expr, @hash_splat_argument {
  final override HashSplatArgument::Range range;

  final override string getAPrimaryQlClass() { result = "HashSplatArgument" }

  /**
   * Gets the underlying expression. In the following example, the result is
   * the `Expr` for `bar`:
   * ```rb
   * foo(**bar)
   * ```
   */
  final Expr getValue() { result = range.getValue() }
}
