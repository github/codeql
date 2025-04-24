import powershell
import semmle.code.powershell.dataflow.internal.DataFlowDispatch
import semmle.code.powershell.dataflow.internal.DataFlowPublic
import semmle.code.powershell.dataflow.internal.DataFlowPrivate
import TestUtilities.InlineExpectationsTest

module TypeTrackingTest implements TestSig {
  string getARelevantTag() { result = "type" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Node n, DataFlowCall c |
      location = n.getLocation() and
      element = n.toString() and
      tag = "type" and
      n = trackInstance(value, _) and
      isArgumentNode(n, c, _) and
      c.asCall().matchesName("Sink")
    )
  }
}

import MakeTest<TypeTrackingTest>
