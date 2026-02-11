private import codeql.ruby.AST as R
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  private import codeql.ruby.ast.internal.TreeSitter

  /**
   * A class representing line comments in Ruby.
   */
  class ExpectationComment extends Ruby::Comment {
    string getContents() { result = this.getValue().suffix(1) }
  }

  class Location = R::Location;
}
