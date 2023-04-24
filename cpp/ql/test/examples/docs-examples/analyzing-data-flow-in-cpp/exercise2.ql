import cpp
import semmle.code.cpp.dataflow.new.DataFlow

module LiteralToGethostbynameConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asIndirectExpr(1) instanceof StringLiteral }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall fc |
      sink.asIndirectExpr(1) = fc.getArgument(0) and
      fc.getTarget().hasName("gethostbyname")
    )
  }
}

module LiteralToGethostbynameFlow = DataFlow::Global<LiteralToGethostbynameConfig>;

from StringLiteral sl, FunctionCall fc, DataFlow::Node source, DataFlow::Node sink
where
  source.asIndirectExpr(1) = sl and
  sink.asIndirectExpr(1) = fc.getArgument(0) and
  LiteralToGethostbynameFlow::flow(source, sink)
select sl, fc
