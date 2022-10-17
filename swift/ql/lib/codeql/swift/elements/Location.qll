private import codeql.swift.generated.Location

/**
 * A location of a program element.
 */
class Location extends LocationBase {
  /**
   * Holds if this location is described by `path`, `startLine`, `startColumn`, `endLine` and `endColumn`.
   */
  predicate hasLocationInfo(string path, int startLine, int startColumn, int endLine, int endColumn) {
    path = getFile().getFullName() and
    startLine = getStartLine() and
    startColumn = getStartColumn() and
    endLine = getEndLine() and
    endColumn = getEndColumn()
  }

  /**
   * Gets a textual representation of this location.
   */
  override string toString() {
    exists(string filePath, int startLine, int startColumn, int endLine, int endColumn |
      this.hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn)
    |
      toUrl(filePath, startLine, startColumn, endLine, endColumn, result)
    )
  }
}
