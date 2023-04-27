/**
 * Provides a library for writing QL tests whose success or failure is based on expected results
 * embedded in the test source code as comments, rather than the contents of an `.expected` file
 * (in that the `.expected` file should always be empty).
 *
 * To add this framework to a new language, add a new file
 * (usually called `InlineExpectationsTest.qll`) with:
 * - `private import codeql.util.test.InlineExpectationsTest` (this file)
 * - An implementation of the signature in `InlineExpectationsTestSig`.
 *   Usually this is done in a mdule called `Impl`.
 *   `Impl` has to define a `Location` class, and an `ExpectationComment` class.
 *   The `ExpectationComment` class must support a `getContents` method that returns
 *   the contents of the given comment, _excluding_ the comment indicator itself.
 *   It should also define `toString` and `getLocation` as usual.
 * - `import Make<Impl>` to expose the query predicates constructed in the `Make` module.
 *
 * To create a new inline expectations test:
 * - Declare a class that extends `InlineExpectationsTest`. In the characteristic predicate of the
 * new class, bind `this` to a unique string (usually the name of the test).
 * - Override the `hasActualResult()` predicate to produce the actual results of the query. For each
 * result, specify a `Location`, a text description of the element for which the result was
 * reported, a short string to serve as the tag to identify expected results for this test, and the
 * expected value of the result.
 * - Override `getARelevantTag()` to return the set of tags that can be produced by
 * `hasActualResult()`. Often this is just a single tag.
 *
 * Example:
 * ```ql
 * class ConstantValueTest extends InlineExpectationsTest {
 *   ConstantValueTest() { this = "ConstantValueTest" }
 *
 *   override string getARelevantTag() {
 *     // We only use one tag for this test.
 *     result = "const"
 *   }
 *
 *   override predicate hasActualResult(
 *     Location location, string element, string tag, string value
 *   ) {
 *     exists(Expr e |
 *       tag = "const" and // The tag for this test.
 *       value = e.getValue() and // The expected value. Will only hold for constant expressions.
 *       location = e.getLocation() and // The location of the result to be reported.
 *       element = e.toString() // The display text for the result.
 *     )
 *   }
 * }
 * ```
 *
 * There is no need to write a `select` clause or query predicate. All of the differences between
 * expected results and actual results will be reported in the `failures()` query predicate.
 *
 * To annotate the test source code with an expected result, place a comment starting with a `$` on the
 * same line as the expected result, with text of the following format as the body of the comment:
 *
 * `tag=expected-value`
 *
 * Where `tag` is the value of the `tag` parameter from `hasActualResult()`, and `expected-value` is
 * the value of the `value` parameter from `hasActualResult()`. The `=expected-value` portion may be
 * omitted, in which case `expected-value` is treated as the empty string. Multiple expectations may
 * be placed in the same comment. Any actual result that
 * appears on a line that does not contain a matching expected result comment will be reported with
 * a message of the form "Unexpected result: tag=value". Any expected result comment for which there
 * is no matching actual result will be reported with a message of the form
 * "Missing result: tag=expected-value".
 *
 * Example:
 * ```cpp
 * int i = x + 5;  // $ const=5
 * int j = y + (7 - 3)  // $ const=7 const=3 const=4  // The result of the subtraction is a constant.
 * ```
 *
 * For tests that contain known missing and spurious results, it is possible to further
 * annotate that a particular expected result is known to be spurious, or that a particular
 * missing result is known to be missing:
 *
 * `$ SPURIOUS: tag=expected-value`  // Spurious result
 * `$ MISSING: tag=expected-value`  // Missing result
 *
 * A spurious expectation is treated as any other expected result, except that if there is no
 * matching actual result, the message will be of the form "Fixed spurious result: tag=value". A
 * missing expectation is treated as if there were no expected result, except that if a
 * matching expected result is found, the message will be of the form
 * "Fixed missing result: tag=value".
 *
 * A single line can contain all the expected, spurious and missing results of that line. For instance:
 * `$ tag1=value1 SPURIOUS: tag2=value2 MISSING: tag3=value3`.
 *
 * If the same result value is expected for two or more tags on the same line, there is a shorthand
 * notation available:
 *
 * `tag1,tag2=expected-value`
 *
 * is equivalent to:
 *
 * `tag1=expected-value tag2=expected-value`
 */

/**
 * A signature specifying the required parts for
 * constructing inline expectations.
 */
signature module InlineExpectationsTestSig {
  /** The location of an element in the source code. */
  class Location {
    predicate hasLocationInfo(
      string filename, int startLine, int startColumn, int endLine, int endColumn
    );
  }

  /** A comment that may contain inline expectations. */
  class ExpectationComment {
    /** Gets the contents of this comment, _excluding_ the comment indicator. */
    string getContents();

    /** Gets the location of this comment. */
    Location getLocation();

    /** Gets a textual representation of this element. */
    string toString();
  }
}

/**
 * Classes and predicates implementing inline expectations.
 */
module Make<InlineExpectationsTestSig Impl> {
  private import Impl

