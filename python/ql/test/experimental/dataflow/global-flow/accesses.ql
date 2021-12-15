import python
import semmle.python.dataflow.new.DataFlow
import TestUtilities.InlineExpectationsTest

class GlobalReadTest extends InlineExpectationsTest {
  GlobalReadTest() { this = "GlobalReadTest" }

  override string getARelevantTag() { result = "reads" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::ModuleVariableNode n, DataFlow::Node read |
      read = n.getARead() and
      value = n.getVariable().getId() and
      value != "print" and
      tag = "reads" and
      location = read.getLocation() and
      element = read.toString()
    )
  }
}

class GlobalWriteTest extends InlineExpectationsTest {
  GlobalWriteTest() { this = "GlobalWriteTest" }

  override string getARelevantTag() { result = "writes" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::ModuleVariableNode n, DataFlow::Node read |
      read = n.getAWrite() and
      value = n.getVariable().getId() and
      tag = "writes" and
      location = read.getLocation() and
      element = read.toString()
    )
  }
}
