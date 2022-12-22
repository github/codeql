/**
 * Inline expectation tests for CSharp.
 * See `shared/util/codeql/util/test/InlineExpectationsTest.qll`
 */

private import csharp as CS
private import codeql.util.test.InlineExpectationsTest

/**
 * A class representing line comments in C# used by the InlineExpectations core code
 */
private class ExpectationComment extends CS::SinglelineComment {
  /** Gets the contents of the given comment, _without_ the preceding comment marker (`//`). */
  string getContents() { result = this.getText() }

  predicate hasLocationInfo(string file, int line, int column, int endLine, int endColumn) {
    this.getLocation().hasLocationInfo(file, line, column, endLine, endColumn)
  }
}

import Make<ExpectationComment>
