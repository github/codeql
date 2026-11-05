import csharp
import semmle.code.csharp.dataflow.FlowSteps
import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate

/**
 * A test-only additional taint step that treats calls to `Marker.Step` as
 * propagating taint from the argument to the call result, to verify that
 * `AdditionalTaintStep` subclasses are picked up by `defaultAdditionalTaintStep`.
 */
private class MarkerStepTaintStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodCall mc |
      mc.getTarget().hasName("Step") and
      mc.getTarget().getDeclaringType().hasName("Marker")
    |
      node1.asExpr() = mc.getArgument(0) and
      node2.asExpr() = mc
    )
  }
}

from DataFlow::Node src, DataFlow::Node sink, string model
where defaultAdditionalTaintStep(src, sink, model) and model = "AdditionalTaintStep"
select src, sink, model
