import go
import utils.test.InlineExpectationsTest
import experimental.frameworks.CleverGo

module HttpResponseBodyTest implements TestSig {
  string getARelevantTag() { result = ["contentType", "responseBody"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Http::ResponseBody rd |
      rd.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
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

import MakeTest<HttpResponseBodyTest>
