/** Provides classes for working with locations and program elements that have locations. */

import go
private import internal.Locations

private module DbLocationInput implements LocationClassInputSig {
  class Base = TDbLocation;

  predicate locationInfo(
    Base b, string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(File f |
      dbLocationInfo(b, f, startline, startcolumn, endline, endcolumn) and
      filepath = f.getAbsolutePath()
    )
  }

  File getFile(Base b) { dbLocationInfo(b, result, _, _, _, _) }
}

/**
 * A location as given by a file, a start line, a start column,
 * an end line, and an end column.
 *
 * This class is restricted to locations created by the extractor.
 *
 * For more information about locations see [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
 */
class DbLocation = LocationClass<DbLocationInput>::Location;

private module LocationInput implements LocationClassInputSig {
  class Base = TLocation;

  predicate locationInfo(
    Base b, string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    DbLocationInput::locationInfo(b, filepath, startline, startcolumn, endline, endcolumn)
    or
    dataFlowNodeLocationInfo(b, filepath, startline, startcolumn, endline, endcolumn)
  }

  File getFile(Base b) {
    result = DbLocationInput::getFile(b)
    or
    dataFlowNodeLocationInfo(b, result.getAbsolutePath(), _, _, _, _)
  }
}

class Location = LocationClass<LocationInput>::Location;

/** A program element with a location. */
class Locatable extends @locatable {
  /** Gets the file this program element comes from. */
  File getFile() { result = this.getLocation().getFile() }

  /** Gets this element's location. */
  final DbLocation getLocation() { result = getLocatableLocation(this) }

  /** Gets the number of lines covered by this element. */
  int getNumLines() { result = this.getLocation().getNumLines() }

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
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets a textual representation of this element. */
  string toString() { result = "locatable element" }
}
