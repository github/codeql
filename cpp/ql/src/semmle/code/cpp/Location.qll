/**
 * Provides classes and predicates for locations in the source code.
 */

import semmle.code.cpp.Element
import semmle.code.cpp.File

/**
 * A location of a C/C++ artifact.
 */
class Location extends @location {
  /** Gets the container corresponding to this location. */
  Container getContainer() { this.fullLocationInfo(result, _, _, _, _) }

  /** Gets the file corresponding to this location, if any. */
  File getFile() { result = this.getContainer() }

  /** Gets the 1-based line number (inclusive) where this location starts. */
  int getStartLine() { this.fullLocationInfo(_, result, _, _, _) }

  /** Gets the 1-based column number (inclusive) where this location starts. */
  int getStartColumn() { this.fullLocationInfo(_, _, result, _, _) }

  /** Gets the 1-based line number (inclusive) where this location ends. */
  int getEndLine() { this.fullLocationInfo(_, _, _, result, _) }

  /** Gets the 1-based column number (inclusive) where this location ends. */
  int getEndColumn() { this.fullLocationInfo(_, _, _, _, result) }

  /**
   * Gets a textual representation of this element.
   *
   * The format is "file://filePath:startLine:startColumn:endLine:endColumn".
   */
  string toString() {
    exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
      this.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    |
      toUrl(filepath, startline, startcolumn, endline, endcolumn, result)
    )
  }

  /**
   * Holds if this element is in the specified container.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline`.
   *
   * This predicate is similar to `hasLocationInfo`, but exposes the `Container`
   * entity, rather than merely its path.
   */
  predicate fullLocationInfo(
    Container container, int startline, int startcolumn, int endline, int endcolumn
  ) {
    locations_default(this, unresolveElement(container), startline, startcolumn, endline, endcolumn) or
    locations_expr(this, unresolveElement(container), startline, startcolumn, endline, endcolumn) or
    locations_stmt(this, unresolveElement(container), startline, startcolumn, endline, endcolumn)
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(Container f | this.fullLocationInfo(f, startline, startcolumn, endline, endcolumn) |
      filepath = f.getAbsolutePath()
    )
  }

  /** Holds if `this` comes on a line strictly before `l`. */
  predicate isBefore(Location l) {
    this.getFile() = l.getFile() and this.getEndLine() < l.getStartLine()
  }

  /** Holds if location `l` is completely contained within this one. */
  predicate subsumes(Location l) {
    exists(File f | f = getFile() |
      exists(int thisStart, int thisEnd | charLoc(f, thisStart, thisEnd) |
        exists(int lStart, int lEnd | l.charLoc(f, lStart, lEnd) |
          thisStart <= lStart and lEnd <= thisEnd
        )
      )
    )
  }

  /**
   * Holds if this location corresponds to file `f` and character "offsets"
   * `start..end`. Note that these are not real character offsets, because
   * we use `maxCols` to find the length of the longest line and then pretend
   * that all the lines are the same length. However, these offsets are
   * convenient for comparing or sorting locations in a file. For an example,
   * see `subsumes`.
   */
  predicate charLoc(File f, int start, int end) {
    f = getFile() and
    exists(int maxCols | maxCols = maxCols(f) |
      start = getStartLine() * maxCols + getStartColumn() and
      end = getEndLine() * maxCols + getEndColumn()
    )
  }
}

/**
 * DEPRECATED: Use `Location` instead.
 * A location of an element. Not used for expressions or statements, which
 * instead use LocationExpr and LocationStmt respectively.
 */
deprecated library class LocationDefault extends Location, @location_default { }

/**
 * DEPRECATED: Use `Location` instead.
 * A location of a statement.
 */
deprecated library class LocationStmt extends Location, @location_stmt { }

/**
 * DEPRECATED: Use `Location` instead.
 * A location of an expression.
 */
deprecated library class LocationExpr extends Location, @location_expr { }

/**
 * Gets the length of the longest line in file `f`.
 */
pragma[nomagic]
private int maxCols(File f) { result = max(Location l | l.getFile() = f | l.getEndColumn()) }

/**
 * A C/C++ element that has a location in a file
 */
class Locatable extends Element { }

/**
 * A dummy location which is used when something doesn't have a location in
 * the source code but needs to have a `Location` associated with it. There
 * may be several distinct kinds of unknown locations. For example: one for
 * expressions, one for statements and one for other program elements.
 */
class UnknownLocation extends Location {
  UnknownLocation() { getFile().getAbsolutePath() = "" }
}

/**
 * A dummy location which is used when something doesn't have a location in
 * the source code but needs to have a `Location` associated with it.
 */
class UnknownDefaultLocation extends UnknownLocation {
  UnknownDefaultLocation() { locations_default(this, _, 0, 0, 0, 0) }
}

/**
 * A dummy location which is used when an expression doesn't have a
 * location in the source code but needs to have a `Location` associated
 * with it.
 */
class UnknownExprLocation extends UnknownLocation {
  UnknownExprLocation() { locations_expr(this, _, 0, 0, 0, 0) }
}

/**
 * A dummy location which is used when a statement doesn't have a location
 * in the source code but needs to have a `Location` associated with it.
 */
class UnknownStmtLocation extends UnknownLocation {
  UnknownStmtLocation() { locations_stmt(this, _, 0, 0, 0, 0) }
}
