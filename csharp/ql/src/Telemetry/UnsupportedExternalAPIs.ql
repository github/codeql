/**
 * @name Usage of unsupported APIs coming from external libraries
 * @description A list of 3rd party APIs used in the codebase. Excludes APIs exposed by test libraries.
 * @kind metric
 * @tags summary telemetry
 * @id csharp/telemetry/unsupported-external-api
 */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.dataflow.internal.NegativeSummary
private import ExternalApi

private predicate getRelevantUsages(string apiInfo, int usages) {
  usages =
    strictcount(DispatchCall c, ExternalApi api |
      apiInfo = api.getInfo() and
      c = api.getACall() and
      not api.isUninteresting() and
      not api.isSupported() and
      not api instanceof FlowSummaryImpl::Public::NegativeSummarizedCallable
    )
}

from string info, int usages
where Results<getRelevantUsages/2>::restrict(info, usages)
select info, usages order by usages desc
