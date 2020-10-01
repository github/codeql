/**
 * Provides classes that define callables that can be overridden or
 * implemented.
 */

import csharp

/**
 * A callable that can be overridden or implemented.
 *
 * Unlike the class `Virtualizable`, this class only includes methods that
 * can actually be overriden/implemented. Additionally, this class includes
 * accessors whose declarations can actually be overridden/implemented.
 */
class OverridableCallable extends Callable {
  OverridableCallable() {
    this.(Method).isOverridableOrImplementable() or
    this.(Accessor).getDeclaration().isOverridableOrImplementable()
  }

  /** Gets a callable that immediately overrides this callable, if any. */
  Callable getAnOverrider() { none() }

  /**
   * Gets a callable that immediately implements this interface callable,
   * if any.
   */
  Callable getAnImplementor(ValueOrRefType t) { none() }

  /**
   * Gets a callable that immediately implements this interface member,
   * if any.
   *
   * The type `t` is a (transitive, reflexive) sub type of a type that
   * implements the interface type in which this callable is declared,
   * in such a way that the result is the implementation of this
   * callable.
   *
   * Example:
   *
   * ```csharp
   * interface I { void M(); }
   *
   * class A { public void M() { } }
   *
   * class B : A, I { }
   *
   * class C : A, I { new public void M() }
   *
   * class D : C
   *
   * class E : A
   * ```
   *
   * In the example above, the following (and nothing else) holds:
   * `I.M.getAnImplementorSubType(B) = A.M`,
   * `I.M.getAnImplementorSubType(C) = C.M`, and
   * `I.M.getAnImplementorSubType(D) = C.M`.
   */
  private Callable getAnImplementorSubType(ValueOrRefType t) {
    result = getAnImplementor(t)
    or
    exists(ValueOrRefType mid |
      result = getAnImplementorSubType(mid) and
      t.getBaseClass() = mid and
      // There must be no other implementation of this callable in `t`
      forall(Callable other | other = getAnImplementor(t) | other = result)
    )
  }

  /**
   * Gets a callable that (transitively) implements this interface callable,
   * if any. That is, either this interface callable is immediately implemented
   * by the result, or the result overrides (transitively) another callable that
   * immediately implements this interface callable.
   *
   * Note that this is generally *not* equivalent with
   *
   * ```ql
   * result = getAnImplementor()
   * or
   * result = getAnImplementor().(OverridableCallable).getAnOverrider+()`
   * ```
   *
   * as the example below illustrates:
   *
   * ```csharp
   * interface I { void M(); }
   *
   * class A { public virtual void M() { } }
   *
   * class B : A, I { }
   *
   * class C : A { public override void M() }
   *
   * class D : B { public override void M() }
   * ```
   *
   * If this callable is `I.M` then `A.M = getAnUltimateImplementor() ` and
   * `D.M = getAnUltimateImplementor()`. However, it is *not* the case that
   * `C.M = getAnUltimateImplementor()`, because `C` is not a sub type of `I`.
   */
  Callable getAnUltimateImplementor() { none() }

  /**
   * Gets a callable that overrides (transitively) another callable that
   * implements this interface callable, if any.
   */
  private Callable getAnOverridingImplementor() {
    result = getAnUltimateImplementor() and
    not result = getAnImplementor(_)
  }

  /**
   * Gets the unique callable inherited by (or defined in) type `t` that
   * overrides, implements, or equals this callable, where this callable
   * is defined in a (transitive, reflexive) base type of `t`.
   *
   * Example:
   *
   * ```csharp
   * class C1 { public virtual void M() { } }
   *
   * class C2 : C1 { public override void M() { } }
   *
   * class C3 : C2 { }
   * ```
   *
   * The following holds:
   *
   * - `C1.M = C1.M.getInherited(C1)`,
   * - `C2.M = C1.M.getInherited(C2)`,
   * - `C2.M = C1.M.getInherited(C3)`,
   * - `C2.M = C2.M.getInherited(C2)`, and
   * - `C2.M = C2.M.getInherited(C3)`.
   */
  Callable getInherited(ValueOrRefType t) {
    result = this.getInherited1(t) and
    t.hasCallable(result)
  }

  private Callable getInherited0(ValueOrRefType t) {
    // A (transitive, reflexive) overrider
    t = this.hasOverrider(result)
    or
    // A (transitive) overrider of an interface implementation
    t = this.hasOverridingImplementor(result)
    or
    exists(ValueOrRefType mid | result = this.getInherited0(mid) | t = mid.getASubType())
  }

