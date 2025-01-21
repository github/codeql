/**
 * Provides a library for writing QL tests whose success or failure is based on expected results
 * embedded in the test source code as comments, rather than the contents of an `.expected` file
 * (in that the `.expected` file should always be empty).
 *
 * To add this framework to a new language, add a new file
 * (usually called `InlineExpectationsTest.qll`) with:
 * - `private import codeql.util.test.InlineExpectationsTest` (this file)
 * - An implementation of the signature in `InlineExpectationsTestSig`.
 *   Usually this is done in a module called `Impl`.
 *   `Impl` has to define a `Location` class, and an `ExpectationComment` class.
 *   The `ExpectationComment` class must support a `getContents` method that returns
 *   the contents of the given comment, _excluding_ the comment indicator itself.
 *   It should also define `toString` and `getLocation` as usual.
 * - `import Make<Impl>` to expose the query predicates constructed in the `Make` module.
 *
 * To create a new inline expectations test:
 * - Declare a module that implements `TestSig`, say `TestImpl`.
 * - Implement the `hasActualResult()` predicate to produce the actual results of the query.
 *   For each result, specify a `Location`, a text description of the element for which the
 *   result was reported, a short string to serve as the tag to identify expected results
 *   for this test, and the expected value of the result.
 * - Implement `getARelevantTag()` to return the set of tags that can be produced by
 *   `hasActualResult()`. Often this is just a single tag.
 * - `import MakeTest<TestImpl>` to ensure the test is evaluated.
 *
 * Example:
 * ```ql
 * module ConstantValueTest implements TestSig {
 *   string getARelevantTag() {
 *     // We only use one tag for this test.
 *     result = "const"
 *   }
 *
 *   predicate hasActualResult(
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
 *
 * import MakeTest<ConstantValueTest>
 * ```
 *
 * There is no need to write a `select` clause or query predicate. All of the differences between
 * expected results and actual results will be reported in the `testFailures()` query predicate.
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
 * A signature specifying the required parts for constructing inline expectations.
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
 * Module implementing inline expectations.
 */
module Make<InlineExpectationsTestSig Impl> {
  /**
   * A signature specifying the required parts of an inline expectation test.
   */
  signature module TestSig {
    /**
     * Returns all tags that can be generated by this test. Most tests will only ever produce a single
     * tag. Any expected result comments for a tag that is not returned by the `getARelevantTag()`
     * predicate for an active test will be ignored. This makes it possible to write multiple tests in
     * different `.ql` files that all query the same source code.
     */
    bindingset[result]
    string getARelevantTag();

    /**
     * Holds if expected tag `expectedTag` matches actual tag `actualTag`.
     *
     * This is normally defined as `expectedTag = actualTag`.
     */
    bindingset[expectedTag, actualTag]
    default predicate tagMatches(string expectedTag, string actualTag) { expectedTag = actualTag }

    /** Holds if expectations marked with `expectedTag` are optional. */
    bindingset[expectedTag]
    default predicate tagIsOptional(string expectedTag) { none() }

    /**
     * Holds if expected value `expectedValue` matches actual value `actualValue`.
     *
     * This is normally defined as `expectedValue = actualValue`.
     */
    bindingset[expectedValue, actualValue]
    default predicate valueMatches(string expectedValue, string actualValue) {
      expectedValue = actualValue
    }

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
    predicate hasActualResult(Impl::Location location, string element, string tag, string value);

    /**
     * Holds if there is an optional result on the specified location.
     *
     * This is similar to `hasActualResult`, but returns results that do not require a matching annotation.
     * A failure will still arise if there is an annotation that does not match any results, but not vice versa.
     * Override this predicate to specify optional results.
     */
    default predicate hasOptionalResult(
      Impl::Location location, string element, string tag, string value
    ) {
      none()
    }
  }

