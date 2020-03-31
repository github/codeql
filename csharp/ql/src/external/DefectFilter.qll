import csharp

external predicate defectResults(
  int id, string queryPath, string file, int startline, int startcol, int endline, int endcol,
  string message
);

class DefectResult extends int {
  DefectResult() { defectResults(this, _, _, _, _, _, _, _) }

  string getQueryPath() { defectResults(this, result, _, _, _, _, _, _) }

  File getFile() {
    exists(string path |
      defectResults(this, _, path, _, _, _, _, _) and result.getAbsolutePath() = path
    )
  }

  int getStartLine() { defectResults(this, _, _, result, _, _, _, _) }

  int getStartColumn() { defectResults(this, _, _, _, result, _, _, _) }

  int getEndLine() { defectResults(this, _, _, _, _, result, _, _) }

  int getEndColumn() { defectResults(this, _, _, _, _, _, result, _) }

  string getMessage() { defectResults(this, _, _, _, _, _, _, result) }

  string getURL() {
    result =
      "file://" + getFile().getAbsolutePath() + ":" + getStartLine() + ":" + getStartColumn() + ":" +
        getEndLine() + ":" + getEndColumn()
  }
}
