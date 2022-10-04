/**
 * @name Supported sinks in external libraries
 * @description A list of 3rd party APIs detected as sinks. Excludes APIs exposed by test libraries.
 * @kind metric
 * @tags summary telemetry
 * @id csharp/telemetry/supported-external-api-sinks
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
      api.isSink()
    )
}

from string info, int usages
where Results<getRelevantUsages/2>::restrict(info, usages)
select info, usages order by usages desc
