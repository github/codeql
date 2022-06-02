import go
import TestUtilities.InlineExpectationsTest

class K8sIoApimachineryPkgRuntimeTest extends InlineExpectationsTest {
  K8sIoApimachineryPkgRuntimeTest() { this = "KsIoClientGoTest" }

  override string getARelevantTag() { result = "KsIoClientGo" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(K8sIoClientGo::SecretInterfaceSource source |
      source
          .hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
            location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = source.toString() and
      value = "" and
      tag = "KsIoClientGo"
    )
  }
}
