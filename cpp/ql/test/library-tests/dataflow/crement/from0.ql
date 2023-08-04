import cpp
import semmle.code.cpp.ir.dataflow.DataFlow

module Cfg implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr().getValue() = "0" }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof VariableAccess }
}

module Flow = DataFlow::Global<Cfg>;

from Expr sink
where Flow::flowToExpr(sink)
select sink
