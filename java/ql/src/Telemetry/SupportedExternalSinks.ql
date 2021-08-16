/**
 * @name Supported sinks in external libraries
 * @description A list of 3rd party APIs detected as sinks. Excludes test and generated code.
 * @id java/telemetry/supported-external-api-sinks
 * @kind metric
 * @metricType callable
 */

import java
import APIUsage
import ExternalAPI
import semmle.code.java.GeneratedFiles

from ExternalAPI api
where
  not api.isTestLibrary() and
  supportKind(api) = "sink"
select api.asCSV(api) as csv,
  strictcount(Call c |
    c.getCallee() = api and
    not c.getFile() instanceof GeneratedFile
  ) as Usages order by Usages desc
