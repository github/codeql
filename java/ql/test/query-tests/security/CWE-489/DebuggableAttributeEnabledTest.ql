import java
import semmle.code.xml.AndroidManifest
import TestUtilities.InlineExpectationsTest

class DebuggableAttributeEnabledTest extends InlineExpectationsTest {
  DebuggableAttributeEnabledTest() { this = "DebuggableAttributeEnabledTest" }

  override string getARelevantTag() { result = "hasDebuggableAttributeEnabled" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasDebuggableAttributeEnabled" and
    exists(AndroidApplicationXmlElement androidAppElem |
      androidAppElem.isDebuggable() and
      not androidAppElem.getFile().(AndroidManifestXmlFile).isInBuildDirectory()
    |
      androidAppElem.getAttribute("debuggable").getLocation() = location and
      element = androidAppElem.getAttribute("debuggable").toString() and
      value = ""
    )
  }
}
