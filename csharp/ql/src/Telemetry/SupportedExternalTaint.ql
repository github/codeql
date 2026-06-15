/**
 * @name Supported flow steps in external libraries
 * @description A list of 3rd party APIs detected as flow steps. Excludes APIs exposed by test libraries.
 * @kind metric
 * @tags summary telemetry
 * @id cs/telemetry/supported-external-api-taint
 */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.telemetry.ExternalApi

private predicate relevant(ExternalApi api) { api.hasSummary() }

from string info, int usages
where Results<relevant/1>::restrict(info, usages)
select info, usages order by usages desc
