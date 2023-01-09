private import swift

/**
 * A floating-point type. This includes the `Float` type, the `Double`, and
 * builtin floating-point types.
 */
class FloatingPointType extends Type {
  FloatingPointType() {
    this.getName() = ["Float", "Double"] or
    this instanceof BuiltinFloatType
  }
}
