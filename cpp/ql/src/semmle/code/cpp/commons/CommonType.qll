import semmle.code.cpp.Type

/**
 * The C/C++ `char*` type.
 */
class CharPointerType extends PointerType {
  CharPointerType() { this.getBaseType() instanceof CharType }

  override string getAPrimaryQlClass() { result = "CharPointerType" }
}

/**
 * The C/C++ `int*` type.
 */
class IntPointerType extends PointerType {
  IntPointerType() { this.getBaseType() instanceof IntType }

  override string getAPrimaryQlClass() { result = "IntPointerType" }
}

/**
 * The C/C++ `void*` type.
 */
class VoidPointerType extends PointerType {
  VoidPointerType() { this.getBaseType() instanceof VoidType }

  override string getAPrimaryQlClass() { result = "VoidPointerType" }
}

/**
 * The C/C++ `size_t` type.
 */
class Size_t extends Type {
  Size_t() {
    this.getUnderlyingType() instanceof IntegralType and
    this.hasName("size_t")
  }

  override string getAPrimaryQlClass() { result = "Size_t" }
}

/**
 * The C/C++ `ssize_t` type.
 */
class Ssize_t extends Type {
  Ssize_t() {
    this.getUnderlyingType() instanceof IntegralType and
    this.hasName("ssize_t")
  }

  override string getAPrimaryQlClass() { result = "Ssize_t" }
}

/**
 * The C/C++ `ptrdiff_t` type.
 */
class Ptrdiff_t extends Type {
  Ptrdiff_t() {
    this.getUnderlyingType() instanceof IntegralType and
    this.hasName("ptrdiff_t")
  }

  override string getAPrimaryQlClass() { result = "Ptrdiff_t" }
}

/**
 * A parent class representing C/C++ a typedef'd `UserType` such as `int8_t`.
 */
private class IntegralUnderlyingUserType extends UserType {
  IntegralUnderlyingUserType() { this.getUnderlyingType() instanceof IntegralType }
}

/**
 * A C/C++ fixed-width numeric type, such as `int8_t`.
 */
class FixedWidthIntegralType extends UserType {
  FixedWidthIntegralType() {
    this instanceof Int8_t or
    this instanceof Int16_t or
    this instanceof Int32_t or
    this instanceof Int64_t or
    this instanceof UInt8_t or
    this instanceof UInt16_t or
    this instanceof UInt32_t or
    this instanceof UInt64_t
  }
}

/**
 * A C/C++ minimum-width numeric type, such as `int_least8_t`.
 */
class MinimumWidthIntegralType extends UserType {
  MinimumWidthIntegralType() {
    this instanceof Int_least8_t or
    this instanceof Int_least16_t or
    this instanceof Int_least32_t or
    this instanceof Int_least64_t or
    this instanceof UInt_least8_t or
    this instanceof UInt_least16_t or
    this instanceof UInt_least32_t or
    this instanceof UInt_least64_t
  }
}

/**
 * A C/C++ minimum-width numeric type, representing the fastest integer type with a
 * width of at least `N` such as `int_fast8_t`.
 */
class FastestMinimumWidthIntegralType extends UserType {
  FastestMinimumWidthIntegralType() {
    this instanceof Int_fast8_t or
    this instanceof Int_fast16_t or
    this instanceof Int_fast32_t or
    this instanceof Int_fast64_t or
    this instanceof UInt_fast8_t or
    this instanceof UInt_fast16_t or
    this instanceof UInt_fast32_t or
    this instanceof UInt_fast64_t
  }
}

/**
 * A C/C++ maximum-width numeric type, either `intmax_t` or `uintmax_t`.
 */
class MaximumWidthIntegralType extends UserType {
  MaximumWidthIntegralType() {
    this instanceof Intmax_t or
    this instanceof Uintmax_t
  }
}

/**
 * An enum type based on a fixed-width integer type. For instance, `enum e: uint8_t = { a, b };`
 */
class FixedWidthEnumType extends UserType {
  FixedWidthEnumType() { this.(Enum).getExplicitUnderlyingType() instanceof FixedWidthIntegralType }
}

/**
 *  The C/C++ `int8_t` type.
 */
class Int8_t extends IntegralUnderlyingUserType {
  Int8_t() { this.hasGlobalOrStdName("int8_t") }

  override string getAPrimaryQlClass() { result = "Int8_t" }
}

/**
 *  The C/C++ `int16_t` type.
 */
class Int16_t extends IntegralUnderlyingUserType {
  Int16_t() { this.hasGlobalOrStdName("int16_t") }

  override string getAPrimaryQlClass() { result = "Int16_t" }
}

/**
 *  The C/C++ `int32_t` type.
 */
class Int32_t extends IntegralUnderlyingUserType {
  Int32_t() { this.hasGlobalOrStdName("int32_t") }

  override string getAPrimaryQlClass() { result = "Int32_t" }
}

