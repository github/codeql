/**
 * @name Divide by zero
 * @description Converting the result of `strconv.Atoi`, `strconv.ParseInt`,
 *              and `strconv.ParseUint` to integer types or use of integer types for division without checks
 *              might lead to division by zero and panic, which cause denial of service.
 * @kind path-problem
 * @problem.severity error
 * @id go/divide-by-zero
 * @tags security
 *       external/cwe/cwe-369
 */

import go
import DataFlow::PathGraph
import semmle.go.dataflow.internal.TaintTrackingUtil

class DivideByZeroSanitizeGuard extends DataFlow::BarrierGuard {
  override predicate checks(Expr e, boolean branch) {
    exists(
      DataFlow::Node zero, DataFlow::Node sink, DataFlow::EqualityTestNode eqNode,
      DataFlow::RelationalComparisonNode compNode
    |
      zero.getNumericValue() = 0 and
      (
        sink.getType().getUnderlyingType() instanceof IntegerType
      ) and
      (
        eqNode.eq(branch.booleanNot(), sink, zero) or
        compNode.leq(branch.booleanNot(), sink, zero, 0)
      ) and
      globalValueNumber(DataFlow::exprNode(e)) = globalValueNumber(sink)
    )
  }
}

class DivideByZeroCheckConfig extends TaintTracking::Configuration {
  DivideByZeroCheckConfig() { this = "DivideByZeroCheckConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(Function f |
      (
        f.getName() = "Atoi" or
        f.getName() = "ParseInt" or
        f.getName() = "ParseUint"
      ) and
      node1 = f.getACall().getArgument(0) and
      node2 = f.getACall().getResult(0)
    )
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof DivideByZeroSanitizeGuard
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(QuoExpr e | sink.asExpr().getParent().(QuoExpr).getRightOperand() = e.getAnOperand())
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, DivideByZeroCheckConfig cfg
where cfg.hasFlowPath(source, sink)
select sink, source, sink,
  "Variable $@, which is used at division statement might be zero and leads to division by zero exception.",
  sink, sink.getNode().toString()
