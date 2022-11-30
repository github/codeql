import java
import semmle.code.xml.AndroidManifest
import TestUtilities.InlineExpectationsTest

class ContentProviderIncompletePermissionsTest extends InlineExpectationsTest {
  ContentProviderIncompletePermissionsTest() { this = "ContentProviderIncompletePermissionsTest" }

  override string getARelevantTag() { result = "hasIncompletePermissions" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
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
