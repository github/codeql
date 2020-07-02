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
 * The C/C++ `intmax_t` type.
 */
class Intmax_t extends Type {
  Intmax_t() {
    this.getUnderlyingType() instanceof IntegralType and
    this.hasName("intmax_t")
  }

  override string getAPrimaryQlClass() { result = "Intmax_t" }
}

/**
 * The C/C++ `uintmax_t` type.
 */
class Uintmax_t extends Type {
  Uintmax_t() {
    this.getUnderlyingType() instanceof IntegralType and
    this.hasName("uintmax_t")
  }

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
