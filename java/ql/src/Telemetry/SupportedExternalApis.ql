/**
 * @name Usage of supported APIs coming from external libraries
 * @description A list of supported 3rd party APIs used in the codebase. Excludes test and generated code.
 * @kind metric
 * @tags summary telemetry
 * @id java/telemetry/supported-external-api
 */

import java
import ExternalApi

private predicate relevant(ExternalApi api) { api.isSupported() }

from string apiName, int usages
where Results<relevant/1>::restrict(apiName, usages)
select apiName, usages order by usages desc
