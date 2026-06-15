/**
 * @name Usage of unsupported external library API
 * @description A call to an unsupported external library API.
 * @kind problem
 * @problem.severity recommendation
 * @tags meta
 * @id cs/meta/unsupported-external-api
 * @precision very-low
 */

private import csharp
private import semmle.code.csharp.telemetry.ExternalApi

from Call c, ExternalApi api
where
  c.getTarget().getUnboundDeclaration() = api and
  not api.isSupported()
select c, "Call to unsupported external API $@.", api, api.toString()
