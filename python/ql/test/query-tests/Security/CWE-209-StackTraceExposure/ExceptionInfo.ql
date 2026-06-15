import python
import semmle.python.dataflow.new.DataFlow
import utils.test.InlineExpectationsTest
import semmle.python.security.dataflow.ExceptionInfo

module ExceptionInfoTest implements TestSig {
  string getARelevantTag() { result = "exceptionInfo" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(ExceptionInfo e |
      location = e.getLocation() and
      element = e.toString() and
      value = "" and
      tag = "exceptionInfo"
    )
  }
}

import MakeTest<ExceptionInfoTest>
