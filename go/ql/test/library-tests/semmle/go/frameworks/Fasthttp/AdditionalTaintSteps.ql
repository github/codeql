import go
import TestUtilities.InlineExpectationsTest

module FasthttpTest implements TestSig {
  string getARelevantTag() { result = ["UriSucc", "UriPred", "ReqSucc", "ReqPred"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Fasthttp::Request::RequestAdditionalStep q, DataFlow::Node succ, DataFlow::Node pred |
      q.hasTaintStep(pred, succ)
    |
      (
        pred.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
          location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
        element = pred.toString() and
        value = pred.toString() and
        tag = "ReqPred"
        or
        succ.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
          location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
        element = succ.toString() and
        value = succ.toString() and
        tag = "ReqSucc"
      )
    )
    or
    exists(Fasthttp::URI::UriAdditionalStep q, DataFlow::Node succ, DataFlow::Node pred |
      q.hasTaintStep(pred, succ)
    |
      (
        pred.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
          location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
        element = pred.toString() and
        value = pred.toString() and
        tag = "UriPred"
        or
        succ.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
          location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
        element = succ.toString() and
        value = succ.toString() and
        tag = "UriSucc"
      )
    )
  }
}

import MakeTest<FasthttpTest>
