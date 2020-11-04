/**
 * Provides support for generic types and methods.
 *
 * The classes `UnboundGeneric*` represent the unbound form of the generic,
 * whereas `ConstructedGeneric*` represent the constructed generic where type arguments
 * have been supplied and are bound to the type parameters.
 *
 * There is a one-to-many relationship between an unbound generic (`UnboundGenric*`)
 * and its constructed generics (`ConstructedGeneric*`).
 *
 * Generics can be partially constructed if they are unbound generics contained
 * within constructed generic types. The predicate `getSourceDeclaration` refers
 * to the ultimate `UnboundGeneric` type/method as defined in the source code.
 */

import Location
import Namespace
private import dotnet
private import TypeRef

/**
 * A generic declaration. Either an unbound generic (`UnboundGeneric`) or a
 * constructed generic (`ConstructedGeneric`).
 */
class Generic extends DotNet::Generic, Declaration, @generic {
  Generic() {
    type_parameters(_, _, this, _) or
    type_arguments(_, _, this)
  }
}

/**
 * A generic declaration with type parameters.
 *
 * Either an unbound generic type (`UnboundGenericType`) or an unbound generic method
 * (`UnboundGenericMethod`).
 */
class UnboundGeneric extends DotNet::UnboundGeneric, Generic {
  UnboundGeneric() { type_parameters(_, _, this, _) }

  override TypeParameter getTypeParameter(int n) { type_parameters(result, n, this, _) }

  override ConstructedGeneric getAConstructedGeneric() { result.getUnboundGeneric() = this }

  override TypeParameter getATypeParameter() {
    result = DotNet::UnboundGeneric.super.getATypeParameter()
  }
}

/**
 * A constructed generic.
 *
 * Either a constructed generic type (`ConstructedType`) or a constructed
 * generic method (`ConstructedMethod`).
 */
class ConstructedGeneric extends DotNet::ConstructedGeneric, Generic {
  ConstructedGeneric() { type_arguments(_, _, this) }

  override UnboundGeneric getUnboundGeneric() { constructed_generic(this, result) }

  override UnboundGeneric getSourceDeclaration() {
    result = getUnboundGeneric().getSourceDeclaration()
  }

  override int getNumberOfTypeArguments() { result = count(int i | type_arguments(_, i, this)) }

  override Type getTypeArgument(int i) { none() }

  override Type getATypeArgument() { result = getTypeArgument(_) }

  /** Gets the annotated type of type argument `i`. */
  final AnnotatedType getAnnotatedTypeArgument(int i) { result.appliesToTypeArgument(this, i) }
}

/**
 * An unbound generic type. This is a generic type with type parameters
 * (for example `List<T>`) or elided type parameters (for example `List<>`).
 *
 * Either an unbound generic `struct` (`UnboundGenericStruct`), an unbound generic `class`
 * (`UnboundGenericClass`), an unbound generic `interface` (`UnboundGenericInterface`), or
 * an unbound generic delegate (`UnboundGenericDelegateType`).
 */
class UnboundGenericType extends ValueOrRefType, UnboundGeneric {
  /**
   * Gets a bound/constructed version of this unbound generic type. This includes
   * not only closed constructed types such as `G<int>`, but also open constructed
   * types such as the `G<T>` in `class Other<T> { G<T> g; }`. Note that such a type
   * is distinct from the `G<T>` used in the class definition, since in `G<T> g;`
   * the `T` will be the actual type parameter used for the `Other` that contains
   * `g`, whereas in `class G<T> { ... }` the `T` is a formal type parameter of `G`.
   */
  override ConstructedType getAConstructedGeneric() {
    result = UnboundGeneric.super.getAConstructedGeneric()
  }

  /**
   * Gets the instance type of this type. For an unbound generic type, the instance type
   * is a constructed type created from the unbound type, with each of the supplied type
   * arguments being the corresponding type parameter.
   */
  ConstructedType getInstanceType() {
    result = this.getAConstructedGeneric() and
    forall(TypeParameter tp, int i | tp = this.getTypeParameter(i) | tp = result.getTypeArgument(i))
  }

