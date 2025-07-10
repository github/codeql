/** Provides a module for constructing optional versions of types. */

/** A type with `toString`. */
private signature class TypeWithToString {
  bindingset[this]
  string toString();
}

/**
 * Constructs an `Option` type that is a disjoint union of the given type and an
 * additional singleton element.
 */
module Option<TypeWithToString T> {
  private newtype TOption =
    TNone() or
    TSome(T c)

  /**
   * An option type. This is either a singleton `None` or a `Some` wrapping the
   * given type.
   */
  class Option extends TOption {
    /** Gets a textual representation of this element. */
    string toString() {
      this = TNone() and result = "(none)"
      or
      exists(T c | this = TSome(c) and result = c.toString())
    }

    /** Gets the wrapped element, if any. */
    T asSome() { this = TSome(result) }

    /** Holds if this option is the singleton `None`. */
    predicate isNone() { this = TNone() }
  }

  /** The singleton `None` element. */
  class None extends Option, TNone { }

  /** A wrapper for the given type. */
  class Some extends Option, TSome { }

  /** Gets the given element wrapped as an `Option`. */
  Some some(T c) { result = TSome(c) }
}
