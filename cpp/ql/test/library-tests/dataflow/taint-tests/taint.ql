import cpp
import semmle.code.cpp.dataflow.TaintTracking

/** Common data flow configuration to be used by tests. */
class TestAllocationConfig extends TaintTracking::Configuration {
  TestAllocationConfig() {
    this = "TestAllocationConfig"
  }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(FunctionCall).getTarget().getName() = "source"
    or
    source.asParameter().getName().matches("source%")
    or
    // Track uninitialized variables
    exists(source.asUninitialized())
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      call.getTarget().getName() = "sink" and
      sink.asExpr() = call.getAnArgument()
    )
  }

  override predicate isSanitizer(DataFlow::Node barrier) {
    barrier.asExpr().(VariableAccess).getTarget().hasName("sanitizer")
  }
}

from DataFlow::Node sink, DataFlow::Node source, TestAllocationConfig cfg
where cfg.hasFlow(source, sink)
select sink, source
