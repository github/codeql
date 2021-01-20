private import codeql_ruby.AST
private import internal.Call

/**
 * A method call.
 */
class Call extends Expr {
  override Call::Range range;

  override string getAPrimaryQlClass() { result = "Call" }

  final override string toString() { result = "call to " + this.getMethodName() }

  /**
   * Gets the receiver of the call, if any. For example:
   * ```rb
   * foo.bar
   * baz()
   * ```
   * The result for the call to `bar` is the `Expr` for `foo`, while the call
   * to `baz` has no result.
   */
  final Expr getReceiver() { result = range.getReceiver() }

  /**
   * Gets the name of the method being called. For example, in:
   * ```rb
   * foo.bar x, y
   * ```
   * the result is `"bar"`.
   *
   * N.B. in the following example, where the method name is a scope
   * resolution, the result is the name being resolved, i.e. `"bar"`. Use
   * `getMethodScopeResolution` to get the complete `ScopeResolution`.
   * ```rb
   * Foo::bar x, y
   * ```
   */
  final string getMethodName() { result = range.getMethodName() }

  /**
   * Gets the method name if it is a `ScopeResolution`.
   */
  final ScopeResolution getMethodScopeResolution() { result = range.getMethodScopeResolution() }

  /**
   * Gets the `n`th argument of this method call. In the following example, the
   * result for n=0 is the `IntegerLiteral` 0, while for n=1 the result is a
   * `Pair` (whose `getKey` returns the `SymbolLiteral` for `bar`, and
   * `getValue` returns the `IntegerLiteral` 1). Keyword arguments like this
   * can be accessed more naturally using the
   * `getKeywordArgument(string keyword)` predicate.
   * ```rb
   * foo(0, bar: 1)
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
      p = getAnArgument() and
      p.getKey().(SymbolLiteral).getValueText() = keyword and
      result = p.getValue()
    )
  }

  /**
   * Gets the number of arguments of this method call.
   */
  final int getNumberOfArguments() { result = count(this.getAnArgument()) }

  /**
   * Gets the block of this method call, if any.
   * ```rb
   * foo.each { |x| puts x }
   * ```
   */
  final Block getBlock() { result = range.getBlock() }
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
 * A block argument in a method call.
 * ```rb
 * foo(&block)
 * ```
 */
class BlockArgument extends Expr, @block_argument {
  final override BlockArgument::Range range;

  final override string getAPrimaryQlClass() { result = "BlockArgument" }

  final override string toString() { result = "&..." }

  /**
   * Gets the underlying expression representing the block. In the following
   * example, the result is the `Expr` for `bar`:
   * ```rb
   * foo(&bar)
   * ```
   */
  final Expr getExpr() { result = range.getExpr() }
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

  final override string toString() { result = "*..." }

  /**
   * Gets the underlying expression. In the following example, the result is
   * the `Expr` for `bar`:
   * ```rb
   * foo(*bar)
   * ```
   */
  final Expr getExpr() { result = range.getExpr() }
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

  final override string toString() { result = "**..." }

  /**
   * Gets the underlying expression. In the following example, the result is
   * the `Expr` for `bar`:
   * ```rb
   * foo(**bar)
   * ```
   */
  final Expr getExpr() { result = range.getExpr() }
}
