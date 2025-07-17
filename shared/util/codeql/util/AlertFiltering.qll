/**
 * Provides the `restrictAlertsTo` extensible predicate to restrict alerts to specific source
 * locations, and the `AlertFilteringImpl` parameterized module to apply the filtering.
 */
overlay[local?]
module;

private import codeql.util.Location

/**
 * Holds if the query may restrict its computation to only produce alerts that match the given line
 * ranges. This predicate is used for implementing _diff-informed queries_ for pull requests in
 * GitHub Code Scanning.
 *
 * This predicate is active if and only if it is nonempty. If this predicate is inactive, it has no
 * effect. If it is active, queries may omit alerts that don't have a _primary_ or _related_
 * location (in SARIF terminology) whose start line is within a specified range. Queries are allowed
 * to produce alerts outside this range.
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
 * Note that an alert that is not accepted by this filtering predicate may still be included in the
 * query results if it is accepted by another active filtering predicate in this module. An alert is
 * excluded from the query results if only if (1) there is at least one active filtering predicate,
 * and (2) it is not accepted by any active filtering predicate.
 *
 * See also: `restrictAlertsToExactLocation`.
 */
extensible predicate restrictAlertsTo(string filePath, int startLineStart, int startLineEnd);

/**
 * Holds if the query may restrict its computation to only produce alerts that match the given
 * character ranges. This predicate is suitable for testing, where we want to filter by the exact
 * alert location, distinguishing between alerts on the same line.
 *
 * This predicate is active if and only if it is nonempty. If this predicate is inactive, it has no
 * effect. If it is active, queries may omit alerts that don't have a _primary_ or _related_
 * location (in SARIF terminology) whose location equals a tuple from this predicate. Queries are
 * allowed to produce alerts outside this range.
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
 * Note that an alert that is not accepted by this filtering predicate may still be included in the
 * query results if it is accepted by another active filtering predicate in this module. An alert is
 * excluded from the query results if only if (1) there is at least one active filtering predicate,
 * and (2) it is not accepted by any active filtering predicate.
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
  private predicate restrictAlertsToLine(string filePath, int line) {
    exists(int startLineStart, int startLineEnd |
      restrictAlertsTo(filePath, startLineStart, startLineEnd) and
      line = [startLineStart .. startLineEnd]
    )
  }

  /**
   * Holds if the given location intersects the diff range. When that is the
   * case, ensuring that alerts mentioning this location are included in the
   * query results is a valid overapproximation of the requirements for
   * _diff-informed queries_ as documented under `restrictAlertsTo`.
   *
   * Testing for full intersection rather than only matching the start line
   * means that this predicate is more broadly useful than just checking whether
   * a specific element is considered to be in the diff range of GitHub Code
   * Scanning:
   * - If it's inconvenient to pass the exact `Location` of the element of
   *   interest, it's valid to use a `Location` of an enclosing element.
   * - This predicate could be useful for other systems of alert presentation
   *   where the rules don't exactly match GitHub Code Scanning.
   *
   * If there is no diff range, this predicate holds for all locations. Note
   * that this predicate has a bindingset and will therefore be inlined;
   * callers should include enough context to ensure efficient evaluation.
   */
  bindingset[location]
  predicate filterByLocation(Location location) {
    not restrictAlertsTo(_, _, _) and not restrictAlertsToExactLocation(_, _, _, _, _)
    or
    exists(string filePath |
      restrictAlertsToEntireFile(filePath) and
      location.hasLocationInfo(filePath, _, _, _, _)
      or
      exists(int locStartLine, int locEndLine |
        location.hasLocationInfo(filePath, locStartLine, _, locEndLine, _)
      |
        restrictAlertsToLine(pragma[only_bind_into](filePath), [locStartLine .. locEndLine])
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
