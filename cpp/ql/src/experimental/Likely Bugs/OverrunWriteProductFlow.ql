/**
 * @id cpp/overrun-write
 * @kind path-problem
 */

import cpp
import experimental.semmle.code.cpp.dataflow.ProductFlow
import semmle.code.cpp.ir.IR
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.models.interfaces.Allocation
import semmle.code.cpp.models.interfaces.ArrayFunction
import DataFlow::PathGraph

class StringSizeConfiguration extends ProductFlow::Configuration {
  StringSizeConfiguration() { this = "StringSizeConfiguration" }

  override predicate isSourcePair(DataFlow::Node bufSource, DataFlow::Node sizeSource) {
    bufSource.asConvertedExpr().(AllocationExpr).getSizeExpr() = sizeSource.asConvertedExpr()
  }

  override predicate isSinkPair(DataFlow::Node bufSink, DataFlow::Node sizeSink) {
    exists(CallInstruction c, int bufIndex, int sizeIndex |
      c.getStaticCallTarget().(ArrayFunction).hasArrayWithVariableSize(bufIndex, sizeIndex) and
      c.getArgument(bufIndex) = bufSink.asInstruction() and
      c.getArgument(sizeIndex) = sizeSink.asInstruction()
    )
  }
}

// we don't actually check correctness yet. Right now the query just finds relevant source/sink pairs.
from
  StringSizeConfiguration conf, DataFlow::PathNode source1, DataFlow2::PathNode source2,
  DataFlow::PathNode sink1, DataFlow2::PathNode sink2
where conf.hasFlowPath(source1, source2, sink1, sink2)
// TODO: pull delta out and display it
select sink1.getNode(), source1, sink1, "overrunning write allocated at $@ bounded by $@", source1,
  source1.toString(), sink2, sink2.toString()
