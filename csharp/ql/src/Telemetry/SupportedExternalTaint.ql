/**
 * @name Supported flow steps in external libraries
 * @description A list of 3rd party APIs detected as flow steps. Excludes APIs exposed by test libraries.
 * @kind metric
 * @tags summary
 * @id csharp/telemetry/supported-external-api-taint
 */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import ExternalApi

from ExternalApi api, int usages
where
  not api.isUninteresting() and
  api.hasSummary() and
  usages = strictcount(DispatchCall c | c = api.getACall())
select api.getInfo() as info, usages order by usages desc
