import utils.test.InlineExpectationsTest
private import cpp
private import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.controlflow.IRGuards

module IRTestAllocationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asParameter().getName().matches("source%") and
    source.getLocation().getFile().getBaseName() = "guard-condition-regression-test.cpp"
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call, Expr e | e = call.getAnArgument() |
      call.getTarget().getName() = "gard_condition_sink" and
      sink.asExpr() = e
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    exists(GuardCondition gc | node.asExpr() = gc.getAChild*())
  }
}

private module Flow = DataFlow::Global<IRTestAllocationConfig>;

module GuardConditionRegressionTest implements TestSig {
  string getARelevantTag() { result = "guard-condition-regression" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node sink |
      Flow::flowTo(sink) and
      location = sink.getLocation() and
      element = sink.toString() and
      tag = "guard-condition-regression" and
      value = ""
    )
  }
}

import MakeTest<GuardConditionRegressionTest>
