/**
 * Inline expectation tests for Ruby.
 * See `shared/util/codeql/util/test/InlineExpectationsTest.qll`
 */

private import codeql.ruby.AST as R
private import codeql.util.test.InlineExpectationsTest

private module Impl implements InlineExpectationsTestSig {
  private import codeql.ruby.ast.internal.TreeSitter

  /**
   * A class representing line comments in Ruby.
   */
  class ExpectationComment extends Ruby::Comment {
    string getContents() { result = this.getValue().suffix(1) }
  }

  class Location = R::Location;
}

import Make<Impl>
