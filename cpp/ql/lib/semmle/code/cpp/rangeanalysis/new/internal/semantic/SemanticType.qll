/**
 * Minimal, language-neutral type system for semantic analysis.
 */

private import SemanticTypeSpecific as Specific

class LanguageType = Specific::Type;

cached
private newtype TSemType =
  TSemVoidType() { Specific::voidType(_) } or
  TSemUnknownType() { Specific::unknownType(_) } or
  TSemErrorType() { Specific::errorType(_) } or
  TSemBooleanType(int byteSize) { Specific::booleanType(_, byteSize) } or
  TSemIntegerType(int byteSize, boolean signed) { Specific::integerType(_, byteSize, signed) } or
  TSemFloatingPointType(int byteSize) { Specific::floatingPointType(_, byteSize) } or
  TSemAddressType(int byteSize) { Specific::addressType(_, byteSize) } or
  TSemFunctionAddressType(int byteSize) { Specific::functionAddressType(_, byteSize) } or
  TSemOpaqueType(int byteSize, Specific::OpaqueTypeTag tag) {
    Specific::opaqueType(_, byteSize, tag)
  }

/**
 * The language-neutral type of a semantic expression,
 * The interface to `SemType` and its subclasses is the same across all languages for which the IR
 * is supported, so analyses that expect to be used for multiple languages should generally use
 * `SemType` rather than a language-specific type.
 *
 * Many types from the language-specific type system will map to a single canonical `SemType`. Two
 * types that map to the same `SemType` are considered equivalent by semantic analysis. As an
 * example, in C++, all pointer types map to the same instance of `SemAddressType`.
 */
class SemType extends TSemType {
  /** Gets a textual representation of this type. */
  string toString() { none() }

  /**
   * Gets a string that uniquely identifies this `SemType`. This string is often the same as the
   * result of `SemType.toString()`, but for some types it may be more verbose to ensure uniqueness.
   */
  string getIdentityString() { result = this.toString() }

  /**
   * Gets the size of the type, in bytes, if known.
   *
   * This will hold for all `SemType` objects except `SemUnknownType` and `SemErrorType`.
   */
  // This predicate is overridden with `pragma[noinline]` in every leaf subclass.
  // This allows callers to ask for things like _the_ floating-point type of
  // size 4 without getting a join that first finds all types of size 4 and
  // _then_ restricts them to floating-point types.
  int getByteSize() { none() }
}

/**
 * An unknown type. Generally used to represent results and operands that access an unknown set of
 * memory locations, such as the side effects of a function call.
 */
class SemUnknownType extends SemType, TSemUnknownType {
  final override string toString() { result = "unknown" }

  final override int getByteSize() { none() }
}

/**
 * A void type, which has no values. Used to represent the result type of an expression that does
 * not produce a result.
 */
class SemVoidType extends SemType, TSemVoidType {
  final override string toString() { result = "void" }

  final override int getByteSize() { result = 0 }
}

/**
 * An error type. Used when an error in the source code prevents the extractor from determining the
 * proper type.
 */
class SemErrorType extends SemType, TSemErrorType {
  final override string toString() { result = "error" }

  final override int getByteSize() { result = 0 }
}

private class SemSizedType extends SemType {
  int byteSize;

  SemSizedType() {
    this = TSemBooleanType(byteSize) or
    this = TSemIntegerType(byteSize, _) or
    this = TSemFloatingPointType(byteSize) or
    this = TSemAddressType(byteSize) or
    this = TSemFunctionAddressType(byteSize) or
    this = TSemOpaqueType(byteSize, _)
  }
  // Don't override `getByteSize()` here. The optimizer seems to generate better code when this is
  // overridden only in the leaf classes.
}

/**
 * A Boolean type, which can hold the values `true` (non-zero) or `false` (zero).
 */
class SemBooleanType extends SemSizedType, TSemBooleanType {
  final override string toString() { result = "bool" + byteSize.toString() }

  pragma[noinline]
  final override int getByteSize() { result = byteSize }
}

/**
 * A numeric type. This includes `SemSignedIntegerType`, `SemUnsignedIntegerType`, and
 * `SemFloatingPointType`.
 */
class SemNumericType extends SemSizedType {
  SemNumericType() {
    this = TSemIntegerType(byteSize, _) or
    this = TSemFloatingPointType(byteSize)
  }
  // Don't override `getByteSize()` here. The optimizer seems to generate better code when this is
  // overridden only in the leaf classes.
}

/**
 * An integer type. This includes `SemSignedIntegerType` and `SemUnsignedIntegerType`.
 */
class SemIntegerType extends SemNumericType {
  boolean signed;

  SemIntegerType() { this = TSemIntegerType(byteSize, signed) }

  /** Holds if this integer type is signed. */
  final predicate isSigned() { signed = true }

  /** Holds if this integer type is unsigned. */
  final predicate isUnsigned() { not this.isSigned() }
  // Don't override `getByteSize()` here. The optimizer seems to generate better code when this is
  // overridden only in the leaf classes.
}

/**
 * A signed two's-complement integer. Also used to represent enums whose underlying type is a signed
 * integer, as well as character types whose representation is signed.
 */
class SemSignedIntegerType extends SemIntegerType {
  SemSignedIntegerType() { signed = true }

