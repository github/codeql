private newtype TUnit = MkUnit()

/**
 * A class with only one instance.
 */
class Unit extends TUnit {
  /** Gets a textual representation of this element. */
  final string toString() { result = "Unit" }
}
