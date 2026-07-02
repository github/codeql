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
    Ruby::Comment asRubyComment() { this = RubyComment(result) }

    R::ErbComment asErbComment() { this = ErbComment(result) }

    string toString() {
      result = this.asRubyComment().toString()
      or
      result = this.asErbComment().toString()
    }

    Location getLocation() {
      result = this.asRubyComment().getLocation()
      or
      result = this.asErbComment().getLocation()
    }

    string getContents() {
      result = this.asRubyComment().getValue().suffix(1)
      or
      result = this.asErbComment().getValue().suffix(1)
    }
  }

  class Location = R::Location;
}
