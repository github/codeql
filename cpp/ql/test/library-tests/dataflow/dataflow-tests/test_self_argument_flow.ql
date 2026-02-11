import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import utils.test.InlineExpectationsTest

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.getLocation().getFile().getBaseName() = "self_argument_flow.cpp" and
    source.asDefiningArgument() =
      any(Call call | call.getTarget().hasName("acquire")).getAnArgument()
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asIndirectArgument() = any(Call call | call.getTarget().hasName("acquire")).getAnArgument()
  }
}

import DataFlow::Global<TestConfig>

module TestSelfArgumentFlow implements TestSig {
  string getARelevantTag() { result = "self-arg-flow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node sink |
      flowTo(sink) and
      location = sink.getLocation() and
      element = sink.toString() and
      tag = "self-arg-flow" and
      value = ""
    )
  }
}

import MakeTest<TestSelfArgumentFlow>
