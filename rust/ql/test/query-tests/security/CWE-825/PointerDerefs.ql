import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.DanglingPointerExtensions
import utils.test.InlineExpectationsTest

module PointerDereferenceFlow = TaintTracking::Global<PointerDereferenceConfig>;

module PointerDereferenceTest implements TestSig {
  string getARelevantTag() { result = "deref" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node sourceNode, DataFlow::Node sinkNode, DataFlow::Node targetValue |
      PointerDereferenceFlow::flow(sourceNode, sinkNode) and
      createsPointer(sourceNode, targetValue) and
      location = sinkNode.getLocation() and
      location.getFile().getBaseName() != "" and
      element = sinkNode.toString() and
      tag = "deref" and
      value = targetValue.toString()
    )
  }
}

import MakeTest<PointerDereferenceTest>
