/**
 * @name Overflow in uncontrolled allocation size
 * @description Allocating memory with a size controlled by an external
 *              user can result in integer overflow.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cpp/uncontrolled-allocation-size
 * @tags reliability
 *       security
 *       external/cwe/cwe-190
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.controlflow.IRGuards
import semmle.code.cpp.ir.ValueNumbering
import DataFlow::PathGraph
import semmle.code.cpp.ir.IR

/**
 * Holds if `alloc` is an allocation, and `tainted` is a child of it that is a
 * taint sink.
 */
predicate allocSink(Expr alloc, Expr tainted) {
  isAllocationExpr(alloc) and
  tainted = alloc.getAChild() and
  tainted.getUnspecifiedType() instanceof IntegralType
}

class TaintedAllocationSizeConfiguration extends TaintTracking::Configuration {
  TaintedAllocationSizeConfiguration() { this = "TaintedAllocationSizeConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource or source instanceof LocalFlowSource
  }

  override predicate isSink(DataFlow::Node sink) { allocSink(_, sink.asExpr()) }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof UpperBoundGuard
    or
    guard instanceof EqualityGuard
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.asInstruction() instanceof BoundedVariableRead
  }
}

class UpperBoundGuard extends DataFlow::BarrierGuard {
  UpperBoundGuard() { this.comparesLt(_, _, _, _, _) }

  override predicate checks(Instruction i, boolean b) { this.comparesLt(i.getAUse(), _, _, _, b) }
}

class EqualityGuard extends DataFlow::BarrierGuard {
  EqualityGuard() { this.comparesEq(_, _, _, _, _) }

  override predicate checks(Instruction i, boolean b) { this.comparesEq(i.getAUse(), _, _, true, b) }
}

private predicate readsVariable(LoadInstruction load, Variable var) {
  load.getSourceAddress().(VariableAddressInstruction).getASTVariable() = var
}

/**
 * A variable that has any kind of upper-bound check anywhere in the program.  This is
 * biased towards being inclusive because there are a lot of valid ways of doing an
 * upper bounds checks if we don't consider where it occurs, for example:
 * ```
 *   if (x < 10) { sink(x); }
 *
 *   if (10 > y) { sink(y); }
 *
 *   if (z > 10) { z = 10; }
 *   sink(z);
 * ```
 */
// TODO: This coarse overapproximation, ported from the old taint tracking
// library, could be replaced with an actual semantic check that a particular
// variable _access_ is guarded by an upper-bound check. We probably don't want
// to do this right away since it could expose a lot of FPs that were
// previously suppressed by this predicate by coincidence.
private predicate hasUpperBoundsCheck(Variable var) {
  exists(RelationalOperation oper, VariableAccess access |
    oper.getAnOperand() = access and
    access.getTarget() = var and
    // Comparing to 0 is not an upper bound check
    not oper.getAnOperand().getValue() = "0"
  )
}

/**
 * A read of a variable that has an upper-bound check somewhere in the
 * program.
 */
class BoundedVariableRead extends LoadInstruction {
  BoundedVariableRead() {
    exists(Variable checkedVar |
      readsVariable(this, checkedVar) and
      hasUpperBoundsCheck(checkedVar)
    )
  }
}

predicate taintedAllocSize(
  Expr source, Expr alloc, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode,
  string taintCause
) {
  exists(Expr tainted, DataFlow::Node rawSourceNode, TaintedAllocationSizeConfiguration config |
    allocSink(alloc, tainted) and
    (
      rawSourceNode.asExpr() = source or
      rawSourceNode.asDefiningArgument() = source
    ) and
    sourceNode.getNode() = rawSourceNode and
    config.hasFlowPath(sourceNode, sinkNode) and
    tainted = sinkNode.getNode().(DataFlow::ExprNode).getConvertedExpr() and
    (
      taintCause = rawSourceNode.(RemoteFlowSource).getSourceType() or
      taintCause = rawSourceNode.(LocalFlowSource).getSourceType()
    )
  )
}

from
  Expr source, Expr alloc, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode,
  string taintCause
where taintedAllocSize(source, alloc, sourceNode, sinkNode, taintCause)
select alloc, sourceNode, sinkNode, "This allocation size is derived from $@ and might overflow",
  source, "user input (" + taintCause + ")"
