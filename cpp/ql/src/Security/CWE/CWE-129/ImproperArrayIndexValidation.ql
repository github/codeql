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
import semmle.code.cpp.security.FlowSources as FS
import semmle.code.cpp.dataflow.new.TaintTracking
import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils
import ImproperArrayIndexValidation::PathGraph

predicate isFlowSource(FS::FlowSource source, string sourceType) {
  sourceType = source.getSourceType()
}

predicate guardChecks(IRGuardCondition g, Expr e, boolean branch) {
  exists(Operand op | op.getDef().getConvertedResultExpression() = e |
    // op < k
    g.comparesLt(op, _, true, any(BooleanValue bv | bv.getValue() = branch))
    or
    // op < _ + k
    g.comparesLt(op, _, _, true, branch)
    or
    // op == k
    g.comparesEq(op, _, true, any(BooleanValue bv | bv.getValue() = branch))
    or
    // op == _ + k
    g.comparesEq(op, _, _, true, branch)
  )
}

module ImproperArrayIndexValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isFlowSource(source, _) }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<guardChecks/3>::getABarrierNode()
  }

  predicate isBarrierOut(DataFlow::Node node) { isSink(node) }

  predicate isSink(DataFlow::Node sink) {
    exists(ArrayExpr arrayExpr, VariableAccess offsetExpr |
      offsetExpr = arrayExpr.getArrayOffset() and
      sink.asExpr() = offsetExpr
    )
  }
}

module ImproperArrayIndexValidation = TaintTracking::Global<ImproperArrayIndexValidationConfig>;

from
  ImproperArrayIndexValidation::PathNode source, ImproperArrayIndexValidation::PathNode sink,
  string sourceType
where
  ImproperArrayIndexValidation::flowPath(source, sink) and
  isFlowSource(source.getNode(), sourceType)
select sink.getNode(), source, sink,
  "An array indexing expression depends on $@ that might be outside the bounds of the array.",
  source.getNode(), sourceType
