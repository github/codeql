private import csharp
private import experimental.ir.implementation.IRType
private import IRCSharpLanguage as Language

int getTypeSize(Type type) {
  // REVIEW: Is this complete?
  result = type.(SimpleType).getSize()
  or
  result = getTypeSize(type.(Enum).getUnderlyingType())
  or
  // TODO: Generate a reasonable size
  type instanceof Struct and result = 16
  or
  type instanceof RefType and result = getPointerSize()
  or
  type instanceof PointerType and result = getPointerSize()
  or
  result = getTypeSize(type.(TupleType).getUnderlyingType())
  or
  // TODO: Add room for extra field
  result = getTypeSize(type.(NullableType).getUnderlyingType())
  or
  type instanceof VoidType and result = 0
}

int getPointerSize() { result = 8 }

/**
 * Holds if an `IRErrorType` should exist.
 */
predicate hasErrorType() { exists(UnknownType t) }

/**
 * Holds if an `IRBooleanType` with the specified `byteSize` should exist.
 */
predicate hasBooleanType(int byteSize) { byteSize = getTypeSize(any(BoolType type)) }

private predicate isSignedIntegerType(ValueType type) {
  type instanceof SignedIntegralType or
  type.(Enum).getUnderlyingType() instanceof SignedIntegralType
}

private predicate isUnsignedIntegerType(ValueType type) {
  type instanceof UnsignedIntegralType or
  type instanceof CharType or
  type.(Enum).getUnderlyingType() instanceof UnsignedIntegralType
}

/**
 * Holds if an `IRSignedIntegerType` with the specified `byteSize` should exist.
 */
predicate hasSignedIntegerType(int byteSize) {
  byteSize = getTypeSize(any(ValueType type | isSignedIntegerType(type)))
}

/**
 * Holds if an `IRUnsignedIntegerType` with the specified `byteSize` should exist.
 */
predicate hasUnsignedIntegerType(int byteSize) {
  byteSize = getTypeSize(any(ValueType type | isUnsignedIntegerType(type)))
}

/**
 * Holds if an `IRFloatingPointType` with the specified size, base, and type domain should exist.
 */
predicate hasFloatingPointType(int byteSize, int base, Language::TypeDomain domain) {
  byteSize = any(FloatingPointType type).getSize() and
  base = 2 and
  domain instanceof Language::RealDomain
}

private predicate isPointerIshType(Type type) {
  type instanceof PointerType or
  type instanceof RefType
}

/**
 * Holds if an `IRAddressType` with the specified `byteSize` should exist.
 */
predicate hasAddressType(int byteSize) {
  // This covers all pointers, all references, and because it also looks at `NullType`, it
  // should always return a result that makes sense for arbitrary glvalues as well.
  byteSize = getTypeSize(any(Type type | isPointerIshType(type)))
}

/**
 * Holds if an `IRFunctionAddressType` with the specified `byteSize` should exist.
 */
predicate hasFunctionAddressType(int byteSize) { byteSize = getTypeSize(any(NullType type)) }

private predicate isOpaqueType(ValueOrRefType type) {
  type instanceof Struct or
  type instanceof NullableType or
  type instanceof DecimalType
}

/**
 * Holds if an `IROpaqueType` with the specified `tag` and `byteSize` should exist.
 */
predicate hasOpaqueType(Type tag, int byteSize) {
  isOpaqueType(tag) and byteSize = getTypeSize(tag)
}

private Type getRepresentationType(Type type) {
  result = type.(Enum).getUnderlyingType()
  or
  result = type.(TupleType).getUnderlyingType()
  or
  not type instanceof Enum and not type instanceof TupleType and result = type
}

/**
 * Gets the `IRType` that represents a prvalue of the specified `Type`.
 */
