/**
 * Provides classes that define callables that can be overridden or
 * implemented.
 */

import csharp

/**
 * A callable that can be overridden or implemented.
 *
 * Unlike the class `Overridable`, this class only includes callables that
 * can actually be overridden/implemented.
 */
class OverridableCallable extends Callable, Overridable {
  OverridableCallable() { this.isOverridableOrImplementable() }

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
    result = this.getAnImplementor(t)
    or
    exists(ValueOrRefType mid |
      result = this.getAnImplementorSubType(mid) and
      t.getBaseClass() = mid and
      // There must be no other implementation of this callable in `t`
      forall(Callable other | other = this.getAnImplementor(t) | other = result)
    )
  }

  /**
   * Gets a callable that overrides (transitively) another callable that
   * implements this interface callable, if any.
   */
  private Callable getAnOverridingImplementor() {
    result = this.getAnUltimateImplementor() and
    not result = this.getAnImplementor(_)
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
    result = this.getInherited0(t)
    or
    // An interface implementation
    result = this.getAnImplementorSubType(t)
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

  pragma[nomagic]
  private predicate isDeclaringSubType(ValueOrRefType t) {
    t = this.getDeclaringType()
    or
    exists(ValueOrRefType mid | this.isDeclaringSubType(mid) | t = mid.getASubType())
  }

  pragma[nomagic]
  private predicate isDeclaringSubType(ValueOrRefType t, ValueOrRefType sub) {
    this.isDeclaringSubType(t) and
    t = sub.getABaseType()
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
    exists(ValueOrRefType mid | result = this.getAnOverrider(mid) | this.isDeclaringSubType(t, mid))
  }
}

/** An unbound type. */
class UnboundDeclarationType extends Type {
  UnboundDeclarationType() { this.isUnboundDeclaration() }
}
