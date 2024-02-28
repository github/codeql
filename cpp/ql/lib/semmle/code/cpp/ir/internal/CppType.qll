private import cpp
private import semmle.code.cpp.ir.implementation.IRType
private import semmle.code.cpp.ir.implementation.raw.internal.IRConstruction::Raw as Raw

private int getPointerSize() { result = max(any(NullPointerType t).getSize()) }

/**
 * Works around an extractor bug where a function reference gets a size of one byte.
 */
private int getTypeSizeWorkaround(Type type) {
  exists(Type unspecifiedType |
    unspecifiedType = type.getUnspecifiedType() and
    (
      (unspecifiedType instanceof FunctionReferenceType or unspecifiedType instanceof RoutineType) and
      result = getPointerSize()
      or
      exists(PointerToMemberType ptmType |
        ptmType = unspecifiedType and
        (
          if ptmType.getBaseType().getUnspecifiedType() instanceof RoutineType
          then result = getPointerSize() * 2
          else result = getPointerSize()
        )
      )
      or
      exists(ArrayType arrayType |
        // Treat `T[]` as `T*`.
        arrayType = unspecifiedType and
        not arrayType.hasArraySize() and
        result = getPointerSize()
      )
    )
  )
}

private int getTypeSize(Type type) {
  if exists(getTypeSizeWorkaround(type))
  then result = getTypeSizeWorkaround(type)
  else result = type.getSize()
}

/**
 * Holds if an `IRErrorType` should exist.
 */
predicate hasErrorType() { exists(ErroneousType t) }

/**
 * Holds if an `IRBooleanType` with the specified `byteSize` should exist.
 */
predicate hasBooleanType(int byteSize) { byteSize = getTypeSize(any(BoolType type)) }

private predicate isSigned(IntegralOrEnumType type) {
  type.(IntegralType).isSigned()
  or
  exists(Enum enumType |
    // If the enum has an explicit underlying type, we'll determine signedness from that. If not,
    // we'll assume unsigned. The actual rules for the implicit underlying type of an enum vary
    // between compilers, so we'll need an extractor change to get this 100% right. Until then,
    // unsigned is a reasonable default.
    enumType = type.getUnspecifiedType() and
    enumType.getExplicitUnderlyingType().getUnspecifiedType().(IntegralType).isSigned()
  )
}

private predicate isSignedIntegerType(IntegralOrEnumType type) {
  isSigned(type) and not type instanceof BoolType
}

private predicate isUnsignedIntegerType(IntegralOrEnumType type) {
  not isSigned(type) and not type instanceof BoolType
}

/**
 * Holds if an `IRSignedIntegerType` with the specified `byteSize` should exist.
 */
predicate hasSignedIntegerType(int byteSize) {
  byteSize = any(IntegralOrEnumType type | isSignedIntegerType(type)).getSize()
}

/**
 * Holds if an `IRUnsignedIntegerType` with the specified `byteSize` should exist.
 */
predicate hasUnsignedIntegerType(int byteSize) {
  byteSize = any(IntegralOrEnumType type | isUnsignedIntegerType(type)).getSize()
}

/**
 * Holds if an `IRFloatingPointType` with the specified size, base, and type domain should exist.
 */
predicate hasFloatingPointType(int byteSize, int base, TypeDomain domain) {
  exists(FloatingPointType type |
    byteSize = type.getSize() and
    base = type.getBase() and
    domain = type.getDomain()
  )
}

private predicate isPointerIshType(Type type) {
  type instanceof PointerType
  or
  type instanceof ReferenceType
  or
  type instanceof NullPointerType
  or
  // Treat `T[]` as a pointer. The only place we should see these is as the type of a parameter. If
  // the corresponding decayed `T*` type is available, we'll use that, but if it's not available,
  // we're stuck with `T[]`. Just treat it as a pointer.
  type instanceof ArrayType and not exists(type.getSize())
}

/**
 * Holds if an `IRAddressType` with the specified `byteSize` should exist.
 */
