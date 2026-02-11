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
 * @precision high
 */

import codeql.ruby.AST
import codeql.ruby.dataflow.SSA
import codeql.ruby.controlflow.internal.Guards as Guards
import codeql.ruby.controlflow.CfgNodes
import codeql.ruby.ast.internal.Variable

private predicate isInBooleanContext(AstNode n) {
  exists(ConditionalExpr i |
    n = i.getCondition()
    or
    isInBooleanContext(i) and
    n = i.getBranch(_)
  )
  or
  n = any(ConditionalLoop parent).getCondition()
  or
  n = any(InClause parent).getCondition()
  or
  n = any(LogicalAndExpr op).getAnOperand()
  or
  n = any(LogicalOrExpr op).getAnOperand()
  or
  n = any(NotExpr op).getOperand()
  or
  n = any(StmtSequence parent | isInBooleanContext(parent)).getLastStmt()
  or
  exists(CaseExpr c, WhenClause w |
    not exists(c.getValue()) and
    c.getABranch() = w
  |
    w.getPattern(_) = n
    or
    w = n
  )
}

private predicate isGuarded(LocalVariableReadAccess read) {
  exists(AstCfgNode guard, boolean branch |
    Guards::guardControlsBlock(guard, read.getAControlFlowNode().getBasicBlock(), branch)
  |
    // guard is `var`
    guard.getAstNode() = read.getVariable().getAnAccess() and
    branch = true
    or
    // guard is `var.nil?`
    exists(MethodCall c | guard.getAstNode() = c |
      c.getReceiver() = read.getVariable().getAnAccess() and
      c.getMethodName() = "nil?"
    ) and
    branch = false
  )
}

private predicate isNilChecked(LocalVariableReadAccess read) {
  exists(MethodCall c | c.getReceiver() = read |
    c.getMethodName() = "nil?"
    or
    c.isSafeNavigation()
  )
}

/**
 * Holds if `name` is the name of a method defined on `nil`.
 * See https://ruby-doc.org/core-2.5.8/NilClass.html
 */
private predicate isNilMethodName(string name) {
  name in [
      "inspect", "instance_of?", "is_a?", "kind_of?", "method", "nil?", "rationalize", "to_a",
      "to_c", "to_f", "to_h", "to_i", "to_r", "to_s"
    ]
}

class RelevantLocalVariableReadAccess extends LocalVariableReadAccess instanceof TVariableAccessReal
{
  RelevantLocalVariableReadAccess() {
    not isInBooleanContext(this) and
    not isNilChecked(this) and
    not isGuarded(this) and
    this = any(MethodCall m | not isNilMethodName(m.getMethodName())).getReceiver()
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
