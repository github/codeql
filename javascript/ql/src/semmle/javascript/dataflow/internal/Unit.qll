private newtype TUnit = MkUnit()

/**
 * A class with only one instance.
 */
class Unit extends TUnit {
  final string toString() { result = "Unit" }
}
