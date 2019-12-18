import cpp
import semmle.code.cpp.dataflow.DataFlow

/**
 * A `BarrierGuard` that stops flow to all occurrences of `x` within statement
 * S in `if (guarded(x)) S`.
 */
// This is tested in `BarrierGuard.cpp`.
class TestBarrierGuard extends DataFlow::BarrierGuard {
  TestBarrierGuard() { this.(FunctionCall).getTarget().getName() = "guarded" }

  override predicate checks(Expr checked, boolean isTrue) {
    checked = this.(FunctionCall).getArgument(0) and
    isTrue = true
  }
}

/** Common data flow configuration to be used by tests. */
class TestAllocationConfig extends DataFlow::Configuration {
  TestAllocationConfig() { this = "TestAllocationConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(FunctionCall).getTarget().getName() = "source"
    or
    source.asParameter().getName().matches("source%")
    or
    source.(DataFlow::DefinitionByReferenceNode).getParameter().getName().matches("ref_source%")
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

  override predicate isBarrier(DataFlow::Node barrier) {
    barrier.asExpr().(VariableAccess).getTarget().hasName("barrier")
  }

  override predicate isBarrierGuard(DataFlow::BarrierGuard bg) { bg instanceof TestBarrierGuard }
}
