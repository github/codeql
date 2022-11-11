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
private import ExternalApi

private predicate relevant(ExternalApi api) {
  not api.isUninteresting() and
  not api.isSupported() and
  not api instanceof FlowSummaryImpl::Public::NegativeSummarizedCallable
}

from string info, int usages
where Results<relevant/1>::restrict(info, usages)
select info, usages order by usages desc
