private import codeql.swift.generated.Location

class Location extends LocationBase {
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = getFile().getFullName() and
    sl = getStartLine() and
    sc = getStartColumn() and
    el = getEndLine() and
    ec = getEndColumn()
  }
}
