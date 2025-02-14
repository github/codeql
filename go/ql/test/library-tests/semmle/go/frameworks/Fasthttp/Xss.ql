import go
import utils.test.InlineExpectationsTest

module FasthttpTest implements TestSig {
  string getARelevantTag() { result = "XssSink" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(SharedXss::Sink xssSink |
      xssSink
          .hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
            location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = xssSink.toString() and
      value = xssSink.toString() and
      tag = "XssSink"
    )
  }
}

import MakeTest<FasthttpTest>
