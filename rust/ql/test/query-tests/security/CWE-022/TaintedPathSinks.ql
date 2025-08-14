import rust
import codeql.rust.security.TaintedPathExtensions
import utils.test.InlineExpectationsTest
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.internal.DataFlowImpl as DataflowImpl
import codeql.rust.Concepts

module TaintedPathSinksTest implements TestSig {
  string getARelevantTag() {
    result =
      [
        "path-injection-sink", "path-injection-barrier", "path-injection-normalize",
        "path-injection-checked"
      ]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(TaintedPath::Sink sink |
      location = sink.getLocation() and
      location.getFile().getBaseName() != "" and
      element = sink.toString() and
      tag = "path-injection-sink" and
      value = ""
    )
    or
    exists(DataFlow::Node node |
      (
        node instanceof TaintedPath::Barrier or
        node instanceof TaintedPath::SanitizerGuard // tends to label the node *after* the check
      ) and
      location = node.getLocation() and
      location.getFile().getBaseName() != "" and
      element = node.toString() and
      tag = "path-injection-barrier" and
      value = ""
    )
    or
    exists(DataFlow::Node node |
      DataflowImpl::optionalBarrier(node, "normalize-path") and
      location = node.getLocation() and
      location.getFile().getBaseName() != "" and
      element = node.toString() and
      tag = "path-injection-normalize" and
      value = ""
    )
    or
    exists(DataFlow::Node node |
      node instanceof Path::SafeAccessCheck and // tends to label the node *after* the check
      location = node.getLocation() and
      location.getFile().getBaseName() != "" and
      element = node.toString() and
      tag = "path-injection-checked" and
      value = ""
    )
  }
}

import MakeTest<TaintedPathSinksTest>
