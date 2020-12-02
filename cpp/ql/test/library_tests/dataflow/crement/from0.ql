import cpp
import semmle.code.cpp.ir.dataflow.DataFlow

class Cfg extends DataFlow::Configuration {
  Cfg() { this = "from0::Cfg" }

  override predicate isSource(DataFlow::Node source) { source.asExpr().getValue() = "0" }

  override predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof VariableAccess }
}

from Cfg cfg, Expr sink
where cfg.hasFlowToExpr(sink)
select sink
