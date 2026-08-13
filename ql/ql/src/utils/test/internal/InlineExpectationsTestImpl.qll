private import ql as QL
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  private import codeql_ql.ast.internal.TreeSitter as TS

  private newtype TExpectationComment = MkExpectationComment(TS::QL::LineComment comment)

  /**
   * Represents a line comment.
   */
  class ExpectationComment extends TExpectationComment {
    TS::QL::LineComment comment;

    ExpectationComment() { this = MkExpectationComment(comment) }

    /** Returns the contents of the given comment, _without_ the preceding comment marker (`//`). */
    string getContents() { result = comment.getValue().suffix(2) }

    /** Gets a textual representation of this element. */
    string toString() { result = comment.toString() }

    /** Gets the location of this comment. */
    Location getLocation() { result = comment.getLocation() }
  }

  class Location = QL::Location;

  string getRelativeUrl(Location location) {
    exists(QL::File f, int startline, int startcolumn, int endline, int endcolumn |
      location.hasLocationInfo(_, startline, startcolumn, endline, endcolumn) and
      f = location.getFile()
    |
      result =
        f.getRelativePath() + ":" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn
    )
  }

  bindingset[relativePath]
  string getStartCommentMarker(string relativePath) {
    // The QL extractor can also extract YAML (e.g. `qlpack.yml`), whose `#` comment syntax
    // differs, so we only render for QL sources and dbscheme files.
    relativePath.regexpMatch(".*\\.(ql|qll|dbscheme)") and
    result = "//"
  }
}
