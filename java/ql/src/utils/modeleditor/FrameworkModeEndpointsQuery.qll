private import java
private import semmle.code.java.dataflow.internal.DataFlowPrivate
private import semmle.code.java.dataflow.internal.FlowSummaryImpl
private import semmle.code.java.dataflow.internal.ModelExclusions
private import ModelEditor

/**
 * A class of effectively public callables from source code.
 */
class PublicEndpointFromSource extends Endpoint, ModelApi {
  override predicate isSource() { SourceSinkInterpretationInput::sourceElement(this, _, _) }

  override predicate isSink() { SourceSinkInterpretationInput::sinkElement(this, _, _) }
}
