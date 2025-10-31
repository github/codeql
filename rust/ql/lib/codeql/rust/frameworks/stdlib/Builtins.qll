/**
 * Provides classes for builtins.
 */

private import rust

/** The folder containing builtins. */
class BuiltinsFolder extends Folder {
  BuiltinsFolder() {
    this.getBaseName() = "builtins" and
    this.getParentContainer().getBaseName() = "tools"
  }
}

private class BuiltinsTypesFile extends File {
  BuiltinsTypesFile() {
    this.getBaseName() = "types.rs" and
    this.getParentContainer() instanceof BuiltinsFolder
  }
}

/**
 * A builtin type, such as `bool` and `i32`.
 *
 * Builtin types are represented as structs.
 */
class BuiltinType extends Struct {
  BuiltinType() { this.getFile() instanceof BuiltinsTypesFile }

  /** Gets the name of this type. */
  string getName() { result = super.getName().getText() }
}

/**
 * A numerical type, such as `i64`, `usize`, `f32` or `f64`.
 */
abstract private class NumericTypeImpl extends BuiltinType {
}

final class NumericType = NumericTypeImpl;

/**
 * An integral numerical type, such as `i64` or `usize`.
 */
abstract private class IntegralTypeImpl extends NumericTypeImpl {
}

final class IntegralType = IntegralTypeImpl;

/**
 * A floating-point numerical type, such as `f32` or `f64`.
 */
abstract private class FloatingPointTypeImpl extends NumericTypeImpl {
}

final class FloatingPointType = FloatingPointTypeImpl;

/** The builtin `bool` type. */
class Bool extends BuiltinType {
  Bool() { this.getName() = "bool" }
}

/** The builtin `char` type. */
class Char extends BuiltinType {
  Char() { this.getName() = "char" }
}

/** The builtin `str` type. */
class Str extends BuiltinType {
  Str() { this.getName() = "str" }
}

/** The builtin `i8` type. */
class I8 extends IntegralTypeImpl {
  I8() { this.getName() = "i8" }
}

/** The builtin `i16` type. */
class I16 extends IntegralTypeImpl {
  I16() { this.getName() = "i16" }
}

/** The builtin `i32` type. */
class I32 extends IntegralTypeImpl {
  I32() { this.getName() = "i32" }
}

/** The builtin `i64` type. */
class I64 extends IntegralTypeImpl {
  I64() { this.getName() = "i64" }
}

/** The builtin `i128` type. */
class I128 extends IntegralTypeImpl {
  I128() { this.getName() = "i128" }
}

/** The builtin `u8` type. */
class U8 extends IntegralTypeImpl {
  U8() { this.getName() = "u8" }
}

/** The builtin `u16` type. */
class U16 extends IntegralTypeImpl {
  U16() { this.getName() = "u16" }
}

/** The builtin `u32` type. */
class U32 extends IntegralTypeImpl {
  U32() { this.getName() = "u32" }
}

/** The builtin `u64` type. */
class U64 extends IntegralTypeImpl {
  U64() { this.getName() = "u64" }
}

/** The builtin `u128` type. */
class U128 extends IntegralTypeImpl {
  U128() { this.getName() = "u128" }
}

/** The builtin `usize` type. */
class Usize extends IntegralTypeImpl {
  Usize() { this.getName() = "usize" }
}

/** The builtin `isize` type. */
class Isize extends IntegralTypeImpl {
  Isize() { this.getName() = "isize" }
}

/** The builtin `f32` type. */
class F32 extends FloatingPointTypeImpl {
  F32() { this.getName() = "f32" }
}

/** The builtin `f64` type. */
class F64 extends FloatingPointTypeImpl {
  F64() { this.getName() = "f64" }
}
