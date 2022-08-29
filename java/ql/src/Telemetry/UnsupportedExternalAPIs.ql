/**
 * @name Usage of unsupported APIs coming from external libraries
 * @description A list of 3rd party APIs used in the codebase. Excludes test and generated code.
 * @kind metric
 * @tags summary telemetry
 * @id java/telemetry/unsupported-external-api
 */

import java
import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import ExternalApi

private predicate getRelevantUsages(ExternalApi api, int usages) {
  not api.isUninteresting() and
  not api.isSupported() and
  not api instanceof FlowSummaryImpl::Public::NegativeSummarizedCallable and
  usages =
    strictcount(Call c |
      c.getCallee().getSourceDeclaration() = api and
      not c.getFile() instanceof GeneratedFile
    )
}

from ExternalApi api, int usages
where Results<getRelevantUsages/2>::restrict(api, usages)
select api.getApiName() as apiname, usages order by usages desc
