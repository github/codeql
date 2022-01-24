/**
 * Provides classes and predicates for working with generic types.
 *
 * A generic type as declared in the program, for example
 *
 * ```
 *   class X<T> { }
 * ```
 * is represented by a `GenericType`.
 *
 * A parameterized instance of such a type, for example
 *
 * ```
 *   X<String>
 * ```
 * is represented by a `ParameterizedType`.
 *
 * For dealing with legacy code that is unaware of generics, every generic type has a
 * "raw" version, represented by a `RawType`. In the example, `X` is the raw version of
 * `X<T>`.
 *
 * The erasure of a parameterized or raw type is its generic counterpart.
 *
 * Type parameters may have bounds as in
 *
 * ```
 *   class X<T extends Number> { }
 * ```
 * which are represented by a `TypeBound`.
 *
 * The terminology for generic methods is analogous.
 */

import Type

/**
 * A generic type is a type that has a type parameter.
 *
 * For example, `X` in `class X<T> { }`.
 */
class GenericType extends ClassOrInterface {
  GenericType() { typeVars(_, _, _, _, this) }

  /**
   * Gets a parameterization of this generic type, where each use of
   * a formal type parameter has been replaced by its argument.
   *
   * For example, `List<Number>` is a parameterization of
   * the generic type `List<E>`, where `E` is a type parameter.
   */
  ParameterizedType getAParameterizedType() { result.getErasure() = this }

  /**
   * Gets the raw type corresponding to this generic type.
   *
   * The raw version of this generic type is the type that is formed by
   * using the name of this generic type without specifying its type arguments.
   *
   * For example, `List` is the raw version of the generic type
   * `List<E>`, where `E` is a type parameter.
   */
  RawType getRawType() { result.getErasure() = this }

  /**
   * Gets the `i`-th type parameter of this generic type.
   */
  TypeVariable getTypeParameter(int i) { typeVars(result, _, i, _, this) }

  /**
   * Gets a type parameter of this generic type.
   */
  TypeVariable getATypeParameter() { result = this.getTypeParameter(_) }

  /**
   * Gets the number of type parameters of this generic type.
   */
  int getNumberOfTypeParameters() { result = strictcount(this.getATypeParameter()) }

  override string getAPrimaryQlClass() { result = "GenericType" }
}

/** A generic type that is a class. */
class GenericClass extends GenericType, Class {
  override string getAPrimaryQlClass() {
    result = Class.super.getAPrimaryQlClass() or
    result = GenericType.super.getAPrimaryQlClass()
  }
}

/** A generic type that is an interface. */
class GenericInterface extends GenericType, Interface {
  override string getAPrimaryQlClass() {
    result = Interface.super.getAPrimaryQlClass() or
    result = GenericType.super.getAPrimaryQlClass()
  }
}

/**
 * A common super-class for Java types that may have a type bound.
 * This includes type parameters and wildcards.
 */
abstract class BoundedType extends RefType, @boundedtype {
  /** Holds if this type is bounded. */
  predicate hasTypeBound() { exists(this.getATypeBound()) }

  /** Gets a type bound for this type, if any. */
  TypeBound getATypeBound() { result.getBoundedType() = this }

  /** Gets the first type bound for this type, if any. */
  TypeBound getFirstTypeBound() { result = this.getATypeBound() and result.getPosition() = 0 }

  /**
   * Gets an upper type bound of this type, or `Object`
   * if no explicit type bound is present.
   */
  abstract RefType getUpperBoundType();

  /**
   * Gets the first upper type bound of this type, or `Object`
   * if no explicit type bound is present.
   */
  abstract RefType getFirstUpperBoundType();

  /** Gets a transitive upper bound for this type that is not itself a bounded type. */
  RefType getAnUltimateUpperBoundType() {
    result = this.getUpperBoundType() and not result instanceof BoundedType
    or
    result = this.getUpperBoundType().(BoundedType).getAnUltimateUpperBoundType()
  }