predicate hasAddressType(int byteSize) {
  // This covers all pointers, all references, and because it also looks at `NullPointerType`, it
  // should always return a result that makes sense for arbitrary glvalues as well.
  byteSize = any(Type type | isPointerIshType(type)).getSize()
}

/**
 * Holds if an `IRFunctionAddressType` with the specified `byteSize` should exist.
 */
predicate hasFunctionAddressType(int byteSize) {
  byteSize = getPointerSize() or // Covers function lvalues
  byteSize = getTypeSize(any(FunctionPointerIshType type))
}

private predicate isOpaqueType(Type type) {
  exists(type.getSize()) and // Only include complete types
  (
    type instanceof ArrayType or
    type instanceof Class or
    type instanceof GNUVectorType
  )
  or
  type instanceof PointerToMemberType // PTMs are missing size info
}

/**
 * Holds if an `IROpaqueType` with the specified `tag` and `byteSize` should exist.
 */
predicate hasOpaqueType(Type tag, int byteSize) {
  isOpaqueType(tag) and byteSize = getTypeSize(tag.getUnspecifiedType())
  or
  tag instanceof UnknownType and Raw::needsUnknownOpaqueType(byteSize)
}

/**
 * Gets the `IRType` that represents a prvalue of the specified `Type`.
 */
private IRType getIRTypeForPRValue(Type type) {
  exists(Type unspecifiedType | unspecifiedType = type.getUnspecifiedType() |
    isOpaqueType(unspecifiedType) and
    exists(IROpaqueType opaqueType | opaqueType = result |
      opaqueType.getByteSize() = getTypeSize(unspecifiedType) and
      opaqueType.getTag() = unspecifiedType
    )
    or
    unspecifiedType instanceof BoolType and
    result.(IRBooleanType).getByteSize() = unspecifiedType.getSize()
    or
    isSignedIntegerType(unspecifiedType) and
    result.(IRSignedIntegerType).getByteSize() = unspecifiedType.getSize()
    or
    isUnsignedIntegerType(unspecifiedType) and
    result.(IRUnsignedIntegerType).getByteSize() = unspecifiedType.getSize()
    or
    exists(FloatingPointType floatType, IRFloatingPointType irFloatType |
      floatType = unspecifiedType and
      irFloatType = result and
      irFloatType.getByteSize() = floatType.getSize() and
      irFloatType.getBase() = floatType.getBase() and
      irFloatType.getDomain() = floatType.getDomain()
    )
    or
    isPointerIshType(unspecifiedType) and
    result.(IRAddressType).getByteSize() = getTypeSize(unspecifiedType)
    or
    (unspecifiedType instanceof FunctionPointerIshType or unspecifiedType instanceof RoutineType) and
    result.(IRFunctionAddressType).getByteSize() = getTypeSize(type)
    or
    unspecifiedType instanceof VoidType and result instanceof IRVoidType
    or
    unspecifiedType instanceof ErroneousType and result instanceof IRErrorType
    or
    unspecifiedType instanceof UnknownType and result instanceof IRUnknownType
  )
}

cached
private newtype TCppType =
  TPRValueType(Type type) { exists(getIRTypeForPRValue(type)) } or
  TFunctionGLValueType() or
  TGLValueAddressType(Type type) or
  TUnknownOpaqueType(int byteSize) { Raw::needsUnknownOpaqueType(byteSize) } or
  TUnknownType()

/**
 * The C++ type of an IR entity.
 * This cannot just be `Type` for a couple reasons:
 * - Some types needed by the IR might not exist in the database (e.g. `RoutineType`s for functions
 *   that are always called directly)
 * - Some types needed by the IR are not representable in the C++ type system (e.g. the result type
 *   of a `VariableAddress` where the variable is of reference type)
 */
class CppType extends TCppType {
  /** Gets a textual representation of this type. */
  string toString() { none() }

  /** Gets a string used in IR dumps */
  string getDumpString() { result = this.toString() }

