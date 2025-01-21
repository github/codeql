import python
import semmle.python.dataflow.new.DataFlow
import utils.test.InlineExpectationsTest

module GlobalReadTest implements TestSig {
  string getARelevantTag() { result = "reads" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
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

module GlobalWriteTest implements TestSig {
  string getARelevantTag() { result = "writes" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::ModuleVariableNode n, DataFlow::Node read |
      read = n.getAWrite() and
      value = n.getVariable().getId() and
      tag = "writes" and
      location = read.getLocation() and
      element = read.toString()
    )
  }
}

import MakeTest<MergeTests<GlobalReadTest, GlobalWriteTest>>
