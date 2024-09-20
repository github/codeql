import csharp
import semmle.code.csharp.dataflow.internal.ExternalFlow

from DataFlow::Node source
where sourceNode(source, "environment")
select source
