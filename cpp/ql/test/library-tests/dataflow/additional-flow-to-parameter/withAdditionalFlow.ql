import cpp
import semmle.code.cpp.dataflow.DataFlow

class TestConfig extends DataFlow::Configuration {
  TestConfig() { this = "TestConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(FunctionCall).getTarget().getName() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      call.getTarget().getName() = "sink" and
      sink.asExpr() = call.getAnArgument()
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    // Send all arguments of function-pointer-calls to a function with a
    // special name
    exists(Call call, Function target, int i |
      not call instanceof FunctionCall and
      call.getArgument(i) = n1.asExpr() and
      target.getParameter(i) = n2.asParameter() and
      target.getName() = "targetOfAllFunctionPointerCalls"
    )
  }
}

from DataFlow::Node sink, DataFlow::Node source, TestConfig cfg
where cfg.hasFlow(source, sink)
select sink, source
