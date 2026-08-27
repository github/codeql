/**
 * @name MMIO/DMA unsanitized memory copy
 * @description Memory copy sizes derived from memory-mapped I/O or DMA
 *              descriptor fields without bounds validation may overflow
 *              destination buffers.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.6
 * @precision medium
 * @id cpp/mmio-unsanitized-memcpy
 * @tags security
 *       external/cwe/cwe-120
 *       external/cwe/cwe-787
 */

import cpp
import semmle.code.cpp.dataflow.new.TaintTracking
import semmle.code.cpp.controlflow.IRGuards
import MmioFlow::PathGraph

/** Holds if `e` is an expression that reads MMIO/DMA hardware state. */
predicate isMmioExpr(Expr e) {
  exists(VariableAccess va | va = e and va.getTarget().isVolatile())
  or
  exists(FieldAccess fa | fa = e and fa.getTarget().getType().isVolatile())
  or
  exists(FunctionCall call |
    call = e and
    call.getTarget().hasName(["READ_REG", "GET_MMIO", "REG_READ", "DMA_READ"])
  )
  or
  exists(PointerDereferenceExpr deref |
    deref = e and
    deref.getOperand().getUnspecifiedType() instanceof PointerType and
    deref.getOperand().getUnspecifiedType().(PointerType).getBaseType().isVolatile()
  )
}

predicate isMmioSource(DataFlow::Node source) {
  isMmioExpr(source.asExpr())
  or
  exists(MacroInvocation mi |
    mi.getMacro().hasName(["READ_REG", "GET_MMIO", "REG_READ", "DMA_READ"]) and
    source.asExpr() = mi.getExpr()
  )
}

predicate isMemcpySizeSink(DataFlow::Node sink, FunctionCall fc) {
  fc.getTarget().hasName(["memcpy", "memmove", "strncpy", "wmemcpy", "wmemmove"]) and
  sink.asExpr() = fc.getArgument(2)
}

/** Recognizes relational comparison bounds checks using public IRGuards API. */
predicate lessThanOrEqual(IRGuardCondition g, Expr e, boolean branch) {
  exists(Operand left |
    g.comparesLt(left, _, _, true, branch) or
    g.comparesEq(left, _, _, true, branch)
  |
    left.getDef().getConvertedResultExpression() = e
  )
}

module MmioConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isMmioSource(source) }

  predicate isSink(DataFlow::Node sink) { isMemcpySizeSink(sink, _) }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<lessThanOrEqual/3>::getABarrierNode() or
    node = DataFlow::BarrierGuard<lessThanOrEqual/3>::getAnIndirectBarrierNode()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module MmioFlow = TaintTracking::Global<MmioConfig>;

from FunctionCall memcpyCall, MmioFlow::PathNode source, MmioFlow::PathNode sink
where
  MmioFlow::flowPath(source, sink) and
  isMemcpySizeSink(sink.getNode(), memcpyCall)
select memcpyCall, source, sink,
  "Memory copy size argument is derived from $@ without sufficient bounds validation.",
  source.getNode(), "an MMIO/DMA hardware register read"
