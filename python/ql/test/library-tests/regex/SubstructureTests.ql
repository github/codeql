import python
import TestUtilities.InlineExpectationsTest
private import semmle.python.regex

class CharacterSetTest extends InlineExpectationsTest {
  CharacterSetTest() { this = "CharacterSetTest" }

  override string getARelevantTag() { result = "charSet" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    location.getFile().getBaseName() = "charSetTest.py" and
    exists(Regex re, int start, int end |
      re.charSet(start, end) and
      location = re.getLocation() and
      element = re.toString().substring(start, end) and
      value = start + ":" + end and
      tag = "charSet"
    )
  }
}
