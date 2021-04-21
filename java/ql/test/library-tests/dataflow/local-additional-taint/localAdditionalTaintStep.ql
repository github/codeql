import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.internal.TaintTrackingUtil

from DataFlow::Node src, DataFlow::Node sink
where
  localAdditionalTaintStep(src, sink) and
  src.getLocation().getFile().getExtension() = "java"
select src, sink
