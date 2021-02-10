import go
import TestUtilities.InlineExpectationsTest

class HttpResponseBodyTest extends InlineExpectationsTest {
  HttpResponseBodyTest() { this = "HttpResponseBodyTest" }

  override string getARelevantTag() { result = "responsebody" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    exists(HTTP::ResponseBody rb |
      rb.hasLocationInfo(file, line, _, _, _) and
      element = rb.toString() and
      value = rb.toString() and
      tag = "responsebody"
    )
  }
}
