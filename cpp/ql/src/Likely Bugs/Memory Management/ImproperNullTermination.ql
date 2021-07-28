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

class ImproperNullTerminationReachability extends StackVariableReachabilityWithReassignment {
  ImproperNullTerminationReachability() { this = "ImproperNullTerminationReachability" }

  override predicate isSourceActual(ControlFlowNode node, StackVariable v) {
    node = declWithNoInit(v)
    or
    exists(Call c, int arg |
      c = node and
      (
        c.getTarget().hasName("readlink") and arg = 1
        or
        c.getTarget().hasName("readlinkat") and arg = 2
      ) and
      c.getArgument(arg).(VariableAccess).getTarget() = v
    )
  }

  override predicate isSinkActual(ControlFlowNode node, StackVariable v) {
    node.(VariableAccess).getTarget() = v and
    variableMustBeNullTerminated(node)
  }

  override predicate isBarrier(ControlFlowNode node, StackVariable v) {
    exprDefinition(v, node, _) or
    mayAddNullTerminator(node, v.getAnAccess()) or
    isSinkActual(node, v) // only report first use
  }
}

from ImproperNullTerminationReachability r, LocalVariable v, VariableAccess va
where r.reaches(_, v, va)
select va, "Variable $@ may not be null terminated.", v, v.getName()
