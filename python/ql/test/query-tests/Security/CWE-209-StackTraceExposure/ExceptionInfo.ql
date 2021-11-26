import python
import semmle.python.dataflow.new.DataFlow
import TestUtilities.InlineExpectationsTest
import semmle.python.security.dataflow.ExceptionInfo

class ExceptionInfoTest extends InlineExpectationsTest {
  ExceptionInfoTest() { this = "ExceptionInfoTest" }

  override string getARelevantTag() { result = "exceptionInfo" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(ExceptionInfo e |
      location = e.getLocation() and
      element = e.toString() and
      value = "" and
      tag = "exceptionInfo"
    )
  }
}
