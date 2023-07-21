import cpp
import semmle.code.cpp.dataflow.new.DataFlow

module EnvironmentToFileConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(Function getenv |
      source.asIndirectExpr(1).(FunctionCall).getTarget() = getenv and
      getenv.hasGlobalName("getenv")
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall fc |
      sink.asIndirectExpr(1) = fc.getArgument(0) and
      fc.getTarget().hasGlobalName("fopen")
    )
  }
}

module EnvironmentToFileFlow = DataFlow::Global<EnvironmentToFileConfig>;

from Expr getenv, Expr fopen, DataFlow::Node source, DataFlow::Node sink
where
  source.asIndirectExpr(1) = getenv and
  sink.asIndirectExpr(1) = fopen and
  EnvironmentToFileFlow::flow(source, sink)
select fopen, "This 'fopen' uses data from $@.", getenv, "call to 'getenv'"
