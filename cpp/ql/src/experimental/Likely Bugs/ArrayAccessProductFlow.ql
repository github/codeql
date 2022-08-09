import cpp
import experimental.semmle.code.cpp.dataflow.ProductFlow
import experimental.semmle.code.cpp.semantic.analysis.RangeAnalysis
import experimental.semmle.code.cpp.rangeanalysis.Bound
import experimental.semmle.code.cpp.semantic.SemanticExprSpecific
import semmle.code.cpp.ir.IR
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.models.interfaces.Allocation

predicate bounded(Instruction i, Bound b, int delta, boolean upper) {
  // TODO: reason
  semBounded(getSemanticExpr(i), b, delta, upper, _)
}

class ArraySizeConfiguration extends ProductFlow::Configuration {
  ArraySizeConfiguration() { this = "ArraySizeConfiguration" }

  override predicate isSourcePair(DataFlow::Node source1, DataFlow::Node source2) {
    exists(GVN sizeGVN |
      source1.asConvertedExpr().(AllocationExpr).getSizeExpr() = sizeGVN.getAnExpr() and
      source2.asConvertedExpr() = sizeGVN.getAnExpr()
    )
  }

  override predicate isSinkPair(DataFlow::Node sink1, DataFlow::Node sink2) {
    exists(PointerAddInstruction pai, Instruction index, Bound b, int delta |
      pai.getRight() = index and
      pai.getLeft() = sink1.asInstruction() and
      bounded(index, b, delta, true) and
      sink2.asInstruction() = b.getInstruction())
  }
}

predicate hasFlow1(DataFlow::PathNode source, DataFlow::PathNode sink) {
  any(ProductFlow::Conf1 conf).hasFlowPath(source, sink)
}

predicate hasFlow2(DataFlow2::PathNode source, DataFlow2::PathNode sink) {
    any(ProductFlow::Conf2 conf).hasFlowPath(source, sink)
  }


  predicate hasPartialFlow2(DataFlow2::PartialPathNode source, DataFlow2::PartialPathNode sink) {
    any(ProductFlow::Conf2 conf).hasPartialFlow(source, sink, _)
  }

from ArraySizeConfiguration conf, DataFlow::PathNode source1, DataFlow2::PathNode source2, DataFlow::PathNode sink1, DataFlow2::PathNode sink2
where conf.hasFlowPath(source1, source2, sink1, sink2)
select source1, source2, sink1, sink2