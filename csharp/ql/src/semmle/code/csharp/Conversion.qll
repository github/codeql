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
cached
predicate implicitConversion(Type fromType, Type toType) {
  implicitConversionNonNull(fromType, toType)
  or
  defaultNullConversion(fromType, toType)
}

private predicate implicitConversionNonNull(Type fromType, Type toType) {
  convIdentity(fromType, toType)
  or
  convNumeric(fromType, toType)
  or
  convNullableType(fromType, toType)
  or
  convRefTypeNonNull(fromType, toType)
  or
  convBoxing(fromType, toType)
  or
  convConversionOperator(fromType, toType)
  or
  fromType instanceof DynamicType // 6.1.8
}

private Type getTypeArgument(UnboundGenericType ugt, ConstructedType ct, int i, TypeParameter tp) {
  ct.getUnboundGeneric() = ugt
  and
  not ugt instanceof AnonymousClass
  and
  tp = ugt.getTypeParameter(i)
  and
  result = ct.getTypeArgument(i)
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
  convIdentityStrict(fromType, toType)
}

private class IdentityConvertibleType extends Type {
  IdentityConvertibleType() {
    isIdentityConvertible(this)
  }
}

private class IdentityConvertibleArrayType extends IdentityConvertibleType, ArrayType { }

private class IdentityConvertibleConstructedType extends IdentityConvertibleType {
  IdentityConvertibleConstructedType() {
    this instanceof ConstructedType
  }
}

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
  isIdentityConvertible(t.(ConstructedType).getATypeArgument())
}

private predicate convIdentityStrict(IdentityConvertibleType fromType, IdentityConvertibleType toType) {
  convIdentityObjectDynamic(fromType, toType)
  or
  convIdentityObjectDynamic(toType, fromType)
  or
  convIdentityStrictArrayType(fromType, toType)
  or
  convIdentityStrictConstructedType(fromType, toType)
}

private predicate convIdentityObjectDynamic(ObjectType fromType, DynamicType toType) {
  any()
}

private predicate convIdentityStrictArrayType(IdentityConvertibleArrayType fromType, IdentityConvertibleArrayType toType) {
  convIdentityStrictArrayTypeJoin(fromType, toType, toType.getDimension(), toType.getRank())
}

pragma [noinline]
private predicate convIdentityStrictArrayTypeJoin(IdentityConvertibleArrayType fromType, IdentityConvertibleArrayType toType, int dim, int rnk) {
  convIdentityStrictArrayElementType(fromType, toType.getElementType(), dim, rnk)
}

private predicate convIdentityStrictArrayElementType(IdentityConvertibleArrayType fromType, ArrayElementType aet, int dim, int rnk) {
  convIdentityStrict(fromType.getElementType(), aet) and
  dim = fromType.getDimension() and
  rnk = fromType.getRank()
}

/** A type that is an element type of an array type. */
private class ArrayElementType extends Type {
  ArrayElementType() {
    this = any(ArrayType at).getElementType()
  }
}

private predicate convIdentityStrictConstructedType(IdentityConvertibleConstructedType fromType, IdentityConvertibleConstructedType toType) {
  /* Semantically equivalent with
   * ```
   * ugt = fromType.getUnboundGeneric()
   * and
   * forex(int i |
   *   i in [0 .. ugt.getNumberOfTypeParameters() - 1] |
   *   exists(Type t1, Type t2 |
   *     t1 = getTypeArgument(ugt, fromType, i, _) and
   *     t2 = getTypeArgument(ugt, toType, i, _) |
   *     convIdentity(t1, t2)
   *   )
   * )
   * ```
   * but performance is improved by explicitly evaluating the `i`th argument
   * only when all preceding arguments are convertible.
   */
  exists(UnboundGenericType ugt |
    convIdentityStrictConstructedTypeFromZero(ugt, fromType, toType, ugt.getNumberOfTypeParameters() - 1)
  )
}

/**
 * Holds if the type arguments 0 through `i` of `fromType` and `toType` are identity convertible.
 */
private predicate convIdentityStrictConstructedTypeFromZero(UnboundGenericType ugt, IdentityConvertibleConstructedType fromType, IdentityConvertibleConstructedType toType, int i) {
  exists(Type toTypeArgument |
    convIdentityStrictConstructedTypeFromZeroAux(ugt, fromType, i, toTypeArgument) and
    toTypeArgument = getTypeArgument(ugt, toType, i, _) and
    fromType != toType |
    i = 0
    or
    convIdentityStrictConstructedTypeFromZero(ugt, fromType, toType, i - 1)
  )
}

pragma [nomagic]
private predicate convIdentityStrictConstructedTypeFromZeroAux(UnboundGenericType ugt, IdentityConvertibleConstructedType fromType, int i, Type toTypeArgument) {
  exists(Type fromTypeArgument |
    fromTypeArgument = getTypeArgument(ugt, fromType, i, _) and
    convIdentityTypeArgument(fromTypeArgument, toTypeArgument)
  )
}

