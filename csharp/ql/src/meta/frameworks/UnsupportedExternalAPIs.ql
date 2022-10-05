/**
 * @name Usage of unsupported external library API
 * @description A call to an unsuppported external library API.
 * @kind problem
 * @problem.severity recommendation
 * @tags meta
 * @id csharp/meta/unsupported-external-api
 * @precision very-low
 */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import Telemetry.ExternalApi

from DispatchCall c, ExternalApi api
where
  c = api.getACall() and
  api.isRelevantUnsupported()
select c, "Call to unsupported external API $@.", api, api.toString()
