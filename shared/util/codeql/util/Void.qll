/** Provides the empty `Void` class. */

/** The empty void type. */
private newtype TVoid = TMkVoid() { none() }

/** The trivial empty type. */
final class Void extends TVoid {
  /** Gets a textual representation of this element. */
  string toString() { result = "dummy" }
}
