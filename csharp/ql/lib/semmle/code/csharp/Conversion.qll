/**
 * INTERNAL: Do not use.
 *
 * Provides definitions related to implicit type conversions.
 *
 * The definitions are based on the
 * [C# Language Specification 5.0](https://www.microsoft.com/en-us/download/details.aspx?id=7029),
 * with references to the relevant sections in the specification.
 *
 * Do not use the predicates in this library directly; use `Type.isImplicitlyConvertibleTo(Type)`
 * instead.
 */

import Type
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.collections.Generic

cached
private module Cached {
  /**
   * INTERNAL: Do not use.
   *
   * Holds if there exists an implicit conversion from `fromType` to `toType`.
   *
   * 6.1: Implicit type conversions.
   *
   * The following conversions are included:
   *
   * - Identity conversions
   * - Implicit numeric conversions
   * - Implicit nullable conversions
   * - Implicit reference conversions
   * - Boxing conversions
   */
  cached
  predicate implicitConversionRestricted(Type fromType, Type toType) {
    convIdentity(fromType, toType)
    or
    convNumeric(fromType, toType)
    or
    convNullableType(fromType, toType)
    or
    convRefTypeNonNull(fromType, toType)
    or
    convBoxing(fromType, toType)
  }

  /**
   * INTERNAL: Do not use.
   *
   * Holds if there is a constant expression conversion from `fromType` to `toType`.
   *
   * 6.1.9: Implicit constant expression conversions.
   */
  cached
  predicate convConstantExpr(SignedIntegralConstantExpr e, SimpleType toType) {
    convConstantIntExpr(e, toType)
    or
    convConstantLongExpr(e) and toType instanceof ULongType
  }
}

import Cached

private predicate implicitConversionNonNull(Type fromType, Type toType) {
  implicitConversionRestricted(fromType, toType)
  or
  convConversionOperator(fromType, toType)
  or
  fromType instanceof DynamicType // 6.1.8
}

/**
 * INTERNAL: Do not use.
 *
 * Holds if there exists an implicit conversion from `fromType` to `toType`.
 *
 * 6.1: Implicit type conversions.
 *
 * The following conversions are classified as implicit conversions:
 *
 * - Identity conversions
 * - Implicit numeric conversions
 * - Implicit nullable conversions
 * - Implicit reference conversions
 * - Boxing conversions
 * - User-defined implicit conversions
 */
pragma[nomagic]
predicate implicitConversion(Type fromType, Type toType) {
  implicitConversionNonNull(fromType, toType)
  or
  defaultNullConversion(fromType, toType)
}

/**
 * A generic type. This includes both constructed generic types and unbound
 * generic types (which correspond to constructed generic types where the
 * type arguments equal the type parameters).
 */
private class GenericType extends Generic, Type {
  /** Gets the `i`th type argument. */
  Type getTypeArgument(int i) { result = this.getChild(i) }

  /** Gets the unbound generic type. */
  UnboundGenericType getUnboundGeneric() {
    result = this.(ConstructedType).getUnboundGeneric()
    or
    result = this
  }
}

private Type getTypeArgument(UnboundGenericType ugt, GenericType gt, int i, TypeParameter tp) {
  gt.getUnboundGeneric() = ugt and
  not ugt instanceof AnonymousClass and
  tp = ugt.getTypeParameter(i) and
  result = gt.getTypeArgument(i)
}

/** A type that is an element type of an array type. */
private class ArrayElementType extends Type {
  ArrayElementType() { this = any(ArrayType at).getElementType() }
}

/** A type that is an argument in a constructed type. */
private class TypeArgument extends Type {
  TypeArgument() { this = any(GenericType gt).getTypeArgument(_) }
}

/**
 * INTERNAL: Do not use.
 *
 * Holds if there exists an identity conversion from `fromType` to `toType`.
 *
 * 6.1.1: Identity conversion.
 *
 * Equality modulo `object` and `dynamic`, that is, two types are considered
 * identical if they are syntactically equal when replacing all occurrences
 * of `dynamic` with `object`.
 */
predicate convIdentity(Type fromType, Type toType) {
  fromType = toType
  or
  Identity::convIdentityStrict(fromType, toType)
}

private module Identity {
  private class IdentityConvertibleType extends Type {
    IdentityConvertibleType() { isIdentityConvertible(this) }
  }

  private class IdentityConvertibleArrayType extends IdentityConvertibleType, ArrayType { }

  private class IdentityConvertibleGenericType extends IdentityConvertibleType, GenericType { }

