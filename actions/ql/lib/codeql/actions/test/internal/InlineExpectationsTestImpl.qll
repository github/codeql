private import codeql.Locations as L
private import codeql.actions.ast.internal.Yaml as Yaml
private import codeql.util.test.InlineExpectationsTest

/** Provides the Actions implementation of inline expectation parsing. */
module Impl implements InlineExpectationsTestSig {
  /** A class representing YAML comments that may contain inline expectations. */
  class ExpectationComment extends Yaml::YamlComment {
    /** Gets the contents of this comment. */
    string getContents() { result = this.getText() }
  }

  class Location = L::Location;

  string getRelativeUrl(Location location) {
    exists(int startLine, int startColumn, int endLine, int endColumn |
      location.hasLocationInfo(_, startLine, startColumn, endLine, endColumn)
    |
      result =
        location.getFile().getRelativePath() + ":" + startLine + ":" + startColumn + ":" + endLine +
          ":" + endColumn
    )
  }
}
