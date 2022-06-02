import go
import TestUtilities.InlineExpectationsTest
import experimental.frameworks.Fiber

class HttpRedirectTest extends InlineExpectationsTest {
  HttpRedirectTest() { this = "HttpRedirectTest" }

  override string getARelevantTag() { result = "redirectUrl" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "redirectUrl" and
    exists(HTTP::Redirect rd |
      rd.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = rd.getUrl().toString() and
      value = rd.getUrl().toString()
    )
  }
}
