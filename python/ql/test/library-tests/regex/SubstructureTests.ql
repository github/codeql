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
      element = re.getText().substring(start, end) and
      value = start + ":" + end and
      tag = "charSet"
    )
  }
}

class CharacterRangeTest extends InlineExpectationsTest {
  CharacterRangeTest() { this = "CharacterRangeTest" }

  override string getARelevantTag() { result = "charRange" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    location.getFile().getBaseName() = "charRangeTest.py" and
    exists(Regex re, int start, int lower_end, int upper_start, int end |
      re.charRange(_, start, lower_end, upper_start, end) and
      location = re.getLocation() and
      element = re.getText().substring(start, end) and
      value = start + ":" + lower_end + "-" + upper_start + ":" + end and
      tag = "charRange"
    )
  }
}

class EscapeTest extends InlineExpectationsTest {
  EscapeTest() { this = "EscapeTest" }

  override string getARelevantTag() { result = "escapedCharacter" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    location.getFile().getBaseName() = "escapedCharacterTest.py" and
    exists(Regex re, int start, int end |
      re.escapedCharacter(start, end) and
      location = re.getLocation() and
      element = re.getText().substring(start, end) and
      value = start + ":" + end and
      tag = "escapedCharacter"
    )
  }
}

class GroupTest extends InlineExpectationsTest {
  GroupTest() { this = "GroupTest" }

  override string getARelevantTag() { result = "group" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    location.getFile().getBaseName() = "groupTest.py" and
    exists(Regex re, int start, int end |
      re.group(start, end) and
      location = re.getLocation() and
      element = re.getText().substring(start, end) and
      value = start + ":" + end and
      tag = "group"
    )
  }
}
