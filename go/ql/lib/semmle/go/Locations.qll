/** Provides classes for working with locations and program elements that have locations. */

import go

/**
 * A location as given by a file, a start line, a start column,
 * an end line, and an end column.
 *
 * For more information about locations see [LGTM locations](https://lgtm.com/help/ql/locations).
 */
class Location extends @location {
  /** Gets the file for this location. */
  File getFile() { locations_default(this, result, _, _, _, _) }

  /** Gets the 1-based line number (inclusive) where this location starts. */
  int getStartLine() { locations_default(this, _, result, _, _, _) }

  /** Gets the 1-based column number (inclusive) where this location starts. */
  int getStartColumn() { locations_default(this, _, _, result, _, _) }

  /** Gets the 1-based line number (inclusive) where this location ends. */
  int getEndLine() { locations_default(this, _, _, _, result, _) }

  /** Gets the 1-based column number (inclusive) where this location ends. */
  int getEndColumn() { locations_default(this, _, _, _, _, result) }

  /** Gets the number of lines covered by this location. */
  int getNumLines() { result = getEndLine() - getStartLine() + 1 }

  /** Gets a textual representation of this element. */
  string toString() {
    exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
      hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
      result = filepath + "@" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn
    )
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [LGTM locations](https://lgtm.com/help/ql/locations).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(File f |
      locations_default(this, f, startline, startcolumn, endline, endcolumn) and
      filepath = f.getAbsolutePath()
    )
  }
}

/** A program element with a location. */
class Locatable extends @locatable {
  /** Gets the file this program element comes from. */
  File getFile() { result = getLocation().getFile() }

  /** Gets this element's location. */
  Location getLocation() { has_location(this, result) }

  /** Gets the number of lines covered by this element. */
  int getNumLines() { result = getLocation().getNumLines() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [LGTM locations](https://lgtm.com/help/ql/locations).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets a textual representation of this element. */
  string toString() { result = "locatable element" }
}
