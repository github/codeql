/**
 * Minimal, language-neutral type system for the IR.
 */

private import internal.IRTypeInternal

cached
private newtype TIRType =
  TIRVoidType() or
  TIRUnknownType() or
  TIRErrorType() { Language::hasErrorType() } or
  TIRBooleanType(int byteSize) { Language::hasBooleanType(byteSize) } or
  TIRSignedIntegerType(int byteSize) { Language::hasSignedIntegerType(byteSize) } or
  TIRUnsignedIntegerType(int byteSize) { Language::hasUnsignedIntegerType(byteSize) } or
  TIRFloatingPointType(int byteSize) { Language::hasFloatingPointType(byteSize) } or
  TIRAddressType(int byteSize) { Language::hasAddressType(byteSize) } or
  TIRFunctionAddressType(int byteSize) { Language::hasFunctionAddressType(byteSize) } or
  TIROpaqueType(Language::OpaqueTypeTag tag, int byteSize) {
    Language::hasOpaqueType(tag, byteSize)
  }

/**
 * The language-neutral type of an IR `Instruction`, `Operand`, or `IRVariable`.
 * The interface to `IRType` and its subclasses is the same across all languages for which the IR
 * is supported, so analyses that expect to be used for multiple languages should generally use
 * `IRType` rather than a language-specific type.
 *
 * Many types from the language-specific type system will map to a single canonical `IRType`. Two
 * types that map to the same `IRType` are considered equivalent by the IR. As an example, in C++,
 * all pointer types map to the same instance of `IRAddressType`.
 */
class IRType extends TIRType {
  string toString() { none() }

  /**
   * Gets a string that uniquely identifies this `IRType`. This string is often the same as the
   * result of `IRType.toString()`, but for some types it may be more verbose to ensure uniqueness.
   */
  string getIdentityString() { result = toString() }

  /**
   * Gets the size of the type, in bytes, if known.
   *
   * This will hold for all `IRType` objects except `IRUnknownType`.
   */
  // This predicate is overridden with `pragma[noinline]` in every leaf subclass.
  // This allows callers to ask for things like _the_ floating-point type of
  // size 4 without getting a join that first finds all types of size 4 and
  // _then_ restricts them to floating-point types.
  int getByteSize() { none() }

  /**
   * Gets a single instance of `LanguageType` that maps to this `IRType`.
   */
  Language::LanguageType getCanonicalLanguageType() { none() }
}

/**
 * An unknown type. Generally used to represent results and operands that access an unknown set of
 * memory locations, such as the side effects of a function call.
 */
class IRUnknownType extends IRType, TIRUnknownType {
  final override string toString() { result = "unknown" }

  final override int getByteSize() { none() }

  final override Language::LanguageType getCanonicalLanguageType() {
    result = Language::getCanonicalUnknownType()
  }
}

/**
 * A void type, which has no values. Used to represent the result type of an instruction that does
 * not produce a result.
 */
class IRVoidType extends IRType, TIRVoidType {
  final override string toString() { result = "void" }

  final override int getByteSize() { result = 0 }

  final override Language::LanguageType getCanonicalLanguageType() {
    result = Language::getCanonicalVoidType()
  }
}

/**
 * An error type. Used when an error in the source code prevents the extractor from determining the
 * proper type.
 */
class IRErrorType extends IRType, TIRErrorType {
  final override string toString() { result = "error" }

  final override int getByteSize() { result = 0 }

  final override Language::LanguageType getCanonicalLanguageType() {
    result = Language::getCanonicalErrorType()
  }
}

private class IRSizedType extends IRType {
  int byteSize;

  IRSizedType() {
    this = TIRBooleanType(byteSize) or
    this = TIRSignedIntegerType(byteSize) or
    this = TIRUnsignedIntegerType(byteSize) or
    this = TIRFloatingPointType(byteSize) or
    this = TIRAddressType(byteSize) or
    this = TIRFunctionAddressType(byteSize) or
    this = TIROpaqueType(_, byteSize)
  }
}

/**
 * A Boolean type, which can hold the values `true` (non-zero) or `false` (zero).
 */
class IRBooleanType extends IRSizedType, TIRBooleanType {
  final override string toString() { result = "bool" + byteSize.toString() }

  final override Language::LanguageType getCanonicalLanguageType() {
    result = Language::getCanonicalBooleanType(byteSize)
  }

  pragma[noinline]
  final override int getByteSize() { result = byteSize }
}

/**
 * A numberic type. This includes `IRSignedIntegerType`, `IRUnsignedIntegerType`, and
 * `IRFloatingPointType`.
 */