  override string getAPrimaryQlClass() { result = "BoundedType" }
}

/**
 * A type parameter used in the declaration of a generic type or method.
 *
 * For example, `T` is a type parameter in
 * `class X<T> { }` and in `<T> void m() { }`.
 */
class TypeVariable extends BoundedType, @typevariable {
  /** Gets the generic type that is parameterized by this type parameter, if any. */
  GenericType getGenericType() { typeVars(this, _, _, _, result) }

  /** Gets the generic callable that is parameterized by this type parameter, if any. */
  GenericCallable getGenericCallable() { typeVars(this, _, _, _, result) }

  /**
   * Gets an upper bound of this type parameter, or `Object`
   * if no explicit type bound is present.
   */
  pragma[nomagic]
  override RefType getUpperBoundType() {
    if this.hasTypeBound()
    then result = this.getATypeBound().getType()
    else result instanceof TypeObject
  }

  /**
   * Gets the first upper bound of this type parameter, or `Object`
   * if no explicit type bound is present.
   */
  pragma[nomagic]
  override RefType getFirstUpperBoundType() {
    if this.hasTypeBound()
    then result = this.getFirstTypeBound().getType()
    else result instanceof TypeObject
  }

  /** Gets the lexically enclosing package of this type parameter, if any. */
  override Package getPackage() {
    result = this.getGenericType().getPackage() or
    result = this.getGenericCallable().getDeclaringType().getPackage()
  }

  /** Finds a type that was supplied for this parameter. */
  RefType getASuppliedType() {
    exists(RefType typearg |
      exists(GenericType gen, int pos |
        this = gen.getTypeParameter(pos) and
        typearg = gen.getAParameterizedType().getTypeArgument(pos)
      )
      or
      typearg = any(GenericCall call).getATypeArgument(this)
    |
      if typearg.(Wildcard).isUnconstrained() and this.hasTypeBound()
      then result.(Wildcard).getUpperBound().getType() = this.getUpperBoundType()
      else result = typearg
    )
  }

  /** Finds a non-typevariable type that was transitively supplied for this parameter. */
  RefType getAnUltimatelySuppliedType() {
    result = this.getASuppliedType() and not result instanceof TypeVariable
    or
    result = this.getASuppliedType().(TypeVariable).getAnUltimatelySuppliedType()
  }

  override string getAPrimaryQlClass() { result = "TypeVariable" }
}

/**
 * A wildcard used as a type argument.
 *
 * For example, in
 *
 * ```
 *   Map<? extends Number, ? super Float>
 * ```
 * the first wildcard has an upper bound of `Number`
 * and the second wildcard has a lower bound of `Float`.
 */
class Wildcard extends BoundedType, @wildcard {
  /**
   * Holds if this wildcard is either unconstrained (i.e. `?`) or
   * has a type bound.
   */
  override predicate hasTypeBound() { BoundedType.super.hasTypeBound() }

  /**
   * Holds if this wildcard is either unconstrained (i.e. `?`) or
   * has an upper bound.
   */
  predicate hasUpperBound() { wildcards(this, _, 1) }

  /** Holds if this wildcard has a lower bound. */
  predicate hasLowerBound() { wildcards(this, _, 2) }

  /** Gets the upper bound for this wildcard, if any. */
  TypeBound getUpperBound() { this.hasUpperBound() and result = this.getATypeBound() }

  /**
   * Gets an upper bound type of this wildcard, or `Object`
   * if no explicit type bound is present.
   */
  override RefType getUpperBoundType() {
    if this.hasUpperBound()
    then result = this.getUpperBound().getType()
    else result instanceof TypeObject
  }

  /**
   * Gets the first upper bound type of this wildcard, or `Object`
   * if no explicit type bound is present.
   */
  override RefType getFirstUpperBoundType() {
    if this.hasUpperBound()
    then result = this.getFirstTypeBound().getType()
    else result instanceof TypeObject
  }

