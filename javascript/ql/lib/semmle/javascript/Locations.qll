/** Provides classes for working with locations and program elements that have locations. */

import javascript
private import internal.Locations

/**
 * A location as given by a file, a start line, a start column,
 * an end line, and an end column.
 *
 * This class is restricted to locations created by the extractor.
 *
 * For more information about locations see [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
 */
class DbLocation extends TDbLocation {
  /** Gets the file for this location. */
  File getFile() { dbLocationInfo(this, result, _, _, _, _) }

  /** Gets the 1-based line number (inclusive) where this location starts. */
  int getStartLine() { dbLocationInfo(this, _, result, _, _, _) }

  /** Gets the 1-based column number (inclusive) where this location starts. */
  int getStartColumn() { dbLocationInfo(this, _, _, result, _, _) }

  /** Gets the 1-based line number (inclusive) where this location ends. */
  int getEndLine() { dbLocationInfo(this, _, _, _, result, _) }

  /** Gets the 1-based column number (inclusive) where this location ends. */
  int getEndColumn() { dbLocationInfo(this, _, _, _, _, result) }

  /** Gets the number of lines covered by this location. */
  int getNumLines() { result = this.getEndLine() - this.getStartLine() + 1 }

  /** Holds if this location starts before location `that`. */
  pragma[inline]
  predicate startsBefore(DbLocation that) {
    exists(File f, int sl1, int sc1, int sl2, int sc2 |
      dbLocationInfo(this, f, sl1, sc1, _, _) and
      dbLocationInfo(that, f, sl2, sc2, _, _)
    |
      sl1 < sl2
      or
      sl1 = sl2 and sc1 < sc2
    )
  }

  /** Holds if this location ends after location `that`. */
  pragma[inline]
  predicate endsAfter(DbLocation that) {
    exists(File f, int el1, int ec1, int el2, int ec2 |
      dbLocationInfo(this, f, _, _, el1, ec1) and
      dbLocationInfo(that, f, _, _, el2, ec2)
    |
      el1 > el2
      or
      el1 = el2 and ec1 > ec2
    )
  }

  /**
   * Holds if this location contains location `that`, meaning that it starts
   * before and ends after it.
   */
  predicate contains(DbLocation that) { this.startsBefore(that) and this.endsAfter(that) }

  /** Holds if this location is empty. */
  predicate isEmpty() { exists(int l, int c | dbLocationInfo(this, _, l, c, l, c - 1)) }

  /** Gets a textual representation of this element. */
  string toString() { result = this.getFile().getBaseName() + ":" + this.getStartLine().toString() }

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
    exists(File f |
      dbLocationInfo(this, f, startline, startcolumn, endline, endcolumn) and
      filepath = f.getAbsolutePath()
    )
  }
}

final class Location = LocationImpl;

/** A program element with a location. */
class Locatable extends @locatable {
  /** Gets the file this program element comes from. */
  File getFile() { result = this.getLocation().getFile() }

  /** Gets this element's location. */
  final DbLocation getLocation() { result = getLocatableLocation(this) }

  /**
   * Gets the line on which this element starts.
   *
   * This predicate is only defined for program elements from snapshots that
   * have been extracted with the `--extract-program-text` flag.
   */
  Line getStartLine() {
    exists(Location l1, Location l2 |
      l1 = this.getLocation() and
      l2 = result.getLocation() and
      l1.getFile() = l2.getFile() and
      l1.getStartLine() = l2.getStartLine()
    )
  }

  /**
   * Gets the line on which this element ends.
   *
   * This predicate is only defined for program elements from snapshots that
   * have been extracted with the `--extract-program-text` flag.
   */
  Line getEndLine() {
    exists(Location l1, Location l2 |
      l1 = this.getLocation() and
      l2 = result.getLocation() and
      l1.getFile() = l2.getFile() and
      l1.getEndLine() = l2.getStartLine()
    )
  }

  /** Gets the number of lines covered by this element. */
  int getNumLines() { result = this.getLocation().getNumLines() }

  /** Gets a textual representation of this element. */
  string toString() {
    // to be overridden by subclasses
    none()
  }

  /**
   * Gets a comma-separated list of the names of the primary CodeQL classes to which this element belongs.
   */
  final string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }

  /**
   * Gets the primary QL class for the Locatable.
   */
  string getAPrimaryQlClass() { result = "???" }
}
