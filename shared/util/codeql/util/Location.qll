/** Provides classes for working with locations. */

/**
 * A location as given by a file, a start line, a start column,
 * an end line, and an end column.
 *
 * For more information about locations see [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
 */
signature class LocationSig {
  /** Gets the 1-based line number (inclusive) where this location starts. */
  int getStartLine();

  /** Gets the 1-based column number (inclusive) where this location starts. */
  int getStartColumn();

  /** Gets the 1-based line number (inclusive) where this location ends. */
  int getEndLine();

  /** Gets the 1-based column number (inclusive) where this location ends. */
  int getEndColumn();

  /** Gets a textual representation of this location. */
  bindingset[this]
  string toString();

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startColumn` of line `startLine` to
   * column `endColumn` of line `endLine` in file `filepath`.
   * For more information, see
   * [Providing locations in CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filePath, int startLine, int startColumn, int endLine, int endColumn
  );
}