  /**
   * The base class for tests with inline expectations. The test extends this class to provide the actual
   * results of the query, which are then compared with the expected results in comments to produce a
   * list of failure messages that point out where the actual results differ from the expected
   * results.
   */
  abstract class InlineExpectationsTest extends string {
    bindingset[this]
    InlineExpectationsTest() { any() }

    /**
     * Returns all tags that can be generated by this test. Most tests will only ever produce a single
     * tag. Any expected result comments for a tag that is not returned by the `getARelevantTag()`
     * predicate for an active test will be ignored. This makes it possible to write multiple tests in
     * different `.ql` files that all query the same source code.
     */
    abstract string getARelevantTag();

    /**
     * Returns the actual results of the query that is being tested. Each result consist of the
     * following values:
     * - `location` - The source code location of the result. Any expected result comment must appear
     *   on the start line of this location.
     * - `element` - Display text for the element on which the result is reported.
     * - `tag` - The tag that marks this result as coming from this test. This must be one of the tags
     *   returned by `getARelevantTag()`.
     * - `value` - The value of the result, which will be matched against the value associated with
     *   `tag` in any expected result comment on that line.
     */
    abstract predicate hasActualResult(Location location, string element, string tag, string value);

    /**
     * Holds if there is an optional result on the specified location.
     *
     * This is similar to `hasActualResult`, but returns results that do not require a matching annotation.
     * A failure will still arise if there is an annotation that does not match any results, but not vice versa.
     * Override this predicate to specify optional results.
     */
    predicate hasOptionalResult(Location location, string element, string tag, string value) {
      none()
    }

    final predicate hasFailureMessage(FailureLocatable element, string message) {
      exists(ActualResult actualResult |
        actualResult.getTest() = this and
        actualResult.getTag() = this.getARelevantTag() and
        element = actualResult and
        (
          exists(FalseNegativeExpectation falseNegative |
            falseNegative.matchesActualResult(actualResult) and
            message = "Fixed missing result:" + falseNegative.getExpectationText()
          )
          or
          not exists(ValidExpectation expectation | expectation.matchesActualResult(actualResult)) and
          message = "Unexpected result: " + actualResult.getExpectationText() and
          not actualResult.isOptional()
        )
      )
      or
      exists(ActualResult actualResult |
        actualResult.getTest() = this and
        not actualResult.getTag() = this.getARelevantTag() and
        element = actualResult and
        message =
          "Tag mismatch: Actual result with tag '" + actualResult.getTag() +
            "' that is not part of getARelevantTag()"
      )
      or
      exists(ValidExpectation expectation |
        not exists(ActualResult actualResult | expectation.matchesActualResult(actualResult)) and
        expectation.getTag() = this.getARelevantTag() and
        element = expectation and
        (
          expectation instanceof GoodExpectation and
          message = "Missing result:" + expectation.getExpectationText()
          or
          expectation instanceof FalsePositiveExpectation and
          message = "Fixed spurious result:" + expectation.getExpectationText()
        )
      )
      or
      exists(InvalidExpectation expectation |
        element = expectation and
        message = "Invalid expectation syntax: " + expectation.getExpectation()
      )
    }
  }

  /**
   * RegEx pattern to match a comment containing one or more expected results. The comment must have
   * `$` as its first non-whitespace character. Any subsequent character
   * is treated as part of the expected results, except that the comment may contain a `//` sequence
   * to treat the remainder of the line as a regular (non-interpreted) comment.
   */
  private string expectationCommentPattern() { result = "\\s*\\$((?:[^/]|/[^/])*)(?://.*)?" }

  /**
   * The possible columns in an expectation comment. The `TDefaultColumn` branch represents the first
   * column in a comment. This column is not precedeeded by a name. `TNamedColumn(name)` represents a
   * column containing expected results preceded by the string `name:`.
   */
  private newtype TColumn =
    TDefaultColumn() or
    TNamedColumn(string name) { name = ["MISSING", "SPURIOUS"] }

  bindingset[start, content]
  private int getEndOfColumnPosition(int start, string content) {
    result =
      min(string name, int cand |
        exists(TNamedColumn(name)) and
        cand = content.indexOf(name + ":") and
        cand >= start
      |
        cand
      )
    or
    not exists(string name |
      exists(TNamedColumn(name)) and
      content.indexOf(name + ":") >= start
    ) and
    result = content.length()
  }

  private predicate getAnExpectation(
    ExpectationComment comment, TColumn column, string expectation, string tags, string value
  ) {
    exists(string content |
      content = comment.getContents().regexpCapture(expectationCommentPattern(), 1) and
      (
        column = TDefaultColumn() and
        exists(int end |
          end = getEndOfColumnPosition(0, content) and
          expectation = content.prefix(end).regexpFind(expectationPattern(), _, _).trim()
        )
        or
        exists(string name, int start, int end |
          column = TNamedColumn(name) and
          start = content.indexOf(name + ":") + name.length() + 1 and
          end = getEndOfColumnPosition(start, content) and
          expectation = content.substring(start, end).regexpFind(expectationPattern(), _, _).trim()
        )
      )
    ) and
    tags = expectation.regexpCapture(expectationPattern(), 1) and
    if exists(expectation.regexpCapture(expectationPattern(), 2))
    then value = expectation.regexpCapture(expectationPattern(), 2)
    else value = ""
  }

