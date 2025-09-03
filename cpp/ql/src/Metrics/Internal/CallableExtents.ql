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
   * The location spans column `sc` of line `sl` to
   * column `ec` of line `el` in file `path`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    super.getLocation().hasLocationInfo(path, sl, sc, _, _) and
    (
      this.getBlock().getLocation().hasLocationInfo(path, _, _, el, ec)
      or
      not exists(this.getBlock()) and el = sl + 1 and ec = 1
    )
  }
}

from RangeFunction f
where f.fromSource()
select f.getLocation(), f