  /**
   * A type is (strictly) identity convertible if it contains at least one `object`
   * or one `dynamic` sub term.
   */
  private predicate isIdentityConvertible(Type t) {
    t instanceof ObjectType
    or
    t instanceof DynamicType
    or
    isIdentityConvertible(t.(ArrayType).getElementType())
    or
    isIdentityConvertible(t.(GenericType).getTypeArgument(_))
  }

  predicate convIdentityStrict(IdentityConvertibleType fromType, IdentityConvertibleType toType) {
    convIdentityObjectDynamic(fromType, toType)
    or
    convIdentityObjectDynamic(toType, fromType)
    or
    convIdentityStrictArrayType(fromType, toType)
    or
    convIdentityStrictGenericType(fromType, toType)
  }

  private predicate convIdentityObjectDynamic(ObjectType fromType, DynamicType toType) { any() }

  private predicate convIdentityStrictArrayType(
    IdentityConvertibleArrayType fromType, IdentityConvertibleArrayType toType
  ) {
    convIdentityStrictArrayTypeJoin(fromType, toType, toType.getDimension(), toType.getRank())
  }

  pragma[noinline]
  private predicate convIdentityStrictArrayTypeJoin(
    IdentityConvertibleArrayType fromType, IdentityConvertibleArrayType toType, int dim, int rnk
  ) {
    convIdentityStrictArrayElementType(fromType, toType.getElementType(), dim, rnk)
  }

  private predicate convIdentityStrictArrayElementType(
    IdentityConvertibleArrayType fromType, ArrayElementType aet, int dim, int rnk
  ) {
    convIdentityStrict(fromType.getElementType(), aet) and
    dim = fromType.getDimension() and
    rnk = fromType.getRank()
  }

  /**
   * Gets the number of different type arguments supplied for the type
   * parameter at index `i` in unbound generic type `ugt`.
   */
  private int getTypeArgumentCount(UnboundGenericType ugt, int i) {
    result =
      strictcount(Type arg |
        exists(IdentityConvertibleGenericType ct | ct.getUnboundGeneric() = ugt |
          arg = ct.getTypeArgument(i)
        )
      )
  }

  private int rnk(UnboundGenericType ugt, int i) {
    result = rank[i + 1](int j, int k | j = getTypeArgumentCount(ugt, k) | k order by j, k)
  }

  /** Gets the 'i'th type argument, ranked by size, of constructed type `t`. */
  private Type getTypeArgumentRanked(UnboundGenericType ugt, IdentityConvertibleGenericType t, int i) {
    result = getTypeArgument(ugt, t, rnk(ugt, i), _)
  }

  /**
   * Holds if `fromTypeArgument` is identity convertible to `toTypeArgument`, and
   * both types are the `i`th type argument in _some_ constructed type.
   */
  pragma[nomagic]
  private predicate convTypeArguments(Type fromTypeArgument, Type toTypeArgument, int i) {
    exists(int j |
      fromTypeArgument = getTypeArgumentRanked(_, _, i) and
      toTypeArgument = getTypeArgumentRanked(_, _, j) and
      i <= j and
      j <= i
    |
      convIdentity(fromTypeArgument, toTypeArgument)
    )
  }

  pragma[nomagic]
  private predicate convTypeArgumentsSomeUnbound(
    UnboundGenericType ugt, TypeArgument fromTypeArgument, TypeArgument toTypeArgument, int i
  ) {
    convTypeArguments(fromTypeArgument, toTypeArgument, i) and
    fromTypeArgument = getTypeArgumentRanked(ugt, _, i)
  }

  /**
   * Holds if `fromTypeArgument` is identity convertible to `toTypeArgument` and
   * both types are the `i`th type argument in _some_ constructed type
   * based on unbound generic type `ugt`.
   */
  pragma[noinline]
  private predicate convTypeArgumentsSameUnbound(
    UnboundGenericType ugt, TypeArgument fromTypeArgument, TypeArgument toTypeArgument, int i
  ) {
    convTypeArgumentsSomeUnbound(ugt, fromTypeArgument, toTypeArgument, i) and
    toTypeArgument = getTypeArgumentRanked(ugt, _, i)
  }

  pragma[nomagic]
  private predicate convIdentitySingle0(
    UnboundGenericType ugt, IdentityConvertibleGenericType toType, TypeArgument fromTypeArgument,
    TypeArgument toTypeArgument
  ) {
    convTypeArgumentsSameUnbound(ugt, fromTypeArgument, toTypeArgument, 0) and
    toTypeArgument = getTypeArgumentRanked(ugt, toType, 0) and
    ugt.getNumberOfTypeParameters() = 1
  }