  /**
   * The module for tests with inline expectations. The test implements the signature to provide
   * the actual results of the query, which are then compared with the expected results in comments
   * to produce a list of failure messages that point out where the actual results differ from
   * the expected results.
   */
  module MakeTest<TestSig TestImpl> {
    private predicate hasFailureMessage(FailureLocatable element, string message) {
      exists(ActualTestResult actualResult |
        actualResult.getTag() = TestImpl::getARelevantTag() and
        element = actualResult and
        (
          exists(FalseNegativeTestExpectation falseNegative |
            falseNegative.matchesActualResult(actualResult) and
            message = "Fixed missing result: " + falseNegative.getExpectationText()
          )
          or
          not exists(ValidTestExpectation expectation |
            expectation.matchesActualResult(actualResult)
          ) and
          message = "Unexpected result: " + actualResult.getExpectationText() and
          not actualResult.isOptional()
        )
      )
      or
      exists(ActualTestResult actualResult |
        not actualResult.getTag() = TestImpl::getARelevantTag() and
        element = actualResult and
        message =
          "Tag mismatch: Actual result with tag '" + actualResult.getTag() +
            "' that is not part of getARelevantTag()"
      )
      or
      exists(ValidTestExpectation expectation |
        not exists(ActualTestResult actualResult | expectation.matchesActualResult(actualResult)) and
        expectation.getTag() = TestImpl::getARelevantTag() and
        element = expectation and
        not expectation.isOptional()
      |
        expectation instanceof GoodTestExpectation and
        message = "Missing result: " + expectation.getExpectationText()
        or
        expectation instanceof FalsePositiveTestExpectation and
        message = "Fixed spurious result: " + expectation.getExpectationText()
      )
      or
      exists(InvalidTestExpectation expectation |
        element = expectation and
        message = "Invalid expectation syntax: " + expectation.getExpectation()
      )
    }

    private newtype TFailureLocatable =
      TActualResult(
        Impl::Location location, string element, string tag, string value, boolean optional
      ) {
        TestImpl::hasActualResult(location, element, tag, value) and optional = false
        or
        TestImpl::hasOptionalResult(location, element, tag, value) and optional = true
      } or
      TValidExpectation(
        Impl::ExpectationComment comment, string tag, string value, string knownFailure
      ) {
        exists(TColumn column, string tags |
          getAnExpectation(comment, column, _, tags, value) and
          tag = tags.splitAt(",") and
          knownFailure = getColumnString(column)
        )
      } or
      TInvalidExpectation(Impl::ExpectationComment comment, string expectation) {
        getAnExpectation(comment, _, expectation, _, _) and
        not expectation.regexpMatch(expectationPattern())
      }

    class FailureLocatable extends TFailureLocatable {
      string toString() { none() }

      Impl::Location getLocation() { none() }

      final string getExpectationText() {
        exists(string suffix |
          if this.getValue() = "" then suffix = "" else suffix = "=" + this.getValue()
        |
          result = this.getTag() + suffix
        )
      }

      string getTag() { none() }

      string getValue() { none() }
    }

    class ActualTestResult extends FailureLocatable, TActualResult {
      Impl::Location location;
      string element;
      string tag;
      string value;
      boolean optional;

      ActualTestResult() { this = TActualResult(location, element, tag, value, optional) }

      override string toString() { result = element }

      override Impl::Location getLocation() { result = location }

      override string getTag() { result = tag }

      override string getValue() { result = value }

      predicate isOptional() { optional = true }
    }

    abstract private class Expectation extends FailureLocatable {
      Impl::ExpectationComment comment;

      override string toString() { result = comment.toString() }

      override Impl::Location getLocation() { result = comment.getLocation() }
    }

