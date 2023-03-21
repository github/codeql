import cpp
import semmle.code.cpp.dataflow.new.DataFlow

class LiteralToGethostbynameConfiguration extends DataFlow::Configuration {
  LiteralToGethostbynameConfiguration() { this = "LiteralToGethostbynameConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asIndirectExpr(1) instanceof StringLiteral
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall fc |
      sink.asIndirectExpr(1) = fc.getArgument(0) and
      fc.getTarget().hasName("gethostbyname")
    )
  }
}

from
  StringLiteral sl, FunctionCall fc, LiteralToGethostbynameConfiguration cfg, DataFlow::Node source,
  DataFlow::Node sink
where
  source.asIndirectExpr(1) = sl and
  sink.asIndirectExpr(1) = fc.getArgument(0) and
  cfg.hasFlow(source, sink)
select sl, fc
