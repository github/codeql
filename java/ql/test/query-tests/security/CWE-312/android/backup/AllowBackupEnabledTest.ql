import java
import semmle.code.xml.AndroidManifest
import TestUtilities.InlineExpectationsTest

class AllowBackupEnabledTest extends InlineExpectationsTest {
  AllowBackupEnabledTest() { this = "AllowBackupEnabledTest" }

  override string getARelevantTag() { result = "hasAllowBackupEnabled" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasAllowedBackupEnabled" and
    exists(AndroidApplicationXmlElement androidAppElem |
      androidAppElem.allowsBackup()
    |
      androidAppElem.getAttribute("allowBackup").getLocation() = location and
      element = androidAppElem.getAttribute("debuggable").toString() and
      value = ""
    )
  }
}