    private predicate onSameLine(ValidTestExpectation a, ActualTestResult b) {
      exists(string fname, int line, Impl::Location la, Impl::Location lb |
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

    private class ValidTestExpectation extends Expectation, TValidExpectation {
      string tag;
      string value;
      string knownFailure;

      ValidTestExpectation() { this = TValidExpectation(comment, tag, value, knownFailure) }

      override string getTag() { result = tag }

      override string getValue() { result = value }

      string getKnownFailure() { result = knownFailure }

      predicate matchesActualResult(ActualTestResult actualResult) {
        onSameLine(pragma[only_bind_into](this), actualResult) and
        TestImpl::tagMatches(this.getTag(), actualResult.getTag()) and
        TestImpl::valueMatches(this.getValue(), actualResult.getValue())
      }

      predicate isOptional() { TestImpl::tagIsOptional(tag) }
    }

    // Note: These next three classes correspond to all the possible values of type `TColumn`.
    class GoodTestExpectation extends ValidTestExpectation {
      GoodTestExpectation() { this.getKnownFailure() = "" }
    }

    class FalsePositiveTestExpectation extends ValidTestExpectation {
      FalsePositiveTestExpectation() { this.getKnownFailure() = "SPURIOUS" }
    }

    class FalseNegativeTestExpectation extends ValidTestExpectation {
      FalseNegativeTestExpectation() { this.getKnownFailure() = "MISSING" }
    }

    class InvalidTestExpectation extends Expectation, TInvalidExpectation {
      string expectation;

      InvalidTestExpectation() { this = TInvalidExpectation(comment, expectation) }

      string getExpectation() { result = expectation }
    }

    /**
     * Gets a test expectation that matches the actual result at the given location.
     */
    ValidTestExpectation getAMatchingExpectation(
      Impl::Location location, string element, string tag, string val, boolean optional
    ) {
      exists(ActualTestResult actualResult |
        result.matchesActualResult(actualResult) and
        actualResult = TActualResult(location, element, tag, val, optional)
      )
    }

    query predicate testFailures(FailureLocatable element, string message) {
      hasFailureMessage(element, message)
    }
  }

  private predicate getAnExpectation(
    Impl::ExpectationComment comment, TColumn column, string expectation, string tags, string value
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

  /**
   * A module that merges two test signatures.
   *
   * This module can be used when multiple inline expectation tests occur in a single file. For example:
   * ```ql
   * module Test1 implements TestSig {
   *  ...
   * }
   *
   * module Test2 implements TestSig {
   *   ...
   * }
   *
   * import MakeTest<MergeTests<Test1, Test2>>
   * ```
   */
  module MergeTests<TestSig TestImpl1, TestSig TestImpl2> implements TestSig {
    bindingset[result]
    string getARelevantTag() {
      result = TestImpl1::getARelevantTag() or result = TestImpl2::getARelevantTag()
    }

    predicate hasActualResult(Impl::Location location, string element, string tag, string value) {
      TestImpl1::hasActualResult(location, element, tag, value)
      or
      TestImpl2::hasActualResult(location, element, tag, value)
    }

    predicate hasOptionalResult(Impl::Location location, string element, string tag, string value) {
      TestImpl1::hasOptionalResult(location, element, tag, value)
      or
      TestImpl2::hasOptionalResult(location, element, tag, value)
    }
  }

  /**
   * A module that merges three test signatures.
   */
  module MergeTests3<TestSig TestImpl1, TestSig TestImpl2, TestSig TestImpl3> implements TestSig {
    private module M = MergeTests<MergeTests<TestImpl1, TestImpl2>, TestImpl3>;

    bindingset[result]
    string getARelevantTag() { result = M::getARelevantTag() }

    predicate hasActualResult(Impl::Location location, string element, string tag, string value) {
      M::hasActualResult(location, element, tag, value)
    }

    predicate hasOptionalResult(Impl::Location location, string element, string tag, string value) {
      M::hasOptionalResult(location, element, tag, value)
    }
  }

  /**
   * A module that merges four test signatures.
   */
  module MergeTests4<TestSig TestImpl1, TestSig TestImpl2, TestSig TestImpl3, TestSig TestImpl4>
    implements TestSig
  {
    private module M = MergeTests<MergeTests3<TestImpl1, TestImpl2, TestImpl3>, TestImpl4>;

    bindingset[result]
    string getARelevantTag() { result = M::getARelevantTag() }

    predicate hasActualResult(Impl::Location location, string element, string tag, string value) {
      M::hasActualResult(location, element, tag, value)
    }

    predicate hasOptionalResult(Impl::Location location, string element, string tag, string value) {
      M::hasOptionalResult(location, element, tag, value)
    }
  }

  /**
   * A module that merges five test signatures.
   */
  module MergeTests5<
    TestSig TestImpl1, TestSig TestImpl2, TestSig TestImpl3, TestSig TestImpl4, TestSig TestImpl5>
    implements TestSig
  {
    private module M =
      MergeTests<MergeTests4<TestImpl1, TestImpl2, TestImpl3, TestImpl4>, TestImpl5>;

    bindingset[result]
    string getARelevantTag() { result = M::getARelevantTag() }

    predicate hasActualResult(Impl::Location location, string element, string tag, string value) {
      M::hasActualResult(location, element, tag, value)
    }

    predicate hasOptionalResult(Impl::Location location, string element, string tag, string value) {
      M::hasOptionalResult(location, element, tag, value)
    }
  }

  /**
   * Holds if the expectation `tag=value` is found in one or more expectation comments.
   *
   * This can be used when writing tests where the set of possible values must be known in advance,
   * for example, when testing a predicate for which `value` is part of the binding set.
   */
  predicate hasExpectationWithValue(string tag, string value) {
    exists(string tags |
      getAnExpectation(_, _, _, tags, value) and
      tag = tags.splitAt(",")
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
 * column in a comment. This column is not preceded by a name. `TNamedColumn(name)` represents a
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

/** Gets the string `#select` or `problems`, which are equivalent result sets for a `problem` or `path-problem` query. */
private string mainResultSet() { result = ["#select", "problems"] }

/**
 * Provides logic for creating a `@kind test-postprocess` query that checks
 * inline test expectations using `$ Alert` markers.
 *
 * The postprocessing query works for queries of kind `problem` and `path-problem`,
 * and each query result must have a matching `$ Alert` comment. It is possible to
 * augment the comment with a query ID, in order to support cases where multiple
 * `.qlref` tests share the same test code:
 *
 * ```rust
 * var x = ""; // $ Alert[rust/unused-value]
 * return;
 * foo();      // $ Alert[rust/unreachable-code]
 * ```
 *
 * In the example above, the `$ Alert[rust/unused-value]` commment is only taken
 * into account in the test for the query with ID `rust/unused-value`, and vice
 * versa for the `$ Alert[rust/unreachable-code]` comment.
 *
 * For `path-problem` queries, each source and sink must additionally be annotated
 * (`$ Source` and `$ Sink`, respectively), except when their location coincides
 * with the location of the alert itself, in which case only `$ Alert` is needed.
 *
 * Example:
 *
 * ```csharp
 * var queryParam = Request.QueryString["param"]; // $ Source
 * Write(Html.Raw(queryParam));                   // $ Alert
 * ```
 *
 * Morover, it is possible to tag sources with a unique identifier:
 *
 * ```csharp
 * var queryParam = Request.QueryString["param"]; // $ Source=source1
 * Write(Html.Raw(queryParam));                   // $ Alert=source1
 * ```
 *
 * In this case, the source and sink must have the same tag in order
 * to be matched.
 */
module TestPostProcessing {
  external predicate queryResults(string relation, int row, int column, string data);

  external predicate queryRelations(string relation);

  external predicate queryMetadata(string key, string value);

  private string getQueryId() { queryMetadata("id", result) }

  private string getQueryKind() { queryMetadata("kind", result) }

  signature module InputSig<InlineExpectationsTestSig Input> {
    string getRelativeUrl(Input::Location location);
  }

  module Make<InlineExpectationsTestSig Input, InputSig<Input> Input2> {
    private import InlineExpectationsTest as InlineExpectationsTest
    private import InlineExpectationsTest::Make<Input>

    /**
     * Gets the tag to be used for the path-problem source at result row `row`.
     *
     * This is either `Source` or `Alert`, depending on whether the location
     * of the source matches the location of the alert.
     */
    private string getSourceTag(int row) {
      getQueryKind() = "path-problem" and
      exists(string loc | queryResults(mainResultSet(), row, 2, loc) |
        if queryResults(mainResultSet(), row, 0, loc) then result = "Alert" else result = "Source"
      )
    }

    /**
     * Gets the tag to be used for the path-problem sink at result row `row`.
     *
     * This is either `Sink` or `Alert`, depending on whether the location
     * of the sink matches the location of the alert.
     */
    private string getSinkTag(int row) {
      getQueryKind() = "path-problem" and
      exists(string loc | queryResults(mainResultSet(), row, 4, loc) |
        if queryResults(mainResultSet(), row, 0, loc) then result = "Alert" else result = "Sink"
      )
    }

    private string getTagRegex() {
      exists(string sourceSinkTags |
        (
          getQueryKind() = "problem"
          or
          not exists(getSourceTag(_)) and
          not exists(getSinkTag(_))
        ) and
        sourceSinkTags = ""
        or
        sourceSinkTags = "|" + getSourceTag(_) + "|" + getSinkTag(_)
      |
        result = "(Alert" + sourceSinkTags + ")(\\[(.*)\\])?"
      )
    }

    /**
     * A configuration for matching `// $ Source=foo` comments against actual
     * path-problem sources.
     *
     * Whenever a source is tagged with a value, like `foo`, we will use that
     * to define the expected tags at the sink and the alert.
     */
    private module PathProblemSourceTestInput implements TestSig {
      string getARelevantTag() { result = getSourceTag(_) }

      bindingset[expectedTag, actualTag]
      predicate tagMatches(string expectedTag, string actualTag) {
        actualTag = expectedTag.regexpCapture(getTagRegex(), 1) and
        (
          // expected tag is annotated with a query ID
          getQueryId() = expectedTag.regexpCapture(getTagRegex(), 3)
          or
          // expected tag is not annotated with a query ID
          not exists(expectedTag.regexpCapture(getTagRegex(), 3))
        )
      }

      bindingset[expectedValue, actualValue]
      predicate valueMatches(string expectedValue, string actualValue) {
        exists(expectedValue) and
        actualValue = ""
      }

      additional predicate hasPathProblemSource(
        int row, Input::Location location, string element, string tag, string value
      ) {
        getQueryKind() = "path-problem" and
        exists(string loc |
          queryResults(mainResultSet(), row, 2, loc) and
          queryResults(mainResultSet(), row, 3, element) and
          tag = getSourceTag(row) and
          value = "" and
          Input2::getRelativeUrl(location) = loc
        )
      }

      predicate hasActualResult(Input::Location location, string element, string tag, string value) {
        hasPathProblemSource(_, location, element, tag, value)
      }
    }

    private module PathProblemSourceTest = MakeTest<PathProblemSourceTestInput>;

    private module TestInput implements TestSig {
      bindingset[result]
      string getARelevantTag() { any() }

      predicate tagMatches = PathProblemSourceTestInput::tagMatches/2;

      bindingset[expectedTag]
      predicate tagIsOptional(string expectedTag) {
        // ignore irrelevant tags
        not expectedTag.regexpMatch(getTagRegex())
        or
        // ignore tags annotated with a query ID that does not match the current query ID
        exists(string queryId |
          queryId = expectedTag.regexpCapture(getTagRegex(), 3) and
          queryId != getQueryId()
        )
      }

      private predicate hasPathProblemSource = PathProblemSourceTestInput::hasPathProblemSource/5;

      private predicate hasPathProblemSink(
        int row, Input::Location location, string element, string tag
      ) {
        getQueryKind() = "path-problem" and
        exists(string loc |
          queryResults(mainResultSet(), row, 4, loc) and
          queryResults(mainResultSet(), row, 5, element) and
          tag = getSinkTag(row) and
          Input2::getRelativeUrl(location) = loc
        )
      }

      private predicate hasAlert(int row, Input::Location location, string element, string tag) {
        getQueryKind() = ["problem", "path-problem"] and
        exists(string loc |
          queryResults(mainResultSet(), row, 0, loc) and
          queryResults(mainResultSet(), row, 2, element) and
          tag = "Alert" and
          Input2::getRelativeUrl(location) = loc and
          not hasPathProblemSource(row, location, _, _, _) and
          not hasPathProblemSink(row, location, _, _)
        )
      }

      /**
       * Gets the expected value for result row `row`, if any. This value must
       * match the value at the corresponding path-problem source (if it is
       * present).
       */
      private string getValue(int row) {
        exists(Input::Location location, string element, string tag, string val |
          hasPathProblemSource(row, location, element, tag, val) and
          result =
            PathProblemSourceTest::getAMatchingExpectation(location, element, tag, val, false)
                .getValue()
        )
      }

      predicate hasActualResult(Input::Location location, string element, string tag, string value) {
        exists(int row |
          hasPathProblemSource(row, location, element, tag, _)
          or
          hasPathProblemSink(row, location, element, tag)
          or
          hasAlert(row, location, element, tag)
        |
          not exists(getValue(row)) and value = ""
          or
          value = getValue(row)
        )
      }
    }

    private module Test = MakeTest<TestInput>;

    private newtype TTestFailure =
      MkTestFailure(Test::FailureLocatable f, string message) { Test::testFailures(f, message) }

    private predicate rankedTestFailures(int i, MkTestFailure f) {
      f =
        rank[i](MkTestFailure f0, Test::FailureLocatable fl, string message, string filename,
          int startLine, int startColumn, int endLine, int endColumn |
          f0 = MkTestFailure(fl, message) and
          fl.getLocation().hasLocationInfo(filename, startLine, startColumn, endLine, endColumn)
        |
          f0 order by filename, startLine, startColumn, endLine, endColumn, message
        )
    }

    query predicate results(string relation, int row, int column, string data) {
      queryResults(relation, row, column, data)
      or
      exists(MkTestFailure f, Test::FailureLocatable fl, string message |
        relation = "testFailures" and
        rankedTestFailures(row, f) and
        f = MkTestFailure(fl, message)
      |
        column = 0 and data = Input2::getRelativeUrl(fl.getLocation())
        or
        column = 1 and data = fl.toString()
        or
        column = 2 and data = message
      )
    }

    query predicate resultRelations(string relation) {
      queryRelations(relation)
      or
      Test::testFailures(_, _) and
      relation = "testFailures"
    }
  }
}
