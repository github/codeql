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

class DivideByZeroSanitizeGuard extends DataFlow::BarrierGuard, DataFlow::EqualityTestNode {
  override predicate checks(Expr e, boolean branch) {
    exists(DataFlow::Node zero, DataFlow::Node sink |
      zero.getNumericValue() = 0 and
      sink.getType().getUnderlyingType() instanceof SignedIntegerType and
      this.eq(branch.booleanNot(), sink, zero) and
      globalValueNumber(DataFlow::exprNode(e)) = globalValueNumber(sink)
    )
  }
}

class DivideByZeroCheckConfig extends TaintTracking::Configuration {
  DivideByZeroCheckConfig() { this = "DivideByZeroCheckConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(DataFlow::CallNode c, IntegerParser::Range ip |
      c.getTarget() = ip and source = c.getResult(0)
    )
    or
    exists(IntegerType integerType | source.getType().getUnderlyingType() = integerType)
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(IntegerType integerType, QuoExpr e |
      sink.asExpr().getParent().(QuoExpr).getRightOperand() = e.getAnOperand() and
      not sink.asExpr().getParent().(QuoExpr).getRightOperand().isConst() and
      sink.getType().getUnderlyingType() = integerType
    )
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof DivideByZeroSanitizeGuard
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, DivideByZeroCheckConfig cfg,
  DataFlow::CallNode call
where cfg.hasFlowPath(source, sink) and call.getResult(0) = source.getNode()
select sink, source, sink,
  "Variable $@, which is used at division statement might be zero and leads to division by zero exception.",
  sink, sink.getNode().toString()
