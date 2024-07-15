import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.dataflow.ExternalFlow

from DataFlow::Node node, string kind
where sinkNode(node, kind)
select node, kind
