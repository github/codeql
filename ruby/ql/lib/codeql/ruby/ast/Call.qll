private import codeql.ruby.AST
private import internal.AST
private import internal.Call
private import internal.TreeSitter
private import codeql.ruby.dataflow.internal.DataFlowDispatch
private import codeql.ruby.dataflow.internal.DataFlowImplCommon

/**
 * A call.
 */
class Call extends Expr instanceof CallImpl {
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
  final Expr getArgument(int n) { result = super.getArgumentImpl(n) }

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
      p.getKey().getConstantValue().isSymbol(keyword) and
      result = p.getValue()
    )
  }

  /**
   * Gets the number of arguments of this method call.
   */
  final int getNumberOfArguments() { result = super.getNumberOfArgumentsImpl() }

  /** Gets a potential target of this call, if any. */
  final Callable getATarget() {
    exists(DataFlowCall c |
      this = c.asCall().getExpr() and
      TCfgScope(result) = viableCallableLambda(c, _)
    )
    or
    result = getTarget(TNormalCall(this.getAControlFlowNode()))
  }

  override AstNode getAChild(string pred) {
    result = Expr.super.getAChild(pred)
    or
    pred = "getArgument" and result = this.getArgument(_)
  }
}

/**
 * A method call.
 */
class MethodCall extends Call instanceof MethodCallImpl {
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
  final Expr getReceiver() { result = super.getReceiverImpl() }

  /**
   * Gets the name of the method being called. For example, in:
   *
   * ```rb
   * foo.bar x, y
   * ```
   *
   * the result is `"bar"`.
   *
   * Super calls call a method with the same name as the current method, so
   * the result for a super call is the name of the current method.
   * E.g:
   * ```rb
   * def foo
   *  super # the result for this super call is "foo"
   * end
   * ```
   */
  final string getMethodName() { result = super.getMethodNameImpl() }

  /**
   * Gets the block of this method call, if any.
   * ```rb
   * foo.each { |x| puts x }
   * ```
   */
  final Block getBlock() { result = super.getBlockImpl() }

  /**
   * Gets the block argument of this method call, if any.
   * ```rb
   * foo(&block)
   * ```
   */
  final BlockArgument getBlockArgument() { result = this.getAnArgument() }

  /** Holds if this method call has a block or block argument. */
  final predicate hasBlock() { exists(this.getBlock()) or exists(this.getBlockArgument()) }

  /**
   * Holds if the safe navigation operator (`&.`) is used in this call.
   * ```rb
   * foo&.empty?
   * ```
   */
  final predicate isSafeNavigation() { super.isSafeNavigationImpl() }

  override string toString() { result = "call to " + this.getMethodName() }

  override AstNode getAChild(string pred) {
    result = Call.super.getAChild(pred)
    or
    pred = "getReceiver" and result = this.getReceiver()
    or
    pred = "getBlock" and result = this.getBlock()
  }
}

/**
 * A `Method` call that has no known target.
 * These will typically be calls to methods inherited from a superclass.
 * TODO: When API Graphs is able to resolve calls to methods like `Kernel.send`
 * this class is no longer necessary and should be removed.
 */
class UnknownMethodCall extends MethodCall {
  UnknownMethodCall() { not exists(this.(Call).getATarget()) }
}

/**
 * A call to a setter method.
 * ```rb
 * self.foo = 10
 * a[0] = 10
 * ```
 */
class SetterMethodCall extends MethodCall, TMethodCallSynth {
  SetterMethodCall() { this = TMethodCallSynth(_, _, _, true, _) }

  final override string getAPrimaryQlClass() { result = "SetterMethodCall" }

  /**
   * Gets the name of the method being called without the trailing `=`. For example, in the following
   * two statements the target name is `value`:
   * ```rb
   * foo.value=(1)
   * foo.value = 1
   * ```
   */
  final string getTargetName() {
    exists(string methodName |
      methodName = this.getMethodName() and
      result = methodName.prefix(methodName.length() - 1)
    )
  }
}

/**
 * An element reference; a call to the `[]` method.
 * ```rb
 * a[0]
 * ```
 */
class ElementReference extends MethodCall instanceof ElementReferenceImpl {
  final override string getAPrimaryQlClass() { result = "ElementReference" }

  final override string toString() { result = "...[...]" }
}

/**
 * A call to `yield`.
 * ```rb
 * yield x, y
 * ```
 */
class YieldCall extends Call instanceof YieldCallImpl {
  final override string getAPrimaryQlClass() { result = "YieldCall" }

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
class SuperCall extends MethodCall instanceof SuperCallImpl {
  final override string getAPrimaryQlClass() { result = "SuperCall" }

  override string toString() { result = "super call to " + this.getMethodName() }
}

/**
 * A block argument in a method call.
 * ```rb
 * foo(&block)
 * ```
 */
class BlockArgument extends Expr, TBlockArgument {
  private Ruby::BlockArgument g;

  BlockArgument() { this = TBlockArgument(g) }

  final override string getAPrimaryQlClass() { result = "BlockArgument" }

  /**
   * Gets the underlying expression representing the block. In the following
   * example, the result is the `Expr` for `bar`:
   * ```rb
   * foo(&bar)
   * ```
   */
  final Expr getValue() {
    toGenerated(result) = g.getChild() or
    synthChild(this, 0, result)
  }

  final override string toString() { result = "&..." }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getValue" and result = this.getValue()
  }
}

/**
 * A `...` expression that contains forwarded arguments.
 * ```rb
 * foo(...)
 * ```
 */
class ForwardedArguments extends Expr, TForwardArgument {
  private Ruby::ForwardArgument g;

  ForwardedArguments() { this = TForwardArgument(g) }

  final override string getAPrimaryQlClass() { result = "ForwardedArguments" }

  final override string toString() { result = "..." }
}
