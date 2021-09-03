/**
 * @name Supported sinks in external libraries
 * @description A list of 3rd party APIs detected as sinks. Excludes test and generated code.
 * @id java/telemetry/supported-external-api-taint
 * @kind metric
 * @metricType callable
 */

import java
import APIUsage
import ExternalAPI
import semmle.code.java.GeneratedFiles

from ExternalAPI api, int usages
where
  not api.isTestLibrary() and
  supportKind(api) = ["summary", "taint-preserving"] and
  usages =
    strictcount(Call c |
      c.getCallee().getSourceDeclaration() = api and
      not c.getFile() instanceof GeneratedFile
    )
select api.asHumanReadbleString(api) as apiname, usages order by usages desc
