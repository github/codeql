private import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.internal.DataFlowPrivate
private import ModelEditor

/**
 * A class of effectively public callables in library code.
 */
class ExternalEndpoint extends Endpoint {
  ExternalEndpoint() { not this.fromSource() }

  /** Gets a node that is an input to a call to this API. */
  private DataFlow::Node getAnInput() {
    exists(Call call | call.getCallee().getSourceDeclaration() = this |
      result.asExpr().(Argument).getCall() = call or
      result.(ArgumentNode).getCall().asCall() = call
    )
  }

  /** Gets a node that is an output from a call to this API. */
  private DataFlow::Node getAnOutput() {
    exists(Call call | call.getCallee().getSourceDeclaration() = this |
      result.asExpr() = call or
      result.(DataFlow::PostUpdateNode).getPreUpdateNode().(ArgumentNode).getCall().asCall() = call
    )
  }

  override predicate hasSummary() {
    Endpoint.super.hasSummary()
    or
    TaintTracking::localAdditionalTaintStep(this.getAnInput(), _, _)
  }

  override predicate isSource() {
    this.getAnOutput() instanceof RemoteFlowSource or sourceNode(this.getAnOutput(), _)
  }

  override predicate isSink() { sinkNode(this.getAnInput(), _) }
}
