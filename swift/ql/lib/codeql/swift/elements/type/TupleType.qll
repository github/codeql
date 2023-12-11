private import codeql.swift.generated.type.TupleType

/**
 * A tuple type, for example:
 * ```
 * (Int, String)
 * ```
 */
class TupleType extends Generated::TupleType {
  /**
   * Gets the type that is this tuple type with any element labels removed.
   */
  TupleType asUnlabeled() {
    result.getNumberOfTypes() = this.getNumberOfTypes() and
    not exists(int index | result.getType(index) != this.getType(index)) and
    not exists(result.getName(_))
  }
}
