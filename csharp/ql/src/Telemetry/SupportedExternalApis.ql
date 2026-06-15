/**
 * @name Usage of supported APIs coming from external libraries
 * @description A list of supported 3rd party APIs used in the codebase. Excludes APIs exposed by test libraries.
 * @kind metric
 * @tags summary telemetry
 * @id cs/telemetry/supported-external-api
 */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.telemetry.ExternalApi

private predicate relevant(ExternalApi api) { api.isSupported() }

from string info, int usages
where Results<relevant/1>::restrict(info, usages)
select info, usages order by usages desc