  /**
   * Holds if the type arguments of types `fromType` and `toType` are identity
   * convertible, and the number of type arguments is 1.
   */
  predicate convIdentitySingle(
    UnboundGenericType ugt, IdentityConvertibleGenericType fromType,
    IdentityConvertibleGenericType toType
  ) {
    exists(TypeArgument fromTypeArgument, TypeArgument toTypeArgument |
      convIdentitySingle0(ugt, toType, fromTypeArgument, toTypeArgument)
    |
      fromTypeArgument = getTypeArgumentRanked(ugt, fromType, 0)
    )
  }

  pragma[nomagic]
  private predicate convIdentityMultiple01Aux0(
    UnboundGenericType ugt, IdentityConvertibleGenericType toType, TypeArgument fromTypeArgument0,
    TypeArgument toTypeArgument0, TypeArgument toTypeArgument1
  ) {
    convTypeArgumentsSameUnbound(ugt, fromTypeArgument0, toTypeArgument0, 0) and
    toTypeArgument0 = getTypeArgumentRanked(ugt, toType, 0) and
    toTypeArgument1 = getTypeArgumentRanked(ugt, toType, 1)
  }

  pragma[nomagic]
  private predicate convIdentityMultiple01Aux1(
    UnboundGenericType ugt, IdentityConvertibleGenericType fromType, TypeArgument fromTypeArgument0,
    TypeArgument fromTypeArgument1, TypeArgument toTypeArgument1
  ) {
    convTypeArgumentsSameUnbound(ugt, fromTypeArgument1, toTypeArgument1, 1) and
    fromTypeArgument0 = getTypeArgumentRanked(ugt, fromType, 0) and
    fromTypeArgument1 = getTypeArgumentRanked(ugt, fromType, 1)
  }

  /**
   * Holds if the first two ranked type arguments of types `fromType` and `toType`
   * are identity convertible.
   */
  private predicate convIdentityMultiple01(
    UnboundGenericType ugt, IdentityConvertibleGenericType fromType,
    IdentityConvertibleGenericType toType
  ) {
    exists(
      Type fromTypeArgument0, Type toTypeArgument0, Type fromTypeArgument1, Type toTypeArgument1
    |
      convIdentityMultiple01Aux0(ugt, toType, fromTypeArgument0, toTypeArgument0, toTypeArgument1)
    |
      convIdentityMultiple01Aux1(ugt, fromType, fromTypeArgument0, fromTypeArgument1,
        toTypeArgument1)
    )
  }

  pragma[nomagic]
  private predicate convIdentityMultiple2Aux(
    UnboundGenericType ugt, IdentityConvertibleGenericType toType, int i,
    TypeArgument fromTypeArgument, TypeArgument toTypeArgument
  ) {
    convTypeArgumentsSameUnbound(ugt, fromTypeArgument, toTypeArgument, i) and
    toTypeArgument = getTypeArgumentRanked(ugt, toType, i) and
    i >= 2
  }

  private predicate convIdentityMultiple2(
    UnboundGenericType ugt, IdentityConvertibleGenericType fromType,
    IdentityConvertibleGenericType toType, int i
  ) {
    exists(TypeArgument fromTypeArgument, TypeArgument toTypeArgument |
      convIdentityMultiple2Aux(ugt, toType, i, fromTypeArgument, toTypeArgument)
    |
      fromTypeArgument = getTypeArgumentRanked(ugt, fromType, i)
    )
  }

  /**
   * Holds if the ranked type arguments 0 through `i` (with `i >= 1`) of types
   * `fromType` and `toType` are identity convertible.
   */
  pragma[nomagic]
  predicate convIdentityMultiple(
    UnboundGenericType ugt, IdentityConvertibleGenericType fromType,
    IdentityConvertibleGenericType toType, int i
  ) {
    convIdentityMultiple01(ugt, fromType, toType) and i = 1
    or
    convIdentityMultiple(ugt, fromType, toType, i - 1) and
    convIdentityMultiple2(ugt, fromType, toType, i)
  }

  private predicate convIdentityStrictGenericType(
    IdentityConvertibleGenericType fromType, IdentityConvertibleGenericType toType
  ) {
    // Semantically equivalent with
    // ```ql
    // ugt = fromType.getUnboundGeneric()
    // and
    // forex(int i |
    //   i in [0 .. ugt.getNumberOfTypeParameters() - 1] |
    //   exists(Type t1, Type t2 |
    //     t1 = getTypeArgument(ugt, fromType, i, _) and
    //     t2 = getTypeArgument(ugt, toType, i, _) |
    //     convIdentity(t1, t2)
    //   )
    // )
    // ```
    // but performance is improved by explicitly evaluating the `i`th argument
    // only when all preceding arguments are convertible.
    //
    fromType != toType and
    (
      convIdentitySingle(_, fromType, toType)
      or
      exists(UnboundGenericType ugt |
        convIdentityMultiple(ugt, fromType, toType, ugt.getNumberOfTypeParameters() - 1)
      )
    )
  }
}

