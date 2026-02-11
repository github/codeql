import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import utils.test.InlineExpectationsTest

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.getLocation().getFile().getBaseName() = "self_parameter_flow.cpp" and
    source.asIndirectArgument() =
      any(Call call | call.getTarget().hasName("callincr")).getAnArgument()
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asDefiningArgument() =
      any(Call call | call.getTarget().hasName("callincr")).getAnArgument()
  }
}

import DataFlow::Global<TestConfig>

module TestSelfParameterFlow implements TestSig {
  string getARelevantTag() { result = "flow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node sink |
      flowTo(sink) and
      location = sink.getLocation() and
      element = sink.toString() and
      tag = "flow" and
      value = ""
    )
  }
}

import MakeTest<TestSelfParameterFlow>
