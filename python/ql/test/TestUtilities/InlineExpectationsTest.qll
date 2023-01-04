/**
 * Inline expectation tests for Python.
 * See `shared/util/codeql/util/test/InlineExpectationsTest.qll`
 */

private import python as PY
private import codeql.util.test.InlineExpectationsTest

/**
 * A class representing line comments in Python. As this is the only form of comment Python
 * permits, we simply reuse the `Comment` class.
 */
private class ExpectationComment extends PY::Comment {
  predicate hasLocationInfo(string file, int line, int column, int endLine, int endColumn) {
    this.getLocation().hasLocationInfo(file, line, column, endLine, endColumn)
  }
}

import Make<ExpectationComment>
