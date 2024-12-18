/** Provides classes for working with locations. */

import files.FileSystem
import codeql.actions.ast.internal.Ast

bindingset[loc]
pragma[inline_late]
private string locationToString(Location loc) {
  exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
    loc.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
    result = filepath + "@" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn
  )
}

newtype TLocation =
  TBaseLocation(string filepath, int startline, int startcolumn, int endline, int endcolumn) {
    exists(File file |
      file.getAbsolutePath() = filepath and
      locations_default(_, file, startline, startcolumn, endline, endcolumn)
    )
    or
    exists(ExpressionImpl e |
      e.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    )
    or
    filepath = "" and startline = 0 and startcolumn = 0 and endline = 0 and endcolumn = 0
  }

/**
 * A location as given by a file, a start line, a start column,
 * an end line, and an end column.
 *
 * For more information about locations see [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
 */
class Location extends TLocation, TBaseLocation {
  string filepath;
  int startline;
  int startcolumn;
  int endline;
  int endcolumn;

  Location() { this = TBaseLocation(filepath, startline, startcolumn, endline, endcolumn) }

  /** Gets the file for this location. */
  File getFile() {
    exists(File file |
      file.getAbsolutePath() = filepath and
      result = file
    )
  }

  /** Gets the 1-based line number (inclusive) where this location starts. */
  int getStartLine() { result = startline }

  /** Gets the 1-based column number (inclusive) where this location starts. */
  int getStartColumn() { result = startcolumn }

  /** Gets the 1-based line number (inclusive) where this.getLocationDefault() location ends. */
  int getEndLine() { result = endline }

  /** Gets the 1-based column number (inclusive) where this.getLocationDefault() location ends. */
  int getEndColumn() { result = endcolumn }

  /** Gets the number of lines covered by this location. */
  int getNumLines() { result = endline - startline + 1 }

  /** Gets a textual representation of this element. */
  pragma[inline]
  string toString() { result = locationToString(this) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Providing locations in CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(string p, int sl, int sc, int el, int ec) {
    p = filepath and
    sl = startline and
    sc = startcolumn and
    el = endline and
    ec = endcolumn
  }

  /** Holds if this location starts strictly before the specified location. */
  pragma[inline]
  predicate strictlyBefore(Location other) {
    this.getStartLine() < other.getStartLine()
    or
    this.getStartLine() = other.getStartLine() and this.getStartColumn() < other.getStartColumn()
  }
}

/** An entity representing an empty location. */
class EmptyLocation extends Location {
  EmptyLocation() { this.hasLocationInfo("", 0, 0, 0, 0) }
}
