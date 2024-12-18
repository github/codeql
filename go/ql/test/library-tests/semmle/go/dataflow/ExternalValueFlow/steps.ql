import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

from DataFlow::Node node1, DataFlow::Node node2
where FlowSummaryImpl::Private::Steps::summaryThroughStepValue(node1, node2, _)
select node1, node2
