import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.internal.DataFlowDispatch as DataFlowDispatch
import TestUtilities.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode
import experimental.semmle.python.Concepts

module SystemCommandExecutionTest implements TestSig {
  string getARelevantTag() { result = "getSecondaryCommand" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(location.getFile().getRelativePath()) and
    exists(SecondaryCommandInjection sci, DataFlow::Node command |
      command = sci and
      location = command.getLocation() and
      element = command.toString() and
      value = prettyNodeForInlineTest(command) and
      tag = "getSecondaryCommand"
    )
  }
}

import MakeTest<SystemCommandExecutionTest>
