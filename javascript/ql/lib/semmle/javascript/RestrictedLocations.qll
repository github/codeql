/** Provides classes for restricting the locations reported for program elements. */

import javascript

/**
 * A program element with its location restricted to its first line, unless the element
 * is less than one line long to begin with.
 *
 * This is useful for avoiding multi-line violations.
 */
class FirstLineOf extends Locatable {
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
    exists(int xl, int xc |
      this.getLocation().hasLocationInfo(filepath, startline, startcolumn, xl, xc) and
      startline = endline and
      if xl = startline
      then endcolumn = xc
      else
        endcolumn =
          max(int c | any(DbLocation l).hasLocationInfo(filepath, startline, _, startline, c))
    )
  }
}

/**
 * A program element with its location restricted to its last line, unless the element
 * is less than one line long to begin with.
 *
 * This is useful for avoiding multi-line violations.
 */
class LastLineOf extends Locatable {
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
    exists(int xl, int xc |
      this.getLocation().hasLocationInfo(filepath, xl, xc, endline, endcolumn) and
      startline = endline and
      if xl = endline then startcolumn = xc else startcolumn = 1
    )
  }
}
