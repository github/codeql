import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.regexp.ExponentialBackTracking
import semmle.code.java.regex.regex

class HasExpRedos extends InlineExpectationsTest {
  HasExpRedos() { this = "HasExpRedos" }

  override string getARelevantTag() { result = ["hasExpRedos", "hasParseFailure"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasExpRedos" and
    exists(RegExpTerm t, string pump, State s, string prefixMsg |
      hasReDoSResult(t, pump, s, prefixMsg) and
      not t.getRegex().getAMode() = "VERBOSE" and
      value = "" and
      location = t.getLocation() and
      element = t.toString()
    )
    or
    tag = "hasParseFailure" and
    exists(Regex r |
      r.failedToParse(_) and
      value = "" and
      location = r.getLocation() and
      element = r.toString()
    )
  }
}
