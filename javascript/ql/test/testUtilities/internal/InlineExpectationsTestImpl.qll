private import javascript as JS
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  private import javascript

  class ExpectationComment extends LineComment {
    string getContents() { result = this.getText() }
  }

  class Location = JS::Location;
}
