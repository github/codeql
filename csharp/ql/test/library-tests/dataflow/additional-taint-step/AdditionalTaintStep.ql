import csharp
import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate
import TestAdditionalTaintStep

from DataFlow::Node src, DataFlow::Node sink, string model
where defaultAdditionalTaintStep(src, sink, model) and model = "AdditionalTaintStep"
select src, sink, model
