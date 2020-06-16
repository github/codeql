import java

external predicate metricResults(
  int id, string queryPath, string file, int startline, int startcol, int endline, int endcol,
  float value
);

class MetricResult extends int {
  MetricResult() { metricResults(this, _, _, _, _, _, _, _) }

  string getQueryPath() { metricResults(this, result, _, _, _, _, _, _) }

  File getFile() {
    exists(string path |
      metricResults(this, _, path, _, _, _, _, _) and result.getAbsolutePath() = path
    )
  }

  int getStartLine() { metricResults(this, _, _, result, _, _, _, _) }

  int getStartColumn() { metricResults(this, _, _, _, result, _, _, _) }

  int getEndLine() { metricResults(this, _, _, _, _, result, _, _) }

  int getEndColumn() { metricResults(this, _, _, _, _, _, result, _) }

  predicate hasMatchingLocation() { exists(this.getMatchingLocation()) }

  Location getMatchingLocation() {
    result.getFile() = this.getFile() and
    result.getStartLine() = this.getStartLine() and
    result.getEndLine() = this.getEndLine() and
    result.getStartColumn() = this.getStartColumn() and
    result.getEndColumn() = this.getEndColumn()
  }

  float getValue() { metricResults(this, _, _, _, _, _, _, result) }

  string getURL() {
    result =
      "file://" + getFile().getAbsolutePath() + ":" + getStartLine() + ":" + getStartColumn() + ":" +
        getEndLine() + ":" + getEndColumn()
  }
}