/**
 *  The C/C++ `int64_t` type.
 */
class Int64_t extends IntegralUnderlyingUserType {
  Int64_t() { this.hasGlobalOrStdName("int64_t") }

  override string getAPrimaryQlClass() { result = "Int64_t" }
}

/**
 *  The C/C++ `uint8_t` type.
 */
class UInt8_t extends IntegralUnderlyingUserType {
  UInt8_t() { this.hasGlobalOrStdName("uint8_t") }

  override string getAPrimaryQlClass() { result = "UInt8_t" }
}

/**
 *  The C/C++ `uint16_t` type.
 */
class UInt16_t extends IntegralUnderlyingUserType {
  UInt16_t() { this.hasGlobalOrStdName("uint16_t") }

  override string getAPrimaryQlClass() { result = "UInt16_t" }
}

/**
 *  The C/C++ `uint32_t` type.
 */
class UInt32_t extends IntegralUnderlyingUserType {
  UInt32_t() { this.hasGlobalOrStdName("uint32_t") }

  override string getAPrimaryQlClass() { result = "UInt32_t" }
}

/**
 *  The C/C++ `uint64_t` type.
 */
class UInt64_t extends IntegralUnderlyingUserType {
  UInt64_t() { this.hasGlobalOrStdName("uint64_t") }

  override string getAPrimaryQlClass() { result = "UInt64_t" }
}

/**
 *  The C/C++ `int_least8_t` type.
 */
class Int_least8_t extends IntegralUnderlyingUserType {
  Int_least8_t() { this.hasGlobalOrStdName("int_least8_t") }

  override string getAPrimaryQlClass() { result = "Int_least8_t" }
}

/**
 *  The C/C++ `int_least16_t` type.
 */
class Int_least16_t extends IntegralUnderlyingUserType {
  Int_least16_t() { this.hasGlobalOrStdName("int_least16_t") }

  override string getAPrimaryQlClass() { result = "Int_least16_t" }
}

/**
 *  The C/C++ `int_least32_t` type.
 */
class Int_least32_t extends IntegralUnderlyingUserType {
  Int_least32_t() { this.hasGlobalOrStdName("int_least32_t") }

  override string getAPrimaryQlClass() { result = "Int_least32_t" }
}

/**
 *  The C/C++ `int_least64_t` type.
 */
class Int_least64_t extends IntegralUnderlyingUserType {
  Int_least64_t() { this.hasGlobalOrStdName("int_least64_t") }

  override string getAPrimaryQlClass() { result = "Int_least64_t" }
}

/**
 *  The C/C++ `uint_least8_t` type.
 */
class UInt_least8_t extends IntegralUnderlyingUserType {
  UInt_least8_t() { this.hasGlobalOrStdName("uint_least8_t") }

  override string getAPrimaryQlClass() { result = "UInt_least8_t" }
}

/**
 *  The C/C++ `uint_least16_t` type.
 */
class UInt_least16_t extends IntegralUnderlyingUserType {
  UInt_least16_t() { this.hasGlobalOrStdName("uint_least16_t") }

  override string getAPrimaryQlClass() { result = "UInt_least16_t" }
}

/**
 *  The C/C++ `uint_least32_t` type.
 */
class UInt_least32_t extends IntegralUnderlyingUserType {
  UInt_least32_t() { this.hasGlobalOrStdName("uint_least32_t") }

  override string getAPrimaryQlClass() { result = "UInt_least32_t" }
}

/**
 *  The C/C++ `uint_least64_t` type.
 */
class UInt_least64_t extends IntegralUnderlyingUserType {
  UInt_least64_t() { this.hasGlobalOrStdName("uint_least64_t") }

  override string getAPrimaryQlClass() { result = "UInt_least64_t" }
}

/**
 *  The C/C++ `int_fast8_t` type.
 */
class Int_fast8_t extends IntegralUnderlyingUserType {
  Int_fast8_t() { this.hasGlobalOrStdName("int_fast8_t") }

  override string getAPrimaryQlClass() { result = "Int_fast8_t" }
}

/**
 *  The C/C++ `int_fast16_t` type.
 */
class Int_fast16_t extends IntegralUnderlyingUserType {
  Int_fast16_t() { this.hasGlobalOrStdName("int_fast16_t") }

  override string getAPrimaryQlClass() { result = "Int_fast16_t" }
}

/**
 *  The C/C++ `int_fast32_t` type.
 */
class Int_fast32_t extends IntegralUnderlyingUserType {
  Int_fast32_t() { this.hasGlobalOrStdName("int_fast32_t") }

  override string getAPrimaryQlClass() { result = "Int_fast32_t" }
}

/**
 *  The C/C++ `int_fast64_t` type.
 */
class Int_fast64_t extends IntegralUnderlyingUserType {
  Int_fast64_t() { this.hasGlobalOrStdName("int_fast64_t") }

