/** Provides a module for constructing optional versions of types. */
overlay[local?]
module;

private import Location

/** A type with `toString`. */
private signature class TypeWithToString {
  bindingset[this]
  string toString();
}

/** A type with `toString` and `hasLocationInfo` */
private signature class TypeWithLocationInfo {
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
 * `T` must have a `hasLocationInfo` predicate.
 */
module OptionWithLocationInfo<TypeWithLocationInfo T> {
  private module O = Option<T>;

  final private class BaseOption = O::Option;

  /**
   * An option type. This is either a singleton `None` or a `Some` wrapping the
   * given type.
   */
  class Option extends BaseOption {
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
  class None extends Option instanceof O::None { }

  /** A wrapper for the given type. */
  class Some extends Option instanceof O::Some { }

  /** Gets the given element wrapped as an `Option`. */
  Some some(T c) { result.asSome() = c }
}

private module WithLocation<LocationSig Location> {
  signature class LocatableType {
    bindingset[this]
    string toString();

    Location getLocation();
  }
}

/**
 * Constructs an `Option` type that is a disjoint union of the given type and an
 * additional singleton element, and has a `getLocation` predicate.
 * `T` must have a `getLocation` predicate with a result type of `Location`.
 */
module LocatableOption<LocationSig Location, WithLocation<Location>::LocatableType T> {
  private module O = Option<T>;

  final private class BaseOption = O::Option;

  /**
   * An option type. This is either a singleton `None` or a `Some` wrapping the
   * given type.
   */
  class Option extends BaseOption {
    Location getLocation() {
      result = this.asSome().getLocation()
      or
      this.isNone() and
      result.hasLocationInfo("", 0, 0, 0, 0)
    }
  }

  /** The singleton `None` element. */
  class None extends Option instanceof O::None { }

  /** A wrapper for the given type. */
  class Some extends Option instanceof O::Some { }

  /** Gets the given element wrapped as an `Option`. */
  Some some(T c) { result.asSome() = c }
}
