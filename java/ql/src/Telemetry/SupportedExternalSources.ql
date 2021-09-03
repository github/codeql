/**
 * @name Supported sources in external libraries
 * @description A list of 3rd party APIs detected as sources. Excludes test and generated code.
 * @id java/telemetry/supported-external-api-sources
 * @kind metric
 * @metricType callable
 */

import java
import ExternalAPI
import semmle.code.java.GeneratedFiles

from ExternalAPI api, int usages
where
  api.isWorthSupporting() and
  api.isSource() and
  usages =
    strictcount(Call c |
      c.getCallee().getSourceDeclaration() = api and
      not c.getFile() instanceof GeneratedFile
    )
select api.asHumanReadbleString(api) as apiname, usages order by usages desc
