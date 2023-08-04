/**
 * @name Copy function using source size
 * @description Calling a copy operation with a size derived from the source
 *              buffer instead of the destination buffer may result in a buffer overflow.
 * @kind path-problem
 * @id cpp/overflow-destination
 * @problem.severity warning
 * @security-severity 9.3
 * @precision low
 * @tags reliability
 *       security
 *       external/cwe/cwe-119
 *       external/cwe/cwe-131
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.controlflow.IRGuards
import semmle.code.cpp.security.FlowSources
import OverflowDestination::PathGraph

/**
 * Holds if `fc` is a call to a copy operation where the size argument contains
 * a reference to the source argument.  For example:
 * ```
 *   memcpy(dest, src, sizeof(src));
 * ```
 */
predicate sourceSized(FunctionCall fc, Expr src) {
  fc.getTarget().hasGlobalOrStdName(["strncpy", "strncat", "memcpy", "memmove"]) and
  exists(Expr dest, Expr size, Variable v |
    fc.getArgument(0) = dest and
    fc.getArgument(1).getFullyConverted() = src and
    fc.getArgument(2) = size and
    src = v.getAnAccess().getFullyConverted() and
    size.getAChild+() = v.getAnAccess() and
    // exception: `dest` is also referenced in the size argument
    not exists(Variable other |
      dest = other.getAnAccess() and size.getAChild+() = other.getAnAccess()
    ) and
    // exception: `src` and `dest` are both arrays of the same type and size
    not exists(ArrayType srctype, ArrayType desttype |
      dest.getType().getUnderlyingType() = desttype and
      src.getType().getUnderlyingType() = srctype and
      desttype.getBaseType().getUnderlyingType() = srctype.getBaseType().getUnderlyingType() and
      desttype.getArraySize() = srctype.getArraySize()
    )
  )
}

predicate readsVariable(LoadInstruction load, Variable var) {
  load.getSourceAddress().(VariableAddressInstruction).getAstVariable() = var
}

predicate hasUpperBoundsCheck(Variable var) {
  exists(RelationalOperation oper, VariableAccess access |
    oper.getAnOperand() = access and
    access.getTarget() = var and
    // Comparing to 0 is not an upper bound check
    not oper.getAnOperand().getValue() = "0"
  )
}

predicate nodeIsBarrierEqualityCandidate(DataFlow::Node node, Operand access, Variable checkedVar) {
  readsVariable(node.asInstruction(), checkedVar) and
  any(IRGuardCondition guard).ensuresEq(access, _, _, node.asInstruction().getBlock(), true)
}

module OverflowDestinationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof FlowSource }

  predicate isSink(DataFlow::Node sink) { sourceSized(_, sink.asIndirectConvertedExpr()) }

  predicate isBarrier(DataFlow::Node node) {
    exists(Variable checkedVar |
      readsVariable(node.asInstruction(), checkedVar) and
      hasUpperBoundsCheck(checkedVar)
    )
    or
    exists(Variable checkedVar, Operand access |
      readsVariable(access.getDef(), checkedVar) and
      nodeIsBarrierEqualityCandidate(node, access, checkedVar)
    )
  }
}

module OverflowDestination = TaintTracking::Global<OverflowDestinationConfig>;

from FunctionCall fc, OverflowDestination::PathNode source, OverflowDestination::PathNode sink
where
  OverflowDestination::flowPath(source, sink) and
  sourceSized(fc, sink.getNode().asIndirectConvertedExpr())
select fc, source, sink,
  "To avoid overflow, this operation should be bounded by destination-buffer size, not source-buffer size."
