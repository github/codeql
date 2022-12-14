private import codeql.swift.generated.File

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
}
