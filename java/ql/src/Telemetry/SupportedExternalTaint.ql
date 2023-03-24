/**
 * @name Supported flow steps in external libraries
 * @description A list of 3rd party APIs detected as flow steps. Excludes test and generated code.
 * @kind metric
 * @tags summary telemetry
 * @id java/telemetry/supported-external-api-taint
 */

import java
import ExternalApi

private predicate relevant(ExternalApi api) { api.hasSummary() }

from string apiName, int usages
where Results<relevant/1>::restrict(apiName, usages)
select apiName, usages order by usages desc
