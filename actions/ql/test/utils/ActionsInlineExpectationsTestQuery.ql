/**
 * @kind test-postprocess
 */

private import codeql.Locations as Locations
private import codeql.actions.ast.internal.Yaml as Yaml
private import codeql.util.test.InlineExpectationsTest as T
import T::TestPostProcessing

private module Impl implements T::InlineExpectationsTestSig {
  class Location = Locations::Location;

  string getRelativeUrl(Locations::Location location) {
    exists(int startLine, int startColumn, int endLine, int endColumn |
      location.hasLocationInfo(_, startLine, startColumn, endLine, endColumn)
    |
      result =
        location.getFile().getRelativePath() + ":" + startLine + ":" + startColumn + ":" + endLine +
          ":" + endColumn
    )
  }

  class ExpectationComment extends Yaml::YamlComment {
    string getContents() { result = this.getText() }
  }
}

import T::TestPostProcessing::Make<Impl>