private IRType getIRTypeForPRValue(Type type) {
  exists(Type repType | repType = getRepresentationType(type) |
    exists(IROpaqueType opaqueType | opaqueType = result |
      opaqueType.getByteSize() = getTypeSize(repType) and
      opaqueType.getTag() = repType
    )
    or
    result.(IRBooleanType).getByteSize() = repType.(BoolType).getSize()
    or
    isSignedIntegerType(repType) and
    result.(IRSignedIntegerType).getByteSize() = getTypeSize(repType)
    or
    isUnsignedIntegerType(repType) and
    result.(IRUnsignedIntegerType).getByteSize() = getTypeSize(repType)
    or
    result.(IRFloatingPointType).getByteSize() = repType.(FloatingPointType).getSize()
    or
    isPointerIshType(repType) and result.(IRAddressType).getByteSize() = getTypeSize(repType)
    or
    repType instanceof VoidType and result instanceof IRVoidType
    or
    repType instanceof UnknownType and result instanceof IRErrorType
  )
}

string getOpaqueTagIdentityString(Type tag) { result = tag.getQualifiedName() }

cached
private newtype TCSharpType =
  TPRValueType(Type type) { exists(getIRTypeForPRValue(type)) } or
  TGLValueAddressType(Type type) { any() } or
  TFunctionAddressType() or
  TUnknownType()

class CSharpType extends TCSharpType {
  abstract string toString();

  /** Gets a string used in IR dumps */
  string getDumpString() { result = toString() }

  /** Gets the size of the type in bytes, if known. */
  final int getByteSize() { result = getIRType().getByteSize() }

  /**
   * Gets the `IRType` that represents this `CSharpType`. Many different `CSharpType`s can map to a
   * single `IRType`.
   */
  cached
  abstract IRType getIRType();

  /**
   * Holds if the `CSharpType` represents a prvalue of type `Type` (if `isGLValue` is `false`), or
   * if it represents a glvalue of type `Type` (if `isGLValue` is `true`).
   */
  abstract predicate hasType(Type type, boolean isGLValue);

  final predicate hasUnspecifiedType(Type type, boolean isGLValue) { hasType(type, isGLValue) }
}

/**
 * A `CSharpType` that wraps an existing `Type` (either as a prvalue or a glvalue).
 */
private class CSharpWrappedType extends CSharpType {
  Type cstype;

  CSharpWrappedType() {
    this = TPRValueType(cstype) or
    this = TGLValueAddressType(cstype)
  }

  abstract override string toString();

  abstract override IRType getIRType();

  abstract override predicate hasType(Type type, boolean isGLValue);
}

/**
 * A `CSharpType` that represents a prvalue of an existing `Type`.
 */
private class CSharpPRValueType extends CSharpWrappedType, TPRValueType {
  final override string toString() { result = cstype.toString() }

  final override IRType getIRType() { result = getIRTypeForPRValue(cstype) }

  final override predicate hasType(Type type, boolean isGLValue) {
    type = cstype and
    isGLValue = false
  }
}

/**
 * A `CSharpType` that represents a glvalue of an existing `Type`.
 */
private class CSharpGLValueAddressType extends CSharpWrappedType, TGLValueAddressType {
  final override string toString() { result = "glval<" + cstype.toString() + ">" }

  final override IRAddressType getIRType() { result.getByteSize() = getPointerSize() }

  final override predicate hasType(Type type, boolean isGLValue) {
    type = cstype and
    isGLValue = true
  }
}

/**
 * A `CSharpType` that represents a function address.
 */
private class CSharpFunctionAddressType extends CSharpType, TFunctionAddressType {
  final override string toString() { result = "<funcaddr>" }

  final override IRFunctionAddressType getIRType() { result.getByteSize() = getPointerSize() }

  final override predicate hasType(Type type, boolean isGLValue) {
    type instanceof VoidType and isGLValue = true
  }
}

/**
 * A `CSharpType` that represents an unknown type.
 */
private class CSharpUnknownType extends CSharpType, TUnknownType {
  final override string toString() { result = "<unknown>" }

  final override IRUnknownType getIRType() { any() }

  final override predicate hasType(Type type, boolean isGLValue) {
    type instanceof VoidType and isGLValue = false
  }
}

/**
 * Gets the single instance of `CSharpUnknownType`.
 */
CSharpUnknownType getUnknownType() { any() }

/**
 * Gets the `CSharpType` that represents a prvalue of type `void`.
 */
