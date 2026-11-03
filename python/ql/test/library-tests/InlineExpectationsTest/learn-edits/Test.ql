import python
import utils.test.InlineExpectationsTest

module DirectTest implements TestSig {
  string getARelevantTag() { result = "direct" }

  string getARelevantExpectedTag() { result = ["direct", "direct[alias]"] }

  bindingset[expectedTag, actualTag]
  predicate tagMatches(string expectedTag, string actualTag) {
    expectedTag = ["direct", "direct[alias]"] and actualTag = "direct"
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Name name |
      name.getId() = "target" and
      location = name.getLocation() and
      element = name.toString() and
      tag = "direct" and
      value = ""
    )
  }
}

import MakeTest<DirectTest>