  /** Gets the size of the type in bytes, if known. */
  final int getByteSize() { result = this.getIRType().getByteSize() }

  /**
   * Gets the `IRType` that represents this `CppType`. Many different `CppType`s can map to a single
   * `IRType`.
   */
  cached
  IRType getIRType() { none() }

  /**
   * Holds if the `CppType` represents a prvalue of type `Type` (if `isGLValue` is `false`), or if
   * it represents a glvalue of type `Type` (if `isGLValue` is `true`).
   */
  predicate hasType(Type type, boolean isGLValue) { none() }

  /**
   * Holds if this type represents the C++ unspecified type `type`. If `isGLValue` is `true`, then this type
   * represents a glvalue of type `type`. Otherwise, it represents a prvalue of type `type`.
   */
  final predicate hasUnspecifiedType(Type type, boolean isGLValue) {
    exists(Type specifiedType |
      this.hasType(specifiedType, isGLValue) and
      type = specifiedType.getUnspecifiedType()
    )
  }

  /**
   * Holds if this type represents the C++ type `type` (after resolving
   * typedefs). If `isGLValue` is `true`, then this type represents a glvalue
   * of type `type`. Otherwise, it represents a prvalue of type `type`.
   */
  final predicate hasUnderlyingType(Type type, boolean isGLValue) {
    exists(Type typedefType |
      this.hasType(typedefType, isGLValue) and
      type = typedefType.getUnderlyingType()
    )
  }
}

/**
 * A `CppType` that wraps an existing `Type` (either as a prvalue or a glvalue).
 */
private class CppWrappedType extends CppType {
  Type ctype;

  CppWrappedType() {
    this = TPRValueType(ctype) or
    this = TGLValueAddressType(ctype)
  }
}

/**
 * A `CppType` that represents a prvalue of an existing `Type`.
 */
private class CppPRValueType extends CppWrappedType, TPRValueType {
  final override string toString() { result = ctype.toString() }

  final override string getDumpString() { result = ctype.getUnspecifiedType().toString() }

  final override IRType getIRType() { result = getIRTypeForPRValue(ctype) }

  final override predicate hasType(Type type, boolean isGLValue) {
    type = ctype and
    isGLValue = false
  }
}

/**
 * A `CppType` that has unknown type but a known size. Generally to represent synthesized types that
 * occur in certain cases during IR construction, such as the type of a zero-initialized segment of
 * a partially-initialized array.
 */
private class CppUnknownOpaqueType extends CppType, TUnknownOpaqueType {
  int byteSize;

  CppUnknownOpaqueType() { this = TUnknownOpaqueType(byteSize) }

  final override string toString() { result = "unknown[" + byteSize.toString() + "]" }

  final override IROpaqueType getIRType() {
    result.getByteSize() = byteSize and result.getTag() instanceof UnknownType
  }

  override predicate hasType(Type type, boolean isGLValue) {
    type instanceof UnknownType and isGLValue = false
  }
}

/**
 * A `CppType` that represents a glvalue of an existing `Type`.
 */
private class CppGLValueAddressType extends CppWrappedType, TGLValueAddressType {
  final override string toString() { result = "glval<" + ctype.toString() + ">" }

  final override string getDumpString() {
    result = "glval<" + ctype.getUnspecifiedType().toString() + ">"
  }

  final override IRAddressType getIRType() { result.getByteSize() = getPointerSize() }

  final override predicate hasType(Type type, boolean isGLValue) {
    type = ctype and
    isGLValue = true
  }
}

/**
 * A `CppType` that represents a function lvalue.
 */
private class CppFunctionGLValueType extends CppType, TFunctionGLValueType {
  final override string toString() { result = "glval<unknown>" }

  final override IRFunctionAddressType getIRType() { result.getByteSize() = getPointerSize() }

  final override predicate hasType(Type type, boolean isGLValue) {
    type instanceof UnknownType and isGLValue = true
  }
}

