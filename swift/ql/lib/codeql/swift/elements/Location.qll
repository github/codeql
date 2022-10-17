private import codeql.swift.generated.Location

class Location extends LocationBase {
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = getFile().getFullName() and
    sl = getStartLine() and
    sc = getStartColumn() and
    el = getEndLine() and
    ec = getEndColumn()
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
