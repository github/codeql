import java
import semmle.code.java.security.ImplicitlyExportedAndroidComponent
import TestUtilities.InlineExpectationsTest

class ImplicitlyExportedAndroidComponentTest extends InlineExpectationsTest {
  ImplicitlyExportedAndroidComponentTest() { this = "ImplicitlyExportedAndroidComponentTest" }

  override string getARelevantTag() { result = "hasImplicitExport" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasImplicitExport" and
    exists(ImplicitlyExportedAndroidComponent impExpAndroidComp |
      impExpAndroidComp.getLocation() = location and
      element = impExpAndroidComp.toString() and
      value = ""
    )
  }
}
