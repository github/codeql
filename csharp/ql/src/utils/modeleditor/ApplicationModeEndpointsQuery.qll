private import csharp
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.dataflow.FlowSummary
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch as DataFlowDispatch
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
private import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate
private import semmle.code.csharp.security.dataflow.flowsources.Remote
private import ModelEditor

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
    exists(
      Call c, DataFlowDispatch::NonDelegateDataFlowCall dc, DataFlowImplCommon::ReturnKindExt ret
    |
      dc.getDispatchCall().getCall() = c and
      c.getTarget().getUnboundDeclaration() = this
    |
      result = ret.getAnOutNode(dc)
    )
  }

  override predicate hasSummary() {
    this instanceof SummarizedCallable
    or
    defaultAdditionalTaintStep(this.getAnInput(), _)
  }

  override predicate isSource() {
    this.getAnOutput() instanceof RemoteFlowSource or sourceNode(this.getAnOutput(), _)
  }

  override predicate isSink() { sinkNode(this.getAnInput(), _) }
}
