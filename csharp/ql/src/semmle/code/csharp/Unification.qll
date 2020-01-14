import csharp
private import Conversion
private import Caching

/**
 * INTERNAL: Do not use.
 *
 * Provides an implementation of Global Value Numbering for types (see
 * https://en.wikipedia.org/wiki/Global_value_numbering), where types are considered
 * equal modulo identity conversions and type parameters.
 */
module Gvn {
  private class LeafType extends Type {
    LeafType() {
      not exists(this.getAChild()) and
      not this instanceof TypeParameter and
      not this instanceof DynamicType
    }
  }

  /** A type kind for a compound type. */
  class CompoundTypeKind extends TCompoundTypeKind {
    /** Gets the number of type parameters for this kind. */
    int getNumberOfTypeParameters() {
      this = TPointerTypeKind() and result = 1
      or
      this = TNullableTypeKind() and result = 1
      or
      this = TArrayTypeKind(_, _) and result = 1
      or
      exists(UnboundGenericType ugt | this = TConstructedType(ugt) |
        result = ugt.getNumberOfTypeParameters()
      )
    }

    /** Gets a textual representation of this kind when applied to arguments `args`. */
    bindingset[args]
    string toString(string args) {
      this = TPointerTypeKind() and result = args + "*"
      or
      this = TNullableTypeKind() and result = args + "?"
      or
      exists(int rnk | this = TArrayTypeKind(_, rnk) |
        result = args + "[" + concat(int i | i in [0 .. rnk - 2] | ",") + "]"
      )
      or
      exists(UnboundGenericType ugt | this = TConstructedType(ugt) |
        result = ugt.getNameWithoutBrackets() + "<" + args + ">"
      )
    }

    /** Gets a textual representation of this kind. */
    string toString() { result = toString("") }

    /** Gets the location of this kind. */
    Location getLocation() { result instanceof EmptyLocation }
  }

  /** Gets the type kind for type `t`, if any. */
  CompoundTypeKind getTypeKind(Type t) {
    result = TPointerTypeKind() and t instanceof PointerType
    or
    result = TNullableTypeKind() and t instanceof NullableType
    or
    t = any(ArrayType at | result = TArrayTypeKind(at.getDimension(), at.getRank()))
    or
    result = TConstructedType(t.(ConstructedType).getUnboundGeneric())
    or
    result = TConstructedType(t.(TupleType).getUnderlyingType().getUnboundGeneric())
    or
    result = TConstructedType(t)
  }

  /**
   * A global value number for a type. Two types have the same GVN when they
   * are structurally equal modulo type parameters and identity conversions.
   * For example, `Func<T, int>` and `Func<S, int>` have the same GVN, but
   * `Func<T, int>` and `Func<string, int>` do not.
   */
  class GvnType extends TGvnType {
    /** Gets the compound type kind of this GVN, if any. */
    CompoundTypeKind getKind() { none() }

    /** Gets a textual representation of this GVN. */
    cached
    string toString() {
      Stages::UnificationStage::forceCachingInSameStage() and
      exists(LeafType t | this = TLeafGvnType(t) | result = t.toString())
      or
      this instanceof TTypeParameterGvnType and
      result = "T"
      or
      exists(ConstructedGvnTypeList l | this = TConstructedGvnType(l) | result = l.toString())
    }

    /** Gets the location of this GVN. */
    Location getLocation() { result instanceof EmptyLocation }
  }

  class TypeParameterGvnType extends GvnType, TTypeParameterGvnType { }

  class ConstructedGvnType extends GvnType, TConstructedGvnType {
    private ConstructedGvnTypeList l;

    ConstructedGvnType() { this = TConstructedGvnType(l) }

    override CompoundTypeKind getKind() { result = l.getKind() }
  }

  private ConstructedGvnTypeList gvnConstructed(Type t, CompoundTypeKind k, int i) {
    result = TConstructedGvnTypeNil(k) and
    i = -1 and
    k = getTypeKind(t)
    or
    exists(GvnType head, ConstructedGvnTypeList tail | gvnConstructedCons(t, k, i, head, tail) |
      result = TConstructedGvnTypeCons(head, tail)
    )
  }

  pragma[noinline]
  private GvnType gvnTypeChild(Type t, int i) { result = getGlobalValueNumber(t.getChild(i)) }

