/** Provides classes and predicates related to `androidx.slice`. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps

/** The class `androidx.slice.SliceProvider`. */
class SliceProvider extends Class {
  SliceProvider() { this.hasQualifiedName("androidx.slice", "SliceProvider") }
}

/**
 * An additional value step for modeling the lifecycle of a `SliceProvider`.
 * It connects the `PostUpdateNode` of any update done to the provider object in
 * `onCreateSliceProvider` to the instance parameter of `onBindSlice`.
 */
private class SliceProviderLifecycleStep extends AdditionalValueStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(Method onCreate, Method onBind, RefType declaringClass |
      declaringClass.getAnAncestor() instanceof SliceProvider and
      onCreate.getDeclaringType() = declaringClass and
      onCreate.hasName("onCreateSliceProvider") and
      onBind.getDeclaringType() = declaringClass and
      onBind.hasName("onBindSlice")
    |
      node1
          .(DataFlow::PostUpdateNode)
          .getPreUpdateNode()
          .(DataFlow::InstanceAccessNode)
          .isOwnInstanceAccess() and
      node1.getEnclosingCallable() = onCreate and
      node2.(DataFlow::InstanceParameterNode).getEnclosingCallable() = onBind
    )
  }
}

private class SliceActionsInheritTaint extends DataFlow::SyntheticFieldContent,
  TaintInheritingContent
{
  SliceActionsInheritTaint() { this.getField() = "androidx.slice.Slice.action" }
}
