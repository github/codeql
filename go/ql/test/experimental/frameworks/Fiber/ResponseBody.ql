import go
import TestUtilities.InlineExpectationsTest
import experimental.frameworks.Fiber

class HttpResponseBodyTest extends InlineExpectationsTest {
  HttpResponseBodyTest() { this = "HttpResponseBodyTest" }

  override string getARelevantTag() { result = ["contentType", "responseBody"] }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    exists(HTTP::ResponseBody rd |
      rd.hasLocationInfo(file, line, _, _, _) and
      (
        element = rd.getAContentType().toString() and
        value = rd.getAContentType().toString() and
        tag = "contentType"
        or
        element = rd.toString() and
        value = rd.toString() and
        tag = "responseBody"
      )
    )
  }
}
