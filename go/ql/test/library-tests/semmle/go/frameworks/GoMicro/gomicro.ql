import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import TestUtilities.InlineExpectationsTest

module GoMicroTest implements TestSig {
  string getARelevantTag() { result = ["serverRequest", "clientRequest"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node node |
      node.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      (
        node instanceof GoMicro::Request and
        element = node.toString() and
        value = "\"" + node.toString() + "\"" and
        tag = "serverRequest"
        or
        node instanceof GoMicro::ClientRequestUrlAsSink and
        element = node.toString() and
        value = node.toString().replaceAll("/", "\\/") and
        tag = "clientRequest"
      )
    )
  }
}

import MakeTest<GoMicroTest>
