import cpp
import semmle.code.cpp.dataflow.new.DataFlow

from StringLiteral sl, FunctionCall fc, DataFlow::Node source, DataFlow::Node sink
where
  fc.getTarget().hasName("gethostbyname") and
  source.asIndirectExpr(1) = sl and
  sink.asIndirectExpr(1) = fc.getArgument(0) and
  DataFlow::localFlow(source, sink)
select sl, fc
