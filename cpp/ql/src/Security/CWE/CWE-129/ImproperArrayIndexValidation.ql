/**
 * @name Unclear validation of array index
 * @description Accessing an array without first checking
 *              that the index is within the bounds of the array can
 *              cause undefined behavior and can also be a security risk.
 * @kind path-problem
 * @id cpp/unclear-array-index-validation
 * @problem.severity warning
 * @security-severity 8.8
 * @precision low
 * @tags security
 *       external/cwe/cwe-129
 */

import cpp
import semmle.code.cpp.controlflow.IRGuards
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils
import DataFlow::PathGraph
import semmle.code.cpp.security.Security

predicate hasUpperBound(VariableAccess offsetExpr) {
  exists(BasicBlock controlled, StackVariable offsetVar, SsaDefinition def |
    controlled.contains(offsetExpr) and
    linearBoundControls(controlled, def, offsetVar) and
    offsetExpr = def.getAUse(offsetVar)
  )
}

pragma[noinline]
predicate linearBoundControls(BasicBlock controlled, SsaDefinition def, StackVariable offsetVar) {
  exists(GuardCondition guard, boolean branch |
    guard.controls(controlled, branch) and
    cmpWithLinearBound(guard, def.getAUse(offsetVar), Lesser(), branch)
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

predicate isFlowSource(FlowSource source, string sourceType) { sourceType = source.getSourceType() }

predicate predictableInstruction(Instruction instr) {
  instr instanceof ConstantInstruction
  or
  instr instanceof StringConstantInstruction
  or
  // This could be a conversion on a string literal
  predictableInstruction(instr.(UnaryInstruction).getUnary())
}

class ImproperArrayIndexValidationConfig extends TaintTracking::Configuration {
  ImproperArrayIndexValidationConfig() { this = "ImproperArrayIndexValidationConfig" }

  override predicate isSource(DataFlow::Node source) { isFlowSource(source, _) }

  override predicate isSanitizer(DataFlow::Node node) {
    hasUpperBound(node.asExpr())
    or
    // These barriers are ported from `DefaultTaintTracking` because this query is quite noisy
    // otherwise.
    exists(Variable checkedVar |
      readsVariable(node.asInstruction(), checkedVar) and
      hasUpperBoundsCheck(checkedVar)
    )
    or
    exists(Variable checkedVar, Operand access |
      readsVariable(access.getDef(), checkedVar) and
      nodeIsBarrierEqualityCandidate(node, access, checkedVar)
    )
    or
    // Don't use dataflow into binary instructions if both operands are unpredictable
    exists(BinaryInstruction iTo |
      iTo = node.asInstruction() and
      not predictableInstruction(iTo.getLeft()) and
      not predictableInstruction(iTo.getRight()) and
      // propagate taint from either the pointer or the offset, regardless of predictability
      not iTo instanceof PointerArithmeticInstruction
    )
    or
    // don't use dataflow through calls to pure functions if two or more operands
    // are unpredictable
    exists(Instruction iFrom1, Instruction iFrom2, CallInstruction iTo |
      iTo = node.asInstruction() and
      isPureFunction(iTo.getStaticCallTarget().getName()) and
      iFrom1 = iTo.getAnArgument() and
      iFrom2 = iTo.getAnArgument() and
      not predictableInstruction(iFrom1) and
      not predictableInstruction(iFrom2) and
      iFrom1 != iFrom2
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ArrayExpr arrayExpr, VariableAccess offsetExpr |
      offsetExpr = arrayExpr.getArrayOffset() and
      sink.asExpr() = offsetExpr and
      not hasUpperBound(offsetExpr)
    )
  }
}

from
  ImproperArrayIndexValidationConfig conf, DataFlow::PathNode source, DataFlow::PathNode sink,
  string sourceType
where
  conf.hasFlowPath(source, sink) and
  isFlowSource(source.getNode(), sourceType)
select sink.getNode(), source, sink,
  "$@ flows to here and is used in an array indexing expression, potentially causing an invalid access.",
  source.getNode(), sourceType
