import cpp
import experimental.semmle.code.cpp.dataflow.ProductFlow
import semmle.code.cpp.ir.IR
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.models.interfaces.Allocation
import semmle.code.cpp.models.interfaces.ArrayFunction

class StringSizeConfiguration extends ProductFlow::Configuration {
  StringSizeConfiguration() { this = "StringSizeConfiguration" }

  override predicate isSourcePair(DataFlow::Node bufSource, DataFlow::Node sizeSource) {
    exists(
      GVN sizeGVN // TODO: use-use flow instead of GVN
    |
      bufSource.asConvertedExpr().(AllocationExpr).getSizeExpr() = sizeGVN.getAnExpr() and
      sizeSource.asConvertedExpr() = sizeGVN.getAnExpr()
    )
  }

  override predicate isSinkPair(DataFlow::Node bufSink, DataFlow::Node sizeSink) {
    exists(CallInstruction c, int bufIndex, int sizeIndex |
      c.getStaticCallTarget().(ArrayFunction).hasArrayWithVariableSize(bufIndex, sizeIndex) and
      c.getArgument(bufIndex) = bufSink.asInstruction() and
      c.getArgument(sizeIndex) = sizeSink.asInstruction()
    )
  }
}

from StringSizeConfiguration conf, DataFlow::PathNode source1, DataFlow2::PathNode source2, DataFlow::PathNode sink1, DataFlow2::PathNode sink2
where conf.hasFlowPath(source1, source2, sink1, sink2)
select source1, source2, sink1, sink2
