import java
import semmle.code.java.security.ImplicitlyExportedAndroidComponent
import utils.test.InlineExpectationsTest

module ImplicitlyExportedAndroidComponentTest implements TestSig {
  string getARelevantTag() { result = "hasImplicitExport" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasImplicitExport" and
    exists(ImplicitlyExportedAndroidComponent impExpAndroidComp |
      impExpAndroidComp.getLocation() = location and
      element = impExpAndroidComp.toString() and
      value = ""
    )
  }
}

import MakeTest<ImplicitlyExportedAndroidComponentTest>
