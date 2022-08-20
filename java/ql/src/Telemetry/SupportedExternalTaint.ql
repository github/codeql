/**
 * @name Supported flow steps in external libraries
 * @description A list of 3rd party APIs detected as flow steps. Excludes test and generated code.
 * @kind metric
 * @tags summary telemetry
 * @id java/telemetry/supported-external-api-taint
 */

import java
import ExternalApi

private predicate getRelevantUsages(ExternalApi api, int usages) {
  not api.isUninteresting() and
  api.hasSummary() and
  usages =
    strictcount(Call c |
      c.getCallee().getSourceDeclaration() = api and
      not c.getFile() instanceof GeneratedFile
    )
}

from ExternalApi api, int usages
where Results<getRelevantUsages/2>::restrict(api, usages)
select api.getApiName() as apiname, usages order by usages desc
