/** TODO: to be replaced */

/** A file. */
class File extends @file {
  /** toString */
  string toString() { result = getAbsolutePath() }

  /** Gets the name of this file. */
  string getName() { files(this, result) }

  /** Gets the absolute path of this file. */
  string getAbsolutePath() { result = getName() }

  /** Gets the full name of this file. */
  string getFullName() { result = getAbsolutePath() }

  /** Gets the URL of this file. */
  string getURL() { result = "file://" + this.getAbsolutePath() + ":0:0:0:0" }

  /** Gets the base name of this file. */
  string getBaseName() {
    result = this.getAbsolutePath().regexpCapture(".*/(([^/]*?)(?:\\.([^.]*))?)", 1)
  }
}