  private string getColumnString(TColumn column) {
    column = TDefaultColumn() and result = ""
    or
    column = TNamedColumn(result)
  }

  /**
   * RegEx pattern to match a single expected result, not including the leading `$`. It consists of one or
   * more comma-separated tags optionally followed by `=` and the expected value.
   *
   * Tags must be only letters, digits, `-` and `_` (note that the first character
   * must not be a digit), but can contain anything enclosed in a single set of
   * square brackets.
   *
   * Examples:
   * - `tag`
   * - `tag=value`
   * - `tag,tag2=value`
   * - `tag[foo bar]=value`
   *
   * Not allowed:
   * - `tag[[[foo bar]`
   */
  private string expectationPattern() {
    exists(string tag, string tags, string value |
      tag = "[A-Za-z-_](?:[A-Za-z-_0-9]|\\[[^\\]\\]]*\\])*" and
      tags = "((?:" + tag + ")(?:\\s*,\\s*" + tag + ")*)" and
      // In Python, we allow both `"` and `'` for strings, as well as the prefixes `bru`.
      // For example, `b"foo"`.
      value = "((?:[bru]*\"[^\"]*\"|[bru]*'[^']*'|\\S+)*)" and
      result = tags + "(?:=" + value + ")?"
    )
  }

  private newtype TFailureLocatable =
    TActualResult(
      InlineExpectationsTest test, Location location, string element, string tag, string value,
      boolean optional
    ) {
      test.hasActualResult(location, element, tag, value) and
      optional = false
      or
      test.hasOptionalResult(location, element, tag, value) and optional = true
    } or
    TValidExpectation(ExpectationComment comment, string tag, string value, string knownFailure) {
      exists(TColumn column, string tags |
        getAnExpectation(comment, column, _, tags, value) and
        tag = tags.splitAt(",") and
        knownFailure = getColumnString(column)
      )
    } or
    TInvalidExpectation(ExpectationComment comment, string expectation) {
      getAnExpectation(comment, _, expectation, _, _) and
      not expectation.regexpMatch(expectationPattern())
    }

  class FailureLocatable extends TFailureLocatable {
    string toString() { none() }

    Location getLocation() { none() }

    final string getExpectationText() { result = this.getTag() + "=" + this.getValue() }

    string getTag() { none() }

    string getValue() { none() }
  }

  class ActualResult extends FailureLocatable, TActualResult {
    InlineExpectationsTest test;
    Location location;
    string element;
    string tag;
    string value;
    boolean optional;

    ActualResult() { this = TActualResult(test, location, element, tag, value, optional) }

    override string toString() { result = element }

    override Location getLocation() { result = location }

    InlineExpectationsTest getTest() { result = test }

    override string getTag() { result = tag }

    override string getValue() { result = value }

    predicate isOptional() { optional = true }
  }

  abstract private class Expectation extends FailureLocatable {
    ExpectationComment comment;

    override string toString() { result = comment.toString() }

    override Location getLocation() { result = comment.getLocation() }
  }

  private predicate onSameLine(ValidExpectation a, ActualResult b) {
    exists(string fname, int line, Location la, Location lb |
      // Join order intent:
      // Take the locations of ActualResults,
      // join with locations in the same file / on the same line,
      // then match those against ValidExpectations.
      la = a.getLocation() and
      pragma[only_bind_into](lb) = b.getLocation() and
      pragma[only_bind_into](la).hasLocationInfo(fname, line, _, _, _) and
      lb.hasLocationInfo(fname, _, _, line, _)
    )
  }

  private class ValidExpectation extends Expectation, TValidExpectation {
    string tag;
    string value;
    string knownFailure;

    ValidExpectation() { this = TValidExpectation(comment, tag, value, knownFailure) }

    override string getTag() { result = tag }

    override string getValue() { result = value }

    string getKnownFailure() { result = knownFailure }

    predicate matchesActualResult(ActualResult actualResult) {
      onSameLine(pragma[only_bind_into](this), actualResult) and
      this.getTag() = actualResult.getTag() and
      this.getValue() = actualResult.getValue()
    }
  }

  // Note: These next three classes correspond to all the possible values of type `TColumn`.
  class GoodExpectation extends ValidExpectation {
    GoodExpectation() { this.getKnownFailure() = "" }
  }

  class FalsePositiveExpectation extends ValidExpectation {
    FalsePositiveExpectation() { this.getKnownFailure() = "SPURIOUS" }
  }

  class FalseNegativeExpectation extends ValidExpectation {
    FalseNegativeExpectation() { this.getKnownFailure() = "MISSING" }
  }

  class InvalidExpectation extends Expectation, TInvalidExpectation {
    string expectation;

    InvalidExpectation() { this = TInvalidExpectation(comment, expectation) }

    string getExpectation() { result = expectation }
  }

  query predicate failures(FailureLocatable element, string message) {
    exists(InlineExpectationsTest test | test.hasFailureMessage(element, message))
  }
}
