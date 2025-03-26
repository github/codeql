private import Raw

/**
 * A location in source code, comprising of a source file and a segment of text
 * within the file.
 */
class SourceLocation extends Location, @location_default {
  override File getFile() { locations_default(this, result, _, _, _, _) }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(File f | locations_default(this, f, startline, startcolumn, endline, endcolumn) |
      filepath = f.getAbsolutePath()
    )
  }

  override string toString() {
    exists(string filepath, int startline, int startcolumn, int endline, int endcolumn |
      this.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    |
      result = filepath + ":" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn
    )
  }
}
