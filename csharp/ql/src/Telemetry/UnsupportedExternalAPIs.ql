/**
 * @name Usage of unsupported APIs coming from external libraries
 * @description A list of 3rd party APIs used in the codebase. Excludes APIs exposed by test libraries.
 * @kind metric
 * @tags summary telemetry
 * @id csharp/telemetry/unsupported-external-api
 */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import ExternalApi

private predicate getRelevantUsages(ExternalApi api, int usages) {
  not api.isUninteresting() and
  not api.isSupported() and
  usages = strictcount(DispatchCall c | c = api.getACall())
}

from ExternalApi api, int usages
where Results<getRelevantUsages/2>::restrict(api, usages)
select api.getInfo() as info, usages order by usages desc
