private import swift

/** The `Character` type. */
class CharacterType extends StructType {
  CharacterType() { this.getName() = "Character" }
}

/**
 * An integer-like type. For example, `Int`, `Int16`, `Uint16`, etc.
 */
class IntegerType extends Type {
  IntegerType() {
    this.getName() =
      ["Int", "Int8", "Int16", "Int32", "Int64", "UInt", "UInt8", "UInt16", "UInt32", "UInt64"]
    or
    this instanceof BuiltinIntegerType
  }
}

/** The `Bool` type. */
class BooleanType extends Type {
  BooleanType() { this.getName() = "Bool" }
}

/**
 * A numeric-like type. This includes the types `Character`, `Bool`, and all
 * the integer-like types.
 */
class NumericOrCharType extends Type {
  NumericOrCharType() {
    this instanceof CharacterType or
    this instanceof IntegerType or
    this instanceof BooleanType
  }
}
