import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.ArbitraryApkInstallationQuery
import utils.test.InlineExpectationsTest

module HasApkInstallationTest implements TestSig {
  string getARelevantTag() { result = "hasApkInstallation" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasApkInstallation" and
    exists(DataFlow::Node sink | ApkInstallationFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HasApkInstallationTest>
