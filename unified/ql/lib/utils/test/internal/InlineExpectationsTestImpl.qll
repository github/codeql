private import unified as U
private import U
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  class ExpectationComment extends U::Comment {
    /** Gets the text inside this comment, without the surrounding comment delimiters. */
    string getContents() { result = this.getCommentText() }
  }

  class Location = U::Location;

  string getRelativeUrl(Location location) {
    exists(File f, int startline, int startcolumn, int endline, int endcolumn |
      location.hasLocationInfo(_, startline, startcolumn, endline, endcolumn) and
      f = location.getFile()
    |
      result =
        f.getRelativePath() + ":" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn
    )
  }

  bindingset[relativePath]
  string getStartCommentMarker(string relativePath) {
    // The unified extractor currently ingests only Swift sources, which use `//`. Gating on
    // the extension keeps this correct if it gains a language with a different comment syntax.
    relativePath.regexpMatch(".*\\.(swift|swiftinterface)") and
    result = "//"
  }
}
