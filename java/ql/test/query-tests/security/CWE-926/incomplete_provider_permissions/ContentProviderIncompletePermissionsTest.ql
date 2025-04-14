import java
import semmle.code.xml.AndroidManifest
import utils.test.InlineExpectationsTest

module ContentProviderIncompletePermissionsTest implements TestSig {
  string getARelevantTag() { result = "hasIncompletePermissions" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasIncompletePermissions" and
    exists(AndroidProviderXmlElement provider |
      provider.getLocation() = location and
      provider.toString() = element and
      value = ""
    |
      not provider.getFile().(AndroidManifestXmlFile).isInBuildDirectory() and
      provider.hasIncompletePermissions() and
      provider.isExported()
    )
  }
}

import MakeTest<ContentProviderIncompletePermissionsTest>
