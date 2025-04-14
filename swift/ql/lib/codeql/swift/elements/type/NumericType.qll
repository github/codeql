private import swift

/**
 * A floating-point type. This includes the `Float` type, the `Double`, and
 * builtin floating-point types.
 */
final class FloatingPointType extends Type {
  FloatingPointType() {
    this.getName() = ["Float", "Double"] or
    this instanceof BuiltinFloatType
  }
}

/** The `Character` type. */
final class CharacterType extends StructType {
  CharacterType() { this.getName() = "Character" }
}

/**
 * An integer-like type. For example, `Int`, `Int16`, `Uint16`, etc.
 */
final class IntegralType extends Type {
  IntegralType() {
    this.getName() =
      ["Int", "Int8", "Int16", "Int32", "Int64", "UInt", "UInt8", "UInt16", "UInt32", "UInt64"]
    or
    this instanceof BuiltinIntegerType
  }
}

/** The `Bool` type. */
final class BoolType extends Type {
  BoolType() { this.getName() = "Bool" }
}

/**
 * A numeric type. This includes the integer and floating point types.
 */
final class NumericType extends Type {
  NumericType() {
    this instanceof IntegralType or
    this instanceof FloatingPointType
  }
}
