/**
 * @name Usage of unsupported APIs coming from external libraries
 * @description A list of 3rd party APIs used in the codebase. Excludes test and generated code.
 * @kind metric
 * @tags summary
 * @id java/telemetry/unsupported-external-api
 */

import java
import ExternalApi
import semmle.code.java.GeneratedFiles

from ExternalApi api, int usages
where
  not api.isUninteresting() and
  not api.isSupported() and
  usages =
    strictcount(Call c |
      c.getCallee().getSourceDeclaration() = api and
      not c.getFile() instanceof GeneratedFile
    )
select api.getApiName() as apiname, usages order by usages desc