  /** Gets the lower bound of this wildcard, if any. */
  TypeBound getLowerBound() { this.hasLowerBound() and result = this.getATypeBound() }

  /**
   * Gets the lower bound type for this wildcard,
   * if an explicit lower bound is present.
   */
  Type getLowerBoundType() { result = this.getLowerBound().getType() }

  /**
   * Holds if this is the unconstrained wildcard `?`.
   */
  predicate isUnconstrained() {
    not this.hasLowerBound() and
    wildcards(this, "?", _)
  }

  override string getAPrimaryQlClass() { result = "Wildcard" }
}

/**
 * A type bound on a type variable.
 *
 * For example, `Number` is a type bound on the type variable
 * `T` in `class X<T extends Number> { }`.
 *
 * Type variables can have multiple type bounds, specified by
 * an intersection type `T0 & T1 & ... & Tn`.
 * A bound with position 0 is an interface type or class type (possibly `Object`) and
 * a bound with a non-zero position is an interface type.
 */
class TypeBound extends @typebound {
  /**
   * Gets the type variable that is bounded by this type bound.
   *
   * For example, `T` is the type variable bounded by the
   * type `Number` in `T extends Number`.
   */
  BoundedType getBoundedType() { typeBounds(this, _, _, result) }

  /**
   * Gets the type of this bound.
   *
   * For example, `Number` is the type of the bound (of
   * the type variable `T`) in `T extends Number`.
   */
  RefType getType() { typeBounds(this, result, _, _) }

  /**
   * Gets the (zero-indexed) position of this bound.
   *
   * For example, in
   *
   * ```
   *   class X<T extends Runnable & Cloneable> { }
   * ```
   * the position of the bound `Runnable` is 0 and
   * the position of the bound `Cloneable` is 1.
   */
  int getPosition() { typeBounds(this, _, result, _) }

  /** Gets a textual representation of this type bound. */
  string toString() { result = this.getType().getName() }
}

// -------- Parameterizations of generic types  --------
/**
 * A parameterized type is an instantiation of a generic type, where
 * each formal type variable has been replaced with a type argument.
 *
 * For example, `List<Number>` is a parameterization of
 * the generic type `List<E>`, where `E` is a type parameter.
 */
class ParameterizedType extends ClassOrInterface {
  ParameterizedType() {
    typeArgs(_, _, this) or
    typeVars(_, _, _, _, this)
  }

  /**
   * The erasure of a parameterized type is its generic counterpart.
   *
   * For example, the erasure of both `X<Number>` and `X<Integer>` is `X<T>`.
   */
  override RefType getErasure() { erasure(this, result) or this.(GenericType) = result }

  /**
   * Gets the generic type corresponding to this parameterized type.
   *
   * For example, the generic type for both `X<Number>` and `X<Integer>` is `X<T>`.
   */
  GenericType getGenericType() { result.getAParameterizedType() = this }

  /**
   * Gets a type argument for this parameterized type.
   *
   * For example, `Number` in `List<Number>`.
   */
  RefType getATypeArgument() {
    typeArgs(result, _, this) or
    typeVars(result, _, _, _, this)
  }

  /** Gets the type argument of this parameterized type at the specified position. */
  RefType getTypeArgument(int pos) {
    typeArgs(result, pos, this) or
    typeVars(result, _, pos, _, this)
  }

  /** Gets the number of type arguments of this parameterized type. */
  int getNumberOfTypeArguments() {
    result =
      count(int pos |
        typeArgs(_, pos, this) or
        typeVars(_, _, pos, _, this)
      )
  }

  /** Holds if this type originates from source code. */
  override predicate fromSource() {
    typeVars(_, _, _, _, this) and ClassOrInterface.super.fromSource()
  }

  override string getAPrimaryQlClass() { result = "ParameterizedType" }
}

/** A parameterized type that is a class. */
class ParameterizedClass extends Class, ParameterizedType {
  override string getAPrimaryQlClass() {
    result = Class.super.getAPrimaryQlClass() or
    result = ParameterizedType.super.getAPrimaryQlClass()
  }
}

