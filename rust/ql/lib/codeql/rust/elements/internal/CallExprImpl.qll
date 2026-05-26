/**
 * This module provides a hand-modifiable wrapper around the generated class `CallExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.CallExpr

/**
 * INTERNAL: This module contains the customizable definition of `CallExpr` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.elements.internal.InvocationExprImpl::Impl as InvocationExprImpl
  private import codeql.rust.elements.internal.CallImpl::Impl as CallImpl
  private import codeql.rust.internal.PathResolution as PathResolution
  private import codeql.rust.internal.typeinference.TypeInference as TypeInference

  pragma[nomagic]
  Path getFunctionPath(CallExpr ce) { result = ce.getFunction().(PathExpr).getPath() }

  pragma[nomagic]
  PathResolution::ItemNode getResolvedFunction(CallExpr ce) {
    result = PathResolution::resolvePath(getFunctionPath(ce))
  }

  private Expr getSyntacticArg(CallExpr ce, int i) { result = ce.getArgList().getArg(i) }

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * NOTE: Consider using `Call` instead, as that excludes call expressions that are
   * instantiations of tuple structs and tuple variants.
   *
   * A call expression. For example:
   * ```rust
   * foo(42);
   * foo::<u32, u64>(42);
   * foo[0](42);
   * Option::Some(42); // tuple variant instantiation
   * ```
   */
  class CallExpr extends Generated::CallExpr, InvocationExprImpl::InvocationExpr {
    override string toStringImpl() { result = this.getFunction().toAbbreviatedString() + "(...)" }

    override Expr getSyntacticPositionalArgument(int i) { result = getSyntacticArg(this, i) }
  }

  /**
   * A call expression that is _not_ an instantiation of a tuple struct or a tuple variant.
   *
   * For example:
   * ```rust
   * foo(42);
   * foo::<u32, u64>(42);
   * foo[0](42);
   * foo(1) = 4;
   * ```
   */
  class CallExprCall extends CallExpr, CallImpl::Call {
    CallExprCall() {
      not this instanceof TupleStructExpr and
      not this instanceof TupleVariantExpr
    }

    override Expr getPositionalArgument(int i) { result = getSyntacticArg(this, i) }
  }

  /**
   * A call expression that targets a closure (or any value that implements
   * `Fn`, `FnMut`, or `FnOnce`).
   *
   * Dynamic calls never have a static target, and the set of potential
   * run-time targets is only available internally to the data flow library.
   */
  class DynamicCallExpr extends CallExprCall {
    DynamicCallExpr() {
      exists(Expr f | f = this.getFunction() |
        // All calls to complex expressions and local variable accesses are lambda calls
        f instanceof PathExpr implies f = any(Variable v).getAnAccess()
      )
    }
  }

  /**
   * A call expression that is a _potential_ method call.
   *
   * Note: In order to prevent the AST layer from relying on the type inference
   * layer, we do not check that the resolved target is a method in the charpred,
   * instead we check this in `getPositionalArgument` and `getReceiver`.
   */
  class CallExprMethodCall extends CallImpl::MethodCall, CallExprCall {
    CallExprMethodCall() { not this instanceof DynamicCallExpr }

    private predicate isInFactMethodCall() { this.getResolvedTarget() instanceof Method }

    override Expr getPositionalArgument(int i) {
      if this.isInFactMethodCall()
      then result = getSyntacticArg(this, i + 1)
      else result = getSyntacticArg(this, i)
    }

    override Expr getReceiver() {
      this.isInFactMethodCall() and
      result = getSyntacticArg(this, 0)
    }
  }

  /**
   * A call expression that instantiates a tuple struct.
   *
   * For example:
   * ```rust
   * struct S(u32, u64);
   * let s = S(42, 84);
   * ```
   */
  class TupleStructExpr extends CallExpr {
    private Struct struct;

    TupleStructExpr() { struct = getResolvedFunction(this) }

    /** Gets the struct that is instantiated. */
    Struct getStruct() { result = struct }

    /** Gets the `i`th tuple field of the instantiated struct. */
    pragma[nomagic]
    TupleField getTupleField(int i) { result = this.getStruct().getTupleField(i) }

    override string getAPrimaryQlClass() { result = "TupleStructExpr" }
  }

  /**
   * A call expression that instantiates a tuple variant.
   *
   * For example:
   * ```rust
   * enum E {
   *     V(u32, u64),
   * }
   * let e = E::V(42, 84);
   * ```
   */
  class TupleVariantExpr extends CallExpr {
    private Variant variant;

    TupleVariantExpr() { variant = getResolvedFunction(this) }

    /** Gets the variant that is instantiated. */
    Variant getVariant() { result = variant }

    /** Gets the `i`th tuple field of the instantiated variant. */
    pragma[nomagic]
    TupleField getTupleField(int i) { result = this.getVariant().getTupleField(i) }

    override string getAPrimaryQlClass() { result = "TupleVariantExpr" }
  }
}
