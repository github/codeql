/** Provides classes for working with locations. */
overlay[local]
module;

/**
 * A location as given by a file, a start line, a start column,
 * an end line, and an end column.
 */
class Location extends @location_default {
  /** Gets the 1-based line number (inclusive) where this location starts. */
  int getStartLine() { locations_default(this, _, result, _, _, _) }

  /** Gets the 1-based column number (inclusive) where this location starts. */
  int getStartColumn() { locations_default(this, _, _, result, _, _) }

  /** Gets the 1-based line number (inclusive) where this location ends. */
  int getEndLine() { locations_default(this, _, _, _, result, _) }

  /** Gets the 1-based column number (inclusive) where this location ends. */
  int getEndColumn() { locations_default(this, _, _, _, _, result) }

  /** Gets a textual representation of this location. */
  bindingset[this]
  pragma[inline_late]
  string toString() {
    exists(@file file, string path, int startLine, int startColumn, int endLine, int endColumn |
      locations_default(this, file, startLine, startColumn, endLine, endColumn) and
      files(file, path) and
      result = path + "@" + startLine + ":" + startColumn + ":" + endLine + ":" + endColumn
    )
  }
}

/** An entity representing an empty location. */
class EmptyLocation extends Location {
  EmptyLocation() { empty_location(this) }
}
