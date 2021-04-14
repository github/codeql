import go
import experimental.frameworks.CleverGo
import TestUtilities.InlineExpectationsTest

class HttpResponseBodyTest extends InlineExpectationsTest {
  HttpResponseBodyTest() { this = "HttpResponseBodyTest" }

  override string getARelevantTag() { result = ["contentType", "responseBody"] }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    exists(HTTP::ResponseBody rd |
      rd.hasLocationInfo(file, line, _, _, _) and
      (
        (
          element = rd.getAContentType().toString() and
          value = rd.getAContentType()
          or
          element = rd.getAContentTypeNode().toString() and
          value = rd.getAContentTypeNode().getAPredecessor*().getStringValue()
        ) and
        tag = "contentType"
        or
        element = rd.toString() and
        value = rd.toString() and
        tag = "responseBody"
      )
    )
  }
}