/**
 * INTERNAL: Do not use.
 *
 * Holds if there is an implicit numeric conversion from `fromType` to `toType`.
 *
 * 6.1.2: Implicit numeric conversions.
 */
predicate convNumeric(SimpleType fromType, SimpleType toType) {
  fromType instanceof SByteType and convNumericSByte(toType)
  or
  fromType instanceof ByteType and convNumericByte(toType)
  or
  fromType instanceof ShortType and convNumericShort(toType)
  or
  fromType instanceof UShortType and convNumericUShort(toType)
  or
  fromType instanceof IntType and convNumericInt(toType)
  or
  fromType instanceof UIntType and convNumericUInt(toType)
  or
  fromType instanceof LongType and convNumericLong(toType)
  or
  fromType instanceof ULongType and convNumericULong(toType)
  or
  fromType instanceof CharType and convNumericChar(toType)
  or
  fromType instanceof FloatType and convNumericFloat(toType)
}

private predicate convNumericSByte(SimpleType toType) {
  toType instanceof ShortType or
  toType instanceof IntType or
  toType instanceof LongType or
  toType instanceof FloatType or
  toType instanceof DoubleType or
  toType instanceof DecimalType
}

private predicate convNumericByte(SimpleType toType) {
  toType instanceof ShortType or
  toType instanceof UShortType or
  toType instanceof IntType or
  toType instanceof UIntType or
  toType instanceof LongType or
  toType instanceof ULongType or
  toType instanceof FloatType or
  toType instanceof DoubleType or
  toType instanceof DecimalType
}

private predicate convNumericShort(SimpleType toType) {
  toType instanceof IntType or
  toType instanceof LongType or
  toType instanceof FloatType or
  toType instanceof DoubleType or
  toType instanceof DecimalType
}

private predicate convNumericUShort(SimpleType toType) {
  toType instanceof IntType or
  toType instanceof UIntType or
  toType instanceof LongType or
  toType instanceof ULongType or
  toType instanceof FloatType or
  toType instanceof DoubleType or
  toType instanceof DecimalType
}

private predicate convNumericInt(SimpleType toType) {
  toType instanceof LongType or
  toType instanceof FloatType or
  toType instanceof DoubleType or
  toType instanceof DecimalType
}

private predicate convNumericUInt(SimpleType toType) {
  toType instanceof LongType or
  toType instanceof ULongType or
  toType instanceof FloatType or
  toType instanceof DoubleType or
  toType instanceof DecimalType
}

private predicate convNumericLong(SimpleType toType) {
  toType instanceof FloatType or
  toType instanceof DoubleType or
  toType instanceof DecimalType
}

private predicate convNumericULong(SimpleType toType) {
  toType instanceof FloatType or
  toType instanceof DoubleType or
  toType instanceof DecimalType
}

private predicate convNumericChar(SimpleType toType) {
  toType instanceof UShortType or
  toType instanceof IntType or
  toType instanceof UIntType or
  toType instanceof LongType or
  toType instanceof ULongType or
  toType instanceof FloatType or
  toType instanceof DoubleType or
  toType instanceof DecimalType
}

private predicate convNumericFloat(SimpleType toType) { toType instanceof DoubleType }

/**
 * INTERNAL: Do not use.
 *
 * Holds if there is an implicit nullable conversion from `fromType` to `toType`.
 *
 * 6.1.4: Implicit nullable conversions.
 */
predicate convNullableType(ValueOrRefType fromType, NullableType toType) {
  exists(ValueType vt1, ValueType vt2 | implicitConversionNonNull(vt1, vt2) |
    toType.getUnderlyingType() = vt2 and
    (
      fromType = vt1
      or
      fromType.(NullableType).getUnderlyingType() = vt1
    )
  )
}

/**
 * Holds if `fromType` is `NullType`, and `toType` is a type that can represent
 * the `null` value, such as a reference type, `Nullable<T>` or a type parameter
 * with contraints that restrict it to a reference type.
 */
// This is a deliberate, small Cartesian product, so we have manually lifted it to force the
// evaluator to evaluate it in its entirety, rather than trying to optimize it in context.
pragma[noinline]
predicate defaultNullConversion(Type fromType, Type toType) {
  fromType instanceof NullType and convNullType(toType)
}

/**
 * INTERNAL: Do not use.
 *
 * Holds if there is an implicit reference conversion from `fromType` to `toType`.
 *
 * 6.1.6: Implicit reference conversions.
 */