  private Callable getInherited1(ValueOrRefType t) {
    result = getInherited0(t)
    or
    // An interface implementation
    result = getAnImplementorSubType(t)
  }

  pragma[noinline]
  private ValueOrRefType hasOverrider(Callable c) {
    c = this.getAnOverrider*() and
    result = c.getDeclaringType()
  }

  pragma[noinline]
  private ValueOrRefType hasOverridingImplementor(Callable c) {
    c = this.getAnOverridingImplementor() and
    result = c.getDeclaringType()
  }

  private predicate isDeclaringSubType(ValueOrRefType t) {
    t = this.getDeclaringType()
    or
    exists(ValueOrRefType mid | isDeclaringSubType(mid) | t = mid.getASubType())
  }

  pragma[noinline]
  private Callable getAnOverrider0(ValueOrRefType t) {
    // A (transitive) overrider
    result = this.getAnOverrider+() and
    t = result.getDeclaringType()
    or
    // An interface implementation
    result = this.getAnImplementorSubType(t)
    or
    // A (transitive) overrider of an interface implementation
    result = this.getAnOverridingImplementor() and
    t = result.getDeclaringType()
  }

  /**
   * Gets a callable defined in a sub type of `t` (which is itself a sub type
   * of this callable's declaring type) that overrides/implements this callable,
   * if any.
   *
   * The type `t` may be a constructed type: For example, if `t = C<int>`,
   * then only callables defined in sub types of `C<int>` (and e.g. not
   * `C<string>`) are valid. In particular, if `C2<T> : C<T>` and `C2`
   * contains a callable that overrides this callable, then only if `C2<int>`
   * is ever constructed will the callable in `C2` be considered valid.
   */
  Callable getAnOverrider(ValueOrRefType t) {
    result = this.getAnOverrider0(t)
    or
    exists(ValueOrRefType mid | result = this.getAnOverrider(mid) |
      t = mid.getABaseType() and
      this.isDeclaringSubType(t)
    )
  }
}

/** An overridable method. */
class OverridableMethod extends Method, OverridableCallable {
  override Method getAnOverrider() { result = Method.super.getAnOverrider() }

  override Method getAnImplementor(ValueOrRefType t) { result = Method.super.getAnImplementor(t) }

  override Method getAnUltimateImplementor() { result = Method.super.getAnUltimateImplementor() }

  override Method getInherited(ValueOrRefType t) {
    result = OverridableCallable.super.getInherited(t)
  }

  override Method getAnOverrider(ValueOrRefType t) {
    result = OverridableCallable.super.getAnOverrider(t)
  }
}

/** An overridable accessor. */
class OverridableAccessor extends Accessor, OverridableCallable {
  override Accessor getAnOverrider() { overrides(result, this) }

  override Accessor getAnImplementor(ValueOrRefType t) {
    exists(Virtualizable implementor, int kind |
      getAnImplementorAux(t, implementor, kind) and
      result.getDeclaration() = implementor and
      getAccessorKind(result) = kind
    )
  }

  // predicate folding to get proper join order
  private predicate getAnImplementorAux(ValueOrRefType t, Virtualizable implementor, int kind) {
    exists(Virtualizable implementee |
      implementee = getDeclaration() and
      kind = getAccessorKind(this) and
      implementor = implementee.getAnImplementor(t)
    )
  }

  override Accessor getAnUltimateImplementor() {
    exists(Virtualizable implementor, int kind |
      getAnUltimateImplementorAux(implementor, kind) and
      result.getDeclaration() = implementor and
      getAccessorKind(result) = kind
    )
  }

  // predicate folding to get proper join order
  private predicate getAnUltimateImplementorAux(Virtualizable implementor, int kind) {
    exists(Virtualizable implementee |
      implementee = getDeclaration() and
      kind = getAccessorKind(this) and
      implementor = implementee.getAnUltimateImplementor()
    )
  }

  override Accessor getInherited(ValueOrRefType t) {
    result = OverridableCallable.super.getInherited(t)
  }

  override Accessor getAnOverrider(ValueOrRefType t) {
    result = OverridableCallable.super.getAnOverrider(t)
  }
}

private int getAccessorKind(Accessor a) {
  accessors(a, result, _, _, _) or
  event_accessors(a, -result, _, _, _)
}

/** A source declared type. */
class SourceDeclarationType extends Type {
  SourceDeclarationType() { this = this.getSourceDeclaration() }
}
