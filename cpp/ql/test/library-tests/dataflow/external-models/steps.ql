import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.dataflow.ExternalFlow
import semmle.code.cpp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

from DataFlow::Node node1, DataFlow::Node node2
where FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(node1, node2, _)
select node1, node2
