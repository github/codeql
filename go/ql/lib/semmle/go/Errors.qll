/** Provides classes for working with Go frontend errors recorded during extraction. */

import go

/**
 * An error reported by the Go frontend during extraction.
 */
class Error extends @error {
  /** Gets the message associated with this error. */
  string getMessage() { errors(this, _, result, _, _, _, _, _, _) }

  /** Gets the raw position reported by the frontend for this error. */
  string getRawPosition() { errors(this, _, _, result, _, _, _, _, _) }

  /** Gets the package in which this error was reported. */
  Package getPackage() { errors(this, _, _, _, _, _, _, result, _) }

  /** Gets the index of this error among all errors reported for the same package. */
  int getIndex() { errors(this, _, _, _, _, _, _, _, result) }

  /** Gets the file in which this error was reported, if it can be determined. */
  ExtractedOrExternalFile getFile() { this.hasLocationInfo(result.getAbsolutePath(), _, _, _, _) }

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
    errors(this, _, _, _, filepath, startline, startcolumn, _, _) and
    endline = startline and
    endcolumn = startcolumn
  }

  /** Gets a textual representation of this error. */
  string toString() { result = this.getMessage() }
}

/** An error reported by an unknown part of the Go frontend. */
class UnknownError extends Error, @unknownerror { }

/** An error reported by the Go frontend driver. */
class ListError extends Error, @listerror { }

/** An error reported by the Go parser. */
class ParseError extends Error, @parseerror { }

/** An error reported by the Go type checker. */
class TypeError extends Error, @typeerror { }
