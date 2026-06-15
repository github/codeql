/**
 * @name Extents of functions
 * @kind extent
 * @id cpp/callable-extents
 * @metricType callable
 */

import cpp

/**
 * A Function with location overridden to cover its entire range,
 * including the body (if any), as opposed to the location of its name
 * only.
 */
class RangeFunction extends Function {
  /**
   * Holds if this function is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    super.getLocation().hasLocationInfo(filepath, startline, startcolumn, _, _) and
    (
      this.getBlock().getLocation().hasLocationInfo(filepath, _, _, endline, endcolumn)
      or
      not exists(this.getBlock()) and endline = startline + 1 and endcolumn = 1
    )
  }
}

from RangeFunction f
where f.fromSource()
select f.getLocation(), f
