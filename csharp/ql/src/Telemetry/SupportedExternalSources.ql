/**
 * @name Supported sources in external libraries
 * @description A list of 3rd party APIs detected as sources. Excludes APIs exposed by test libraries.
 * @kind metric
 * @tags summary telemetry
 * @id csharp/telemetry/supported-external-api-sources
 */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import ExternalApi

private predicate getRelevantUsages(string apiInfo, int usages) {
  usages =
    strictcount(DispatchCall c, ExternalApi api |
      c = api.getACall() and
      apiInfo = api.getInfo() and
      not api.isUninteresting() and
      api.isSource()
    )
}

from string info, int usages
where Results<getRelevantUsages/2>::restrict(info, usages)
select info, usages order by usages desc
