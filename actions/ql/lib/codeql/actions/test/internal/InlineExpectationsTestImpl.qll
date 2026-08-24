private import codeql.Locations as L
private import codeql.actions.ast.internal.Yaml
private import codeql.util.test.InlineExpectationsTest

module Impl implements InlineExpectationsTestSig {
  class ExpectationComment extends YamlNode {
    ExpectationComment() { this.toString().matches("%$ %") }

    string getContents() { result = "$ " + this.toString().regexpCapture(".*\\$ (.*)", 1) }
  }

  class Location = L::Location;
}
