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
   * Holds if comparison `g` having result `branch` indicates an upper bound for the sub-expression
   * `node`. For example when the comparison `x < 10` is true, we have an upper bound for `x`.
   */
  private predicate isUpperBoundCheck(CfgNodes::AstCfgNode g, Cfg::CfgNode node, boolean branch) {
    exists(BinaryExpr cmp | g = cmp.getACfgNode() |
      node = cmp.(RelationalOperation).getLesserOperand().getACfgNode() and
      branch = true
      or
      node = cmp.(RelationalOperation).getGreaterOperand().getACfgNode() and
      branch = false
      or
      cmp instanceof EqualOperation and
      [cmp.getLhs(), cmp.getRhs()].getACfgNode() = node and
      branch = true
      or
      cmp instanceof NotEqualOperation and
      [cmp.getLhs(), cmp.getRhs()].getACfgNode() = node and
      branch = false
    )
  }
}
