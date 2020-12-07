import go
import TestUtilities.InlineExpectationsTest

class HttpHandler extends InlineExpectationsTest {
  HttpHandler() { this = "httphandler" }

  override string getARelevantTag() { result = "handler" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "handler" and
    exists(HTTP::RequestHandler h, DataFlow::Node check |
      element = h.toString() and value = check.toString()
    |
      h.hasLocationInfo(file, line, _, _, _) and
      h.guardedBy(check)
    )
  }
}
