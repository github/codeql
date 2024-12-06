/** Provides a module for constructing a union `Either` type. */
overlay[local?]
module;

/** A type with `toString`. */
private signature class TypeWithToString {
  string toString();
}

/**
 * Constructs an `Either` type that is a disjoint union of two types.
 */
module Either<TypeWithToString Left, TypeWithToString Right> {
  private newtype TEither =
    TLeft(Left c) or
    TRight(Right c)

  /**
   * An either type. This is either a `Left` or a `Right` wrapping the given
   * type.
   */
  class Either extends TEither {
    /** Gets a textual representation of this element. */
    string toString() {
      exists(Left c | this = TLeft(c) and result = c.toString())
      or
      exists(Right c | this = TRight(c) and result = c.toString())
    }

    /** Gets the element, if this is a `Left`. */
    Left asLeft() { this = TLeft(result) }

    /** Gets the element, if this is a `Right`. */
    Right asRight() { this = TRight(result) }
  }

  /** Makes an `Either` from an instance of `Left` */
  Either left(Left c) { result.asLeft() = c }

  /** Makes an `Either` from an instance of `Right` */
  Either right(Right c) { result.asRight() = c }
}
