/**
 * @name Useless assignment to local variable
 * @description An assignment to a local variable that is not used later on, or whose value is always
 *              overwritten, has no effect.
 * @kind problem
 * @problem.severity warning
 * @id rb/useless-assignment-to-local
 * @tags maintainability
 *       external/cwe/cwe-563
 * @precision low
 */

import ruby
import codeql.ruby.dataflow.SSA

class RelevantLocalVariableWriteAccess extends LocalVariableWriteAccess {
  RelevantLocalVariableWriteAccess() {
    not this.getVariable().getName().charAt(0) = "_" and
    not this = any(Parameter p).getAVariable().getDefiningAccess()
  }
}

from RelevantLocalVariableWriteAccess write, LocalVariable v
where
  v = write.getVariable() and
  exists(write.getAControlFlowNode()) and
  not exists(Ssa::WriteDefinition def | def.getWriteAccess() = write)
select write, "This assignment to $@ is useless, since its value is never read.", v, v.getName()
