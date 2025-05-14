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
class I8 extends BuiltinType {
  I8() { this.getName() = "i8" }
}

/** The builtin `i16` type. */
class I16 extends BuiltinType {
  I16() { this.getName() = "i16" }
}

/** The builtin `i32` type. */
class I32 extends BuiltinType {
  I32() { this.getName() = "i32" }
}

/** The builtin `i64` type. */
class I64 extends BuiltinType {
  I64() { this.getName() = "i64" }
}

/** The builtin `i128` type. */
class I128 extends BuiltinType {
  I128() { this.getName() = "i128" }
}

/** The builtin `u8` type. */
class U8 extends BuiltinType {
  U8() { this.getName() = "u8" }
}

/** The builtin `u16` type. */
class U16 extends BuiltinType {
  U16() { this.getName() = "u16" }
}

/** The builtin `u32` type. */
class U32 extends BuiltinType {
  U32() { this.getName() = "u32" }
}

/** The builtin `u64` type. */
class U64 extends BuiltinType {
  U64() { this.getName() = "u64" }
}

/** The builtin `u128` type. */
class U128 extends BuiltinType {
  U128() { this.getName() = "u128" }
}

/** The builtin `usize` type. */
class USize extends BuiltinType {
  USize() { this.getName() = "usize" }
}

/** The builtin `isize` type. */
class ISize extends BuiltinType {
  ISize() { this.getName() = "isize" }
}

/** The builtin `f32` type. */
class F32 extends BuiltinType {
  F32() { this.getName() = "f32" }
}

/** The builtin `f64` type. */
class F64 extends BuiltinType {
  F64() { this.getName() = "f64" }
}
