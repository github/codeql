import cpp as C
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  private newtype TExpectationComment = MkExpectationComment(C::CppStyleComment c)

  /**
   * A class representing a line comment in the CPP style.
   * Unlike the `CppStyleComment` class, however, the string returned by `getContents` does _not_
   * include the preceding comment marker (`//`).
   */
  class ExpectationComment extends TExpectationComment {
    C::CppStyleComment comment;

    ExpectationComment() { this = MkExpectationComment(comment) }

    /** Returns the contents of the given comment, _without_ the preceding comment marker (`//`). */
    string getContents() { result = comment.getContents().suffix(2) }

    /** Gets a textual representation of this element. */
    string toString() { result = comment.toString() }

    /** Gets the location of this comment. */
    Location getLocation() { result = comment.getLocation() }
  }

  class Location = C::Location;

  string getRelativeUrl(Location location) {
    exists(C::File f, int startline, int startcolumn, int endline, int endcolumn |
      location.hasLocationInfo(_, startline, startcolumn, endline, endcolumn) and
      f = location.getFile()
    |
      result =
        f.getRelativePath() + ":" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn
    )
  }

  bindingset[relativePath]
  string getStartCommentMarker(string relativePath) {
    // C/C++ databases can also contain XML (e.g. `.xml`, `.props`), whose block-comment
    // syntax is not yet supported, so we only render for C/C++ sources.
    relativePath
        .regexpMatch(".*\\.(c|cc|cpp|cxx|cp|c\\+\\+|h|hh|hpp|hxx|h\\+\\+|inl|tcc|ipp|tpp|cu|cuh)") and
    result = "//"
  }
}
