/**
 * @name Supported sources in external libraries
 * @description A list of 3rd party APIs detected as sources. Excludes test and generated code.
 * @kind metric
 * @tags summary telemetry
 * @id java/telemetry/supported-external-api-sources
 */

import java
import ExternalApi

private predicate relevant(ExternalApi api) { api.isSource() }

from string apiName, int usages
where Results<relevant/1>::restrict(apiName, usages)
select apiName, usages order by usages desc
