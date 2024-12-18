import go
import utils.test.InlineExpectationsTest
import experimental.frameworks.CleverGo

module HttpHeaderWriteTest implements TestSig {
  string getARelevantTag() { result = ["headerKeyNode", "headerValNode", "headerKey", "headerVal"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    // Dynamic key-value header:
    exists(Http::HeaderWrite hw |
      hw.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      (
        element = hw.getName().toString() and
        value = hw.getName().toString() and
        tag = "headerKeyNode"
        or
        element = hw.getValue().toString() and
        value = hw.getValue().toString() and
        tag = "headerValNode"
      )
    )
    or
    // Static key, dynamic value header:
    exists(Http::HeaderWrite hw |
      hw.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      (
        element = hw.getHeaderName().toString() and
        value = hw.getHeaderName() and
        tag = "headerKey"
        or
        element = hw.getValue().toString() and
        value = hw.getValue().toString() and
        tag = "headerValNode"
      )
    )
    or
    // Static key, static value header:
    exists(Http::HeaderWrite hw |
      hw.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      (
        element = hw.getHeaderName().toString() and
        value = hw.getHeaderName() and
        tag = "headerKey"
        or
        element = hw.getHeaderValue().toString() and
        value = hw.getHeaderValue() and
        tag = "headerVal"
      )
    )
  }
}

import MakeTest<HttpHeaderWriteTest>
