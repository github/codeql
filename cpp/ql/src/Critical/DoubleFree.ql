/**
 * @name Potential double free
 * @description An allocated memory block is free multiple times. Behavior in such cases is undefined and can cause memory corruption.
 * @kind path-problem
 * @precision medium
 * @id cpp/double-free
 * @problem.severity warning
 * @security-severity 9.3
 * @tags reliability
 *       security
 *       external/cwe/cwe-415
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import FlowAfterFree
import DoubleFree::PathGraph

predicate isFree(DataFlow::Node n, Expr e) { isFree(n, e, _) }

/**
 * Holds if `fc` is a function call that is the result of expanding
 * the `ExFreePool` macro.
 */
predicate isExFreePoolCall(FunctionCall fc) {
  exists(MacroInvocation mi |
    mi.getMacroName() = "ExFreePool" and
    mi.getExpr() = fc
  )
  or
  fc.getTarget().hasGlobalName("ExFreePool")
}

bindingset[dealloc1, e]
predicate isExcludeFreePair(DeallocationExpr dealloc1, Expr e) {
  exists(DeallocationExpr dealloc2 | isFree(_, e, dealloc2) |
    dealloc1.(FunctionCall).getTarget().hasGlobalName("MmFreePagesFromMdl") and
    // From https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/wdm/nf-wdm-mmfreepagesfrommdl:
    // "After calling MmFreePagesFromMdl, the caller must also call ExFreePool
    // to release the memory that was allocated for the MDL structure."
    isExFreePoolCall(dealloc2)
  )
}

module DoubleFree = FlowFromFree<isFree/2, isExcludeFreePair/2>;

from DoubleFree::PathNode source, DoubleFree::PathNode sink, DeallocationExpr dealloc, Expr e2
where
  DoubleFree::flowPath(source, sink) and
  isFree(source.getNode(), _, dealloc) and
  isFree(sink.getNode(), e2)
select sink.getNode(), source, sink,
  "Memory pointed to by '" + e2.toString() + "' may already have been freed by $@.", dealloc,
  dealloc.toString()
