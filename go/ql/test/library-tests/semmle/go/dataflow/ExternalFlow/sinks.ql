import go
import semmle.go.dataflow.ExternalFlow
import CsvValidation

from DataFlow::Node node, string kind
where sinkNode(node, kind)
select node, kind
