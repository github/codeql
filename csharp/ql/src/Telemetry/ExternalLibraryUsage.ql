/**
 * @name External libraries
 * @description A list of external libraries used in the code
 * @kind metric
 * @tags summary telemetry
 * @id csharp/telemetry/external-libs
 */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import ExternalApi

private predicate getRelevantUsages(string info, int usages) {
  usages =
    strictcount(DispatchCall c, ExternalApi api |
      c = api.getACall() and
      api.getInfoPrefix() = info and
      not api.isUninteresting()
    )
}

private int getOrder(string info) {
  info =
    rank[result](string i, int usages | getRelevantUsages(i, usages) | i order by usages desc, i)
}

from ExternalApi api, string info, int usages
where
  info = api.getInfoPrefix() and
  getRelevantUsages(info, usages) and
  getOrder(info) <= resultLimit()
select info, usages order by usages desc
