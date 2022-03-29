/**
 * @name External libraries
 * @description A list of external libraries used in the code
 * @kind metric
 * @tags summary
 * @id csharp/telemetry/external-libs
 */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import ExternalApi

from int usages, string info
where
  usages =
    strictcount(DispatchCall c, ExternalApi api |
      c = api.getACall() and
      api.getInfoPrefix() = info and
      not api.isUninteresting()
    )
select info, usages order by usages desc
