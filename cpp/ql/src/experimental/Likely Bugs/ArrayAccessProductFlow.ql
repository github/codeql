import cpp
import experimental.semmle.code.cpp.dataflow.ProductFlow
import experimental.semmle.code.cpp.semantic.analysis.RangeAnalysis
import experimental.semmle.code.cpp.rangeanalysis.Bound
import experimental.semmle.code.cpp.semantic.SemanticExprSpecific
import semmle.code.cpp.ir.IR
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.models.interfaces.Allocation
import semmle.code.cpp.ir.IRConfiguration

// temporary - custom allocator for ffmpeg
class AvBufferAlloc extends AllocationFunction {
  AvBufferAlloc() { this.hasGlobalName(["av_mallocz", "av_malloc"]) }

  override int getSizeArg() { result = 0 }
}

predicate bounded(Instruction i, Bound b, int delta, boolean upper) {
  // TODO: reason
  semBounded(getSemanticExpr(i), b, delta, upper, _)
}

class ArraySizeConfiguration extends ProductFlow::Configuration {
  ArraySizeConfiguration() { this = "ArraySizeConfiguration" }

  override predicate isSourcePair(DataFlow::Node source1, DataFlow::Node source2) {
    exists(GVN sizeGvn |
      source1.asConvertedExpr().(AllocationExpr).getSizeExpr() = sizeGvn.getAnExpr() and
      source2.asConvertedExpr() = sizeGvn.getAnExpr()
    )
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
select source1, source2, sink1, sink2
