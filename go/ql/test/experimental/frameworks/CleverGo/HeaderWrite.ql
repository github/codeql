import go
import TestUtilities.InlineExpectationsTest
import experimental.frameworks.CleverGo

class HttpHeaderWriteTest extends InlineExpectationsTest {
  HttpHeaderWriteTest() { this = "HttpHeaderWriteTest" }

  override string getARelevantTag() {
    result = ["headerKeyNode", "headerValNode", "headerKey", "headerVal"]
  }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
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
