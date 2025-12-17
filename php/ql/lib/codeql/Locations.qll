/**
 * Provides the Location class for source locations.
 */

overlay[local]
module;

/** A location in the source code. */
class Location extends @location_default {
  /** Gets the file containing this location. */
  File getFile() { locations_default(this, result, _, _, _, _) }

  /** Gets the start line of this location. */
  int getStartLine() { locations_default(this, _, result, _, _, _) }

  /** Gets the start column of this location. */
  int getStartColumn() { locations_default(this, _, _, result, _, _) }

  /** Gets the end line of this location. */
  int getEndLine() { locations_default(this, _, _, _, result, _) }

  /** Gets the end column of this location. */
  int getEndColumn() { locations_default(this, _, _, _, _, result) }

  /** Gets a string representation of this location. */
  string toString() {
    result = this.getFile().toString() + ":" + this.getStartLine().toString()
  }

  /** Holds if this location starts before `that`. */
  predicate startsBefore(Location that) {
    this.getFile() = that.getFile() and
    (
      this.getStartLine() < that.getStartLine() or
      (this.getStartLine() = that.getStartLine() and this.getStartColumn() < that.getStartColumn())
    )
  }
}

/** A file in the source code. */
class File extends @file {
  /** Gets the absolute path of this file. */
  string getAbsolutePath() { files(this, result) }

  /** Gets the base name of this file. */
  string getBaseName() {
    result = this.getAbsolutePath().regexpCapture(".*/([^/]+)$", 1)
    or
    not this.getAbsolutePath().matches("%/%") and result = this.getAbsolutePath()
  }

  /** Gets a string representation of this file. */
  string toString() { result = this.getBaseName() }
}

/** A folder in the file system. */
class Folder extends @folder {
  /** Gets the absolute path of this folder. */
  string getAbsolutePath() { folders(this, result) }

  /** Gets a string representation of this folder. */
  string toString() { result = this.getAbsolutePath() }
}
