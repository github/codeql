import python
import utils.test.InlineExpectationsTest
private import semmle.python.regex

module CharacterSetTest implements TestSig {
  string getARelevantTag() { result = "charSet" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    location.getFile().getBaseName() = "charSetTest.py" and
    exists(RegExp re, int start, int end |
      re.charSet(start, end) and
      location = re.getLocation() and
      element = re.getText().substring(start, end) and
      value = start + ":" + end and
      tag = "charSet"
    )
  }
}

module CharacterRangeTest implements TestSig {
  string getARelevantTag() { result = "charRange" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    location.getFile().getBaseName() = "charRangeTest.py" and
    exists(RegExp re, int start, int lower_end, int upper_start, int end |
      re.charRange(_, start, lower_end, upper_start, end) and
      location = re.getLocation() and
      element = re.getText().substring(start, end) and
      value = start + ":" + lower_end + "-" + upper_start + ":" + end and
      tag = "charRange"
    )
  }
}

module EscapeTest implements TestSig {
  string getARelevantTag() { result = "escapedCharacter" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    location.getFile().getBaseName() = "escapedCharacterTest.py" and
    exists(RegExp re, int start, int end |
      re.escapedCharacter(start, end) and
      location = re.getLocation() and
      element = re.getText().substring(start, end) and
      value = start + ":" + end and
      tag = "escapedCharacter"
    )
  }
}

module GroupTest implements TestSig {
  string getARelevantTag() { result = "group" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    location.getFile().getBaseName() = "groupTest.py" and
    exists(RegExp re, int start, int end |
      re.group(start, end) and
      location = re.getLocation() and
      element = re.getText().substring(start, end) and
      value = start + ":" + end and
      tag = "group"
    )
  }
}

import MakeTest<MergeTests4<CharacterSetTest, CharacterRangeTest, EscapeTest, GroupTest>>
