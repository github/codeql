/**
 * @name Usage count of unsupported external library generic APIs
 * @description A call to an unsuppported external library generic API.
 * @kind metric
 * @tags summary
 * @id csharp/meta/unsupported-external-generic-api
 */

private import csharp
private import semmle.code.csharp.dispatch.Dispatch
private import Telemetry.ExternalApi

private predicate relevant(ExternalApi api) {
  api.isRelevantUnsupported() and
  (
    api instanceof Generic
    or
    api.getDeclaringType() instanceof Generic
  )
}

select count(DispatchCall c, ExternalApi api | c = api.getACall() and relevant(api))
