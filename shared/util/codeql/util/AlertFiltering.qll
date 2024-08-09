/**
 * Provides the `restrictAlertsTo` extensible predicate to restrict alerts to specific source
 * locations, and the `AlertFilteringImpl` parameterized module to apply the filtering.
 */

private import codeql.util.Location

/**
 * Restricts alerts to a specific location in specific files.
 *
 * If this predicate is empty, accept all alerts. Otherwise, accept alerts only at the specified
 * locations.
 *
 * - filePath: Absolute path of the file to restrict alerts to.
 * - line: Line number (starting with 1) to restrict alerts to. If 0, accept alerts anywhere in the
 *   file.
 */
extensible predicate restrictAlertsTo(string filePath, int line);

/** Module for applying alert location filtering. */
module AlertFilteringImpl<LocationSig Location> {
  /** Applies alert filtering to the given location. */
  bindingset[location]
  predicate filterByLocation(Location location) {
    not exists( | restrictAlertsTo(_, _))
    or
    exists(string filePath, int startLine, int endLine |
      location.hasLocationInfo(filePath, startLine, _, endLine, _) and
      (
        restrictAlertsTo(filePath, [startLine .. endLine]) or
        restrictAlertsTo(filePath, 0)
      )
    )
  }
}
