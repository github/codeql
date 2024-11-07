private import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.internal.DataFlowPrivate
private import semmle.code.java.dataflow.internal.ModelExclusions
private import ModelEditor

/**
 * A class of effectively public callables from source code.
 */
class PublicEndpointFromSource extends Endpoint, ModelApi {
  override predicate isSource() { this instanceof SourceCallable }

  override predicate isSink() { this instanceof SinkCallable }
}