predicate convRefType(Type fromType, Type toType) {
  convRefTypeNonNull(fromType, toType)
  or
  defaultNullConversion(fromType, toType)
}

private predicate convRefTypeNonNull(Type fromType, Type toType) {
  convRefTypeRefType(fromType, toType)
  or
  convRefTypeParameter(fromType, toType)
}

// This is a deliberate, small cartesian product, so we have manually lifted it to force the
// evaluator to evaluate it in its entirety, rather than trying to optimize it in context.
pragma[noinline]
private predicate defaultDynamicConversion(Type fromType, Type toType) {
  fromType instanceof RefType and toType instanceof DynamicType
}

pragma[noinline]
private predicate systemDelegateBaseType(RefType t) {
  t = any(SystemDelegateClass c).getABaseType*()
}

// This is a deliberate, small cartesian product, so we have manually lifted it to force the
// evaluator to evaluate it in its entirety, rather than trying to optimize it in context.
pragma[noinline]
private predicate defaultDelegateConversion(RefType fromType, RefType toType) {
  fromType instanceof DelegateType and systemDelegateBaseType(toType)
}

private predicate convRefTypeRefType(RefType fromType, RefType toType) {
  defaultDynamicConversion(fromType, toType)
  or
  fromType.getABaseType+() = toType
  or
  convArrayTypeRefType(fromType, toType)
  or
  defaultDelegateConversion(fromType, toType)
  or
  exists(Type t | convIdentity(fromType, t) or convRefTypeRefType(fromType, t) |
    convIdentity(t, toType) or convVariance(t, toType)
  )
}

// This is a deliberate, small cartesian product, so we have manually lifted it to force the
// evaluator to evaluate it in its entirety, rather than trying to optimize it in context.
pragma[noinline]
private predicate defaultArrayConversion(Type fromType, RefType toType) {
  fromType instanceof ArrayType and toType = any(SystemArrayClass c).getABaseType*()
}

private predicate convArrayTypeRefType(ArrayType fromType, RefType toType) {
  convArrayTypeCovariance(fromType, toType)
  or
  defaultArrayConversion(fromType, toType)
  or
  exists(ConstructedInterface ci, Type argumentType |
    fromType.getDimension() = 1 and
    fromType.getRank() = 1 and
    argumentType = getIListTypeArgument(ci) and
    exists(ArrayElementType elementType | elementType = fromType.getElementType() |
      convIdentity(elementType, argumentType) or
      convRefTypeNonNull(elementType, argumentType)
    ) and
    toType = ci.getABaseType*()
  )
}

private predicate convArrayTypeCovariance(ArrayType fromType, ArrayType toType) {
  convArrayTypeCovarianceJoin(fromType, toType, toType.getDimension(), toType.getRank())
}

pragma[nomagic]
private predicate convArrayTypeCovarianceJoin(ArrayType fromType, ArrayType toType, int dim, int rnk) {
  convArrayElementType(fromType, toType.getElementType(), dim, rnk)
}

pragma[nomagic]
private predicate convArrayElementType(ArrayType at, ArrayElementType aet, int dim, int rnk) {
  convRefTypeNonNull(at.getElementType(), aet) and
  dim = at.getDimension() and
  rnk = at.getRank()
}

private Type getIListTypeArgument(ConstructedInterface ci) {
  ci = any(SystemCollectionsGenericIListTInterface i).getAConstructedGeneric() and
  result = ci.getTypeArgument(0)
}

private predicate convNullType(Type toType) {
  toType instanceof NullableType
  or
  toType instanceof RefType
  or
  toType.(TypeParameter).isRefType() // 6.1.10
}

/**
 * INTERNAL: Do not use.
 *
 * Holds if there is a boxing conversion from `fromType` to `toType`.
 *
 * 6.1.7: Boxing conversions.
 */
predicate convBoxing(Type fromType, Type toType) {
  convBoxingValueType(fromType, toType)
  or
  fromType instanceof Enum and toType instanceof SystemEnumClass
  or
  convBoxing(fromType.(NullableType).getUnderlyingType(), toType)
  or
  convBoxingTypeParameter(fromType, toType)
  or
  exists(Type t | convBoxing(fromType, t) |
    convIdentity(t, toType) or
    convVariance(t, toType)
  )
}

private predicate convBoxingValueType(ValueType fromType, Type toType) {
  toType instanceof ObjectType
  or
  toType instanceof DynamicType
  or
  toType instanceof SystemValueTypeClass
  or
  toType = fromType.getABaseInterface+()
}

private class SignedIntegralConstantExpr extends Expr {
  SignedIntegralConstantExpr() {
    this.getType() instanceof SignedIntegralType and
    this.hasValue()
  }
}