private predicate convIdentityTypeArgument(TypeArgument fromType, TypeArgument toType) {
  convIdentity(fromType, toType)
}

/** A type that is an argument in a constructed type. */
private class TypeArgument extends Type {
  TypeArgument() {
    this = any(ConstructedType ct).getATypeArgument()
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

private predicate convNumericFloat(SimpleType toType) {
  toType instanceof DoubleType
}

/**
 * INTERNAL: Do not use.
 *
 * Holds if there is an implicit nullable conversion from `fromType` to `toType`.
 *
 * 6.1.4: Implicit nullable conversions.
 */
predicate convNullableType(ValueOrRefType fromType, NullableType toType) {
  exists(ValueType vt1, ValueType vt2 |
    implicitConversionNonNull(vt1, vt2) |
    toType.getUnderlyingType() = vt2
    and
    (
      fromType = vt1
      or
      fromType.(NullableType).getUnderlyingType() = vt1
    )
  )
}

/*
 * This is a deliberate, small Cartesian product, so we have manually lifted it to force the
 * evaluator to evaluate it in its entirety, rather than trying to optimize it in context.
 */
pragma[noinline]
private
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

/*
 * This is a deliberate, small cartesian product, so we have manually lifted it to force the
 * evaluator to evaluate it in its entirety, rather than trying to optimize it in context.
 */
pragma [noinline]
private
predicate defaultDynamicConversion(Type fromType, Type toType) {
  fromType instanceof RefType and toType instanceof DynamicType
}

/*
 * This is a deliberate, small cartesian product, so we have manually lifted it to force the
 * evaluator to evaluate it in its entirety, rather than trying to optimize it in context.
 */
pragma [noinline]
private
predicate defaultDelegateConversion(RefType fromType, RefType toType) {
  fromType instanceof DelegateType and toType = any(SystemDelegateClass c).getABaseType*()
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
  exists(Type t |
    convIdentity(fromType, t) or convRefTypeRefType(fromType, t) |
    convIdentity(t, toType) or convVariance(t, toType)
  )
}

/*
 * This is a deliberate, small cartesian product, so we have manually lifted it to force the
 * evaluator to evaluate it in its entirety, rather than trying to optimize it in context.
 */
pragma [noinline]
private
predicate defaultArrayConversion(Type fromType, RefType toType) {
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
    exists(ArrayElementType elementType |
      elementType = fromType.getElementType() |
      convIdentity(elementType, argumentType) or
      convRefTypeNonNull(elementType, argumentType)
    )
    and
    toType = ci.getABaseType*()
  )
}

private predicate convArrayTypeCovariance(ArrayType fromType, ArrayType toType) {
  convArrayTypeCovarianceJoin(fromType, toType, toType.getDimension(), toType.getRank())
}

pragma [noinline]
private predicate convArrayTypeCovarianceJoin(ArrayType fromType, ArrayType toType, int dim, int rnk) {
  convArrayElementType(fromType, toType.getElementType(), dim, rnk)
}

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
  exists(Type t |
    convBoxing(fromType, t) |
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

/**
 * INTERNAL: Do not use.
 *
 * Holds if there is a constant expression conversion from `fromType` to `toType`.
 *
 * 6.1.9: Implicit constant expression conversions.
 */
predicate convConstantExpr(SignedIntegralConstantExpr e, SimpleType toType) {
  convConstantIntExpr(e, toType)
  or
  convConstantLongExpr(e) and toType instanceof ULongType
}

private class SignedIntegralConstantExpr extends Expr {
  SignedIntegralConstantExpr() {
    this.getType() instanceof SignedIntegralType and
    this.hasValue()
  }
}

private predicate convConstantIntExpr(SignedIntegralConstantExpr e, SimpleType toType) {
  exists(int n |
    n = e.getValue().toInt() |
    toType = any(SByteType t | n in [t.minValue() .. t.maxValue()]) or
    toType = any(ByteType t | n in [t.minValue() .. t.maxValue()]) or
    toType = any(ShortType t | n in [t.minValue() .. t.maxValue()]) or
    toType = any(UShortType t | n in [t.minValue() .. t.maxValue()]) or
    toType instanceof UIntType and n >= 0 or
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
  exists(Type t |
    convTypeParameter(fromType, t) |
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
  exists(TypeParameterConstraints tpc |
    tpc = tp.getConstraints() |
    tpc.hasValueTypeConstraint() and result instanceof SystemValueTypeClass
    or
    result = tpc.getClassConstraint()
    or
    result = effectiveBaseClassCandidate(tpc.getATypeParameterConstraint())
    or
    tpc.hasRefTypeConstraint() and result instanceof ObjectType
  )
}

/** 10.1.5: Whether type parameter `tp` has primary constraints. */
private predicate hasPrimaryConstraints(TypeParameter tp) {
  exists(TypeParameterConstraints tpc |
    tpc = tp.getConstraints() |
    exists(tpc.getClassConstraint())
    or
    tpc.hasRefTypeConstraint()
    or
    tpc.hasValueTypeConstraint()
  )
}

/** 10.1.5: The effective interface set of a type parameter `tp` */
private Interface effectiveInterfaceSet(TypeParameter tp) {
  exists(TypeParameterConstraints tpc |
    tpc = tp.getConstraints() |
    result = tpc.getAnInterfaceConstraint()
    or
    result = effectiveInterfaceSet(tpc.getATypeParameterConstraint())
  )
}

private TypeParameter getATypeParameterFromConstraints(TypeParameter tp) {
  result = tp.getConstraints().getATypeParameterConstraint()
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
private predicate convVariance(VarianceConvertibleConstructedType fromType, VarianceConvertibleConstructedType toType) {
  /* Semantically equivalent with
   * ```
   * ugt = fromType.getUnboundGeneric()
   * and
   * forex(int i |
   *   i in [0 .. ugt.getNumberOfTypeParameters() - 1] |
   *   exists(Type t1, Type t2, TypeParameter tp |
   *     t1 = getTypeArgument(ugt, fromType, i, tp) and
   *     t2 = getTypeArgument(ugt, toType, i, tp) |
   *     convIdentity(t1, t2)
   *     or
   *     convRefTypeNonNull(t1, t2) and tp.isOut()
   *     or
   *     convRefTypeNonNull(t2, t1) and tp.isIn()
   *   )
   * )
   * ```
   * but performance is improved by explicitly evaluating the `i`th argument
   * only when all preceding arguments are convertible.
   */
  exists(UnboundGenericType ugt |
    convVarianceFromZero(ugt, fromType, toType, ugt.getNumberOfTypeParameters() - 1)
  )
}

/**
 * Holds if the type arguments 0 through `i` of types `fromType` and `toType`
 * are variance convertible.
 */
private predicate convVarianceFromZero(UnboundGenericType ugt, VarianceConvertibleConstructedType fromType, VarianceConvertibleConstructedType toType, int i) {
  exists(Type toTypeArgument |
    convVarianceFromZeroAux(ugt, fromType, i, toTypeArgument) |
    toTypeArgument = getTypeArgument(ugt, toType, i, _) and
    i = 0 and
    fromType != toType
  )
  or
  exists(Type toTypeArgument |
    convVarianceFromZero(ugt, fromType, toType, i - 1) |
    toTypeArgument = getTypeArgument(ugt, toType, i, _) and
    convVarianceFromZeroAux(ugt, fromType, i, toTypeArgument)
  )
}

pragma [nomagic]
private predicate convVarianceFromZeroAux(UnboundGenericType ugt, VarianceConvertibleConstructedType fromType, int i, Type toTypeArgument) {
  exists(Type fromTypeArgument, TypeParameter tp |
    fromTypeArgument = getTypeArgument(ugt, fromType, i, tp) |
    convIdentity(fromTypeArgument, toTypeArgument)
    or
    convRefTypeTypeArgumentOut(fromTypeArgument, toTypeArgument, i) and
    tp.isOut()
    or
    convRefTypeTypeArgumentIn(toTypeArgument, fromTypeArgument, i) and
    tp.isIn()
  )
}

pragma [nomagic]
private predicate convRefTypeTypeArgumentOut(TypeArgument fromType, TypeArgument toType, int i) {
  exists(TypeParameter tp |
    convRefTypeNonNull(fromType, toType) |
    toType = getTypeArgument(_, _, i, tp) and
    tp.isOut()
  )
}

pragma [nomagic]
private predicate convRefTypeTypeArgumentIn(TypeArgument toType, TypeArgument fromType, int i) {
  exists(TypeParameter tp |
    convRefTypeNonNull(toType, fromType) |
    toType = getTypeArgument(_, _, i, tp) and
    tp.isIn()
  )
}

private class VarianceConvertibleConstructedType extends ConstructedType {
  VarianceConvertibleConstructedType() {
    isVarianceConvertible(this, _)
  }
}

/**
 * Holds if constructed type `ct` is potentially variance convertible to
 * or from another constructed type, as a result of the `i`th type
 * argument being potentially convertible.
 */
private predicate isVarianceConvertible(ConstructedType ct, int i) {
  exists(TypeParameter tp, Type t |
    tp = ct.getUnboundGeneric().getTypeParameter(i)
    and
    t = ct.getTypeArgument(i)
    |
    (
      // Anything that is not a type parameter is potentially convertible
      // to/from another type; if the `i`th type parameter is invariant,
      // `t` must be strictly identity convertible
      not t instanceof TypeParameter
      and
      (tp.isIn() or tp.isOut() or convIdentityStrict(t, _))
    )
    or
    exists(TypeParameter s |
      s = t |
      // A type parameter with implicit reference conversion
      exists(convTypeParameterBase(s)) and s.isRefType() and tp.isOut()
      or
      // A type parameter convertible from another type parameter
      exists(TypeParameter u | s = convTypeParameterBase(u) and u.isRefType() and tp.isIn())
    )
  )
}
