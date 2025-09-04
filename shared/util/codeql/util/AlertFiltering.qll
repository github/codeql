/**
 * Provides the `restrictAlertsTo` and `restrictAlertsToExactLocation` extensible predicate to
 * restrict alerts to specific source locations, and the `AlertFilteringImpl` parameterized module
 * to apply the filtering.
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
 * effect. If it is active, queries may omit alerts that don't have a matching (see below) _primary_
 * or _related_ location (in SARIF terminology). Queries are still allowed to produce alerts that
 * have no matching locations, but they are not required to do so.
 *
 * An alert location is a match if it matches a row in this predicate. If `lineStart` and
 * `lineEnd` are both 0, the row specifies a whole-file match, and a location is a match if
 * its file path matches `filePath`. Otherwise, the row specifies a line-range match, and a
 * location is a match if its file path matches `filePath`, and its character range intersects
 * with the range from the beginning of `lineStart` to the end of `lineEnd`.
 *
 * - filePath: alert location file path (absolute).
 * - lineStart: inclusive start of the line range (1-based).
 * - lineEnd: inclusive end of the line range (1-based).
 *
 * Note that even if an alert has no matching locations for this filtering predicate, it could still
 * have matching locations for other filtering predicates in this module. In that case, queries must
 * still produce such an alert. An alert can be omitted only if (1) there is at least one active
 * filtering predicate, and (2) it has no matching locations for any active filtering predicate.
 *
 * See also: `restrictAlertsToExactLocation`.
 */
extensible predicate restrictAlertsTo(string filePath, int lineStart, int lineEnd);

/**
 * Holds if the query may restrict its computation to only produce alerts that match the given
 * character ranges. This predicate is suitable for testing, where we want to distinguish between
 * alerts on the same line.
 *
 * This predicate is active if and only if it is nonempty. If this predicate is inactive, it has no
 * effect. If it is active, queries may omit alerts that don't have a matching (see below) _primary_
 * or _related_ location (in SARIF terminology). Queries are still allowed to produce alerts that
 * have no matching locations, but they are not required to do so.
 *
 * An alert location is a match if it matches a row in this predicate. Each row specifies a
 * character-range match, and a location is a match if its file path matches `filePath`, and its
 * character range wholly contains the character range from `startColumn` on `startLine` to
 * `endColumn` on `endLine` (inclusive).
 *
 * - filePath: alert location file path (absolute).
 * - startLine: inclusive start line of the character range (1-based).
 * - startColumn: inclusive start column of the character range (1-based).
 * - endLine: inclusive end line of the character range (1-based).
 * - endColumn: inclusive end column of the character range (1-based).
 *
 * Note that even if an alert has no matching locations for this filtering predicate, it could still
 * have matching locations for other filtering predicates in this module. In that case, queries must
 * still produce such an alert. An alert can be omitted only if (1) there is at least one active
 * filtering predicate, and (2) it has no matching locations for any active filtering predicate.
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
   * Holds if the given location is a match for one of the active filtering
   * predicates in this module, or if all filtering predicates are inactive
   * (which means that all alerts must be produced).
   *
   * Note that this predicate has a bindingset and will therefore be inlined;
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
