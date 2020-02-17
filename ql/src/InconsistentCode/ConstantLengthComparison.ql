/**
 * @name Constant length comparison
 * @description Comparing the length of an array to a constant before indexing it using a
 *              loop variable may indicate a logic error.
 * @kind problem
 * @problem.severity warning
 * @id go/constant-length-comparison
 * @tags correctness
 * @precision high
 */

import go

from
  ForStmt fs, Variable i, DataFlow::ElementReadNode idx, GVN a,
  ControlFlow::ConditionGuardNode cond, DataFlow::CallNode lenA
where
  // `i` is incremented in `fs`
  fs.getPost().(IncStmt).getOperand() = i.getAReference() and
  // `idx` reads `a[i]`
  idx.reads(a.getANode(), i.getARead()) and
  // `lenA` is `len(a)`
  lenA = Builtin::len().getACall() and
  lenA.getArgument(0) = a.getANode() and
  // and is checked against a constant
  exists(DataFlow::Node const | exists(const.getIntValue()) |
    cond.ensuresNeq(lenA, const) or
    cond.ensuresLeq(const, lenA, _)
  ) and
  cond.dominates(idx.getBasicBlock()) and
  // and that check happens inside the loop body
  cond.getCondition().getParent+() = fs
select cond.getCondition(),
  "This checks the length against a constant, but it is indexed using a variable $@.", idx, "here"