  override Location getALocation() { type_location(this, result) }

  /** Gets the name of this generic type without the `<...>` brackets. */
  string getNameWithoutBrackets() {
    result = getName().prefix(getName().length() - getNumberOfTypeParameters() - 1)
  }

  override string toStringWithTypes() {
    result = getNameWithoutBrackets() + "<" + this.typeParametersToString() + ">"
  }

  override UnboundGenericType getSourceDeclaration() {
    result = ValueOrRefType.super.getSourceDeclaration()
  }

  final override Type getChild(int n) { result = getTypeParameter(n) }
}

/**
 * A type parameter, for example `T` in `List<T>`.
 */
class TypeParameter extends DotNet::TypeParameter, Type, @type_parameter {
  /** Gets the constraints on this type parameter, if any. */
  TypeParameterConstraints getConstraints() { result.getTypeParameter() = this }

  override predicate isRefType() {
    exists(TypeParameterConstraints tpc | tpc = getConstraints() |
      tpc.hasRefTypeConstraint() or
      tpc.getATypeConstraint() instanceof Class or
      tpc.getATypeConstraint().(TypeParameter).isRefType()
      // NB: an interface constraint is not a guarantee, as structs can implement interfaces
    )
  }

  override predicate isValueType() {
    exists(TypeParameterConstraints tpc | tpc = getConstraints() |
      tpc.hasValueTypeConstraint() or
      tpc.getATypeConstraint().(TypeParameter).isValueType()
    )
  }

  /** Holds if this type parameter is contravariant. */
  predicate isIn() { type_parameters(this, _, _, 2) }

  /** Holds if this type parameter is covariant. */
  predicate isOut() { type_parameters(this, _, _, 1) }

  /** Gets a type that was supplied for this parameter. */
  Type getASuppliedType() {
    // A type parameter either comes from the source declaration
    // or from a partially constructed generic.
    //
    // When from a source declaration, return type arguments from all ConstructedGenerics,
    // and when from a partially constructed UnboundGeneric, return type arguments from
    // directly ConstructedGenerics.
    //
    // For example:
    //
    // class A<T1> { class B<T2> { } }
    //
    // A<T1>.B<T2> is the UnboundGenericClass source declaration,
    // A<int>.B<T2> is a partially constructed UnboundGenericClass and
    // A<int>.B<int> is a ConstructedGenericClass.
    exists(ConstructedGeneric c, UnboundGeneric u, int tpi |
      this = u.getTypeParameter(tpi) and
      (u = c.getUnboundGeneric() or u = c.getSourceDeclaration()) and
      result = c.getTypeArgument(tpi)
    )
  }

  /** Gets a non-type-parameter type that was transitively supplied for this parameter. */
  Type getAnUltimatelySuppliedType() {
    result = getASuppliedType() and not result instanceof TypeParameter
    or
    result = getASuppliedType().(TypeParameter).getAnUltimatelySuppliedType()
  }

  override int getIndex() { type_parameters(this, result, _, _) }

  /** Gets the generic that defines this type parameter. */
  UnboundGeneric getGeneric() { type_parameters(this, _, result, _) }

  override string getAPrimaryQlClass() { result = "TypeParameter" }
}

/**
 * A set of type parameter constraints.
 *
 * For example, `where` on line 2 in
 *
 * ```csharp
 * class Factory<T>
 *   where T : ICloneable {
 * }
 * ```
 */
class TypeParameterConstraints extends Element, @type_parameter_constraints {
  /** Gets a specific type constraint, if any. */
  Type getATypeConstraint() { specific_type_parameter_constraints(this, getTypeRef(result)) }

  /** Gets an annotated specific type constraint, if any. */
  AnnotatedType getAnAnnotatedTypeConstraint() { result.appliesToTypeConstraint(this) }

  override Location getALocation() { type_parameter_constraints_location(this, result) }

  /** Gets the type parameter to which these constraints apply. */
  TypeParameter getTypeParameter() { type_parameter_constraints(this, result) }