  pragma[noinline]
  private predicate gvnConstructedCons(
    Type t, CompoundTypeKind k, int i, GvnType head, ConstructedGvnTypeList tail
  ) {
    tail = gvnConstructed(t, k, i - 1) and
    head = gvnTypeChild(t, i)
  }

  private class ConstructedGvnTypeList extends TConstructedGvnTypeList {
    CompoundTypeKind getKind() { this = gvnConstructed(_, result, _) }

    private int length() {
      this = TConstructedGvnTypeNil(_) and result = -1
      or
      exists(ConstructedGvnTypeList tail | this = TConstructedGvnTypeCons(_, tail) |
        result = tail.length() + 1
      )
    }

    GvnType getArg(int i) {
      exists(GvnType head, ConstructedGvnTypeList tail |
        this = TConstructedGvnTypeCons(head, tail)
      |
        result = head and
        i = this.length()
        or
        result = tail.getArg(i)
      )
    }

    language[monotonicAggregates]
    string toString() {
      exists(CompoundTypeKind k, string args |
        k = this.getKind() and
        args = concat(int i |
            i in [0 .. k.getNumberOfTypeParameters() - 1]
          |
            this.getArg(i).toString(), "," order by i
          ) and
        result = k.toString(args)
      )
    }

    Location getLocation() { result instanceof EmptyLocation }
  }

  /** A GVN type that is an argument in a constructed type. */
  private class GvnTypeArgument extends GvnType {
    GvnTypeArgument() { this = any(ConstructedGvnTypeList l).getArg(_) }
  }

  /** Gets the 'i'th type argument of GVN type `t`, which is of kind `k`. */
  private GvnTypeArgument getTypeArgument(CompoundTypeKind k, ConstructedGvnType t, int i) {
    exists(ConstructedGvnTypeList l | t = TConstructedGvnType(l) |
      result = l.getArg(i) and
      k = l.getKind()
    )
  }

  pragma[noinline]
  private GvnTypeArgument getNonTypeParameterTypeArgument(
    CompoundTypeKind k, ConstructedGvnType t, int i
  ) {
    result = getTypeArgument(k, t, i) and
    result != TTypeParameterGvnType()
  }

  pragma[noinline]
  private predicate typeArgumentIsTypeParameter(CompoundTypeKind k, ConstructedGvnType t, int i) {
    getTypeArgument(k, t, i) = TTypeParameterGvnType()
  }

  /**
   * Hold if (non-type-parameters) `arg1` and `arg2` are unifiable, and both are
   * the `i`th type argument of a compound type of kind `k`.
   */
  pragma[nomagic]
  private predicate unifiableNonTypeParameterTypeArguments(
    CompoundTypeKind k, GvnTypeArgument arg1, GvnTypeArgument arg2, int i
  ) {
    exists(int j |
      arg1 = getNonTypeParameterTypeArgument(k, _, i) and
      arg2 = getNonTypeParameterTypeArgument(k, _, j) and
      i <= j and
      j <= i
    |
      arg1 = arg2
      or
      unifiable(arg1, arg2)
    )
  }

  /**
   * Hold if `arg1` and `arg2` are unifiable, and both are the `i`th type argument
   * of a compound type of kind `k`.
   */
  pragma[nomagic]
  private predicate unifiableTypeArguments(
    CompoundTypeKind k, GvnTypeArgument arg1, GvnTypeArgument arg2, int i
  ) {
    unifiableNonTypeParameterTypeArguments(k, arg1, arg2, i)
    or
    exists(int j |
      arg1 = TTypeParameterGvnType() and
      typeArgumentIsTypeParameter(k, _, i) and
      arg2 = getTypeArgument(k, _, j) and
      i <= j and
      j <= i
    )
    or
    exists(int j |
      arg1 = getTypeArgument(k, _, i) and
      typeArgumentIsTypeParameter(k, _, j) and
      arg2 = TTypeParameterGvnType() and
      i <= j and
      j <= i
    )
  }

  pragma[nomagic]
  private predicate unifiableSingle0(
    CompoundTypeKind k, ConstructedGvnType t2, GvnTypeArgument arg1, GvnTypeArgument arg2
  ) {
    unifiableTypeArguments(k, arg1, arg2, 0) and
    arg2 = getTypeArgument(k, t2, 0) and
    k.getNumberOfTypeParameters() = 1
  }