/**
 * A `CppType` that represents an unknown type.
 */
private class CppUnknownType extends CppType, TUnknownType {
  final override string toString() { result = any(UnknownType type).toString() }

  final override IRUnknownType getIRType() { any() }

  final override predicate hasType(Type type, boolean isGLValue) {
    type instanceof UnknownType and isGLValue = false
  }
}

/**
 * Gets the single instance of `CppUnknownType`.
 */
CppUnknownType getUnknownType() { any() }

/**
 * Gets the `CppType` that represents a prvalue of type `void`.
 */
CppPRValueType getVoidType() { exists(VoidType voidType | result.hasType(voidType, false)) }

/**
 * Gets the `CppType` that represents a prvalue of type `type`.
 */
CppType getTypeForPRValue(Type type) {
  if type instanceof UnknownType
  then result instanceof CppUnknownType
  else result.hasType(type, false)
}

/**
 * Gets the `CppType` that represents a prvalue of type `type`, if such a `CppType` exists.
 * Otherwise, gets `CppUnknownType`.
 */
CppType getTypeForPRValueOrUnknown(Type type) {
  result = getTypeForPRValue(type)
  or
  not exists(getTypeForPRValue(type)) and result = getUnknownType()
}

/**
 * Gets the `CppType` that represents a glvalue of type `type`.
 */
CppGLValueAddressType getTypeForGLValue(Type type) { result.hasType(type, true) }

/**
 * Gets the `CppType` that represents a prvalue of type `int`.
 */
CppPRValueType getIntType() {
  exists(IntType type |
    type.isImplicitlySigned() and
    result.hasType(type, false)
  )
}

/**
 * Gets the `CppType` that represents a prvalue of type `bool`.
 */
CppPRValueType getBoolType() { exists(BoolType type | result.hasType(type, false)) }

/**
 * Gets the `CppType` that represents a glvalue of type `bool`.
 */
CppType getBoolGLValueType() { exists(BoolType type | result.hasType(type, true)) }

/**
 * Gets the `CppType` that represents a glvalue of function type.
 */
CppFunctionGLValueType getFunctionGLValueType() { any() }

/**
 * Gets the `CppType` that represents a opaque of unknown type with size `byteSize`.
 */
CppUnknownOpaqueType getUnknownOpaqueType(int byteSize) { result.getByteSize() = byteSize }

/**
 * Gets the `CppType` that is the canonical type for an `IRBooleanType` with the specified
 * `byteSize`.
 */
CppWrappedType getCanonicalBooleanType(int byteSize) {
  exists(BoolType type | result = TPRValueType(type) and byteSize = type.getSize())
}

/**
 * Compute the sorting priority of an `IntegralType` based on its signedness.
 */
private int getSignPriority(IntegralType type) {
  // Explicitly unsigned types sort first. Explicitly signed types sort last. Types with no explicit
  // signedness sort in between. This lets us always choose `int` over `signed int`, while also
  // choosing `unsigned char`+`char` when `char` is signed, and `unsigned char`+`signed char` when
  // `char` is unsigned.
  if type.isExplicitlyUnsigned()
  then result = 2
  else
    if type.isExplicitlySigned()
    then result = 0
    else result = 1
}

/**
 * Gets the sort priority of an `IntegralType` based on its kind.
 */
private int getKindPriority(IntegralType type) {
  // `CharType` sorts lower so that we prefer the plain integer types when they have the same size
  // as a `CharType`.
  if type instanceof CharType then result = 0 else result = 1
}

/**
 * Gets the `CppType` that is the canonical type for an `IRSignedIntegerType` with the specified
 * `byteSize`.
 */
CppPRValueType getCanonicalSignedIntegerType(int byteSize) {
  result =
    TPRValueType(max(IntegralType type |
        type.isSigned() and type.getSize() = byteSize
      |
        type order by getKindPriority(type), getSignPriority(type), type.toString() desc
      ))
}

