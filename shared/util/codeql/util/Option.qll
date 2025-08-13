/** Provides a module for constructing optional versions of types. */
overlay[local?]
module;

/** A type with `toString`. */
private signature class TypeWithToString {
  bindingset[this]
  string toString();
}

/** A type with `toString` and `hasLocationInfo` */
private signature class TypeWithToStringAndLocation {
  bindingset[this]
  string toString();

  predicate hasLocationInfo(
    string filePath, int startLine, int startColumn, int endLine, int endColumn
  );
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

/**
 * Constructs an `Option` type that is a disjoint union of the given type and an
 * additional singleton element, and has a `hasLocationInfo` predicate.
 */
module LocOption<TypeWithToStringAndLocation T> {
  private module O = Option<T>;

  final private class BOption = O::Option;

  final private class BNone = O::None;

  final private class BSome = O::Some;

  /**
   * An option type. This is either a singleton `None` or a `Some` wrapping the
   * given type.
   */
  class Option extends BOption {
    /**
     * Holds if this element is at the specified location.
     * The location spans column `startColumn` of line `startLine` to
     * column `endColumn` of line `endLine` in file `filepath`.
     * For more information, see
     * [Providing locations in CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(
      string filePath, int startLine, int startColumn, int endLine, int endColumn
    ) {
      this.isNone() and
      filePath = "" and
      startLine = 0 and
      startColumn = 0 and
      endLine = 0 and
      endColumn = 0
      or
      this.asSome().hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn)
    }
  }

  /** The singleton `None` element. */
  class None extends BNone, Option { }

  /** A wrapper for the given type. */
  class Some extends BSome, Option { }

  /** Gets the given element wrapped as an `Option`. */
  Some some(T c) { result = O::some(c) }
}
