private import codeql.ruby.AST as R
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  private import codeql.ruby.ast.internal.TreeSitter

  private newtype TAnyComment =
    RubyComment(Ruby::Comment comment) or
    ErbComment(R::ErbComment comment)

  /**
   * A class representing comments that may contain inline expectations (Ruby line comments and ERB comments).
   */
  class ExpectationComment extends TAnyComment {
    string toString() {
      result = any(Ruby::Comment c | this = RubyComment(c)).toString()
      or
      result = any(R::ErbComment c | this = ErbComment(c)).toString()
    }

    Location getLocation() {
      result = any(Ruby::Comment c | this = RubyComment(c)).getLocation()
      or
      result = any(R::ErbComment c | this = ErbComment(c)).getLocation()
    }

    string getContents() {
      result = any(Ruby::Comment c | this = RubyComment(c)).getValue().suffix(1)
      or
      result = any(R::ErbComment c | this = ErbComment(c)).getValue().suffix(1)
    }
  }

  class Location = R::Location;
}
