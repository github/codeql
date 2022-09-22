import go
import TestUtilities.InlineExpectationsTest

class HttpHandler extends InlineExpectationsTest {
  HttpHandler() { this = "httphandler" }

  override string getARelevantTag() { result = "handler" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "handler" and
    exists(Http::RequestHandler h, DataFlow::Node check |
      element = h.toString() and value = check.toString()
    |
      h.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      h.guardedBy(check)
    )
  }
}
