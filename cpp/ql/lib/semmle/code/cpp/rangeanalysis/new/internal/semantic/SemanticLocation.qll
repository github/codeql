private import semmle.code.cpp.Location

class SemLocation instanceof Location {
  /**
   * Gets a textual representation of this element.
   *
   * The format is "file://filePath:startLine:startColumn:endLine:endColumn".
   */
  string toString() { result = super.toString() }

  /** Gets the 1-based line number (inclusive) where this location starts. */
  int getStartLine() { result = super.getStartLine() }

  /** Gets the 1-based column number (inclusive) where this location starts. */
  int getStartColumn() { result = super.getStartColumn() }

  /** Gets the 1-based line number (inclusive) where this location ends. */
  int getEndLine() { result = super.getEndLine() }

  /** Gets the 1-based column number (inclusive) where this location ends. */
  int getEndColumn() { result = super.getEndColumn() }

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
    super.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}
