/**
 * Inline expectation tests for Python.
 * See `shared/util/codeql/util/test/InlineExpectationsTest.qll`
 */

private import python as PY
private import codeql.util.test.InlineExpectationsTest

private module Impl implements InlineExpectationsTestSig {
  /**
   * A class representing line comments in Python. As this is the only form of comment Python
   * permits, we simply reuse the `Comment` class.
   */
  class ExpectationComment = PY::Comment;

  class Location = PY::Location;
}

import Make<Impl>