  final override string toString() { result = "int" + byteSize.toString() }

  pragma[noinline]
  final override int getByteSize() { result = byteSize }
}

/**
 * An unsigned two's-complement integer. Also used to represent enums whose underlying type is an
 * unsigned integer, as well as character types whose representation is unsigned.
 */
class SemUnsignedIntegerType extends SemIntegerType {
  SemUnsignedIntegerType() { signed = false }

  final override string toString() { result = "uint" + byteSize.toString() }

  pragma[noinline]
  final override int getByteSize() { result = byteSize }
}

/**
 * A floating-point type.
 */
class SemFloatingPointType extends SemNumericType, TSemFloatingPointType {
  final override string toString() { result = "float" + byteSize.toString() }

  pragma[noinline]
  final override int getByteSize() { result = byteSize }
}

/**
 * An address type, representing the memory address of data. Used to represent pointers, references,
 * and lvalues, include those that are garbage collected.
 *
 * The address of a function is represented by the separate `SemFunctionAddressType`.
 */
class SemAddressType extends SemSizedType, TSemAddressType {
  final override string toString() { result = "addr" + byteSize.toString() }

  pragma[noinline]
  final override int getByteSize() { result = byteSize }
}

/**
 * An address type, representing the memory address of code. Used to represent function pointers,
 * function references, and the target of a direct function call.
 */
class SemFunctionAddressType extends SemSizedType, TSemFunctionAddressType {
  final override string toString() { result = "func" + byteSize.toString() }

  pragma[noinline]
  final override int getByteSize() { result = byteSize }
}

/**
 * A type with known size that does not fit any of the other kinds of type. Used to represent
 * classes, structs, unions, fixed-size arrays, pointers-to-member, and more.
 */
class SemOpaqueType extends SemSizedType, TSemOpaqueType {
  Specific::OpaqueTypeTag tag;

  SemOpaqueType() { this = TSemOpaqueType(byteSize, tag) }

  final override string toString() {
    result = "opaque" + byteSize.toString() + "{" + tag.toString() + "}"
  }

  final override string getIdentityString() {
    result = "opaque" + byteSize.toString() + "{" + Specific::getOpaqueTagIdentityString(tag) + "}"
  }

  /**
   * Gets the "tag" that differentiates this type from other incompatible opaque types that have the
   * same size.
   */
  final Specific::OpaqueTypeTag getTag() { result = tag }

  pragma[noinline]
  final override int getByteSize() { result = byteSize }
}

cached
SemType getSemanticType(Specific::Type type) {
  exists(int byteSize |
    Specific::booleanType(type, byteSize) and result = TSemBooleanType(byteSize)
    or
    exists(boolean signed |
      Specific::integerType(type, byteSize, signed) and
      result = TSemIntegerType(byteSize, signed)
    )
    or
    Specific::floatingPointType(type, byteSize) and result = TSemFloatingPointType(byteSize)
    or
    Specific::addressType(type, byteSize) and result = TSemAddressType(byteSize)
    or
    Specific::functionAddressType(type, byteSize) and result = TSemFunctionAddressType(byteSize)
    or
    exists(Specific::OpaqueTypeTag tag |
      Specific::opaqueType(type, byteSize, tag) and result = TSemOpaqueType(byteSize, tag)
    )
  )
  or
  Specific::errorType(type) and result = TSemErrorType()
  or
  Specific::unknownType(type) and result = TSemUnknownType()
}

private class SemNumericOrBooleanType extends SemSizedType {
  SemNumericOrBooleanType() {
    this instanceof SemNumericType
    or
    this instanceof SemBooleanType
  }
}

/**
 * Holds if the conversion from `fromType` to `toType` can never overflow or underflow.
 */
predicate conversionCannotOverflow(SemNumericOrBooleanType fromType, SemNumericOrBooleanType toType) {
  // Identity cast
  fromType = toType
  or
  // Treat any cast to an FP type as safe. It can lose precision, but not overflow.
  toType instanceof SemFloatingPointType and fromType = any(SemNumericType n)
  or
  fromType instanceof SemBooleanType and toType instanceof SemIntegerType
  or
  exists(SemIntegerType fromInteger, SemIntegerType toInteger, int fromSize, int toSize |
    fromInteger = fromType and
    toInteger = toType and
    fromSize = fromInteger.getByteSize() and
    toSize = toInteger.getByteSize()
  |
    // Conversion to a larger type. Safe unless converting signed -> unsigned.
    fromSize < toSize and
    (
      toInteger.isSigned()
      or
      not fromInteger.isSigned()
    )
  )
}

/**
 * INTERNAL: Do not use.
 * Query predicates used to check invariants that should hold for all `SemType` objects.
 */
module SemTypeConsistency {
  /**
   * Holds if the type has no result for `getSemanticType()`.
   */
  query predicate missingSemType(Specific::Type type, string message) {
    not exists(getSemanticType(type)) and
    message = "`Type` does not have a corresponding `SemType`."
  }

  /**
   * Holds if the type has more than one result for `getSemanticType()`.
   */
  query predicate multipleSemTypes(Specific::Type type, string message) {
    strictcount(getSemanticType(type)) > 1 and
    message =
      "`Type` " + type + " has multiple `SemType`s: " +
        concat(getSemanticType(type).toString(), ", ")
  }
}