/** A parameterized type that is an interface. */
class ParameterizedInterface extends Interface, ParameterizedType {
  override string getAPrimaryQlClass() {
    result = Interface.super.getAPrimaryQlClass() or
    result = ParameterizedType.super.getAPrimaryQlClass()
  }
}

/**
 * The raw version of a generic type is the type that is formed by
 * using the name of a generic type without specifying its type arguments.
 *
 * For example, `List` is the raw version of the generic type
 * `List<E>`, where `E` is a type parameter.
 *
 * Raw types typically occur in legacy code that was written
 * prior to the introduction of generic types in Java 5.
 */
class RawType extends RefType {
  RawType() { isRaw(this) }

  /**
   * The erasure of a raw type is its generic counterpart.
   *
   * For example, the erasure of `List` is `List<E>`.
   */
  override RefType getErasure() { erasure(this, result) }

  /** Holds if this type originates from source code. */
  override predicate fromSource() { not any() }

  override string getAPrimaryQlClass() { result = "RawType" }
}

/** A raw type that is a class. */
class RawClass extends Class, RawType {
  override string getAPrimaryQlClass() {
    result = Class.super.getAPrimaryQlClass() or
    result = RawType.super.getAPrimaryQlClass()
  }
}

/** A raw type that is an interface. */
class RawInterface extends Interface, RawType {
  override string getAPrimaryQlClass() {
    result = Interface.super.getAPrimaryQlClass() or
    result = RawType.super.getAPrimaryQlClass()
  }
}

// -------- Generic callables  --------
/**
 * A generic callable is a callable with a type parameter.
 */
class GenericCallable extends Callable {
  GenericCallable() {
    exists(Callable srcDecl |
      methods(this, _, _, _, _, srcDecl) or constrs(this, _, _, _, _, srcDecl)
    |
      typeVars(_, _, _, _, srcDecl)
    )
  }

  /**
   * Gets the `i`-th type parameter of this generic callable.
   */
  TypeVariable getTypeParameter(int i) { typeVars(result, _, i, _, this.getSourceDeclaration()) }

  /**
   * Gets a type parameter of this generic callable.
   */
  TypeVariable getATypeParameter() { result = this.getTypeParameter(_) }

  /**
   * Gets the number of type parameters of this generic callable.
   */
  int getNumberOfTypeParameters() { result = strictcount(this.getATypeParameter()) }
}

/**
 * A call where the callee is a generic callable.
 */
class GenericCall extends Call {
  GenericCall() { this.getCallee() instanceof GenericCallable }

  private RefType getAnInferredTypeArgument(TypeVariable v) {
    typevarArg(this, v, result)
    or
    not typevarArg(this, v, _) and
    v = this.getCallee().(GenericCallable).getATypeParameter() and
    result.(Wildcard).getUpperBound().getType() = v.getUpperBoundType()
  }

  private RefType getAnExplicitTypeArgument(TypeVariable v) {
    exists(GenericCallable gen, MethodAccess call, int i |
      this = call and
      gen = call.getCallee() and
      v = gen.getTypeParameter(i) and
      result = call.getTypeArgument(i).getType()
    )
  }

  /** Gets a type argument of the call for the given `TypeVariable`. */
  RefType getATypeArgument(TypeVariable v) {
    result = this.getAnExplicitTypeArgument(v)
    or
    not exists(this.getAnExplicitTypeArgument(v)) and
    result = this.getAnInferredTypeArgument(v)
  }
}

/** Infers a type argument of `call` for `v` using a simple unification. */
private predicate typevarArg(Call call, TypeVariable v, RefType typearg) {
  exists(GenericCallable gen |
    gen = call.getCallee() and
    v = gen.getATypeParameter()
  |
    hasSubstitution(gen.getReturnType(), call.(Expr).getType(), v, typearg) or
    exists(int n |
      hasSubtypedSubstitution(gen.getParameterType(n), call.getArgument(n).getType(), v, typearg)
    )
  )
}

