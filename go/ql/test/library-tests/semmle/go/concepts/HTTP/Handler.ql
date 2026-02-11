import go
import utils.test.InlineExpectationsTest

module HttpHandler implements TestSig {
  string getARelevantTag() { result = "handler" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "handler" and
    exists(Http::RequestHandler h, DataFlow::Node check |
      element = h.toString() and value = check.toString()
    |
      h.getLocation() = location and
      h.guardedBy(check)
    )
  }
}

import MakeTest<HttpHandler>
