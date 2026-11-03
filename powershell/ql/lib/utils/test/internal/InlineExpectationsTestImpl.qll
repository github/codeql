private import powershell as P
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  /**
   * A class representing line comments in Powershell.
   */
  class ExpectationComment extends P::SingleLineComment {
    string getContents() { result = this.getCommentContents().getValue().suffix(1) }
  }

  class Location = P::Location;

  string getRelativeUrl(Location location) {
    exists(P::File f, int startline, int startcolumn, int endline, int endcolumn |
      location.hasLocationInfo(_, startline, startcolumn, endline, endcolumn) and
      f = location.getFile()
    |
      result =
        f.getRelativePath() + ":" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn
    )
  }
}