private predicate convConstantIntExpr(SignedIntegralConstantExpr e, SimpleType toType) {
  exists(int n | n = e.getValue().toInt() |
    toType = any(SByteType t | n in [t.minValue() .. t.maxValue()])
    or
    toType = any(ByteType t | n in [t.minValue() .. t.maxValue()])
    or
    toType = any(ShortType t | n in [t.minValue() .. t.maxValue()])
    or
    toType = any(UShortType t | n in [t.minValue() .. t.maxValue()])
    or
    toType instanceof UIntType and n >= 0
    or
    toType instanceof ULongType and n >= 0
  )
}

private predicate convConstantLongExpr(SignedIntegralConstantExpr e) {
  e.getType() instanceof LongType and
  e.getValue().toInt() >= 0
}

/** 6.1.10: Implicit reference conversions involving type parameters. */
private predicate convRefTypeParameter(TypeParameter fromType, Type toType) {
  convTypeParameter(fromType, toType) and
  fromType.isRefType()
}

/** 6.1.10: Implicit boxing conversions involving type parameters. */
private predicate convBoxingTypeParameter(TypeParameter fromType, Type toType) {
  convTypeParameter(fromType, toType) and
  not fromType.isRefType()
}

/** 6.1.10: Implicit (reference or boxing) conversions involving type parameters. */
private predicate convTypeParameter(TypeParameter fromType, Type toType) {
  toType = convTypeParameterBase(fromType)
  or
  exists(Type t | convTypeParameter(fromType, t) |
    convIdentity(t, toType) or
    convVariance(t, toType)
  )
}

private Type convTypeParameterBase(TypeParameter tp) {
  result = effectiveBaseClassCandidate(tp).getABaseType*()
  or
  result = effectiveInterfaceSet(tp).getABaseInterface*()
  or
  result = getATypeParameterFromConstraints+(tp)
}

/**
 * 10.1.5: Candidates for the effective base class of type parameter `tp`.
 *
 * The definition of effective base class is the *least* among all the candidates,
 * but since we only care about all base types of the effective base class
 * (`getABaseType*()`), we do not need to compute the smallest, but rather
 * consider all base types of all candidates.
 */
private Class effectiveBaseClassCandidate(TypeParameter tp) {
  not hasPrimaryConstraints(tp) and result instanceof ObjectType
  or
  exists(TypeParameterConstraints tpc | tpc = tp.getConstraints() |
    tpc.hasValueTypeConstraint() and result instanceof SystemValueTypeClass
    or
    result = tpc.getATypeConstraint()
    or
    result = effectiveBaseClassCandidate(tpc.getATypeConstraint())
    or
    tpc.hasRefTypeConstraint() and result instanceof ObjectType
  )
}

/** 10.1.5: Whether type parameter `tp` has primary constraints. */
private predicate hasPrimaryConstraints(TypeParameter tp) {
  exists(TypeParameterConstraints tpc | tpc = tp.getConstraints() |
    tpc.getATypeConstraint() instanceof Class
    or
    tpc.hasRefTypeConstraint()
    or
    tpc.hasValueTypeConstraint()
  )
}

/** 10.1.5: The effective interface set of a type parameter `tp` */
private Interface effectiveInterfaceSet(TypeParameter tp) {
  exists(TypeParameterConstraints tpc | tpc = tp.getConstraints() |
    result = tpc.getATypeConstraint()
    or
    result = effectiveInterfaceSet(tpc.getATypeConstraint())
  )
}

private TypeParameter getATypeParameterFromConstraints(TypeParameter tp) {
  result = tp.getConstraints().getATypeConstraint()
}

/**
 * INTERNAL: Do not use.
 *
 * Holds if there is an implicit operator conversion from `fromType` to `toType`.
 *
 * 6.1.11: User-defined implicit conversions.
 */
predicate convConversionOperator(Type fromType, Type toType) {
  exists(ImplicitConversionOperator ico |
    ico.getSourceType() = fromType and
    ico.getTargetType() = toType
  )
}

/** 13.1.3.2: Variance conversion. */
private predicate convVariance(GenericType fromType, GenericType toType) {
  // Semantically equivalent with
  // ```ql
  // ugt = fromType.getUnboundGeneric()
  // and
  // forex(int i |
  //   i in [0 .. ugt.getNumberOfTypeParameters() - 1] |
  //   exists(Type t1, Type t2, TypeParameter tp |
  //     t1 = getTypeArgument(ugt, fromType, i, tp) and
  //     t2 = getTypeArgument(ugt, toType, i, tp) |
  //     convIdentity(t1, t2)
  //     or
  //     convRefTypeNonNull(t1, t2) and tp.isOut()
  //     or
  //     convRefTypeNonNull(t2, t1) and tp.isIn()
  //   )
  // )
  // ```
  // but performance is improved by explicitly evaluating the `i`th argument
  // only when all preceding arguments are convertible.
  Variance::convVarianceSingle(_, fromType, toType)
  or
  exists(UnboundGenericType ugt |
    Variance::convVarianceMultiple(ugt, fromType, toType, ugt.getNumberOfTypeParameters() - 1)
  )
}

