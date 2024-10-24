private import codeql.files.FileSystem

module LocationImpl {
  newtype TLocation =
    TLocationDefault(@location_default location) or
    TLocationSynth(File file, int beginLine, int beginColumn, int endLine, int endColumn) {
      not locations_default(_, file, beginLine, beginColumn, endLine, endColumn) and none()
    }

  /**
   * A location as given by a file, a start line, a start column,
   * an end line, and an end column.
   *
   * For more information about locations see [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  abstract class Location extends TLocation {
    /** Gets the file for this location. */
    File getFile() { this.hasLocationInfo(result.getAbsolutePath(), _, _, _, _) }

    /** Gets the 1-based line number (inclusive) where this location starts. */
    int getStartLine() { this.hasLocationInfo(_, result, _, _, _) }

    /** Gets the 1-based column number (inclusive) where this location starts. */
    int getStartColumn() { this.hasLocationInfo(_, _, result, _, _) }

    /** Gets the 1-based line number (inclusive) where this location ends. */
    int getEndLine() { this.hasLocationInfo(_, _, _, result, _) }

    /** Gets the 1-based column number (inclusive) where this location ends. */
    int getEndColumn() { this.hasLocationInfo(_, _, _, _, result) }

    /** Gets the number of lines covered by this location. */
    int getNumLines() { result = this.getEndLine() - this.getStartLine() + 1 }

    /** Gets a textual representation of this element. */
    bindingset[this]
    pragma[inline_late]
    string toString() {
      exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
        this.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) and
        result = filepath + "@" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn
      )
    }

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Providing locations in CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    abstract predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    );

    /** Holds if this location starts strictly before the specified location. */
    pragma[inline]
    predicate strictlyBefore(Location other) {
      this.getStartLine() < other.getStartLine()
      or
      this.getStartLine() = other.getStartLine() and this.getStartColumn() < other.getStartColumn()
    }
  }

  private class LocationDefault extends Location, TLocationDefault {
    @location_default self;

    LocationDefault() { this = TLocationDefault(self) }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      exists(File f |
        locations_default(self, f, startline, startcolumn, endline, endcolumn) and
        filepath = f.getAbsolutePath()
      )
    }
  }

  /** An entity representing an empty location. */
  class EmptyLocation extends LocationDefault {
    EmptyLocation() { empty_location(self) }
  }

  private class LocationSynth extends Location, TLocationSynth {
    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      this =
        TLocationSynth(any(File f | f.getAbsolutePath() = filepath), startline, startcolumn,
          endline, endcolumn)
    }
  }
}
