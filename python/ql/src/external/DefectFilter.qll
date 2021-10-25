/** Provides a class for working with defect query results stored in dashboard databases. */

import semmle.python.Files

/**
 * Holds if `id` is the opaque identifier of a result reported by query `queryPath`,
 * such that `message` is the associated message and the location of the result spans
 * column `startcol` of line `startline` to column `endcol` of line `endline`
 * in file `filepath`.
 *
 * For more information, see [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
 */
external predicate defectResults(
  int id, string queryPath, string filepath, int startline, int startcol, int endline, int endcol,
  string message
);

/**
 * A defect query result stored in a dashboard database.
 */
class DefectResult extends int {
  DefectResult() { defectResults(this, _, _, _, _, _, _, _) }

  /** Gets the path of the query that reported the result. */
  string getQueryPath() { defectResults(this, result, _, _, _, _, _, _) }

  /** Gets the file in which this query result was reported. */
  File getFile() {
    exists(string path |
      defectResults(this, _, path, _, _, _, _, _) and result.getAbsolutePath() = path
    )
  }

  /** Gets the file path in which this query result was reported. */
  string getFilePath() { defectResults(this, _, result, _, _, _, _, _) }

  /** Gets the line on which the location of this query result starts. */
  int getStartLine() { defectResults(this, _, _, result, _, _, _, _) }

  /** Gets the column on which the location of this query result starts. */
  int getStartColumn() { defectResults(this, _, _, _, result, _, _, _) }

  /** Gets the line on which the location of this query result ends. */
  int getEndLine() { defectResults(this, _, _, _, _, result, _, _) }

  /** Gets the column on which the location of this query result ends. */
  int getEndColumn() { defectResults(this, _, _, _, _, _, result, _) }

  /** Gets the message associated with this query result. */
  string getMessage() { defectResults(this, _, _, _, _, _, _, result) }

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
    defectResults(this, _, filepath, startline, startcolumn, endline, endcolumn, _)
  }

  /** Gets the URL corresponding to the location of this query result. */
  string getURL() {
    result =
      "file://" + getFile().getAbsolutePath() + ":" + getStartLine() + ":" + getStartColumn() + ":" +
        getEndLine() + ":" + getEndColumn()
  }
}

// crude containment by line number only
predicate contains(Location l, DefectResult res) {
  exists(string path, int bl1, int el1, int bl2, int el2 |
    l.hasLocationInfo(path, bl1, _, el1, _) and
    res.hasLocationInfo(path, bl2, _, el2, _) and
    bl1 <= bl2 and
    el1 >= el2
  )
}
