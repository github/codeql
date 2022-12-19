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

private predicate relevant(ExternalApi api) {
  not api.isSupported() and
  not api = any(FlowSummaryImpl::Public::NeutralCallable nsc).asCallable()
}

from string apiName, int usages
where Results<relevant/1>::restrict(apiName, usages)
select apiName, usages order by usages desc
