import go
import TestUtilities.InlineExpectationsTest

module K8sIoApimachineryPkgRuntimeTest implements TestSig {
  string getARelevantTag() { result = "KsIoClientGo" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
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

import MakeTest<K8sIoApimachineryPkgRuntimeTest>
