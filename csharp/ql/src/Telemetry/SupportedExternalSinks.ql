/**
 * @name Supported sinks in external libraries
 * @description A list of 3rd party APIs detected as sinks. Excludes test and generated code.
 * @kind metric
 * @tags summary
 * @id csharp/telemetry/supported-external-api-sinks
 */

import csharp
import ExternalApi

from ExternalApi api, int usages
where
  not api.isUninteresting() and
  api.isSink() and
  usages = strictcount(Call c | c.getTarget() = api)
select api.getInfo() as info, usages order by usages desc
