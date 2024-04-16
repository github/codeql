private import csharp
private import semmle.code.csharp.dataflow.internal.ExternalFlow
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch as DataFlowDispatch
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate
private import semmle.code.csharp.security.dataflow.flowsources.Remote
private import ModelEditor

/**
 * A class of effectively public callables in library code.
 */
class ExternalEndpoint extends Endpoint {
  ExternalEndpoint() { this.fromLibrary() }

  /** Gets a node that is an input to a call to this API. */
  private ArgumentNode getAnInput() {
    result
        .getCall()
        .(DataFlowDispatch::NonDelegateDataFlowCall)
        .getATarget(_)
        .getUnboundDeclaration() = this
  }

  /** Gets a node that is an output from a call to this API. */
  private DataFlow::Node getAnOutput() {
    exists(Call c, DataFlowDispatch::NonDelegateDataFlowCall dc |
      dc.getDispatchCall().getCall() = c and
      c.getTarget().getUnboundDeclaration() = this
    |
      result = DataFlowDispatch::getAnOutNode(dc, _)
    )
  }

  override predicate hasSummary() {
    Endpoint.super.hasSummary()
    or
    defaultAdditionalTaintStep(this.getAnInput(), _, _)
  }

  override predicate isSource() {
    this.getAnOutput() instanceof RemoteFlowSource or sourceNode(this.getAnOutput(), _)
  }

  override predicate isSink() { sinkNode(this.getAnInput(), _) }
}