  /** Holds if these constraints include a constructor constraint. */
  predicate hasConstructorConstraint() { general_type_parameter_constraints(this, 3) }

  /** Holds if these constraints include a general reference type constraint. */
  predicate hasRefTypeConstraint() { general_type_parameter_constraints(this, 1) }

  /** Holds if these constraints include a general value type constraint. */
  predicate hasValueTypeConstraint() { general_type_parameter_constraints(this, 2) }

  /** Holds if these constraints include an unmanaged type constraint. */
  predicate hasUnmanagedTypeConstraint() { general_type_parameter_constraints(this, 4) }

  /** Holds if these constraints include a nullable reference type constraint. */
  predicate hasNullableRefTypeConstraint() { general_type_parameter_constraints(this, 5) }

  /** Gets a textual representation of these constraints. */
  override string toString() { result = "where " + this.getTypeParameter().getName() + ": ..." }
}

/**
 * An unbound generic `struct`.
 * (See the comments on `UnboundGenericType` for more information.)
 *
 * For example,
 *
 * ```csharp
 * struct KeyValuePair<Key, Value> {
 *   ...
 * }
 * ```
 */
class UnboundGenericStruct extends Struct, UnboundGenericType {
  override ConstructedStruct getInstanceType() {
    result = UnboundGenericType.super.getInstanceType()
  }

  override ConstructedStruct getAConstructedGeneric() {
    result = UnboundGenericType.super.getAConstructedGeneric()
  }

  override UnboundGenericStruct getSourceDeclaration() {
    result = UnboundGenericType.super.getSourceDeclaration()
  }
}

/**
 * An unbound generic class, for example
 *
 * ```csharp
 * class List<T> {
 *   ...
 * }
 * ```
 */
class UnboundGenericClass extends Class, UnboundGenericType {
  override ConstructedClass getInstanceType() {
    result = UnboundGenericType.super.getInstanceType()
  }

  override ConstructedClass getAConstructedGeneric() {
    result = UnboundGenericType.super.getAConstructedGeneric()
  }

  override UnboundGenericClass getSourceDeclaration() {
    result = UnboundGenericType.super.getSourceDeclaration()
  }
}

/**
 * An unbound generic interface, for example
 *
 * ```csharp
 * interface IEnumerable<T> {
 *   ...
 * }
 * ```
 */
class UnboundGenericInterface extends Interface, UnboundGenericType {
  override ConstructedInterface getInstanceType() {
    result = UnboundGenericType.super.getInstanceType()
  }

  override ConstructedInterface getAConstructedGeneric() {
    result = UnboundGenericType.super.getAConstructedGeneric()
  }

  override UnboundGenericInterface getSourceDeclaration() {
    result = UnboundGenericType.super.getSourceDeclaration()
  }
}

/**
 * An unbound generic delegate type.
 * (See the comments on `UnboundGenericType` for more information.)
 *
 * For example
 *
 * ```csharp
 * delegate void F<T>(T t);
 * ```
 */
class UnboundGenericDelegateType extends DelegateType, UnboundGenericType {
  override ConstructedDelegateType getInstanceType() {
    result = UnboundGenericType.super.getInstanceType()
  }

  override ConstructedDelegateType getAConstructedGeneric() {
    result = UnboundGenericType.super.getAConstructedGeneric()
  }

  override UnboundGenericDelegateType getSourceDeclaration() {
    result = UnboundGenericType.super.getSourceDeclaration()
  }

  override string toStringWithTypes() {
    result =
      getNameWithoutBrackets() + "<" + this.typeParametersToString() + ">(" +
        parameterTypesToString() + ")"
  }
}

