import python

/*
 * When this library is imported, the 'hasLocationInfo' predicate of
 * Functions and is overridden to specify their entire range
 * instead of just the range of their name. The latter can still be
 * obtained by invoking the getLocation() predicate.
 *
 * The full ranges are required for the purpose of associating an alert
 * with an individual Function as opposed to a whole File.
 */

/**
 * A Function whose 'hasLocationInfo' is overridden to specify its entire range
 * including the body (if any), as opposed to the location of its name only.
 */
class RangeFunction extends Function {
  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    super.getLocation().hasLocationInfo(filepath, startline, startcolumn, _, _) and
    this.getBody().getLastItem().getLocation().hasLocationInfo(filepath, _, _, endline, endcolumn)
  }
}

/**
 * A Class whose 'hasLocationInfo' is overridden to specify its entire range
 * including the body (if any), as opposed to the location of its name only.
 */
class RangeClass extends Class {
  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    super.getLocation().hasLocationInfo(filepath, startline, startcolumn, _, _) and
    this.getBody().getLastItem().getLocation().hasLocationInfo(filepath, _, _, endline, endcolumn)
  }
}
