import go
import TestUtilities.InlineExpectationsTest

module FasthttpTest implements TestSig {
  string getARelevantTag() { result = ["URI", "req"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Fasthttp::Request::RequestAdditionalStep q, DataFlow::Node succ |
      q.hasTaintStep(_, succ)
    |
      succ.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = succ.toString() and
      value = succ.toString() and
      tag = "req"
    )
    or
    exists(Fasthttp::URI::UriAdditionalStep q, DataFlow::Node succ | q.hasTaintStep(_, succ) |
      succ.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = succ.toString() and
      value = succ.toString() and
      tag = "URI"
    )
  }
}

import MakeTest<FasthttpTest>
