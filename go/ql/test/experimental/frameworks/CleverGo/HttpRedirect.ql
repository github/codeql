import go
import TestUtilities.InlineExpectationsTest
import experimental.frameworks.CleverGo

class HttpRedirectTest extends InlineExpectationsTest {
  HttpRedirectTest() { this = "HttpRedirectTest" }

  override string getARelevantTag() { result = "redirectUrl" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "redirectUrl" and
    exists(HTTP::Redirect rd |
      rd.hasLocationInfo(file, line, _, _, _) and
      element = rd.getUrl().toString() and
      value = rd.getUrl().toString()
    )
  }
}
