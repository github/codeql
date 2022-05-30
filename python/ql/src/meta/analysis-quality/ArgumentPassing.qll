/** Provides comparison of argument passing between type-tracking and points-to. */

import python

module PointsToArgumentPassing {
  module DataFlow {
    import semmle.python.dataflow.new.internal_pt.DataFlowImpl
  }

  // import semmle.python.dataflow.new.internal_pt.DataFlowPrivate as DFP
  class PointsToArgumentPassingConfig extends DataFlow::Configuration {
    PointsToArgumentPassingConfig() { this = "PointsToArgumentPassingConfig" }

    override predicate isSource(DataFlow::Node node) {
      node instanceof DataFlow::ArgumentNode and
      exists(node.getLocation().getFile().getRelativePath())
    }

    override predicate isSink(DataFlow::Node node) {
      node instanceof DataFlow::ParameterNode and
      exists(node.getLocation().getFile().getRelativePath())
    }

    override predicate isBarrierIn(DataFlow::Node node) { this.isSource(node) }

    override predicate isBarrierOut(DataFlow::Node node) { this.isSink(node) }
  }

  predicate argumentPassing(ControlFlowNode arg, Parameter param) {
    exists(PointsToArgumentPassingConfig config |
      config
          .hasFlow(any(DataFlow::ArgumentNode node | node.asCfgNode() = arg),
            any(DataFlow::ParameterNode node | node.getParameter() = param))
    )
  }
}

module TypeTrackingArgumentPassing {
  import semmle.python.dataflow.new.DataFlow

  class TypeTrackingArgumentPassingConfig extends DataFlow::Configuration {
    TypeTrackingArgumentPassingConfig() { this = "TypeTrackingArgumentPassingConfig" }

    override predicate isSource(DataFlow::Node node) {
      node instanceof DataFlow::ArgumentNode and
      exists(node.getLocation().getFile().getRelativePath())
    }

    override predicate isSink(DataFlow::Node node) {
      node instanceof DataFlow::ParameterNode and
      exists(node.getLocation().getFile().getRelativePath())
    }

    override predicate isBarrierIn(DataFlow::Node node) { this.isSource(node) }

    override predicate isBarrierOut(DataFlow::Node node) { this.isSink(node) }
  }

  predicate argumentPassing(ControlFlowNode arg, Parameter param) {
    exists(TypeTrackingArgumentPassingConfig config |
      config
          .hasFlow(any(DataFlow::ArgumentNode node | node.asCfgNode() = arg),
            any(DataFlow::ParameterNode node | node.getParameter() = param))
    )
  }
}
