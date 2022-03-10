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

predicate isUnboundedArrayIndex(DataFlow::Node sink, VariableAccess offsetExpr) {
  offsetExpr = sink.asExpr().(ArrayExpr).getArrayOffset() and
  not hasUpperBound(offsetExpr)
}

predicate readsVariable(LoadInstruction load, Variable var) {
  load.getSourceAddress().(VariableAddressInstruction).getASTVariable() = var
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

class ImproperArrayIndexValidationConfig extends TaintTracking::Configuration {
  ImproperArrayIndexValidationConfig() { this = "ImproperArrayIndexValidationConfig" }

  override predicate isSource(DataFlow::Node source) { isFlowSource(source, _) }

  override predicate isSanitizer(DataFlow::Node node) {
    hasUpperBound(node.asExpr())
    or
    exists(Variable checkedVar |
      readsVariable(node.asInstruction(), checkedVar) and
      hasUpperBoundsCheck(checkedVar)
    )
    or
    exists(Variable checkedVar, Operand access |
      readsVariable(access.getDef(), checkedVar) and
      nodeIsBarrierEqualityCandidate(node, access, checkedVar)
    )
  }

  override predicate isSink(DataFlow::Node sink) { isUnboundedArrayIndex(sink, _) }
}

from
  VariableAccess offsetExpr, ImproperArrayIndexValidationConfig conf, DataFlow::PathNode source,
  DataFlow::PathNode sink, string sourceType
where
  conf.hasFlowPath(source, sink) and
  isFlowSource(source.getNode(), sourceType) and
  isUnboundedArrayIndex(sink.getNode(), offsetExpr)
select sink.getNode(), source, sink,
  "$@ flows to here and is used in an array indexing expression, potentially causing an invalid access.",
  source.getNode(), sourceType
