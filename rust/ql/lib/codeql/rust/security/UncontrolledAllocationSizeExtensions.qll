/**
 * Provides classes and predicates for reasoning about uncontrolled allocation
 * size vulnerabilities.
 */

import rust
private import codeql.rust.Concepts
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.controlflow.ControlFlowGraph as Cfg
private import codeql.rust.controlflow.CfgNodes as CfgNodes

/**
 * Provides default sources, sinks and barriers for detecting uncontrolled
 * allocation size vulnerabilities, as well as extension points for adding your own.
 */
module UncontrolledAllocationSize {
  /**
   * A data flow sink for uncontrolled allocation size vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "UncontrolledAllocationSize" }
  }

  /**
   * A barrier for uncontrolled allocation size vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A sink for uncontrolled allocation size from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, ["alloc-size", "alloc-layout"]) }
  }

  /**
   * A barrier for uncontrolled allocation size that is an upper bound check / guard.
   */
  private class UpperBoundCheckBarrier extends Barrier {
    UpperBoundCheckBarrier() {
      this = DataFlow::BarrierGuard<isUpperBoundCheck/3>::getABarrierNode()
    }
  }

  /**
   * Gets the operand on the "greater" (or "greater-or-equal") side
   * of this relational expression, that is, the side that is larger
   * if the overall expression evaluates to `true`; for example on
   * `x <= 20` this is the `20`, and on `y > 0` it is `y`.
   */
  private Expr getGreaterOperand(BinaryExpr op) {
    op.getOperatorName() = ["<", "<="] and
    result = op.getRhs()
    or
    op.getOperatorName() = [">", ">="] and
    result = op.getLhs()
  }

  /**
   * Gets the operand on the "lesser" (or "lesser-or-equal") side
   * of this relational expression, that is, the side that is smaller
   * if the overall expression evaluates to `true`; for example on
   * `x <= 20` this is `x`, and on `y > 0` it is the `0`.
   */
  private Expr getLesserOperand(BinaryExpr op) {
    op.getOperatorName() = ["<", "<="] and
    result = op.getLhs()
    or
    op.getOperatorName() = [">", ">="] and
    result = op.getRhs()
  }

  /**
   * Holds if comparison `g` having result `branch` indicates an upper bound for the sub-expression
   * `node`. For example when the comparison `x < 10` is true, we have an upper bound for `x`.
   */
  private predicate isUpperBoundCheck(CfgNodes::AstCfgNode g, Cfg::CfgNode node, boolean branch) {
    exists(BinaryExpr cmp | g = cmp.getACfgNode() |
      node = getLesserOperand(cmp).getACfgNode() and
      branch = true
      or
      node = getGreaterOperand(cmp).getACfgNode() and
      branch = false
      or
      cmp.getOperatorName() = "==" and
      [cmp.getLhs(), cmp.getRhs()].getACfgNode() = node and
      branch = true
      or
      cmp.getOperatorName() = "!=" and
      [cmp.getLhs(), cmp.getRhs()].getACfgNode() = node and
      branch = false
    )
  }
}
