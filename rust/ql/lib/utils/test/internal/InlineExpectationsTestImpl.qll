private import rust as R
private import R
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  class ExpectationComment extends R::Comment {
    ExpectationComment() { this.fromSource() }

    /** Gets the contents of the given comment, _without_ the preceding comment marker (`//`). */
    string getContents() { result = this.getCommentText() }
  }

  class Location = R::Location;

  string getRelativeUrl(Location location) {
    exists(R::File f, int startline, int startcolumn, int endline, int endcolumn |
      location.hasLocationInfo(_, startline, startcolumn, endline, endcolumn) and
      f = location.getFile()
    |
      result =
        f.getRelativePath() + ":" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn
    )
  }
}