/**
 * Gets the `CppType` that is the canonical type for an `IRUnsignedIntegerType` with the specified
 * `byteSize`.
 */
CppPRValueType getCanonicalUnsignedIntegerType(int byteSize) {
  result =
    TPRValueType(max(IntegralType type |
        type.isUnsigned() and type.getSize() = byteSize
      |
        type order by getKindPriority(type), getSignPriority(type), type.toString() desc
      ))
}

/**
 * Gets the sort priority of a `RealNumberType` base on its precision.
 */
private int getPrecisionPriority(RealNumberType type) {
  // Prefer `double`, `float`, `long double` in that order.
  if type instanceof DoubleType
  then result = 4
  else
    if type instanceof FloatType
    then result = 3
    else
      if type instanceof LongDoubleType
      then result = 2
      else
        // If we get this far, prefer non-extended-precision types.
        if not type.isExtendedPrecision()
        then result = 1
        else result = 0
}

/**
 * Gets the `CppType` that is the canonical type for an `IRFloatingPointType` with the specified
 * size, base, and type domain.
 */
CppPRValueType getCanonicalFloatingPointType(int byteSize, int base, TypeDomain domain) {
  result =
    TPRValueType(max(FloatingPointType type |
        type.getSize() = byteSize and
        type.getBase() = base and
        type.getDomain() = domain
      |
        type order by getPrecisionPriority(type.getRealType()), type.toString() desc
      ))
}

/**
 * Gets the `CppType` that is the canonical type for an `IRAddressType` with the specified
 * `byteSize`.
 */
CppPRValueType getCanonicalAddressType(int byteSize) {
  // We just use `NullPointerType`, since it should be unique.
  exists(NullPointerType type |
    type.getSize() = byteSize and
    result = TPRValueType(type)
  )
}

/**
 * Gets the `CppType` that is the canonical type for an `IRFunctionAddressType` with the specified
 * `byteSize`.
 */
CppFunctionGLValueType getCanonicalFunctionAddressType(int byteSize) {
  result.getByteSize() = byteSize
}

/**
 * Gets the `CppType` that is the canonical type for `IRErrorType`.
 */
CppPRValueType getCanonicalErrorType() { result = TPRValueType(any(ErroneousType type)) }

/**
 * Gets the `CppType` that is the canonical type for `IRUnknownType`.
 */
CppUnknownType getCanonicalUnknownType() { any() }

/**
 * Gets the `CppType` that is the canonical type for `IRVoidType`.
 */
CppPRValueType getCanonicalVoidType() { result = TPRValueType(any(VoidType type)) }

/**
 * Gets the `CppType` that is the canonical type for an `IROpaqueType` with the specified `tag` and
 * `byteSize`.
 */
CppType getCanonicalOpaqueType(Type tag, int byteSize) {
  isOpaqueType(tag) and
  result = TPRValueType(tag.getUnspecifiedType()) and
  getTypeSize(tag) = byteSize
  or
  tag instanceof UnknownType and result = getUnknownOpaqueType(byteSize)
}

/**
 * Gets a string that uniquely identifies an `IROpaqueType` tag. Using `toString` here might
 * not be sufficient to ensure uniqueness, but suffices for our current debugging purposes.
 * To ensure uniqueness `getOpaqueTagIdentityString` from `semmle.code.cpp.Print` could be used,
 * but that comes at the cost of importing all the `Dump` classes defined in that library.
 */
string getOpaqueTagIdentityString(Type tag) {
  hasOpaqueType(tag, _) and
  result = tag.toString()
}

module LanguageTypeConsistency {
  /**
   * Consistency query to detect C++ `Type` objects which have no corresponding `CppType` object.
   */
  query predicate missingCppType(Type type, string message) {
    not exists(getTypeForPRValue(type)) and
    exists(type.getSize()) and
    // `ProxyClass`es have a size, but only appear in uninstantiated templates
    not type instanceof ProxyClass and
    message = "Type does not have an associated `CppType`."
  }
}
