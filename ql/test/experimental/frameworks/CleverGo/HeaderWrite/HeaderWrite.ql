import go
import experimental.frameworks.CleverGo
import TestUtilities.InlineExpectationsTest

class HttpHeaderWriteTest extends InlineExpectationsTest {
  HttpHeaderWriteTest() { this = "HttpHeaderWriteTest" }

  override string getARelevantTag() { result = ["headerKey", "headerVal"] }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    exists(HTTP::HeaderWrite hw |
      hw.hasLocationInfo(file, line, _, _, _) and
      (
        element = hw.getName().toString() and
        value = hw.getName().toString() and
        tag = "headerKey"
        or
        element = hw.getValue().toString() and
        value = hw.getValue().toString() and
        tag = "headerVal"
      )
    )
  }
}
