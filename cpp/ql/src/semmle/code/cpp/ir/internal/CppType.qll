private import cpp
private import semmle.code.cpp.Print
private import semmle.code.cpp.ir.implementation.IRType
private import semmle.code.cpp.ir.implementation.raw.internal.IRConstruction as IRConstruction

/**
 * Works around an extractor bug where a function reference gets a size of one byte.
 */
private int getTypeSizeWorkaround(Type type) {
  exists(Type unspecifiedType |
    unspecifiedType = type.getUnspecifiedType() and
    (
      unspecifiedType instanceof FunctionReferenceType and
      result = any(NullPointerType t).getSize()
      or
      exists(PointerToMemberType ptmType |
        ptmType = unspecifiedType and
        (
          if ptmType.getBaseType().getUnspecifiedType() instanceof RoutineType
          then result = any(NullPointerType t).getSize() * 2
          else result = any(NullPointerType t).getSize()
        )
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
 * Holds if an `IRBooleanType` with the specified `byteSize` should exist.
 */
predicate hasBooleanType(int byteSize) {
  byteSize = getTypeSize(any(BoolType type))
}

private predicate isSigned(IntegralOrEnumType type) {
  type.(IntegralType).isSigned() or
  exists(Enum enumType |
    enumType = type.getUnspecifiedType() and
    (
      enumType.getExplicitUnderlyingType().getUnspecifiedType().(IntegralType).isSigned() or
      not exists(enumType.getExplicitUnderlyingType())  // Assume signed.
    )
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
 * Holds if an `IRFloatingPointType` with the specified `byteSize` should exist.
 */
predicate hasFloatingPointType(int byteSize) {
  byteSize = any(FloatingPointType type).getSize()
}

private predicate isPointerIshType(Type type) {
  type instanceof PointerType or
  type instanceof ReferenceType or
  type instanceof NullPointerType
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
  byteSize = any(NullPointerType type).getSize() or // Covers function lvalues
  byteSize = getTypeSize(any(FunctionPointerIshType type))
}

private predicate isBlobType(Type type) {
  (
    exists(type.getSize()) and // Only include complete types
    (
      type instanceof ArrayType or
      type instanceof Class or
      type instanceof GNUVectorType
    )
  ) or
  type instanceof PointerToMemberType // PTMs are missing size info
}

/**
 * Holds if an `IRBlobType` with the specified `tag` and `byteSize` should exist.
 */
predicate hasBlobType(Type tag, int byteSize) {
  isBlobType(tag) and byteSize = getTypeSize(tag)
  or
  tag instanceof UnknownType and IRConstruction::needsUnknownBlobType(byteSize)
}

/**
 * Gets the `IRType` that represents a prvalue of the specified `Type`.
 */
private IRType getIRTypeForPRValue(Type type) {
  exists(Type unspecifiedType |
    unspecifiedType = type.getUnspecifiedType() |
    (
      isBlobType(unspecifiedType) and
      exists(IRBlobType blobType |
        blobType = result |
        blobType.getByteSize() = getTypeSize(type) and
        blobType.getTag() = unspecifiedType
      )
    ) or
    unspecifiedType instanceof BoolType and result.(IRBooleanType).getByteSize() = type.getSize() or
    isSignedIntegerType(unspecifiedType) and result.(IRSignedIntegerType).getByteSize() = type.getSize() or
    isUnsignedIntegerType(unspecifiedType) and result.(IRUnsignedIntegerType).getByteSize() = type.getSize() or
    unspecifiedType instanceof FloatingPointType and result.(IRFloatingPointType).getByteSize() = type.getSize() or
    isPointerIshType(unspecifiedType) and result.(IRAddressType).getByteSize() = type.getSize() or
    unspecifiedType instanceof FunctionPointerIshType and result.(IRFunctionAddressType).getByteSize() = getTypeSize(type) or
    unspecifiedType instanceof VoidType and result instanceof IRVoidType or
    unspecifiedType instanceof ErroneousType and result instanceof IRErrorType or
    unspecifiedType instanceof UnknownType and result instanceof IRUnknownType
  )
}

private newtype TCppType =
  TPRValueType(Type type) {
    exists(getIRTypeForPRValue(type))
  } or
  TFunctionGLValueType() or
  TGLValueAddressType(Type type) {
    any()
  } or
  TUnknownBlobType(int byteSize) {
    IRConstruction::needsUnknownBlobType(byteSize)
  } or
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
  string toString() {
    result = ""
  }

  /** Gets a string used in IR dumps */
  string getDumpString() { result = toString() }

  /** Gets the size of the type in bytes, if known. */
  final int getByteSize() { result = getIRType().getByteSize() }

  /**
   * Gets the `IRType` that represents this `CppType`. Many different `CppType`s can map to a single
   * `IRType`.
   */
  abstract IRType getIRType();

  /**
   * Holds if the `CppType` represents a prvalue of type `Type` (if `isGLValue` is `false`), or if
   * it represents a glvalue of type `Type` (if `isGLValue` is `true`).
   */
  abstract predicate hasType(Type type, boolean isGLValue);
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

  abstract override IRType getIRType();
  abstract override predicate hasType(Type type, boolean isGLValue);
}

/**
 * A `CppType` that represents a prvalue of an existing `Type`.
 */
private class CppPRValueType extends CppWrappedType, TPRValueType {
  override final string toString() { result = ctype.toString() }

  override final string getDumpString() { result = ctype.getUnspecifiedType().toString() }

  override final IRType getIRType() { result = getIRTypeForPRValue(ctype) }

  override final predicate hasType(Type type, boolean isGLValue) {
    type = ctype and
    isGLValue = false
  }
}

/**
 * A `CppType` that has unknown type but a known size. Generally to represent synthesized types that
 * occur in certain cases during IR construction, such as the type of a zero-initialized segment of
 * a partially-initialized array.
 */
private class CppUnknownBlobType extends CppType, TUnknownBlobType {
  int byteSize;

  CppUnknownBlobType() {
    this = TUnknownBlobType(byteSize)
  }

  override final string toString() {
    result = "unknown[" + byteSize.toString() + "]"
  }

  override final IRBlobType getIRType() {
    result.getByteSize() = byteSize
  }

  override predicate hasType(Type type, boolean isGLValue) {
    type instanceof UnknownType and isGLValue = false
  }
}

/**
 * A `CppType` that represents a glvalue of an existing `Type`.
 */
private class CppGLValueAddressType extends CppWrappedType, TGLValueAddressType {
  override final string toString() {
    result = "glval<" + ctype.toString() + ">"
  }

  override final string getDumpString() {
    result = "glval<" + ctype.getUnspecifiedType().toString() + ">"
  }

  override final IRAddressType getIRType() {
    result.getByteSize() = any(NullPointerType t).getSize()
  }

  override final predicate hasType(Type type, boolean isGLValue) {
    type = ctype and
    isGLValue = true
  }
}

/**
 * A `CppType` that represents a function lvalue.
 */
private class CppFunctionGLValueType extends CppType, TFunctionGLValueType {
  override final string toString() {
    result = "glval<unknown>"
  }

  override final IRFunctionAddressType getIRType() {
    result.getByteSize() = any(NullPointerType type).getSize()
  }

  override final predicate hasType(Type type, boolean isGLValue) {
    type instanceof UnknownType and isGLValue = true
  }
}

/**
 * A `CppType` that represents an unknown type.
 */
private class CppUnknownType extends CppType, TUnknownType {
  override final string toString() {
    result = any(UnknownType type).toString()
  }

  override final IRUnknownType getIRType() {
    any()
  }

  override final predicate hasType(Type type, boolean isGLValue) {
    type instanceof UnknownType and isGLValue = false
  }
}

/**
 * Gets the single instance of `CppUnknownType`.
 */
CppUnknownType getUnknownType() {
  any()
}

/**
 * Gets the `CppType` that represents a prvalue of type `void`.
 */
CppPRValueType getVoidType() {
  exists(VoidType voidType |
    result.hasType(voidType, false)
  )
}

/**
 * Gets the `CppType` that represents a prvalue of type `type`.
 */
CppType getTypeForPRValue(Type type) {
  if type instanceof UnknownType
  then result instanceof CppUnknownType
  else result.hasType(type, false)
}

/**
 * Gets the `CppType` that represents a glvalue of type `type`.
 */
CppType getTypeForGLValue(Type type) {
  result.hasType(type, true)
}

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
CppPRValueType getBoolType() {
  exists(BoolType type |
    result.hasType(type, false)
  )
}

/**
 * Gets the `CppType` that represents a glvalue of function type.
 */
CppFunctionGLValueType getFunctionGLValueType() {
  any()
}

/**
 * Gets the `CppType` that represents a blob of unknown type with size `byteSize`.
 */
CppUnknownBlobType getUnknownBlobType(int byteSize) {
  result.getByteSize() = byteSize
}

/**
 * Gets the `CppType` that is the canonical type for an `IRBooleanType` with the specified
 * `byteSize`.
 */
CppWrappedType getCanonicalBooleanType(int byteSize) {
  exists(BoolType type |
    result = TPRValueType(type) and byteSize = type.getSize()
  )
}

/**
 * Compute the sorting priority of an `IntegralType` based on its signedness.
 */
private int getSignPriority(IntegralType type) {
  /*
    Explicitly unsigned types sort first. Explicitly signed types sort last. Types with no explicit
    signedness sort in between. This lets us always choose `int` over `signed int`, while also
    choosing `unsigned char`+`char` when `char` is signed, and `unsigned char`+`signed char` when
    `char` is unsigned.
  */
  if type.isExplicitlyUnsigned()
  then result = 2
  else if type.isExplicitlySigned()
  then result = 0
  else result = 1
}

/**
 * Gets the sort priority of an `IntegralType` based on its kind.
 */
private int getKindPriority(IntegralType type) {
  /*
    `CharType` sorts lower so that we prefer the plain integer types when they have the same size as
    a `CharType`.
  */
  if type instanceof CharType
  then result = 0
  else result = 1
}

/**
 * Gets the `CppType` that is the canonical type for an `IRSignedIntegerType` with the specified
 * `byteSize`.
 */
CppPRValueType getCanonicalSignedIntegerType(int byteSize) {
  result = TPRValueType(max(IntegralType type | type.isSigned() and type.getSize() = byteSize |
    type order by getKindPriority(type), getSignPriority(type), type.toString() desc))
}

/**
 * Gets the `CppType` that is the canonical type for an `IRUnsignedIntegerType` with the specified
 * `byteSize`.
 */
CppPRValueType getCanonicalUnsignedIntegerType(int byteSize) {
  result = TPRValueType(max(IntegralType type | type.isUnsigned() and type.getSize() = byteSize |
    type order by getKindPriority(type), getSignPriority(type), type.toString() desc))
}

/**
 * Gets the `CppType` that is the canonical type for an `IRFloatingPointType` with the specified
 * `byteSize`.
 */
CppPRValueType getCanonicalFloatingPointType(int byteSize) {
  result = TPRValueType(max(FloatingPointType type | type.getSize() = byteSize |
    type order by type.toString() desc))
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
CppPRValueType getCanonicalErrorType() {
  result = TPRValueType(any(ErroneousType type))
}

/**
 * Gets the `CppType` that is the canonical type for `IRUnknownType`.
 */
CppUnknownType getCanonicalUnknownType() {
  any()
}

/**
 * Gets the `CppType` that is the canonical type for `IRVoidType`.
 */
CppPRValueType getCanonicalVoidType() {
  result = TPRValueType(any(VoidType type))
}

/**
 * Gets the `CppType` that is the canonical type for an `IRBlobType` with the specified `tag` and
 * `byteSize`.
 */
CppType getCanonicalBlobType(Type tag, int byteSize) {
  isBlobType(tag) and
  result = TPRValueType(tag.getUnspecifiedType()) and
  getTypeSize(tag) = byteSize
  or
  tag instanceof UnknownType and result = getUnknownBlobType(byteSize)
}

/**
 * Gets a string that uniquely identifies an `IRBlobType` tag. This may be different from the usual
 * `toString()` of the tag in order to ensure uniqueness.
 */
string getBlobTagIdentityString(Type tag) {
  hasBlobType(tag, _) and
  result = getTypeIdentityString(tag)
}
