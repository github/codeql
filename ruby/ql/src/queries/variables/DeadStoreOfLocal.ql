/**
 * @name Useless assignment to local variable
 * @description An assignment to a local variable that is not used later on, or whose value is always
 *              overwritten, has no effect.
 * @kind problem
 * @problem.severity warning
 * @id rb/useless-assignment-to-local
 * @tags maintainability
 *       quality
 *       external/cwe/cwe-563
 * @precision medium
 */

import codeql.ruby.AST
import codeql.ruby.CFG
import codeql.ruby.dataflow.SSA
import codeql.ruby.ApiGraphs

pragma[nomagic]
private predicate hasErbResultCall(CfgScope scope) {
  scope = API::getTopLevelMember("ERB").getInstance().getAMethodCall("result").asExpr().getScope()
}

class RelevantLocalVariableWriteAccess extends LocalVariableWriteAccess {
  RelevantLocalVariableWriteAccess() {
    not this.getVariable().getName().charAt(0) = "_" and
    not this = any(Parameter p).getAVariable().getDefiningAccess() and
    not hasErbResultCall(this.getCfgScope()) and
    not exists(RetryStmt r | r.getCfgScope() = this.getCfgScope()) and
    not exists(MethodCall c |
      c.getReceiver() instanceof SelfVariableAccess and
      c.getMethodName() = "binding" and
      c.getCfgScope() = this.getCfgScope()
    )
  }
}

from RelevantLocalVariableWriteAccess write, LocalVariable v
where
  v = write.getVariable() and
  exists(write.getAControlFlowNode()) and
  not exists(Ssa::WriteDefinition def | def.getWriteAccess().getAstNode() = write)
select write, "This assignment to $@ is useless, since its value is never read.", v, v.getName()
