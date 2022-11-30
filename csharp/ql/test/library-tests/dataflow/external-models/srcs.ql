import csharp
import DataFlow
import semmle.code.csharp.dataflow.ExternalFlow
import ModelValidation

from DataFlow::Node node, string kind
where sourceNode(node, kind)
select node, kind
