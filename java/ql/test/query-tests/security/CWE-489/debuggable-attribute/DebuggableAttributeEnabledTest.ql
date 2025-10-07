import java
import semmle.code.xml.AndroidManifest
import utils.test.InlineExpectationsTest

module DebuggableAttributeEnabledTest implements TestSig {
  string getARelevantTag() { result = "hasDebuggableAttributeEnabled" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
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

import MakeTest<DebuggableAttributeEnabledTest>
