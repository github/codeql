import codeql.rust.elements.internal.ExtractorStep

private class Step instanceof ExtractorStep {
  string toString() {
    result = super.getAction() + "(" + this.getFilePath() + ")"
    or
    not super.hasFile() and result = super.getAction()
  }

  private string getFilePath() {
    exists(File file | file = super.getFile() |
      exists(file.getRelativePath()) and result = file.getAbsolutePath()
      or
      not exists(file.getRelativePath()) and result = "/" + file.getBaseName()
    )
  }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    super.hasLocationInfo(_, startline, startcolumn, endline, endcolumn) and
    filepath = this.getFilePath()
  }
}

from Step step
select step
