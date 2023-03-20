import cpp
import semmle.code.cpp.dataflow.new.DataFlow

class EnvironmentToFileConfiguration extends DataFlow::Configuration {
  EnvironmentToFileConfiguration() { this = "EnvironmentToFileConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(Function getenv |
      source.asIndirectExpr(1).(FunctionCall).getTarget() = getenv and
      getenv.hasGlobalName("getenv")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall fc |
      sink.asIndirectExpr(1) = fc.getArgument(0) and
      fc.getTarget().hasGlobalName("fopen")
    )
  }
}

from
  Expr getenv, Expr fopen, EnvironmentToFileConfiguration config, DataFlow::Node source,
  DataFlow::Node sink
where
  source.asIndirectExpr(1) = getenv and
  sink.asIndirectExpr(1) = fopen and
  config.hasFlow(source, sink)
select fopen, "This 'fopen' uses data from $@.", getenv, "call to 'getenv'"
