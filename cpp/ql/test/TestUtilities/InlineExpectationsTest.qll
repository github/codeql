import cpp

abstract class InlineExpectationsTest extends string {
  bindingset[this]
  InlineExpectationsTest() {
    any()
  }

  abstract string getARelevantTag();

  abstract predicate hasActualResult(Location location, string element, string tag, string value);

  final predicate hasFailureMessage(FailureLocatable element, string message) {
    exists(ActualResult actualResult |
      actualResult.getTest() = this and
      element = actualResult and
      (
        exists(FalseNegativeExpectation falseNegative |
          falseNegative.matchesActualResult(actualResult) and
          message = "Fixed false negative:" + falseNegative.getExpectationText()
        ) or
        (
          not exists(ValidExpectation expectation |
            expectation.matchesActualResult(actualResult)
          ) and
          message = "Unexpected result: " + actualResult.getExpectationText()
        )
      )
    ) or
    exists(ValidExpectation expectation |
      not exists(ActualResult actualResult |
        expectation.matchesActualResult(actualResult)
      ) and
      expectation.getTag() = getARelevantTag() and
      element = expectation and
      (
        (
          expectation instanceof GoodExpectation and
          message = "Missing result:" + expectation.getExpectationText()
        ) or
        (
          expectation instanceof FalsePositiveExpectation and
          message = "Fixed false positive:" + expectation.getExpectationText()
        )
      )
    ) or
    exists(InvalidExpectation expectation |
      element = expectation and
      message = "Invalid expectation syntax: " + expectation.getExpectation()
    )
  }
}

private string expectationCommentPattern() {
  result = "//\\s*(\\$(?:[^/]|/[^/])*)(?://.*)?"
}

private string expectationPattern() {
  result = "(?:(f(?:\\+|-)):)?((?:[A-Za-z-_]+)(?:\\s*,\\s*[A-Za-z-_]+)*)(?:=(.*))?"
}

private string getAnExpectation(CppStyleComment comment) {
  result = comment.getContents().regexpCapture(expectationCommentPattern(), 1).splitAt("$").trim() and
  result != ""
}

private newtype TFailureLocatable =
  TActualResult(InlineExpectationsTest test, Location location, string element, string tag, string value) {
    test.hasActualResult(location, element, tag, value)
  } or
  TValidExpectation(CppStyleComment comment, string tag, string value, string knownFailure) {
    exists(string expectation |
      expectation = getAnExpectation(comment) and
      expectation.regexpMatch(expectationPattern()) and
      tag = expectation.regexpCapture(expectationPattern(), 2).splitAt(",").trim() and
      (
        if exists(expectation.regexpCapture(expectationPattern(), 3)) then
          value = expectation.regexpCapture(expectationPattern(), 3)
        else
          value = ""
      ) and
      (
        if exists(expectation.regexpCapture(expectationPattern(), 1)) then
          knownFailure = expectation.regexpCapture(expectationPattern(), 1)
        else
          knownFailure = ""
      )
    )
  } or
  TInvalidExpectation(CppStyleComment comment, string expectation) {
    expectation = getAnExpectation(comment) and
    not expectation.regexpMatch(expectationPattern())
  }

class FailureLocatable extends TFailureLocatable {
  string toString() {
    none()
  }

  Location getLocation() {
    none()
  }

  final string getExpectationText() {
    result = getTag() + "=" + getValue()
  }

  string getTag() {
    none()
  }

  string getValue() {
    none()
  }
}

class ActualResult extends FailureLocatable, TActualResult {
  InlineExpectationsTest test;
  Location location;
  string element;
  string tag;
  string value;

  ActualResult() {
    this = TActualResult(test, location, element, tag, value)
  }

  override string toString() {
    result = element
  }

  override Location getLocation() {
    result = location
  }

  InlineExpectationsTest getTest() {
    result = test
  }

  override string getTag() {
    result = tag
  }

  override string getValue() {
    result = value
  }
}

private abstract class Expectation extends FailureLocatable {
  CppStyleComment comment;

  override string toString() {
    result = comment.toString()
  }

  override Location getLocation() {
    result = comment.getLocation()
  }
}

private class ValidExpectation extends Expectation, TValidExpectation {
  string tag;
  string value;
  string knownFailure;

  ValidExpectation() {
    this = TValidExpectation(comment, tag, value, knownFailure)
  }

  override string getTag() {
    result = tag
  }

  override string getValue() {
    result = value
  }

  string getKnownFailure() {
    result = knownFailure
  }

  predicate matchesActualResult(ActualResult actualResult) {
    getLocation().getStartLine() = actualResult.getLocation().getStartLine() and
    getLocation().getFile() = actualResult.getLocation().getFile() and
    getTag() = actualResult.getTag() and
    getValue() = actualResult.getValue()
  }
}

class GoodExpectation extends ValidExpectation {
  GoodExpectation() {
    getKnownFailure() = ""
  }
}

class FalsePositiveExpectation extends ValidExpectation {
  FalsePositiveExpectation() {
    getKnownFailure() = "f+"
  }
}

class FalseNegativeExpectation extends ValidExpectation {
  FalseNegativeExpectation() {
    getKnownFailure() = "f-"
  }
}

class InvalidExpectation extends Expectation, TInvalidExpectation {
  string expectation;

  InvalidExpectation() {
    this = TInvalidExpectation(comment, expectation)
  }

  string getExpectation() {
    result = expectation
  }
}

query predicate failures(FailureLocatable element, string message) {
  exists(InlineExpectationsTest test |
    test.hasFailureMessage(element, message)
  )
}