  /**
   * Holds if the type arguments of types `t1` and `t2` are unifiable, `t1`
   * and `t2` are of the same kind, and the number of type arguments is 1.
   */
  private predicate unifiableSingle(ConstructedGvnType t1, ConstructedGvnType t2) {
    exists(CompoundTypeKind k, GvnTypeArgument arg1, GvnTypeArgument arg2 |
      unifiableSingle0(k, t2, arg1, arg2) and
      arg1 = getTypeArgument(k, t1, 0)
    )
  }

  pragma[nomagic]
  private predicate unifiableMultiple01Aux0(
    CompoundTypeKind k, ConstructedGvnType t2, GvnTypeArgument arg10, GvnTypeArgument arg21
  ) {
    exists(GvnTypeArgument arg20 |
      unifiableTypeArguments(k, arg10, arg20, 0) and
      arg20 = getTypeArgument(k, t2, 0) and
      arg21 = getTypeArgument(k, t2, 1)
    )
  }

  pragma[nomagic]
  private predicate unifiableMultiple01Aux1(
    CompoundTypeKind k, ConstructedGvnType t1, GvnTypeArgument arg10, GvnTypeArgument arg21
  ) {
    exists(GvnTypeArgument arg11 |
      unifiableTypeArguments(k, arg11, arg21, 1) and
      arg10 = getTypeArgument(k, t1, 0) and
      arg11 = getTypeArgument(k, t1, 1)
    )
  }

  /**
   * Holds if the first two type arguments of types `t1` and `t2` are unifiable,
   * and both `t1` and `t2` are of kind `k`.
   */
  private predicate unifiableMultiple01(
    CompoundTypeKind k, ConstructedGvnType t1, ConstructedGvnType t2
  ) {
    exists(GvnTypeArgument arg10, GvnTypeArgument arg21 |
      unifiableMultiple01Aux0(k, t2, arg10, arg21) and
      unifiableMultiple01Aux1(k, t1, arg10, arg21)
    )
  }

  pragma[nomagic]
  private predicate unifiableMultiple2Aux(
    CompoundTypeKind k, ConstructedGvnType t2, int i, GvnTypeArgument arg1, GvnTypeArgument arg2
  ) {
    unifiableTypeArguments(k, arg1, arg2, i) and
    arg2 = getTypeArgument(k, t2, i) and
    i >= 2
  }

  private predicate unifiableMultiple2(
    CompoundTypeKind k, ConstructedGvnType t1, ConstructedGvnType t2, int i
  ) {
    exists(GvnTypeArgument arg1, GvnTypeArgument arg2 |
      unifiableMultiple2Aux(k, t2, i, arg1, arg2) and
      arg1 = getTypeArgument(k, t1, i)
    )
  }

  /**
   * Holds if the arguments 0 through `i` (with `i >= 1`) of types
   * `t1` and `t2` are unifiable, and both `t1` and `t2` are of kind `k`.
   */
  pragma[nomagic]
  private predicate unifiableMultiple(
    CompoundTypeKind k, ConstructedGvnType t1, ConstructedGvnType t2, int i
  ) {
    unifiableMultiple01(k, t1, t2) and i = 1
    or
    unifiableMultiple(k, t1, t2, i - 1) and
    unifiableMultiple2(k, t1, t2, i)
  }

  private newtype TTypePath =
    TTypePathNil() or
    TTypePathCons(int head, TTypePath tail) { exists(getTypeAtCons(_, head, tail)) }

  /**
   * Gets the GVN inside GVN `t`, by following the path `path`, if any.
   */
  private GvnType getTypeAt(GvnType t, TTypePath path) {
    path = TTypePathNil() and
    result = t
    or
    exists(ConstructedGvnTypeList l, int head, TTypePath tail |
      t = TConstructedGvnType(l) and
      path = TTypePathCons(head, tail) and
      result = getTypeAtCons(l, head, tail)
    )
  }

  private GvnType getTypeAtCons(ConstructedGvnTypeList l, int head, TTypePath tail) {
    result = getTypeAt(l.getArg(head), tail)
  }

  /**
   * Gets the leaf GVN inside GVN `t`, by following the path `path`, if any.
   */
  private GvnType getLeafTypeAt(GvnType t, TTypePath path) {
    result = getTypeAt(t, path) and
    not result instanceof ConstructedGvnType
  }

  cached
  private module Cached {
    cached
    newtype TCompoundTypeKind =
      TPointerTypeKind() { Stages::UnificationStage::forceCachingInSameStage() } or
      TNullableTypeKind() or
      TArrayTypeKind(int dim, int rnk) {
        exists(ArrayType at | dim = at.getDimension() and rnk = at.getRank())
      } or
      TConstructedType(UnboundGenericType ugt) { exists(ugt.getATypeParameter()) }

