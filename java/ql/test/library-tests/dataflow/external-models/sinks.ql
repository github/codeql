import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import ModelValidation

from DataFlow::Node node, string kind
where sinkNode(node, kind)
select node, kind