CSharpPRValueType getVoidType() { exists(VoidType voidType | result.hasType(voidType, false)) }

/**
 * Gets the `CSharpType` that represents a prvalue of type `type`.
 */
CSharpPRValueType getTypeForPRValue(Type type) { result.hasType(type, false) }

/**
 * Gets the `CSharpType` that represents a glvalue of type `type`.
 */
CSharpGLValueAddressType getTypeForGLValue(Type type) { result.hasType(type, true) }

/**
 * Gets the `CSharpType` that represents a prvalue of type `int`.
 */
CSharpPRValueType getIntType() { result.hasType(any(IntType t), false) }

/**
 * Gets the `CSharpType` that represents a prvalue of type `bool`.
 */
CSharpPRValueType getBoolType() { result.hasType(any(BoolType t), false) }

/**
 * Gets the `CSharpType` that represents a prvalue of `NullType`.
 */
CSharpPRValueType getNullType() { result.hasType(any(NullType t), false) }

/**
 * Gets the `CSharpType` that represents a function address.
 */
CSharpFunctionAddressType getFunctionAddressType() { any() }

/**
 * Gets the `CSharpType` that is the canonical type for an `IRBooleanType` with the specified
 * `byteSize`.
 */
CSharpPRValueType getCanonicalBooleanType(int byteSize) {
  exists(BoolType type | result = TPRValueType(type) and byteSize = type.getSize())
}

/**
 * Gets the `CSharpType` that is the canonical type for an `IRSignedIntegerType` with the specified
 * `byteSize`.
 */
CSharpPRValueType getCanonicalSignedIntegerType(int byteSize) {
  result = TPRValueType(any(SignedIntegralType t | t.getSize() = byteSize))
}

/**
 * Gets the `CSharpType` that is the canonical type for an `IRUnsignedIntegerType` with the specified
 * `byteSize`.
 */
CSharpPRValueType getCanonicalUnsignedIntegerType(int byteSize) {
  result = TPRValueType(any(UnsignedIntegralType t | t.getSize() = byteSize))
}

/**
 * Gets the `CSharpType` that is the canonical type for an `IRFloatingPointType` with the specified
 * size, base, and type domain.
 */
CSharpPRValueType getCanonicalFloatingPointType(int byteSize, int base, Language::TypeDomain domain) {
  base = 2 and
  domain instanceof Language::RealDomain and
  result = TPRValueType(any(FloatingPointType type | type.getSize() = byteSize))
}

/**
 * Gets the `CSharpType` that is the canonical type for an `IRAddressType` with the specified
 * `byteSize`.
 */
CSharpPRValueType getCanonicalAddressType(int byteSize) {
  // We just use `NullType`, since it should be unique.
  result = TPRValueType(any(NullType type | getTypeSize(type) = byteSize))
}

/**
 * Gets the `CSharpType` that is the canonical type for an `IRFunctionAddressType` with the specified
 * `byteSize`.
 */
CSharpFunctionAddressType getCanonicalFunctionAddressType(int byteSize) {
  result.getByteSize() = byteSize
}

/**
 * Gets the `CSharpType` that is the canonical type for `IRErrorType`.
 */
CSharpPRValueType getCanonicalErrorType() { result = TPRValueType(any(UnknownType type)) }

/**
 * Gets the `CSharpType` that is the canonical type for `IRUnknownType`.
 */
CSharpUnknownType getCanonicalUnknownType() { any() }

/**
 * Gets the `CSharpType` that is the canonical type for `IRVoidType`.
 */
CSharpPRValueType getCanonicalVoidType() { result = TPRValueType(any(VoidType type)) }

/**
 * Gets the `CSharpType` that is the canonical type for an `IROpaqueType` with the specified `tag` and
 * `byteSize`.
 */
CSharpPRValueType getCanonicalOpaqueType(Type tag, int byteSize) {
  isOpaqueType(tag) and
  result = TPRValueType(tag) and
  getTypeSize(tag) = byteSize
}

module LanguageTypeConsistency {
  // Nothing interesting here for C# yet, but the module still has to exist because it is imported
  // by `IRTypeConsistency`.
}
