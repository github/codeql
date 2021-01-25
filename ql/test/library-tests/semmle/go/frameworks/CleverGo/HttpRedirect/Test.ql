import go
import TestUtilities.InlineExpectationsTest

class TaintTrackingTest extends InlineExpectationsTest {
  TaintTrackingTest() { this = "TaintTrackingTest" }

  override string getARelevantTag() { result = "redirectUrl" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "redirectUrl" and
    exists(HTTP::Redirect q |
      q.hasLocationInfo(file, line, _, _, _) and
      element = q.getUrl().toString() and
      value = q.getUrl().toString()
    )
  }
}
