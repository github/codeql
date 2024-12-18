/**
 * @name Supported sources in external libraries
 * @description A list of 3rd party APIs detected as sources. Excludes APIs exposed by test libraries.
 * @kind metric
 * @tags summary telemetry
 * @id cs/telemetry/supported-external-api-sources
 */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.telemetry.ExternalApi

private predicate relevant(ExternalApi api) { api.isSource() }

from string info, int usages
where Results<relevant/1>::restrict(info, usages)
select info, usages order by usages desc
