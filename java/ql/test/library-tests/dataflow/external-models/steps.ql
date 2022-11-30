import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import ModelValidation
import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

from DataFlow::Node node1, DataFlow::Node node2
where FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(node1, node2, _)
select node1, node2
