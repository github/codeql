/**
 * @name Usage of APIs coming from external libraries
 * @description A list of 3rd party APIs used in the codebase. Excludes test and generated code.
 * @id java/telemetry/external-api
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
  not api.isSupported() and
  api.isInteresting()
select api.asCSV(api) as csv,
  strictcount(Call c |
    c.getCallee() = api and
    not c.getFile() instanceof GeneratedFile
  ) as Usages order by Usages desc
