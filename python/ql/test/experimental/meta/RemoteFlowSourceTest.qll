import python
import semmle.python.dataflow.new.RemoteFlowSources
import utils.test.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode

module SourceTest implements TestSig {
  string getARelevantTag() { result = "source" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(RemoteFlowSource rfs |
      location = rfs.getLocation() and
      element = rfs.toString() and
      value = prettyNode(rfs) and
      tag = "source"
    )
  }
}

import MakeTest<SourceTest>
