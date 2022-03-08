/**
 * @name Usage of unsupported APIs coming from external libraries
 * @description A list of 3rd party APIs used in the codebase. Excludes test and generated code.
 * @kind metric
 * @tags summary
 * @id csharp/telemetry/unsupported-external-api
 */

import csharp
import ExternalApi

from ExternalApi api, int usages
where
  not api.isUninteresting() and
  not api.isSupported() and
  usages = strictcount(Call c | c.getTarget() = api)
select api.getInfo() as info, usages order by usages desc
