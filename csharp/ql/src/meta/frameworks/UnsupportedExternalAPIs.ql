/**
 * @name Usage of unsupported external library API
 * @description A call to an unsupported external library API.
 * @kind problem
 * @problem.severity recommendation
 * @tags meta
 * @id cs/meta/unsupported-external-api
 * @precision very-low
 */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import Telemetry.ExternalApi

from Call c, ExternalApi api
where
  c.getTarget().getUnboundDeclaration() = api and
  not api.isSupported() and
  not api instanceof FlowSummaryImpl::Public::NeutralCallable
select c, "Call to unsupported external API $@.", api, api.toString()