/**
 * A constructed (bound) type. This is a generic type for which actual type
 * arguments have been supplied, for example `G<int>` or the `G<T>` in
 * `class Other<T> { G<T> g; }`. Constructed types can be divided further into
 * those that are open (for example `G1<T>` or `G2<T,T,U,int>`), in the sense
 * that one or more of their type arguments is a type parameter, versus those
 * that are closed (for example `G1<int>` or `G2<long,long,float,int>`).
 *
 * Either a constructed `struct` (`ConstructedStruct`), constructed `class`
 * (`ConstructedClass`), constructed `interface` (`ConstructedInterface`),
 * or constructed method (`ConstructedMethod`).
 */
class ConstructedType extends ValueOrRefType, ConstructedGeneric {
  override UnboundGenericType getSourceDeclaration() {
    result = ConstructedGeneric.super.getSourceDeclaration()
  }

  override Location getALocation() { result = this.getSourceDeclaration().getALocation() }

  override Type getTypeArgument(int n) { type_arguments(getTypeRef(result), n, getTypeRef(this)) }

  override UnboundGenericType getUnboundGeneric() { constructed_generic(this, getTypeRef(result)) }

  override string toStringWithTypes() {
    result =
      getUnboundGeneric().getNameWithoutBrackets() + "<" + this.getTypeArgumentsString() + ">"
  }

  final override Type getChild(int n) { result = getTypeArgument(n) }

  language[monotonicAggregates]
  private string getTypeArgumentsString() {
    result =
      concat(int i |
        exists(this.getTypeArgument(i))
      |
        this.getTypeArgument(i).toString(), ", " order by i
      )
  }
}

/**
 * A constructed (bound) `struct`. (See the comments on `ConstructedType` for more information.)
 *
 * For example, `KeyValuePair<int, string>` on line 4 in
 *
 * ```csharp
 * struct KeyValuePair<Key, Value> { ... }
 *
 * class C {
 *   void M(KeyValuePair<int, string> kvp) { }
 * }
 * ```
 */
class ConstructedStruct extends Struct, ConstructedType {
  override UnboundGenericStruct getSourceDeclaration() {
    result = ConstructedType.super.getSourceDeclaration()
  }

  override UnboundGenericStruct getUnboundGeneric() {
    result = ConstructedType.super.getUnboundGeneric()
  }
}

/**
 * A constructed (bound) class. (See the comments on `ConstructedType` for more information.)
 *
 * For example, `List<int>` on line 4 in
 *
 * ```csharp
 * class List<T> { ... }
 *
 * class C {
 *   void M(List<int> l) { }
 * }
 * ```
 */
class ConstructedClass extends Class, ConstructedType {
  override UnboundGenericClass getSourceDeclaration() {
    result = ConstructedType.super.getSourceDeclaration()
  }

  override UnboundGenericClass getUnboundGeneric() {
    result = ConstructedType.super.getUnboundGeneric()
  }
}

/**
 * A C# constructed (bound) interface. (See the comments on `ConstructedType` for more information.)
 *
 * For example, `IEnumerable<string>` on line 4 in
 *
 * ```csharp
 * interface IEnumerable<T> { ... }
 *
 * class C {
 *   void M(IEnumerable<string> i) { }
 * }
 * ```
 */
class ConstructedInterface extends Interface, ConstructedType {
  override UnboundGenericInterface getSourceDeclaration() {
    result = ConstructedType.super.getSourceDeclaration()
  }

  override UnboundGenericInterface getUnboundGeneric() {
    result = ConstructedType.super.getUnboundGeneric()
  }
}

/**
 * A constructed (bound) delegate type. (See the comments on `ConstructedType` for more information.)
 *
 * For example, `F<int>` on line 4 in
 *
 * ```csharp
 * delegate void F<T>(T t);
 *
 * class C {
 *   void M(F<int> f) { }
 * }
 * ```
 */
class ConstructedDelegateType extends DelegateType, ConstructedType {
  override UnboundGenericDelegateType getSourceDeclaration() {
    result = ConstructedType.super.getSourceDeclaration()
  }

  override UnboundGenericDelegateType getUnboundGeneric() {
    result = ConstructedType.super.getUnboundGeneric()
  }
}

/**
 * An unbound generic method. This is a generic method whose signature involves formal type parameters,
 * For example `M<T>` on line 2 in
 *
 * ```csharp
 * class C {
 *   void M<T>() { ... }
 * }
 * ```
 */
