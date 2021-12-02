/**
 * @name Supported sinks in external libraries
 * @description A list of 3rd party APIs detected as sinks. Excludes test and generated code.
 * @id java/telemetry/supported-external-api-sinks
 * @kind metric
 * @tags summary
 */

import java
import ExternalAPI
import semmle.code.java.GeneratedFiles

from ExternalAPI api, int usages
where
  not api.isUninteresting() and
  api.isSink() and
  usages =
    strictcount(Call c |
      c.getCallee().getSourceDeclaration() = api and
      not c.getFile() instanceof GeneratedFile
    )
select api.getApiName() as apiname, usages order by usages desc