private module Variance {
  private class VarianceConvertibleGenericType extends GenericType {
    VarianceConvertibleGenericType() {
      exists(TypeParameter tp | tp = this.getUnboundGeneric().getATypeParameter() |
        tp.isIn()
        or
        tp.isOut()
      )
    }
  }

  /**
   * Gets the number of different type arguments supplied for the type
   * parameter at index `i` in unbound generic type `ugt`.
   */
  private int getTypeArgumentCount(UnboundGenericType ugt, int i) {
    result =
      strictcount(Type arg |
        exists(VarianceConvertibleGenericType gt | gt.getUnboundGeneric() = ugt |
          arg = gt.getTypeArgument(i)
        )
      )
  }

  private int rnk(UnboundGenericType ugt, int i) {
    result = rank[i + 1](int j, int k | j = getTypeArgumentCount(ugt, k) | k order by j, k)
  }

  /** Gets the 'i'th type argument, ranked by size, of constructed type `t`. */
  private Type getTypeArgumentRanked(
    UnboundGenericType ugt, VarianceConvertibleGenericType t, int i, TypeParameter tp
  ) {
    result = getTypeArgument(ugt, t, rnk(ugt, i), tp)
  }

  pragma[noinline]
  private Type getATypeArgumentRankedOut(int i) {
    result = getTypeArgumentRanked(_, _, i, any(TypeParameter tp | tp.isOut()))
  }

  pragma[noinline]
  private Type getATypeArgumentRankedIn(int i) {
    result = getTypeArgumentRanked(_, _, i, any(TypeParameter tp | tp.isIn()))
  }

  private predicate convRefTypeTypeArgumentOut(TypeArgument fromType, TypeArgument toType, int i) {
    convRefTypeNonNull(fromType, toType) and
    toType = getATypeArgumentRankedOut(i)
  }

  private predicate convRefTypeTypeArgumentIn(TypeArgument toType, TypeArgument fromType, int i) {
    convRefTypeNonNull(toType, fromType) and
    toType = getATypeArgumentRankedIn(i)
  }

  private newtype TVariance =
    TNone() or
    TIn() or
    TOut()

  /**
   * Holds if `fromTypeArgument` is convertible to `toTypeArgument`, with variance
   * `v`, and both types are the `i`th type argument in _some_ constructed type.
   */
  pragma[nomagic]
  private predicate convTypeArguments(
    TypeArgument fromTypeArgument, TypeArgument toTypeArgument, int i, TVariance v
  ) {
    exists(int j |
      fromTypeArgument = getTypeArgumentRanked(_, _, i, _) and
      toTypeArgument = getTypeArgumentRanked(_, _, j, _) and
      i <= j and
      j <= i
    |
      convIdentity(fromTypeArgument, toTypeArgument) and
      v = TNone()
      or
      convRefTypeTypeArgumentOut(fromTypeArgument, toTypeArgument, j) and
      v = TOut()
      or
      convRefTypeTypeArgumentIn(toTypeArgument, fromTypeArgument, j) and
      v = TIn()
    )
  }

  pragma[nomagic]
  private predicate convTypeArgumentsSomeUnbound(
    UnboundGenericType ugt, TypeArgument fromTypeArgument, TypeArgument toTypeArgument, int i
  ) {
    exists(TypeParameter tp, TVariance v |
      convTypeArguments(fromTypeArgument, toTypeArgument, i, v)
    |
      fromTypeArgument = getTypeArgumentRanked(ugt, _, i, tp) and
      (v = TIn() implies tp.isIn()) and
      (v = TOut() implies tp.isOut())
    )
  }

  /**
   * Holds if `fromTypeArgument` is convertible to `toTypeArgument` and
   * both types are the `i`th type argument in _some_ constructed type
   * based on unbound generic type `ugt`.
   */
  pragma[noinline]
  private predicate convTypeArgumentsSameUnbound(
    UnboundGenericType ugt, TypeArgument fromTypeArgument, TypeArgument toTypeArgument, int i
  ) {
    convTypeArgumentsSomeUnbound(ugt, fromTypeArgument, toTypeArgument, i) and
    toTypeArgument = getTypeArgumentRanked(ugt, _, i, _)
  }

