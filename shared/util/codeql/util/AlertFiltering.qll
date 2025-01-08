/**
 * Provides the `restrictAlertsTo` extensible predicate to restrict alerts to specific source
 * locations, and the `AlertFilteringImpl` parameterized module to apply the filtering.
 */

private import codeql.util.Location

/**
 * Restricts alerts to a specific location in specific files.
 *
 * If this predicate is empty, accept all alerts. Otherwise, accept alerts only at the specified
 * locations. Note that alert restrictions apply only to the start line of an alert (even if the
 * alert location spans multiple lines) because alerts are displayed on their start lines.
 *
 * - filePath: Absolute path of the file to restrict alerts to.
 * - startLine: Start line number (starting with 1, inclusive) to restrict alerts to.
 * - endLine: End line number (starting with 1, inclusive) to restrict alerts to.
 *
 * If startLine and endLine are both 0, accept alerts anywhere in the file.
 *
 * A query should either completely ignore this predicate (i.e., perform no filtering whatsoever),
 * or only return alerts that meet the filtering criteria as specified above.
 */
extensible predicate restrictAlertsTo(string filePath, int startLine, int endLine);

/** Module for applying alert location filtering. */
module AlertFilteringImpl<LocationSig Location> {
  /** Applies alert filtering to the given location. */
  bindingset[location]
  predicate filterByLocation(Location location) {
    not restrictAlertsTo(_, _, _)
    or
    exists(string filePath, int startLine, int endLine |
      restrictAlertsTo(filePath, startLine, endLine)
    |
      startLine = 0 and
      endLine = 0 and
      location.hasLocationInfo(filePath, _, _, _, _)
      or
      location.hasLocationInfo(filePath, [startLine .. endLine], _, _, _)
    )
  }
}
