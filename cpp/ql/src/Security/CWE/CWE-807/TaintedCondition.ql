/**
 * @name Untrusted input for a condition
 * @description Using untrusted inputs in a statement that makes a
 *              security decision makes code vulnerable to
 *              attack.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id cpp/tainted-permissions-check
 * @tags security
 *       external/cwe/cwe-807
 */

import cpp
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.ir.IR
import Flow::PathGraph

predicate sensitiveCondition(Expr condition, Expr raise) {
  raisesPrivilege(raise) and
  exists(IfStmt ifstmt |
    ifstmt.getCondition() = condition and
    raise.getEnclosingStmt().getParentStmt*() = ifstmt
  )
}

private predicate constantInstruction(Instruction instr) {
  instr instanceof ConstantInstruction
  or
  instr instanceof StringConstantInstruction
  or
  constantInstruction(instr.(UnaryInstruction).getUnary())
}

predicate isSource(FlowSource source, string sourceType) { sourceType = source.getSourceType() }

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { isSource(node, _) }

  predicate isSink(DataFlow::Node node) {
    sensitiveCondition([node.asExpr(), node.asIndirectExpr()], _)
  }

  predicate isBarrier(DataFlow::Node node) {
    // Block flow into binary instructions if both operands are non-constant
    exists(BinaryInstruction iTo |
      iTo = node.asInstruction() and
      not constantInstruction(iTo.getLeft()) and
      not constantInstruction(iTo.getRight()) and
      // propagate taint from either the pointer or the offset, regardless of constant-ness
      not iTo instanceof PointerArithmeticInstruction
    )
    or
    // Block flow through calls to pure functions if two or more operands are non-constant
    exists(Instruction iFrom1, Instruction iFrom2, CallInstruction iTo |
      iTo = node.asInstruction() and
      isPureFunction(iTo.getStaticCallTarget().getName()) and
      iFrom1 = iTo.getAnArgument() and
      iFrom2 = iTo.getAnArgument() and
      not constantInstruction(iFrom1) and
      not constantInstruction(iFrom2) and
      iFrom1 != iFrom2
    )
  }
}

module Flow = TaintTracking::Global<Config>;

/*
 * Produce an alert if there is an 'if' statement whose condition `condition`
 * is influenced by tainted data `source`, and the body contains
 * `raise` which escalates privilege.
 */

from
  Expr raise, string sourceType, DataFlow::Node source, DataFlow::Node sink,
  Flow::PathNode sourceNode, Flow::PathNode sinkNode
where
  source = sourceNode.getNode() and
  sink = sinkNode.getNode() and
  isSource(source, sourceType) and
  sensitiveCondition([sink.asExpr(), sink.asIndirectExpr()], raise) and
  Flow::flowPath(sourceNode, sinkNode)
select sink, sourceNode, sinkNode, "Reliance on $@ to raise privilege at $@.", source, sourceType,
  raise, raise.toString()
