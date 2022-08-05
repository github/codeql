import java
import semmle.code.xml.AndroidManifest
import TestUtilities.InlineExpectationsTest

class ImplicitlyExportedAndroidComponentTest extends InlineExpectationsTest {
  ImplicitlyExportedAndroidComponentTest() { this = "ImplicitlyExportedAndroidComponentTest" }

  override string getARelevantTag() { result = "hasImplicitExport" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasImplicitExport" and
    exists(AndroidComponentXmlElement compElement | compElement.isImplicitlyExported() |
      compElement.getLocation() = location and
      element = compElement.toString() and
      value = ""
    )
  }
}
