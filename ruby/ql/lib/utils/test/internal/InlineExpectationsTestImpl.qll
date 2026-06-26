private import codeql.ruby.AST as R
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  private import codeql.ruby.ast.internal.TreeSitter

  private newtype TAnyComment =
    RubyComment(Ruby::Comment comment) or
    ErbComment(R::ErbComment comment)

  private class AnyComment extends TAnyComment {
    string toString() {
      exists(Ruby::Comment c |
        this = RubyComment(c) and
        result = c.toString()
      )
      or
      exists(R::ErbComment c |
        this = ErbComment(c) and
        result = c.toString()
      )
    }

    Location getLocation() {
      exists(Ruby::Comment c |
        this = RubyComment(c) and
        result = c.getLocation()
      )
      or
      exists(R::ErbComment c |
        this = ErbComment(c) and
        result = c.getLocation()
      )
    }
  }

  /**
   * A class representing line comments in Ruby.
   */
  class ExpectationComment extends AnyComment {
    string getContents() {
      exists(Ruby::Comment c |
        this = RubyComment(c) and
        result = c.getValue().suffix(1)
      )
      or
      exists(R::ErbComment c |
        this = ErbComment(c) and
        result = c.getValue().suffix(1)
      )
    }
  }

  class Location = R::Location;
}
