import go
import utils.test.InlineExpectationsTest
import experimental.frameworks.CleverGo

module HttpRedirectTest implements TestSig {
  string getARelevantTag() { result = "redirectUrl" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "redirectUrl" and
    exists(Http::Redirect rd |
      rd.getLocation() = location and
      element = rd.getUrl().toString() and
      value = rd.getUrl().toString()
    )
  }
}

import MakeTest<HttpRedirectTest>