class UnboundGenericMethod extends Method, UnboundGeneric {
  /**
   * Gets a bound/constructed version of this unbound generic method. These correspond to the unbound
   * generic method in the same way that bound/constructed types correspond to unbound generic types.
   * (See the comments on `UnboundGenericType` for more information.)
   */
  override ConstructedMethod getAConstructedGeneric() {
    result = UnboundGeneric.super.getAConstructedGeneric()
  }

  override string toStringWithTypes() {
    result =
      getName() + "<" + this.typeParametersToString() + ">" + "(" + parameterTypesToString() + ")"
  }
}

/**
 * A constructed (bound) method, for example the target `M<int>` of the call on
 * line 5 in
 *
 * ```csharp
 * class C {
 *   void M<T>() { ... }
 *
 *   void CallM(int i) {
 *     M<int>(i);
 *   }
 * }
 * ```
 *
 * This is a generic method for which actual type arguments have been supplied.
 * It corresponds to `UnboundGenericMethod` in the same way that `ConstructedType`
 * corresponds to `UnboundGenericType`.
 */
class ConstructedMethod extends Method, ConstructedGeneric {
  override Location getALocation() { result = this.getSourceDeclaration().getALocation() }

  override Type getTypeArgument(int n) { type_arguments(getTypeRef(result), n, this) }

  override UnboundGenericMethod getUnboundGeneric() { constructed_generic(this, result) }

  override string toStringWithTypes() {
    result =
      getName() + "<" + this.typeArgumentsToString() + ">" + "(" + parameterTypesToString() + ")"
  }

  override UnboundGenericMethod getSourceDeclaration() {
    result = Method.super.getSourceDeclaration()
  }
}

/**
 * An unbound generic local function, for example `f` on line 3 in
 *
 * ```csharp
 * class C {
 *   void M() {
 *     void f<T>(T t) { ... }
 *   }
 * }
 * ```
 */
class UnboundLocalFunction extends LocalFunction, UnboundGeneric {
  override ConstructedLocalFunction getAConstructedGeneric() {
    result = UnboundGeneric.super.getAConstructedGeneric()
  }
}

/**
 * A constructed generic local function, for example the target `f<int>`
 * of the function call `f(5)` on line 4 in
 *
 * ```csharp
 * class C {
 *   void M() {
 *     void f<T>(T t) { ... }
 *     f(5);
 *   }
 * }
 * ```
 */
class ConstructedLocalFunction extends LocalFunction, ConstructedGeneric {
  override UnboundLocalFunction getSourceDeclaration() {
    result = LocalFunction.super.getSourceDeclaration()
  }

  override UnboundLocalFunction getUnboundGeneric() {
    result = ConstructedGeneric.super.getUnboundGeneric()
  }
}

/**
 * A method that is not constructed. That is, either a method that is
 * not a generic method or an unbound generic method (`UnboundGenericMethod`).
 */
class NonConstructedMethod extends Method {
  NonConstructedMethod() { not this instanceof ConstructedMethod }

  /**
   * Gets a method that either equals this non-constructed method, or
   * a method that is a constructed version of this non-constructed
   * method.
   *
   * Note that this only relates to method type parameters and not to
   * type parameters of enclosing types.
   *
   * Example:
   *
   * ```csharp
   * class A<T1> {
   *   void M1(T1 x1) { }
   *   void M2<T2>(T1 x1, T2 x) { }
   * }
   *
   * class B {
   *   void M() {
   *     var c = new C<int>();
   *     c.M1(0);
   *     c.M2<string>(0, "");
   *   }
   * }
   * ```
   *
   * The unbound generic method of the call on line 10 is `M1(int)`, whereas
   * the unbound generic method of the call on line 11 is `M2<T2>(int, T2)`.
   */
  Method getAConstructingMethodOrSelf() {
    result = this
    or
    result = this.(UnboundGenericMethod).getAConstructedGeneric()
  }
}
