/**
 * @name Supported flow steps in external libraries
 * @description A list of 3rd party APIs detected as flow steps. Excludes APIs exposed by test libraries.
 * @kind metric
 * @tags summary telemetry
 * @id csharp/telemetry/supported-external-api-taint
 */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import ExternalApi

private predicate getRelevantUsages(string apiInfo, int usages) {
  usages =
    strictcount(DispatchCall c, ExternalApi api |
      apiInfo = api.getInfo() and
      c = api.getACall() and
      not api.isUninteresting() and
      api.hasSummary()
    )
}

from string info, int usages
where Results<getRelevantUsages/2>::restrict(info, usages)
select info, usages order by usages desc