  pragma[nomagic]
  private predicate convVarianceSingle0(
    UnboundGenericType ugt, VarianceConvertibleGenericType toType, TypeArgument fromTypeArgument,
    TypeArgument toTypeArgument
  ) {
    convTypeArgumentsSameUnbound(ugt, fromTypeArgument, toTypeArgument, 0) and
    toTypeArgument = getTypeArgumentRanked(ugt, toType, 0, _) and
    ugt.getNumberOfTypeParameters() = 1
  }

  /**
   * Holds if the type arguments of types `fromType` and `toType` are variance
   * convertible, and the number of type arguments is 1.
   */
  predicate convVarianceSingle(
    UnboundGenericType ugt, VarianceConvertibleGenericType fromType,
    VarianceConvertibleGenericType toType
  ) {
    exists(TypeArgument fromTypeArgument, TypeArgument toTypeArgument |
      convVarianceSingle0(ugt, toType, fromTypeArgument, toTypeArgument)
    |
      fromTypeArgument = getTypeArgumentRanked(ugt, fromType, 0, _)
    )
  }

  pragma[nomagic]
  private predicate convVarianceMultiple01Aux0(
    UnboundGenericType ugt, VarianceConvertibleGenericType toType, TypeArgument fromTypeArgument0,
    TypeArgument toTypeArgument0, TypeArgument toTypeArgument1
  ) {
    convTypeArgumentsSameUnbound(ugt, fromTypeArgument0, toTypeArgument0, 0) and
    toTypeArgument0 = getTypeArgumentRanked(ugt, toType, 0, _) and
    toTypeArgument1 = getTypeArgumentRanked(ugt, toType, 1, _)
  }

  pragma[nomagic]
  private predicate convVarianceMultiple01Aux1(
    UnboundGenericType ugt, VarianceConvertibleGenericType fromType, TypeArgument fromTypeArgument0,
    TypeArgument fromTypeArgument1, TypeArgument toTypeArgument1
  ) {
    convTypeArgumentsSameUnbound(ugt, fromTypeArgument1, toTypeArgument1, 1) and
    fromTypeArgument0 = getTypeArgumentRanked(ugt, fromType, 0, _) and
    fromTypeArgument1 = getTypeArgumentRanked(ugt, fromType, 1, _)
  }

  /**
   * Holds if the first two ranked type arguments of types `fromType` and `toType`
   * are variance convertible.
   */
  private predicate convVarianceMultiple01(
    UnboundGenericType ugt, VarianceConvertibleGenericType fromType,
    VarianceConvertibleGenericType toType
  ) {
    exists(
      TypeArgument fromTypeArgument0, TypeArgument toTypeArgument0, TypeArgument fromTypeArgument1,
      TypeArgument toTypeArgument1
    |
      convVarianceMultiple01Aux0(ugt, toType, fromTypeArgument0, toTypeArgument0, toTypeArgument1)
    |
      convVarianceMultiple01Aux1(ugt, fromType, fromTypeArgument0, fromTypeArgument1,
        toTypeArgument1)
    )
  }

  pragma[nomagic]
  private predicate convVarianceMultiple2Aux(
    UnboundGenericType ugt, VarianceConvertibleGenericType toType, int i,
    TypeArgument fromTypeArgument, TypeArgument toTypeArgument
  ) {
    convTypeArgumentsSameUnbound(ugt, fromTypeArgument, toTypeArgument, i) and
    toTypeArgument = getTypeArgumentRanked(ugt, toType, i, _) and
    i >= 2
  }

  private predicate convVarianceMultiple2(
    UnboundGenericType ugt, VarianceConvertibleGenericType fromType,
    VarianceConvertibleGenericType toType, int i
  ) {
    exists(TypeArgument fromTypeArgument, TypeArgument toTypeArgument |
      convVarianceMultiple2Aux(ugt, toType, i, fromTypeArgument, toTypeArgument)
    |
      fromTypeArgument = getTypeArgumentRanked(ugt, fromType, i, _)
    )
  }

  /**
   * Holds if the ranked type arguments 0 through `i` (with `i >= 1`) of types
   * `fromType` and `toType` are variance convertible.
   */
  pragma[nomagic]
  predicate convVarianceMultiple(
    UnboundGenericType ugt, VarianceConvertibleGenericType fromType,
    VarianceConvertibleGenericType toType, int i
  ) {
    convVarianceMultiple01(ugt, fromType, toType) and i = 1
    or
    convVarianceMultiple(ugt, fromType, toType, i - 1) and
    convVarianceMultiple2(ugt, fromType, toType, i)
  }
}
