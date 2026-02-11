/**
 * @name Supported sinks in external libraries
 * @description A list of 3rd party APIs detected as sinks. Excludes test and generated code.
 * @kind metric
 * @tags summary telemetry exclude-from-incremental
 * @id java/telemetry/supported-external-api-sinks
 */

import java
import ExternalApi

private predicate relevant(ExternalApi api) { api.isSink() }

from string apiName, int usages
where Results<relevant/1>::restrict(apiName, usages)
select apiName, usages order by usages desc
