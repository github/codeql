/**
 * Provides the `Location` class to give a location for each
 * program element.
 *
 * A `SourceLocation` provides a section of text in a source file
 * containing the program element.
 *
 * Based on csharp/ql/lib/semmle/code/csharp/Location.qll
 */

import File

/**
 * A location of a program element.
 */
class Location extends @location {
  /** Gets the file of the location. */
  File getFile() { none() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    none()
  }

  /** Gets a textual representation of this location. */
  string toString() { none() }

  /** Gets the 1-based line number (inclusive) where this location starts. */
  int getStartLine() { this.hasLocationInfo(_, result, _, _, _) }

  /** Gets the 1-based line number (inclusive) where this location ends. */
  int getEndLine() { this.hasLocationInfo(_, _, _, result, _) }

  /** Gets the 1-based column number (inclusive) where this location starts. */
  int getStartColumn() { this.hasLocationInfo(_, _, result, _, _) }

  /** Gets the 1-based column number (inclusive) where this location ends. */
  int getEndColumn() { this.hasLocationInfo(_, _, _, _, result) }

  /** Holds if this location starts strictly before the specified location. */
  pragma[inline]
  predicate strictlyBefore(Location other) {
    this.getStartLine() < other.getStartLine()
    or
    this.getStartLine() = other.getStartLine() and this.getStartColumn() < other.getStartColumn()
  }
}

/** An empty location. */
class EmptyLocation extends Location {
  EmptyLocation() { this.hasLocationInfo("", 0, 0, 0, 0) }
}
