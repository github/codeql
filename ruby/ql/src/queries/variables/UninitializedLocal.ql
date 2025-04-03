/**
 * @name Potentially uninitialized local variable
 * @description Using a local variable before it is initialized gives the variable a default
 *              'nil' value.
 * @kind problem
 * @problem.severity error
 * @id rb/uninitialized-local-variable
 * @tags quality
 *       reliability
 *       correctness
 * @precision medium
 */

import codeql.ruby.AST
import codeql.ruby.dataflow.SSA
private import codeql.ruby.dataflow.internal.DataFlowPublic
import codeql.ruby.controlflow.internal.Guards as Guards
import codeql.ruby.controlflow.CfgNodes

predicate isInBooleanContext(Expr e) {
  e = any(ConditionalExpr c).getCondition()
  or
  e = any(ConditionalLoop l).getCondition()
  or
  e = any(LogicalAndExpr n).getAnOperand()
  or
  e = any(LogicalOrExpr n).getAnOperand()
  or
  e = any(NotExpr n).getOperand()
}

predicate isGuarded(LocalVariableReadAccess read) {
  exists(AstCfgNode guard, boolean branch |
    Guards::guardControlsBlock(guard, read.getAControlFlowNode().getBasicBlock(), branch)
  |
    // guard is `var`
    guard.getAstNode() = read.getVariable().getAnAccess() and
    branch = true
    or
    // guard is `!var`
    guard.getAstNode().(NotExpr).getOperand() = read.getVariable().getAnAccess() and
    branch = false
    or
    // guard is `var.nil?`
    exists(MethodCall c | guard.getAstNode() = c |
      c.getReceiver() = read.getVariable().getAnAccess() and
      c.getMethodName() = "nil?"
    ) and
    branch = false
    or
    // guard is `!var.nil?`
    exists(MethodCall c | guard.getAstNode().(NotExpr).getOperand() = c |
      c.getReceiver() = read.getVariable().getAnAccess() and
      c.getMethodName() = "nil?"
    ) and
    branch = true
  )
}

predicate isNilChecked(LocalVariableReadAccess read) {
  exists(MethodCall c | c.getReceiver() = read |
    c.getMethodName() = "nil?"
    or
    c.isSafeNavigation()
  )
}

class RelevantLocalVariableReadAccess extends LocalVariableReadAccess {
  RelevantLocalVariableReadAccess() {
    not isInBooleanContext(this) and
    not isNilChecked(this) and
    not isGuarded(this)
  }
}

from RelevantLocalVariableReadAccess read, LocalVariable v
where
  v = read.getVariable() and
  exists(Ssa::Definition def |
    def.getAnUltimateDefinition() instanceof Ssa::UninitializedDefinition and
    read = def.getARead().getExpr()
  )
select read, "Local variable $@ may be used before it is initialized.", v, v.getName()
