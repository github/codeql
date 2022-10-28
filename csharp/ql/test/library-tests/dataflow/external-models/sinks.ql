import csharp
import DataFlow
import semmle.code.csharp.dataflow.ExternalFlow
import CsvValidation

from DataFlow::Node node, string kind
where sinkNode(node, kind)
select node, kind
