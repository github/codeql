/** Provides a class for working with metric query results stored in dashboard databases. */

import cpp

/**
 * Holds if `id` in the opaque identifier of a result reported by query `queryPath`,
 * such that `value` is the reported metric value and the location of the result spans
 * column `startcolumn` of line `startline` to column `endcolumn` of line `endline`
 * in file `filepath`.
 *
 * For more information, see [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
 */
external predicate metricResults(
  int id, string queryPath, string file, int startline, int startcol, int endline, int endcol,
  float value
);

/**
 * A metric query result stored in a dashboard database.
 */
class MetricResult extends int {
  MetricResult() { metricResults(this, _, _, _, _, _, _, _) }

  /** Gets the path of the query that reported the result. */
  string getQueryPath() { metricResults(this, result, _, _, _, _, _, _) }

  /** Gets the file in which this query result was reported. */
  File getFile() {
    exists(string path |
      metricResults(this, _, path, _, _, _, _, _) and result.getAbsolutePath() = path
    )
  }

  /** Gets the line on which the location of this query result starts. */
  int getStartLine() { metricResults(this, _, _, result, _, _, _, _) }

  /** Gets the column on which the location of this query result starts. */
  int getStartColumn() { metricResults(this, _, _, _, result, _, _, _) }

  /** Gets the line on which the location of this query result ends. */
  int getEndLine() { metricResults(this, _, _, _, _, result, _, _) }

  /** Gets the column on which the location of this query result ends. */
  int getEndColumn() { metricResults(this, _, _, _, _, _, result, _) }

  /**
   * Holds if there is a `Location` entity whose location is the same as
   * the location of this query result.
   */
  predicate hasMatchingLocation() { exists(this.getMatchingLocation()) }

  /**
   * Gets the `Location` entity whose location is the same as the location
   * of this query result.
   */
  Location getMatchingLocation() {
    result.getFile() = this.getFile() and
    result.getStartLine() = this.getStartLine() and
    result.getEndLine() = this.getEndLine() and
    result.getStartColumn() = this.getStartColumn() and
    result.getEndColumn() = this.getEndColumn()
  }

  /** Gets the value associated with this query result. */
  float getValue() { metricResults(this, _, _, _, _, _, _, result) }

  /** Gets the URL corresponding to the location of this query result. */
  string getURL() {
    result =
      "file://" + getFile().getAbsolutePath() + ":" + getStartLine() + ":" + getStartColumn() + ":" +
        getEndLine() + ":" + getEndColumn()
  }
}
