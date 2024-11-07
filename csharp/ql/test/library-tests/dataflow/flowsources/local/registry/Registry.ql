import csharp
import semmle.code.csharp.security.dataflow.flowsources.FlowSources

from DataFlow::Node source
where source instanceof ActiveThreatModelSource
select source, source.(SourceNode).getThreatModel()
