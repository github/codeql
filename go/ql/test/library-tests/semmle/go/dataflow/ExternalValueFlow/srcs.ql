import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation

from DataFlow::Node node, string kind
where sourceNode(node, kind)
select node, kind
