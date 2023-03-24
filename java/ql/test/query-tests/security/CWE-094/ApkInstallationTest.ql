import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.ArbitraryApkInstallationQuery
import TestUtilities.InlineExpectationsTest

class HasApkInstallationTest extends InlineExpectationsTest {
  HasApkInstallationTest() { this = "HasApkInstallationTest" }

  override string getARelevantTag() { result = "hasApkInstallation" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasApkInstallation" and
    exists(DataFlow::Node sink | ApkInstallationFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
