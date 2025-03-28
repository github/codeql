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
   * A barrier for uncontrolled allocation size that is an guard / bound check.
   */
  private class BoundCheckBarrier extends Barrier {
    BoundCheckBarrier() { this = DataFlow::BarrierGuard<isBoundCheck/3>::getABarrierNode() }
  }

  private predicate isBoundCheck(CfgNodes::AstCfgNode g, Cfg::CfgNode node, boolean branch) {
    // any comparison (`g` / `cmp`) guards the expression on either side (`node`)
    exists(BinaryExpr cmp |
      g = cmp.getACfgNode() and
      [cmp.getLhs(), cmp.getRhs()].getACfgNode() = node and
      branch = [true, false]
    )
  }
}
