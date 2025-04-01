/**
 * @name Potentially uninitialized local variable
 * @description Using a local variable before it is initialized gives the variable a default
 *              'nil' value.
 * @kind problem
 * @problem.severity error
 * @id rb/uninitialized-local-variable
 * @tags reliability
 *       correctness
 * @precision low
 */

import codeql.ruby.AST
import codeql.ruby.dataflow.SSA
private import codeql.ruby.dataflow.internal.DataFlowPublic

predicate factor(Expr e, Expr factor) {
  factor = e
  or
  e.(BinaryOperation).getOperator() = ["||", "&&"] and
  factor = e.(BinaryOperation).getAnOperand()
  or
  e.(BinaryOperation).getOperator() = ["||", "&&"] and
  factor(e.(BinaryOperation).getAnOperand(), factor)
}

predicate previousConjunct(Expr e, Expr prev) {
  exists(BinaryOperation b |
    b.getOperator() = "&&" and
    b.getRightOperand() = e
  |
    // 'prev' && 'e'
    prev = b.getLeftOperand()
    or
    // (... && 'prev') && 'e'
    b.getLeftOperand().(BinaryOperation).getOperator() = "&&" and
    prev = b.getLeftOperand().(BinaryOperation).getRightOperand()
    or
    // (subtree['prev'] && _) && 'e'
    b.getLeftOperand().(BinaryOperation).getOperator() = "&&" and
    previousConjunct(b.getLeftOperand().(BinaryOperation).getRightOperand(), prev)
  )
}

Expr evaluatingMention(LocalVariableReadAccess read) {
  result = read
  or
  result.(AssignExpr).getLeftOperand() = read
  or
  result.(NotExpr).getOperand() = read
}

class RelevantLocalVariableReadAccess extends LocalVariableReadAccess {
  RelevantLocalVariableReadAccess() {
    not exists(MethodCall c |
      c.getReceiver() = this and
      c.getMethodName() = "nil?"
    ) and
    // 'a' is fine to be uninitialised in 'a || ...'
    not exists(BinaryOperation b |
      b.getLeftOperand() = this and
      b.getOperator() = "||"
    ) and
    // The second 'a' cannot be uninitialised in 'a && (...a...)'
    not exists(Expr parent |
      parent.getAChild*() = this and
      previousConjunct(parent, this.getVariable().getAnAccess())
    ) and
    // Various guards
    not exists(ConditionalExpr c | factor(c.getCondition(), evaluatingMention(this))) and
    not exists(ConditionalExpr c | factor(c.getCondition(), this.getVariable().getAnAccess()) |
      this = c.getBranch(true).getAChild*()
    )
  }
}

from RelevantLocalVariableReadAccess read, LocalVariable v, Node source
where
  v = read.getVariable() and
  exists(Ssa::Definition def, Ssa::UninitializedDefinition uninit, Node sink |
    uninit = def.getAnUltimateDefinition() and
    // def.getAnUltimateDefinition() instanceof Ssa::UninitializedDefinition and
    read = def.getARead().getExpr() and
    // localFlow(uninit, read)
    source.asExpr() = uninit.getARead() and
    sink.asExpr() = read.getAControlFlowNode() and
    localFlow(source, sink)
  )
select read,
  "Local variable $@ may be used before it is initialized. Uninitialized value appears $@.", v,
  v.getName(), source, "here"
