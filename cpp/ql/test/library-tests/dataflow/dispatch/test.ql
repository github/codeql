import cpp
import utils.test.InlineExpectationsTest
import semmle.code.cpp.ir.dataflow.internal.DataFlowDispatch
import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate

module ResolveDispatchTest implements TestSig {
  string getARelevantTag() { result = "target" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlowCall call, SourceCallable callable, MemberFunction mf |
      mf = callable.asSourceCallable() and
      not mf.isCompilerGenerated() and
      callable = viableCallable(call) and
      location = call.getLocation() and
      element = call.toString() and
      tag = "target" and
      value = callable.getLocation().getStartLine().toString()
    )
  }
}

import MakeTest<ResolveDispatchTest>
