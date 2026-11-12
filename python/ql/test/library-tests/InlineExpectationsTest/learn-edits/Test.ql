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
      name.getId() = ["target", "target_continuation"] and
      location = name.getLocation() and
      element = name.toString() and
      tag = "direct" and
      value = ""
    )
  }
}

private module Test = MakeTest<DirectTest>;

from string file, int line, string operation, int startColumn, int endColumn, string text
where Test::learnEdits(file, line, operation, startColumn, endColumn, text)
select file, line, operation, startColumn, endColumn, text
