import cpp
import semmle.code.cpp.dataflow.new.DataFlow

class GetenvSource extends DataFlow::Node {
  GetenvSource() { this.asIndirectExpr(1).(FunctionCall).getTarget().hasGlobalName("getenv") }
}

module GetenvToGethostbynameConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof GetenvSource }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall fc |
      sink.asIndirectExpr(1) = fc.getArgument(0) and
      fc.getTarget().hasName("gethostbyname")
    )
  }
}

module GetenvToGethostbynameFlow = DataFlow::Global<GetenvToGethostbynameConfig>;

from Expr getenv, FunctionCall fc, DataFlow::Node source, DataFlow::Node sink
where
  source.asIndirectExpr(1) = getenv and
  sink.asIndirectExpr(1) = fc.getArgument(0) and
  GetenvToGethostbynameFlow::flow(source, sink)
select getenv, fc
