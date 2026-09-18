private import codeql.Locations as L
private import codeql.actions.ast.internal.Yaml
private import codeql.util.test.InlineExpectationsTest

/** Provides the Actions implementation of inline expectation parsing. */
module Impl implements InlineExpectationsTestSig {
  /** A class representing YAML comments that may contain inline expectations. */
  class ExpectationComment extends YamlNode {
    ExpectationComment() { this.toString().matches("%$ %") }

    /** Gets the contents of this comment, starting at the inline expectation marker (`$`). */
    string getContents() { result = this.toString().regexpCapture(".*(\\$ .*)", 1) }
  }

  class Location = L::Location;
}
