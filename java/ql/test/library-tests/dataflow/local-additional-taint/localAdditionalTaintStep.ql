import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.internal.TaintTrackingUtil
import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

from DataFlow::Node src, DataFlow::Node sink
where
  (
    localAdditionalTaintStep(src, sink) or
    FlowSummaryImpl::Private::Steps::summaryThroughStep(src, sink, false)
  ) and
  not FlowSummaryImpl::Private::Steps::summaryLocalStep(src, sink, false)
select src, sink
