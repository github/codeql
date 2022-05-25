import go
import TestUtilities.InlineExpectationsTest

class K8sIoApimachineryPkgRuntimeTest extends InlineExpectationsTest {
  K8sIoApimachineryPkgRuntimeTest() { this = "KsIoClientGoTest" }

  override string getARelevantTag() { result = "KsIoClientGo" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    exists(K8sIoClientGo::SecretInterfaceSource source |
      source.hasLocationInfo(file, line, _, _, _) and
      element = source.toString() and
      value = "" and
      tag = "KsIoClientGo"
    )
  }
}
