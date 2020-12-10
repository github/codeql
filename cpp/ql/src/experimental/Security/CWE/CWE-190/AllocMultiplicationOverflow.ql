/**
 * @name Multiplication result may overflow and be used in allocation
 * @description TODO
 * @kind path-problem
 * @problem.severity TODO
 * @precision TODO
 * @tags security
 *       correctness
 *       external/cwe/cwe-190
 *       external/cwe/cwe-128
 * @id cpp/multiplication-overflow-in-alloc
 */

import cpp
import semmle.code.cpp.models.interfaces.Allocation
import semmle.code.cpp.dataflow.DataFlow
import DataFlow::PathGraph

class MultToAllocConfig extends DataFlow::Configuration {
  MultToAllocConfig() { this = "MultToAllocConfig" }

  override predicate isSource(DataFlow::Node node) {
    // a multiplication of two non-constant expressions
    exists(MulExpr me |
      me = node.asExpr() and
      forall(Expr e | e = me.getAnOperand() | not exists(e.getValue()))
    )
  }

  override predicate isSink(DataFlow::Node node) {
    // something that affects an allocation size
    node.asExpr() = any(AllocationExpr ae).getSizeExpr().getAChild*()
  }
}

string describe(DataFlow::PathNode n) {
  result = n.getNode().asExpr().getEnclosingFunction().getName()
}

from MultToAllocConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink, "$@ in " + concat(describe(source), ", "), source, "here"
