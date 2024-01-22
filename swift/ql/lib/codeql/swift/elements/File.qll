private import codeql.swift.generated.File
private import codeql.swift.elements.Location
private import codeql.swift.elements.UnknownLocation

class File extends Generated::File {
  /** toString */
  override string toString() { result = this.getAbsolutePath() }

  /** Gets the absolute path of this file. */
  string getAbsolutePath() { result = this.getName() }

  /** Gets the full name of this file. */
  string getFullName() { result = this.getAbsolutePath() }

  /** Gets the URL of this file. */
  string getURL() { result = "file://" + this.getAbsolutePath() + ":0:0:0:0" }

  /** Gets the base name of this file. */
  string getBaseName() {
    result = this.getAbsolutePath().regexpCapture(".*/(([^/]*?)(?:\\.([^.]*))?)", 1)
  }

  /**
   * Gets the number of lines containing code in this file. This value
   * is approximate.
   */
  int getNumberOfLinesOfCode() {
    result =
      count(int line |
        exists(Location loc |
          not loc instanceof UnknownLocation and loc.getFile() = this and loc.getStartLine() = line
        )
      )
  }

  /**
   * Gets the relative path of this file from the root folder of the
   * analyzed source location. The relative path of the root folder itself
   * would be the empty string.
   *
   * This has no result if the file is outside the source root, that is,
   * if the root folder is not a reflexive, transitive parent of this file.
   */
  string getRelativePath() {
    exists(string absPath, string pref |
      absPath = this.getAbsolutePath() and sourceLocationPrefix(pref)
    |
      absPath = pref and result = ""
      or
      absPath = pref.regexpReplaceAll("/$", "") + "/" + result and
      not result.matches("/%")
    )
  }
}
