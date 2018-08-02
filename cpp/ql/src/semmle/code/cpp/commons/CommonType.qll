import semmle.code.cpp.Type

/**
 * The C/C++ char* type.
 */
class CharPointerType extends PointerType {

  CharPointerType() { this.getBaseType() instanceof CharType }

}

/**
 * The C/C++ int* type.
 */
class IntPointerType extends PointerType {

  IntPointerType() { this.getBaseType() instanceof IntType }

}


/**
 * The C/C++ void* type.
 */
class VoidPointerType extends PointerType {

  VoidPointerType() { this.getBaseType() instanceof VoidType }

}

/**
 * The C/C++ size_t type.
 */
class Size_t extends Type {
  Size_t() {
    this.getUnderlyingType() instanceof IntegralType and
    this.hasName("size_t")
  }
}

/**
 * The C/C++ ssize_t type.
 */
class Ssize_t extends Type {
  Ssize_t() {
    this.getUnderlyingType() instanceof IntegralType and
    this.hasName("ssize_t")
  }
}

/**
 * The C/C++ ptrdiff_t type.
 */
class Ptrdiff_t extends Type {
  Ptrdiff_t() {
    this.getUnderlyingType() instanceof IntegralType and
    this.hasName("ptrdiff_t")
  }
}

/**
 * The C/C++ intmax_t type.
 */
class Intmax_t extends Type {
  Intmax_t() {
    this.getUnderlyingType() instanceof IntegralType and
    this.hasName("intmax_t")
  }
}

/**
 * The C/C++ uintmax_t type.
 */
class Uintmax_t extends Type {
  Uintmax_t() {
    this.getUnderlyingType() instanceof IntegralType and
    this.hasName("uintmax_t")
  }
}

/**
 * The C/C++ wchar_t type.
 */
class Wchar_t extends Type {
  Wchar_t() {
    this.getUnderlyingType() instanceof IntegralType and
    this.hasName("wchar_t")
  }
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