  override string getAPrimaryQlClass() { result = "Int_fast64_t" }
}

/**
 *  The C/C++ `uint_fast8_t` type.
 */
class UInt_fast8_t extends IntegralUnderlyingUserType {
  UInt_fast8_t() { this.hasGlobalOrStdName("uint_fast8_t") }

  override string getAPrimaryQlClass() { result = "UInt_fast8_t" }
}

/**
 *  The C/C++ `uint_fast16_t` type.
 */
class UInt_fast16_t extends IntegralUnderlyingUserType {
  UInt_fast16_t() { this.hasGlobalOrStdName("uint_fast16_t") }

  override string getAPrimaryQlClass() { result = "UInt_fast16_t" }
}

/**
 *  The C/C++ `uint_fast32_t` type.
 */
class UInt_fast32_t extends IntegralUnderlyingUserType {
  UInt_fast32_t() { this.hasGlobalOrStdName("uint_fast32_t") }

  override string getAPrimaryQlClass() { result = "UInt_fast32_t" }
}

/**
 *  The C/C++ `uint_fast64_t` type.
 */
class UInt_fast64_t extends IntegralUnderlyingUserType {
  UInt_fast64_t() { this.hasGlobalOrStdName("uint_fast64_t") }

  override string getAPrimaryQlClass() { result = "UInt_fast64_t" }
}

/**
 * The C/C++ `intmax_t` type.
 */
class Intmax_t extends IntegralUnderlyingUserType {
  Intmax_t() { this.hasGlobalOrStdName("intmax_t") }

  override string getAPrimaryQlClass() { result = "Intmax_t" }
}

/**
 * The C/C++ `uintmax_t` type.
 */
class Uintmax_t extends IntegralUnderlyingUserType {
  Uintmax_t() { this.hasGlobalOrStdName("uintmax_t") }

  override string getAPrimaryQlClass() { result = "Uintmax_t" }
}

/**
 * The C/C++ `wchar_t` type.
 *
 * Note that on some platforms `wchar_t` doesn't exist as a built-in
 * type but a typedef is provided.  This QL class includes both cases
 * (see also `WideCharType`).
 */
class Wchar_t extends Type {
  Wchar_t() {
    this.getUnderlyingType() instanceof IntegralType and
    this.hasName("wchar_t")
  }

  override string getAPrimaryQlClass() { result = "Wchar_t" }
}

/**
 * The type that the Microsoft C/C++ `__int8` type specifier is a
 * synonym for.  Note that since `__int8` is not a distinct type,
 * `MicrosoftInt8Type` corresponds to an existing `IntegralType` as
 * well.
 *
 * This class is meaningless if a Microsoft compiler was not used.
 */
class MicrosoftInt8Type extends IntegralType {
  MicrosoftInt8Type() {
    this instanceof CharType and
    not isExplicitlyUnsigned() and
    not isExplicitlySigned()
  }
}

/**
 * The type that the Microsoft C/C++ `__int16` type specifier is a
 * synonym for.  Note that since `__int16` is not a distinct type,
 * `MicrosoftInt16Type` corresponds to an existing `IntegralType` as
 * well.
 *
 * This class is meaningless if a Microsoft compiler was not used.
 */
class MicrosoftInt16Type extends IntegralType {
  MicrosoftInt16Type() {
    this instanceof ShortType and
    not isExplicitlyUnsigned() and
    not isExplicitlySigned()
  }
}

/**
 * The type that the Microsoft C/C++ `__int32` type specifier is a
 * synonym for.  Note that since `__int32` is not a distinct type,
 * `MicrosoftInt32Type` corresponds to an existing `IntegralType` as
 * well.
 *
 * This class is meaningless if a Microsoft compiler was not used.
 */
class MicrosoftInt32Type extends IntegralType {
  MicrosoftInt32Type() {
    this instanceof IntType and
    not isExplicitlyUnsigned() and
    not isExplicitlySigned()
  }
}

/**
 * The type that the Microsoft C/C++ `__int64` type specifier is a
 * synonym for.  Note that since `__int64` is not a distinct type,
 * `MicrosoftInt64Type` corresponds to an existing `IntegralType` as
 * well.
 *
 * This class is meaningless if a Microsoft compiler was not used.
 */
class MicrosoftInt64Type extends IntegralType {
  MicrosoftInt64Type() {
    this instanceof LongLongType and
    not isExplicitlyUnsigned() and
    not isExplicitlySigned()
  }
}

/**
 * The `__builtin_va_list` type, used to provide variadic functionality.
 *
 * This is a complement to the `__builtin_va_start`, `__builtin_va_end`,
 * `__builtin_va_copy` and `__builtin_va_arg` expressions.
 */
class BuiltInVarArgsList extends Type {
  BuiltInVarArgsList() { this.hasName("__builtin_va_list") }

  override string getAPrimaryQlClass() { result = "BuiltInVarArgsList" }
}