/**
 * The reflexive transitive closure of `RefType.extendsOrImplements` including reflexivity on `Type`s.
 */
private Type getShallowSupertype(Type t) { result = t or t.(RefType).extendsOrImplements+(result) }

/**
 * Manual magic sets optimization for the "inputs" of `hasSubstitution` and
 * `hasParameterSubstitution`.
 */
private predicate unificationTargets(RefType t1, Type t2) {
  exists(GenericCallable gen, Call call | gen = call.getCallee() |
    t1 = gen.getReturnType() and t2 = call.(Expr).getType()
    or
    exists(int n |
      t1 = gen.getParameterType(n) and t2 = getShallowSupertype(call.getArgument(n).getType())
    )
  )
  or
  exists(Array a1, Array a2 |
    unificationTargets(a1, a2) and
    t1 = a1.getComponentType() and
    t2 = a2.getComponentType()
  )
  or
  exists(ParameterizedType pt1, ParameterizedType pt2, int pos |
    unificationTargets(pt1, pt2) and
    t1 = pt1.getTypeArgument(pos) and
    t2 = pt2.getTypeArgument(pos)
  )
}

/**
 * Unifies `t1` and `t2` with respect to `v` allowing subtyping.
 *
 * `t1` contains `v` and equals a supertype of `t2` if `subst` is substituted for `v`.
 * Only shallow supertypes of `t2` are considered in order to get the most precise result for `subst`.
 * For example:
 * If `t1` is `List<V>` and `t2` is `ArrayList<T>` we only want `subst` to be `T` and not, say, `?`.
 */
pragma[nomagic]
private predicate hasSubtypedSubstitution(RefType t1, Type t2, TypeVariable v, RefType subst) {
  hasSubstitution(t1, t2, v, subst) or
  exists(GenericType g | hasParameterSubstitution(g, t1, g, getShallowSupertype(t2), v, subst))
}

/**
 * Unifies `t1` and `t2` with respect to `v`.
 *
 * `t1` contains `v` and equals `t2` if `subst` is substituted for `v`.
 * As a special case `t2` can be a primitive type and the equality hold when
 * `t2` is auto-boxed.
 */
private predicate hasSubstitution(RefType t1, Type t2, TypeVariable v, RefType subst) {
  unificationTargets(t1, t2) and
  (
    t1 = v and
    (t2 = subst or t2.(PrimitiveType).getBoxedType() = subst)
    or
    hasSubstitution(t1.(Array).getComponentType(), t2.(Array).getComponentType(), v, subst)
    or
    exists(GenericType g | hasParameterSubstitution(g, t1, g, t2, v, subst))
  )
}

private predicate hasParameterSubstitution(
  GenericType g1, ParameterizedType pt1, GenericType g2, ParameterizedType pt2, TypeVariable v,
  RefType subst
) {
  unificationTargets(pt1, pt2) and
  exists(int pos | hasSubstitution(pt1.getTypeArgument(pos), pt2.getTypeArgument(pos), v, subst)) and
  g1 = pt1.getGenericType() and
  g2 = pt2.getGenericType()
}

/**
 * A generic constructor is a constructor with a type parameter.
 *
 * For example, `<T> C(T t) { }` is a generic constructor for type `C`.
 */
class GenericConstructor extends Constructor, GenericCallable {
  override GenericConstructor getSourceDeclaration() {
    result = Constructor.super.getSourceDeclaration()
  }

  override ConstructorCall getAReference() { result = Constructor.super.getAReference() }
}

/**
 * A generic method is a method with a type parameter.
 *
 * For example, `<T> void m(T t) { }` is a generic method.
 */
class GenericMethod extends Method, GenericCallable {
  override GenericSrcMethod getSourceDeclaration() { result = Method.super.getSourceDeclaration() }
}

/** A generic method that is the same as its source declaration. */
class GenericSrcMethod extends SrcMethod, GenericMethod { }
