overlay[local?]
module;

private import go as G
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  final private class CommentFinal = G::Comment;

  /**
   * A class representing line comments in the Go style, including the
   * preceding comment marker (`//`).
   */
  class ExpectationComment extends CommentFinal {
    /** Returns the contents of the given comment, _without_ the preceding comment marker (`//`). */
    string getContents() { result = this.getText() }

    /** Gets this element's location. */
    G::Location getLocation() { result = super.getLocation() }
  }

  class Location = G::Location;

  string getRelativeUrl(Location location) {
    exists(G::File f, int startline, int startcolumn, int endline, int endcolumn |
      location.hasLocationInfo(_, startline, startcolumn, endline, endcolumn) and
      f = location.getFile()
    |
      result =
        f.getRelativePath() + ":" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn
    )
  }
}
