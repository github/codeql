import cpp
import semmle.code.cpp.dataflow.new.DataFlow

class GetenvSource extends DataFlow::Node {
  GetenvSource() { this.asIndirectExpr(1).(FunctionCall).getTarget().hasQualifiedName("getenv") }
}

class GetenvToGethostbynameConfiguration extends DataFlow::Configuration {
  GetenvToGethostbynameConfiguration() { this = "GetenvToGethostbynameConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof GetenvSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall fc |
      sink.asIndirectExpr(1) = fc.getArgument(0) and
      fc.getTarget().hasName("gethostbyname")
    )
  }
}

from
  Expr getenv, FunctionCall fc, GetenvToGethostbynameConfiguration cfg, DataFlow::Node source,
  DataFlow::Node sink
where
  source.asIndirectExpr(1) = getenv and
  sink.asIndirectExpr(1) = fc.getArgument(0) and
  cfg.hasFlow(source, sink)
select getenv, fc