class IRNumericType extends IRSizedType {
  IRNumericType() {
    this = TIRSignedIntegerType(byteSize) or
    this = TIRUnsignedIntegerType(byteSize) or
    this = TIRFloatingPointType(byteSize)
  }
}

/**
 * A signed two's-complement integer. Also used to represent enums whose underlying type is a signed
 * integer, as well as character types whose representation is signed.
 */
class IRSignedIntegerType extends IRNumericType, TIRSignedIntegerType {
  final override string toString() { result = "int" + byteSize.toString() }

  final override Language::LanguageType getCanonicalLanguageType() {
    result = Language::getCanonicalSignedIntegerType(byteSize)
  }

  pragma[noinline]
  final override int getByteSize() { result = byteSize }
}

/**
 * An unsigned two's-complement integer. Also used to represent enums whose underlying type is an
 * unsigned integer, as well as character types whose representation is unsigned.
 */
class IRUnsignedIntegerType extends IRNumericType, TIRUnsignedIntegerType {
  final override string toString() { result = "uint" + byteSize.toString() }

  final override Language::LanguageType getCanonicalLanguageType() {
    result = Language::getCanonicalUnsignedIntegerType(byteSize)
  }

  pragma[noinline]
  final override int getByteSize() { result = byteSize }
}

/**
 * A floating-point type.
 */
class IRFloatingPointType extends IRNumericType, TIRFloatingPointType {
  final override string toString() { result = "float" + byteSize.toString() }

  final override Language::LanguageType getCanonicalLanguageType() {
    result = Language::getCanonicalFloatingPointType(byteSize)
  }

  pragma[noinline]
  final override int getByteSize() { result = byteSize }
}

/**
 * An address type, representing the memory address of data. Used to represent pointers, references,
 * and lvalues, include those that are garbage collected.
 *
 * The address of a function is represented by the separate `IRFunctionAddressType`.
 */
class IRAddressType extends IRSizedType, TIRAddressType {
  final override string toString() { result = "addr" + byteSize.toString() }

  final override Language::LanguageType getCanonicalLanguageType() {
    result = Language::getCanonicalAddressType(byteSize)
  }

  pragma[noinline]
  final override int getByteSize() { result = byteSize }
}

/**
 * An address type, representing the memory address of code. Used to represent function pointers,
 * function references, and the target of a direct function call.
 */
class IRFunctionAddressType extends IRSizedType, TIRFunctionAddressType {
  final override string toString() { result = "func" + byteSize.toString() }

  final override Language::LanguageType getCanonicalLanguageType() {
    result = Language::getCanonicalFunctionAddressType(byteSize)
  }

  pragma[noinline]
  final override int getByteSize() { result = byteSize }
}

/**
 * A type with known size that does not fit any of the other kinds of type. Used to represent
 * classes, structs, unions, fixed-size arrays, pointers-to-member, and more.
 */
class IROpaqueType extends IRSizedType, TIROpaqueType {
  Language::OpaqueTypeTag tag;

  IROpaqueType() { this = TIROpaqueType(tag, byteSize) }

  final override string toString() {
    result = "opaque" + byteSize.toString() + "{" + tag.toString() + "}"
  }

  final override string getIdentityString() {
    result = "opaque" + byteSize.toString() + "{" + Language::getOpaqueTagIdentityString(tag) + "}"
  }

  final override Language::LanguageType getCanonicalLanguageType() {
    result = Language::getCanonicalOpaqueType(tag, byteSize)
  }

  /**
   * Gets the "tag" that differentiates this type from other incompatible opaque types that have the
   * same size.
   */
  final Language::OpaqueTypeTag getTag() { result = tag }

  pragma[noinline]
  final override int getByteSize() { result = byteSize }
}

module IRTypeSanity {
  query predicate missingCanonicalLanguageType(IRType type, string message) {
    not exists(type.getCanonicalLanguageType()) and
    message = "Type does not have a canonical `LanguageType`"
  }

  query predicate multipleCanonicalLanguageTypes(IRType type, string message) {
    strictcount(type.getCanonicalLanguageType()) > 1 and
    message = "Type has multiple canonical `LanguageType`s: " +
        concat(type.getCanonicalLanguageType().toString(), ", ")
  }

  query predicate missingIRType(Language::LanguageType type, string message) {
    not exists(type.getIRType()) and
    message = "`LanguageType` does not have a corresponding `IRType`."
  }

  query predicate multipleIRTypes(Language::LanguageType type, string message) {
    strictcount(type.getIRType()) > 1 and
    message = "`LanguageType` " + type.getAQlClass() + " has multiple `IRType`s: " +
        concat(type.getIRType().toString(), ", ")
  }

  import Language::LanguageTypeSanity
}
