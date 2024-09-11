/**
 * This module provides a hand-modifiable wrapper around the generated class `Location`.
 */

private import codeql.rust.generated.Location

class LocationImpl extends Generated::LocationImpl {
  /**
   * Holds if this location is described by `path`, `startLine`, `startColumn`, `endLine` and `endColumn`.
   */
  predicate hasLocationInfo(string path, int startLine, int startColumn, int endLine, int endColumn) {
    path = this.getFile().getFullName() and
    startLine = this.getStartLine() and
    startColumn = this.getStartColumn() and
    endLine = this.getEndLine() and
    endColumn = this.getEndColumn()
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
