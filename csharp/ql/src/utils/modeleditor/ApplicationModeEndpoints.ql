/**
 * @name Fetch endpoints for use in the model editor (application mode)
 * @description A list of 3rd party endpoints (methods and attributes) used in the codebase. Excludes test and generated code.
 * @kind problem
 * @problem.severity recommendation
 * @id csharp/utils/modeleditor/application-mode-endpoints
 * @tags modeleditor endpoints application-mode
 */

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

private Call aUsage(ExternalEndpoint api) { result.getTarget().getUnboundDeclaration() = api }

from
  ExternalEndpoint endpoint, string apiName, boolean supported, Call usage, string type,
  string classification
where
  apiName = endpoint.getApiName() and
  supported = isSupported(endpoint) and
  usage = aUsage(endpoint) and
  type = supportedType(endpoint) and
  classification = methodClassification(usage)
select usage, apiName, supported.toString(), "supported", endpoint.dllName(), endpoint.dllVersion(),
  type, "type", classification, "classification"
