/**
 * Provides the `restrictAlertsTo` extensible predicate to restrict alerts to specific source
 * locations, and the `AlertFilteringImpl` parameterized module to apply the filtering.
 */
overlay[local?]
module;

private import codeql.util.Location

/**
 * Holds if the query should produce alerts that match the given line ranges.
 *
 * This predicate is active if and only if it is nonempty. If this predicate is inactive, it has no
 * effect. If it is active, it accepts any alert that has at least one matching location.
 *
 * Note that an alert that is not accepted by this filtering predicate may still be included in the
 * query results if it is accepted by another active filtering predicate in this module. An alert is
 * excluded from the query results if only if (1) there is at least one active filtering predicate,
 * and (2) it is not accepted by any active filtering predicate.
 *
 * An alert location is a match if it matches a row in this predicate. If `startLineStart` and
 * `startLineEnd` are both 0, the row specifies a whole-file match, and a location is a match if
 * its file path matches `filePath`. Otherwise, the row specifies a line-range match, and a
 * location is a match if its file path matches `filePath`, and its start line is between
 * `startLineStart` and `startLineEnd`, inclusive. (Note that only start line of the location is
 * used for matching because an alert is displayed on the first line of its location.)
 *
 * - filePath: alert location file path (absolute).
 * - startLineStart: inclusive start of the range for alert location start line number (1-based).
 * - startLineEnd: inclusive end of the range for alert location start line number (1-based).
 *
 * A query should either perform no alert filtering, or adhere to all the filtering rules in this
 * module and return all and only the accepted alerts.
 *
 * This predicate is suitable for situations where we want to filter alerts at line granularity,
 * such as based on the pull request diff.
 *
 * See also: `restrictAlertsToExactLocation`.
 */
extensible predicate restrictAlertsTo(string filePath, int startLineStart, int startLineEnd);

/**
 * Holds if the query should produce alerts that match the given locations.
 *
 * This predicate is active if and only if it is nonempty. If this predicate is inactive, it has no
 * effect. If it is active, it accepts any alert that has at least one matching location.
 *
 * Note that an alert that is not accepted by this filtering predicate may still be included in the
 * query results if it is accepted by another active filtering predicate in this module. An alert is
 * excluded from the query results if only if (1) there is at least one active filtering predicate,
 * and (2) it is not accepted by any active filtering predicate.
 *
 * An alert location is a match if it matches a row in this predicate. Each row specifies an exact
 * location: an alert location is a match if its file path matches `filePath`, its start line and
 * column match `startLine` and `startColumn`, and its end line and column match `endLine` and
 * `endColumn`.
 *
 * - filePath: alert location file path (absolute).
 * - startLine:  alert location start line number (1-based).
 * - startColumn: alert location start column number (1-based).
 * - endLine: alert location end line number (1-based).
 * - endColumn: alert location end column number (1-based).
 *
 * A query should either perform no alert filtering, or adhere to all the filtering rules in this
 * module and return all and only the accepted alerts.
 *
 * This predicate is suitable for situations where we want to filter by the exact alert location,
 * distinguishing between alerts on the same line.
 *
 * See also: `restrictAlertsTo`.
 */
extensible predicate restrictAlertsToExactLocation(
  string filePath, int startLine, int startColumn, int endLine, int endColumn
);

/** Module for applying alert location filtering. */
module AlertFilteringImpl<LocationSig Location> {
  pragma[nomagic]
  private predicate restrictAlertsToEntireFile(string filePath) { restrictAlertsTo(filePath, 0, 0) }

  pragma[nomagic]
  private predicate restrictAlertsToStartLine(string filePath, int line) {
    exists(int startLineStart, int startLineEnd |
      restrictAlertsTo(filePath, startLineStart, startLineEnd) and
      line = [startLineStart .. startLineEnd]
    )
  }

  /** Applies alert filtering to the given location. */
  bindingset[location]
  predicate filterByLocation(Location location) {
    not restrictAlertsTo(_, _, _) and not restrictAlertsToExactLocation(_, _, _, _, _)
    or
    exists(string filePath |
      restrictAlertsToEntireFile(filePath) and
      location.hasLocationInfo(filePath, _, _, _, _)
      or
      exists(int line |
        restrictAlertsToStartLine(filePath, line) and
        location.hasLocationInfo(filePath, line, _, _, _)
      )
    )
    or
    exists(string filePath, int startLine, int startColumn, int endLine, int endColumn |
      restrictAlertsToExactLocation(filePath, startLine, startColumn, endLine, endColumn)
    |
      location.hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn)
    )
  }

  /**
   * Holds if some subrange within `location` would be accepted by alert filtering.
   *
   * There does not need to exist a `Location` corresponding to that subrange.
   */
  bindingset[location]
  predicate filterByLocationApprox(Location location) {
    not restrictAlertsTo(_, _, _) and not restrictAlertsToExactLocation(_, _, _, _, _)
    or
    exists(string filePath |
      restrictAlertsToEntireFile(filePath) and
      location.hasLocationInfo(filePath, _, _, _, _)
      or
      exists(int locStartLine, int locEndLine |
        location.hasLocationInfo(filePath, locStartLine, _, locEndLine, _)
      |
        restrictAlertsToStartLine(filePath, [locStartLine .. locEndLine])
      )
    )
    or
    // Check if an exact filter-location is fully contained in `location`.
    // This is slow but only used for testing.
    exists(
      string filePath, int startLine, int startColumn, int endLine, int endColumn,
      int filterStartLine, int filterStartColumn, int filterEndLine, int filterEndColumn
    |
      location.hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn) and
      restrictAlertsToExactLocation(filePath, filterStartLine, filterStartColumn, filterEndLine,
        filterEndColumn) and
      startLine <= filterStartLine and
      (startLine != filterStartLine or startColumn <= filterStartColumn) and
      endLine >= filterEndLine and
      (endLine != filterEndLine or endColumn >= filterEndColumn)
    )
  }
}
