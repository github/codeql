import java
import semmle.code.xml.AndroidManifest
import TestUtilities.InlineExpectationsTest

class DebuggableAttributeTrueTest extends InlineExpectationsTest {
  DebuggableAttributeTrueTest() { this = "DebuggableAttributeEnabledTest" }

  override string getARelevantTag() { result = "hasDebuggableAttributeEnabled" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasDebuggableAttributeEnabled" and
    exists(AndroidXmlAttribute androidXmlAttr |
      androidXmlAttr.getName() = "debuggable" and
      androidXmlAttr.getValue() = "true" and
      not androidXmlAttr.getLocation().getFile().getRelativePath().matches("%/build%")
    |
      androidXmlAttr.getLocation() = location and
      element = androidXmlAttr.toString() and
      value = ""
    )
  }
}
