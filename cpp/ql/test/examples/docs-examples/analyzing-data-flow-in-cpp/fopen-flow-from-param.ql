import cpp
import semmle.code.cpp.dataflow.new.DataFlow

from Function fopen, FunctionCall fc, Parameter p, DataFlow::Node source, DataFlow::Node sink
where
  fopen.hasGlobalName("fopen") and
  fc.getTarget() = fopen and
  source.asParameter(1) = p and
  sink.asIndirectExpr(1) = fc.getArgument(0) and
  DataFlow::localFlow(source, sink)
select p