    cached
    newtype TGvnType =
      TLeafGvnType(LeafType t) or
      TTypeParameterGvnType() or
      TConstructedGvnType(ConstructedGvnTypeList l)

    cached
    newtype TConstructedGvnTypeList =
      TConstructedGvnTypeNil(CompoundTypeKind k) or
      TConstructedGvnTypeCons(GvnType head, ConstructedGvnTypeList tail) {
        gvnConstructedCons(_, _, _, head, tail)
      }

    /** Gets the GVN for type `t`. */
    cached
    GvnType getGlobalValueNumber(Type t) {
      result = TLeafGvnType(t)
      or
      t instanceof DynamicType and
      result = TLeafGvnType(any(ObjectType ot))
      or
      t instanceof TypeParameter and
      result = TTypeParameterGvnType()
      or
      exists(ConstructedGvnTypeList l, CompoundTypeKind k, int i |
        l = gvnConstructed(t, k, i) and
        i = k.getNumberOfTypeParameters() - 1 and
        result = TConstructedGvnType(l)
      )
    }

    /**
     * Holds if GVNs `t1` and `t2` can be unified. That is, is it possible to
     * replace all type parameters in `t1` and `t2` with some GVNs (possibly
     * type parameters themselves) to make the two substituted terms equal.
     */
    cached
    predicate unifiable(ConstructedGvnType t1, ConstructedGvnType t2) {
      unifiableSingle(t1, t2)
      or
      exists(CompoundTypeKind k | unifiableMultiple(k, t1, t2, k.getNumberOfTypeParameters() - 1))
    }

    /**
     * Holds if GVN `t1` subsumes GVN `t2`. That is, is it possible to replace all
     * type parameters in `t1` with some GVNs (possibly type parameters themselves)
     * to make the two substituted terms equal.
     */
    cached
    predicate subsumes(ConstructedGvnType t1, ConstructedGvnType t2) {
      unifiable(t1, t2) and // subsumption implies unification
      forall(TTypePath path, GvnType leaf1 | leaf1 = getLeafTypeAt(t1, path) |
        exists(GvnType child2 | child2 = getTypeAt(t2, path) |
          leaf1 = TTypeParameterGvnType()
          or
          leaf1 = child2
        )
      )
    }
  }

  import Cached
}

/** Provides definitions related to type unification. */
module Unification {
  /** A type parameter that is compatible with any type. */
  class UnconstrainedTypeParameter extends TypeParameter {
    UnconstrainedTypeParameter() { not exists(getATypeConstraint(this)) }
  }

  /** A type parameter that is constrained. */
  class ConstrainedTypeParameter extends TypeParameter {
    int constraintCount;

    ConstrainedTypeParameter() { constraintCount = strictcount(getATypeConstraint(this)) }

    /**
     * Holds if this type parameter is unifiable with type `t`.
     *
     * Note: This predicate is inlined.
     */
    bindingset[t]
    predicate unifiable(Type t) { none() }

    /**
     * Holds if this type parameter subsumes type `t`
     *
     * Note: This predicate is inlined.
     */
    bindingset[t]
    predicate subsumes(Type t) { none() }
  }

  /** A type parameter that has a single constraint. */
  private class SingleConstraintTypeParameter extends ConstrainedTypeParameter {
    SingleConstraintTypeParameter() { constraintCount = 1 }

    bindingset[t]
    override predicate unifiable(Type t) {
      exists(TTypeParameterConstraint ttc | ttc = getATypeConstraint(this) |
        ttc = TRefTypeConstraint() and
        t.isRefType()
        or
        ttc = TValueTypeConstraint() and
        t.isValueType()
        or
        typeConstraintUnifiable(ttc, t)
      )
    }

    bindingset[t]
    override predicate subsumes(Type t) {
      exists(TTypeParameterConstraint ttc | ttc = getATypeConstraint(this) |
        ttc = TRefTypeConstraint() and
        t.isRefType()
        or
        ttc = TValueTypeConstraint() and
        t.isValueType()
        or
        typeConstraintSubsumes(ttc, t)
      )
    }
  }

  /** A type parameter that has multiple constraints. */
  private class MultiConstraintTypeParameter extends ConstrainedTypeParameter {
    MultiConstraintTypeParameter() { constraintCount > 1 }

