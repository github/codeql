import java
import semmle.code.xml.AndroidManifest
import TestUtilities.InlineExpectationsTest

class ImplicitlyExportedAndroidComponentTest extends InlineExpectationsTest {
  ImplicitlyExportedAndroidComponentTest() { this = "ImplicitlyExportedAndroidComponentTest" }

  override string getARelevantTag() { result = "hasImplicitExport" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasImplicitExport" and
    exists(AndroidComponentXmlElement compElem, AndroidIntentFilterXmlElement intFiltElem |
      not compElem.hasAttribute("exported") and
      //compElem.getAnIntentFilterElement() instanceof AndroidIntentFilterXmlElement
      not intFiltElem.getParent() = compElem
    |
      compElem.getLocation() = location and
      element = compElem.toString() and
      value = ""
    )
  }
}
