private import java
private import semmle.code.java.dataflow.internal.DataFlowPrivate
private import semmle.code.java.dataflow.internal.FlowSummaryImplSpecific
private import semmle.code.java.dataflow.internal.ModelExclusions
private import ModelEditor

/**
 * A class of effectively public callables from source code.
 */
class PublicEndpointFromSource extends Endpoint, ModelApi {
  override predicate isSource() { sourceElement(this, _, _, _) }

  override predicate isSink() { sinkElement(this, _, _, _) }
}
