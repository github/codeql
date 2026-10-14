private import python as PY
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  /**
   * A class representing line comments in Python. As this is the only form of comment Python
   * permits, we simply reuse the `Comment` class.
   */
  class ExpectationComment = PY::Comment;

  class Location = PY::Location;

  string getRelativeUrl(Location location) {
    exists(PY::File f, int startline, int startcolumn, int endline, int endcolumn |
      location.hasLocationInfo(_, startline, startcolumn, endline, endcolumn) and
      f = location.getFile()
    |
      result =
        f.getRelativePath() + ":" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn
    )
  }
}
