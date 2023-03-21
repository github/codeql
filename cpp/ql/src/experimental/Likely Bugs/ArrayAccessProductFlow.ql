/**
 * @name Off-by-one in array access
 * @description TODO
 * @kind path-problem
 * @problem.severity error
 * @id cpp/off-by-one-array-access
 * @tags reliability
 *       security
 *       experimental
 */

import cpp
import experimental.semmle.code.cpp.dataflow.ProductFlow
import experimental.semmle.code.cpp.semantic.analysis.RangeAnalysis
import experimental.semmle.code.cpp.rangeanalysis.Bound
import experimental.semmle.code.cpp.semantic.SemanticExprSpecific
import semmle.code.cpp.ir.IR
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.models.interfaces.Allocation
import semmle.code.cpp.ir.IRConfiguration
import DataFlow::PathGraph

// temporary - custom allocator for ffmpeg
class AvBufferAlloc extends AllocationFunction {
  AvBufferAlloc() { this.hasGlobalName(["av_mallocz", "av_malloc"]) }

  override int getSizeArg() { result = 0 }
}

// temporary - custom allocator for php
class PhpEmalloc extends AllocationFunction {
  PhpEmalloc() { this.hasGlobalName(["_emalloc"]) }

  override int getSizeArg() { result = 0 }
}

predicate bounded(Instruction i, Bound b, int delta, boolean upper) {
  // TODO: reason
  semBounded(getSemanticExpr(i), b, delta, upper, _)
}

class ArraySizeConfiguration extends ProductFlow::Configuration {
  ArraySizeConfiguration() { this = "ArraySizeConfiguration" }

  override predicate isSourcePair(DataFlow::Node source1, DataFlow::Node source2) {
    source1.asConvertedExpr().(AllocationExpr).getSizeExpr() = source2.asConvertedExpr()
  }

  override predicate isSinkPair(DataFlow::Node sink1, DataFlow::Node sink2) {
    exists(PointerAddInstruction pai, int delta |
      isSinkPair1(sink1, sink2, pai, delta) and
      (
        delta = 0 and
        exists(DataFlow::Node paiNode, DataFlow::Node derefNode |
          DataFlow::localFlow(paiNode, derefNode) and
          paiNode.asInstruction() = pai and
          derefNode.asOperand() instanceof AddressOperand
        )
        or
        delta >= 1
      )
    )
  }
}

pragma[nomagic]
predicate isSinkPair1(
  DataFlow::Node sink1, DataFlow::Node sink2, PointerAddInstruction pai, int delta
) {
  exists(Instruction index, ValueNumberBound b |
    pai.getRight() = index and
    pai.getLeft() = sink1.asInstruction() and
    bounded(index, b, delta, true) and
    sink2.asInstruction() = b.getInstruction()
  )
}

from
  ArraySizeConfiguration conf, DataFlow::PathNode source1, DataFlow2::PathNode source2,
  DataFlow::PathNode sink1, DataFlow2::PathNode sink2
where conf.hasFlowPath(source1, source2, sink1, sink2)
// TODO: pull delta out and display it
select sink1.getNode(), source1, sink1, "Off-by one error allocated at $@ bounded by $@.", source1,
  source1.toString(), sink2, sink2.toString()
