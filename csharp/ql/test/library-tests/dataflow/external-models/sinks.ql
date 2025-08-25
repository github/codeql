import csharp
import DataFlow
import semmle.code.csharp.dataflow.internal.ExternalFlow
import ModelValidation

from DataFlow::Node node, string kind
where sinkNode(node, kind)
select node, kind
