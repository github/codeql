private import codeql_ruby.AST
private import internal.AST
private import internal.TreeSitter

/**
 * A call.
 */
class Call extends Expr, TCall {
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
  Expr getArgument(int n) { none() }

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

  override AstNode getAChild(string pred) { pred = "getArgument" and result = this.getArgument(_) }
}

bindingset[s]
private string getMethodName(MethodCall mc, string s) {
  (
    not mc instanceof LhsExpr
    or
    mc.getParent() instanceof AssignOperation
  ) and
  result = s
  or
  mc instanceof LhsExpr and
  result = s + "="
}

/**
 * A method call.
 */
class MethodCall extends Call, TMethodCall {
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
  Expr getReceiver() { none() }

  /**
   * Holds if the receiver is `self` or there is no receiver, which has the same
   * meaning as an explict `self`. For example:
   *
   * ```rb
   * self.foo
   * foo
   * ```
   */
  predicate receiverIsSelf() {
    this.getReceiver() instanceof Self
    or
    not exists(this.getReceiver())
  }

  /**
   * Gets the name of the method being called. For example, in:
   *
   * ```rb
   * foo.bar x, y
   * ```
   *
   * the result is `"bar"`.
   */
  string getMethodName() { none() }

  /**
   * Gets the block of this method call, if any.
   * ```rb
   * foo.each { |x| puts x }
   * ```
   */
  Block getBlock() { none() }

  override string toString() { result = "call to " + concat(this.getMethodName(), "/") }

  final override AstNode getAChild(string pred) {
    result = Call.super.getAChild(pred)
    or
    pred = "getReceiver" and result = this.getReceiver()
    or
    pred = "getBlock" and result = this.getBlock()
  }
}

private class IdentifierMethodCall extends MethodCall, TIdentifierMethodCall {
  private Generated::Identifier g;

  IdentifierMethodCall() { this = TIdentifierMethodCall(g) }

  final override string getMethodName() { result = getMethodName(this, g.getValue()) }
}

private class ScopeResolutionMethodCall extends MethodCall, TScopeResolutionMethodCall {
  private Generated::ScopeResolution g;
  private Generated::Identifier i;

  ScopeResolutionMethodCall() { this = TScopeResolutionMethodCall(g, i) }

  final override Expr getReceiver() { toGenerated(result) = g.getScope() }

  final override string getMethodName() { result = getMethodName(this, i.getValue()) }
}

private class RegularMethodCall extends MethodCall, TRegularMethodCall {
  private Generated::Call g;

  RegularMethodCall() { this = TRegularMethodCall(g) }

  final override Expr getReceiver() {
    toGenerated(result) = g.getReceiver()
    or
    not exists(g.getReceiver()) and
    toGenerated(result) = g.getMethod().(Generated::ScopeResolution).getScope()
  }

  final override string getMethodName() {
    exists(string res | result = getMethodName(this, res) |
      res = "call" and g.getMethod() instanceof Generated::ArgumentList
      or
      res = g.getMethod().(Generated::Token).getValue()
      or
      res = g.getMethod().(Generated::ScopeResolution).getName().(Generated::Token).getValue()
    )
  }

  final override Expr getArgument(int n) {
    toGenerated(result) = g.getArguments().getChild(n)
    or
    toGenerated(result) = g.getMethod().(Generated::ArgumentList).getChild(n)
  }

  final override Block getBlock() { toGenerated(result) = g.getBlock() }
}

/**
 * A call to a setter method.
 * ```rb
 * self.foo = 10
 * a[0] = 10
 * ```
 */
class SetterMethodCall extends MethodCall, LhsExpr {
  final override string getAPrimaryQlClass() { result = "SetterMethodCall" }
}

/**
 * An element reference; a call to the `[]` method.
 * ```rb
 * a[0]
 * ```
 */
class ElementReference extends MethodCall, TElementReference {
  private Generated::ElementReference g;

  ElementReference() { this = TElementReference(g) }

  final override string getAPrimaryQlClass() { result = "ElementReference" }

  final override Expr getReceiver() { toGenerated(result) = g.getObject() }

  final override string getMethodName() { result = getMethodName(this, "[]") }

  final override Expr getArgument(int n) { toGenerated(result) = g.getChild(n) }

  final override string toString() { result = "...[...]" }
}

/**
 * A call to `yield`.
 * ```rb
 * yield x, y
 * ```
 */
class YieldCall extends Call, TYieldCall {
  private Generated::Yield g;

  YieldCall() { this = TYieldCall(g) }

  final override string getAPrimaryQlClass() { result = "YieldCall" }

  final override Expr getArgument(int n) { toGenerated(result) = g.getChild().getChild(n) }

  final override string toString() { result = "yield ..." }
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
class SuperCall extends MethodCall, TSuperCall {
  final override string getAPrimaryQlClass() { result = "SuperCall" }
}

private class TokenSuperCall extends SuperCall, TTokenSuperCall {
  private Generated::Super g;

  TokenSuperCall() { this = TTokenSuperCall(g) }

  final override string getMethodName() { result = getMethodName(this, g.getValue()) }
}

private class RegularSuperCall extends SuperCall, TRegularSuperCall {
  private Generated::Call g;

  RegularSuperCall() { this = TRegularSuperCall(g) }

  final override string getMethodName() {
    result = getMethodName(this, g.getMethod().(Generated::Super).getValue())
  }

  final override Expr getArgument(int n) { toGenerated(result) = g.getArguments().getChild(n) }

  final override Block getBlock() { toGenerated(result) = g.getBlock() }
}

/**
 * A block argument in a method call.
 * ```rb
 * foo(&block)
 * ```
 */
class BlockArgument extends Expr, TBlockArgument {
  private Generated::BlockArgument g;

  BlockArgument() { this = TBlockArgument(g) }

  final override string getAPrimaryQlClass() { result = "BlockArgument" }

  /**
   * Gets the underlying expression representing the block. In the following
   * example, the result is the `Expr` for `bar`:
   * ```rb
   * foo(&bar)
   * ```
   */
  final Expr getValue() { toGenerated(result) = g.getChild() }

  final override string toString() { result = "&..." }

  final override AstNode getAChild(string pred) { pred = "getValue" and result = this.getValue() }
}

/**
 * A splat argument in a method call.
 * ```rb
 * foo(*args)
 * ```
 */
class SplatArgument extends Expr, TSplatArgument {
  private Generated::SplatArgument g;

  SplatArgument() { this = TSplatArgument(g) }

  final override string getAPrimaryQlClass() { result = "SplatArgument" }

  /**
   * Gets the underlying expression. In the following example, the result is
   * the `Expr` for `bar`:
   * ```rb
   * foo(*bar)
   * ```
   */
  final Expr getValue() { toGenerated(result) = g.getChild() }

  final override string toString() { result = "*..." }

  final override AstNode getAChild(string pred) { pred = "getValue" and result = this.getValue() }
}

/**
 * A hash-splat (or 'double-splat') argument in a method call.
 * ```rb
 * foo(**options)
 * ```
 */
class HashSplatArgument extends Expr, THashSplatArgument {
  private Generated::HashSplatArgument g;

  HashSplatArgument() { this = THashSplatArgument(g) }

  final override string getAPrimaryQlClass() { result = "HashSplatArgument" }

  /**
   * Gets the underlying expression. In the following example, the result is
   * the `Expr` for `bar`:
   * ```rb
   * foo(**bar)
   * ```
   */
  final Expr getValue() { toGenerated(result) = g.getChild() }

  final override string toString() { result = "**..." }

  final override AstNode getAChild(string pred) { pred = "getValue" and result = this.getValue() }
}
