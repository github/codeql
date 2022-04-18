/**
 * @name Supported sources in external libraries
 * @description A list of 3rd party APIs detected as sources. Excludes APIs exposed by test libraries.
 * @kind metric
 * @tags summary
 * @id csharp/telemetry/supported-external-api-sources
 */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import ExternalApi

from ExternalApi api, int usages
where
  not api.isUninteresting() and
  api.isSource() and
  usages = strictcount(DispatchCall c | c = api.getACall())
select api.getInfo() as info, usages order by usages desc
