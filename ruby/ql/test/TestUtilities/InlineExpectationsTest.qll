/**
 * Inline expectation tests for Ruby.
 * See `shared/util/codeql/util/test/InlineExpectationsTest.qll`
 */

private import codeql.util.test.InlineExpectationsTest
private import codeql.ruby.ast.internal.TreeSitter

/**
 * A class representing line comments in Ruby.
 */
private class ExpectationComment extends Ruby::Comment {
  string getContents() { result = this.getValue().suffix(1) }

  predicate hasLocationInfo(string file, int line, int column, int endLine, int endColumn) {
    this.getLocation().hasLocationInfo(file, line, column, endLine, endColumn)
  }
}

import Make<ExpectationComment>
