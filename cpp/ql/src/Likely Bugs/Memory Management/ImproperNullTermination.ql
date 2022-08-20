/**
 * @name Potential improper null termination
 * @description Using a string that may not be null terminated as an argument
 *              to a string function can result in buffer overflow or buffer over-read.
 * @kind problem
 * @id cpp/improper-null-termination
 * @problem.severity warning
 * @security-severity 7.8
 * @tags security
 *       external/cwe/cwe-170
 *       external/cwe/cwe-665
 */

import cpp
import semmle.code.cpp.controlflow.StackVariableReachability
import semmle.code.cpp.commons.NullTermination

/**
 * A declaration of a local variable that leaves the variable uninitialized.
 */
DeclStmt declWithNoInit(LocalVariable v) {
  result.getADeclaration() = v and
  not exists(v.getInitializer())
}

/**
 * Control flow reachability from a buffer that is not not null terminated to a
 * sink that requires null termination.
 */
class ImproperNullTerminationReachability extends StackVariableReachabilityWithReassignment {
  ImproperNullTerminationReachability() { this = "ImproperNullTerminationReachability" }

  override predicate isSourceActual(ControlFlowNode node, StackVariable v) {
    node = declWithNoInit(v)
    or
    exists(Call c, int bufferArg, int sizeArg |
      c = node and
      (
        c.getTarget().hasName("readlink") and bufferArg = 1 and sizeArg = 2
        or
        c.getTarget().hasName("readlinkat") and bufferArg = 2 and sizeArg = 3
      ) and
      c.getArgument(bufferArg).(VariableAccess).getTarget() = v and
      (
        // buffer size parameter likely matches the full buffer size
        c.getArgument(sizeArg) instanceof SizeofOperator or
        c.getArgument(sizeArg).getValue().toInt() = v.getType().getSize()
      )
    )
  }

  override predicate isSinkActual(ControlFlowNode node, StackVariable v) {
    node.(VariableAccess).getTarget() = v and
    variableMustBeNullTerminated(node)
  }

  override predicate isBarrier(ControlFlowNode node, StackVariable v) {
    exprDefinition(v, node, _) or
    isSinkActual(node, v) // only report first use
  }
}

/**
 * Flow from a place where null termination is added, to a sink of
 * `ImproperNullTerminationReachability`. This was previously implemented as a
 * simple barrier in `ImproperNullTerminationReachability`, but there were
 * false positive results involving multiple paths from source to sink.  We'd
 * prefer to report only the results we are sure of.
 */
class NullTerminationReachability extends StackVariableReachabilityWithReassignment {
  NullTerminationReachability() { this = "NullTerminationReachability" }

  override predicate isSourceActual(ControlFlowNode node, StackVariable v) {
    mayAddNullTerminator(node, v.getAnAccess()) or // null termination
    node.(AddressOfExpr).getOperand() = v.getAnAccess() // address taken (possible null termination)
  }

  override predicate isSinkActual(ControlFlowNode node, StackVariable v) {
    // have the same sinks as `ImproperNullTerminationReachability`.
    exists(ImproperNullTerminationReachability r | r.isSinkActual(node, v))
  }

  override predicate isBarrier(ControlFlowNode node, StackVariable v) {
    // don't look further back than the source, or further forward than the sink
    exists(ImproperNullTerminationReachability r | r.isSourceActual(node, v)) or
    exists(ImproperNullTerminationReachability r | r.isSinkActual(node, v))
  }
}

from
  ImproperNullTerminationReachability reaches, NullTerminationReachability nullTermReaches,
  ControlFlowNode source, LocalVariable v, VariableAccess sink
where
  reaches.reaches(source, v, sink) and
  not exists(ControlFlowNode termination |
    nullTermReaches.reaches(termination, _, sink) and
    termination != source
  )
select sink, "Variable $@ may not be null terminated.", v, v.getName()
