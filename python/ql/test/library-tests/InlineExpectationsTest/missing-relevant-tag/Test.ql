// test to illustrate what happens if you forget to put in the
// right values for `getARelevantTag`. We want to alert on this,
// so it gets fixed!
import python
import TestUtilities.InlineExpectationsTest

class MissingRelevantTag extends InlineExpectationsTest {
  MissingRelevantTag() { this = "MissingRelevantTag" }

  override string getARelevantTag() { none() }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Name name | name.getId() = "foo" |
      location = name.getLocation() and
      element = name.toString() and
      value = "val" and
      tag = "foo"
    )
  }
}
