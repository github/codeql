import python
import TestUtilities.InlineExpectationsTest

private module RemoteFlowTest implements TestSig {
  private import semmle.python.dataflow.new.RemoteFlowSources
  private import semmle.python.dataflow.new.internal.PrintNode

  string getARelevantTag() { result = "remoteFlow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(RemoteFlowSource source |
      location = source.getLocation() and
      tag = "remoteFlow" and
      value = prettyNode(source) and
      element = source.toString()
    )
  }
}

import MakeTest<RemoteFlowTest>