    bindingset[t]
    override predicate unifiable(Type t) {
      forex(TTypeParameterConstraint ttc | ttc = getATypeConstraint(this) |
        ttc = TRefTypeConstraint() and
        t.isRefType()
        or
        ttc = TValueTypeConstraint() and
        t.isValueType()
        or
        typeConstraintUnifiable(ttc, t)
      )
    }

    bindingset[t]
    override predicate subsumes(Type t) {
      forex(TTypeParameterConstraint ttc | ttc = getATypeConstraint(this) |
        ttc = TRefTypeConstraint() and
        t.isRefType()
        or
        ttc = TValueTypeConstraint() and
        t.isValueType()
        or
        typeConstraintSubsumes(ttc, t)
      )
    }
  }

  cached
  private module Cached {
    cached
    newtype TTypeParameterConstraint =
      TRefTypeConstraint() or
      TValueTypeConstraint() or
      TTypeConstraint(Type t) {
        t = any(TypeParameterConstraints tpc).getATypeConstraint() and
        not t instanceof TypeParameter
      }

    cached
    TTypeParameterConstraint getATypeConstraint(TypeParameter tp) {
      exists(TypeParameterConstraints tpc | tpc = tp.getConstraints() |
        tpc.hasRefTypeConstraint() and
        result = TRefTypeConstraint()
        or
        tpc.hasNullableRefTypeConstraint() and
        result = TRefTypeConstraint()
        or
        tpc.hasValueTypeConstraint() and
        result = TValueTypeConstraint()
        or
        result = TTypeConstraint(tpc.getATypeConstraint())
        or
        result = getATypeConstraint(tpc.getATypeConstraint())
      )
    }

    cached
    predicate typeConstraintUnifiable(TTypeConstraint ttc, Type t) {
      exists(Type t0 | ttc = TTypeConstraint(t0) | implicitConversionRestricted(t, t0))
      or
      exists(Type t0, Type t1 | ttc = TTypeConstraint(t0) and unifiable(t0, t1) |
        implicitConversionRestricted(t, t1)
      )
    }

    cached
    predicate typeConstraintSubsumes(TTypeConstraint ttc, Type t) {
      exists(Type t0 | ttc = TTypeConstraint(t0) | implicitConversionRestricted(t, t0))
      or
      exists(Type t0, Type t1 | ttc = TTypeConstraint(t0) and subsumes(t0, t1) |
        implicitConversionRestricted(t, t1)
      )
    }
  }

  private import Cached

  /**
   * Holds if types `t1` and `t2` are unifiable. That is, is it possible to replace
   * all type parameters in `t1` and `t2` with some (other) types to make the two
   * substituted terms equal.
   *
   * This predicate covers only the case when `t1` and `t2` are constructed types;
   * the other three cases are:
   *
   * 1. Neither `t1` nor `t2` are type parameters; in this case `t1` and `t2` must
   *    be equal.
   * 2. `t1` or `t2` is an unconstrained type parameter; in this case `t1` and
   *    `t2` are always unifiable.
   * 3. `t1` or `t2` is a constrained type parameter; in this case the predicate
   *    `ConstrainedTypeParameter::unifiable()` can be used.
   *
   *
   * For performance reasons, type paramater constraints inside `t1` and `t2` are
   * *not* taken into account, and there is also no guarantee that the same type
   * parameter can be substituted with two different terms. For example, in
   *
   * ```csharp
   * class C<T1, T2>
   * {
   *     void M<T3>(C<T3, T3> c) where T3 : struct { }
   * }
   * ```
   *
   * the type `C<T3, T3>` is considered unifiable with both `C<object, object>` and
   * `C<int, bool>`.
   *
   * Note: This predicate is inlined.
   */
  pragma[inline]
  predicate unifiable(Type t1, Type t2) {
    Gvn::unifiable(Gvn::getGlobalValueNumber(t1), Gvn::getGlobalValueNumber(t2))
  }

  /**
   * Holds if type `t1` subsumes type `t2`. That is, is it possible to replace all
   * type parameters in `t1` with some (other) types to make the two types equal.
   *
   * The same limitations that apply to the predicate `unifiable()` apply to this
   * predicate as well.
   *
   * Note: This predicate is inlined.
   */
  pragma[inline]
  predicate subsumes(Type t1, Type t2) {
    Gvn::subsumes(Gvn::getGlobalValueNumber(t1), Gvn::getGlobalValueNumber(t2))
  }
}
