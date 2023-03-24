import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.ir.dataflow.DataFlow2

module ProductFlow {
  abstract class Configuration extends string {
    bindingset[this]
    Configuration() { any() }

    /**
     * Holds if `(source1, source2)` is a relevant data flow source.
     *
     * `source1` and `source2` must belong to the same callable.
     */
    predicate isSourcePair(DataFlow::Node source1, DataFlow::Node source2) { none() }

    /**
     * Holds if `(source1, source2)` is a relevant data flow source with initial states `state1`
     * and `state2`, respectively.
     *
     * `source1` and `source2` must belong to the same callable.
     */
    predicate isSourcePair(
      DataFlow::Node source1, DataFlow::FlowState state1, DataFlow::Node source2,
      DataFlow::FlowState state2
    ) {
      state1 = "" and
      state2 = "" and
      this.isSourcePair(source1, source2)
    }

    /**
     * Holds if `(sink1, sink2)` is a relevant data flow sink.
     *
     * `sink1` and `sink2` must belong to the same callable.
     */
    predicate isSinkPair(DataFlow::Node sink1, DataFlow::Node sink2) { none() }

    /**
     * Holds if `(sink1, sink2)` is a relevant data flow sink with final states `state1`
     * and `state2`, respectively.
     *
     * `sink1` and `sink2` must belong to the same callable.
     */
    predicate isSinkPair(
      DataFlow::Node sink1, DataFlow::FlowState state1, DataFlow::Node sink2,
      DataFlow::FlowState state2
    ) {
      state1 = "" and
      state2 = "" and
      this.isSinkPair(sink1, sink2)
    }

    /**
     * Holds if data flow through `node` is prohibited through the first projection of the product
     * dataflow graph when the flow state is `state`.
     */
    predicate isBarrier1(DataFlow::Node node, DataFlow::FlowState state) {
      this.isBarrier1(node) and state = ""
    }

    /**
     * Holds if data flow through `node` is prohibited through the second projection of the product
     * dataflow graph when the flow state is `state`.
     */
    predicate isBarrier2(DataFlow::Node node, DataFlow::FlowState state) {
      this.isBarrier2(node) and state = ""
    }

    /**
     * Holds if data flow through `node` is prohibited through the first projection of the product
     * dataflow graph.
     */
    predicate isBarrier1(DataFlow::Node node) { none() }

    /**
     * Holds if data flow through `node` is prohibited through the second projection of the product
     * dataflow graph.
     */
    predicate isBarrier2(DataFlow::Node node) { none() }

    /**
     * Holds if data flow out of `node` is prohibited in the first projection of the product
     * dataflow graph.
     */
    predicate isBarrierOut1(DataFlow::Node node) { none() }

    /**
     * Holds if data flow out of `node` is prohibited in the second projection of the product
     * dataflow graph.
     */
    predicate isBarrierOut2(DataFlow::Node node) { none() }

    /*
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps in
     * the first projection of the product dataflow graph.
     */

    predicate isAdditionalFlowStep1(DataFlow::Node node1, DataFlow::Node node2) { none() }

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps in
     * the first projection of the product dataflow graph.
     *
     * This step is only applicable in `state1` and updates the flow state to `state2`.
     */
    predicate isAdditionalFlowStep1(
      DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
      DataFlow::FlowState state2
    ) {
      state1 instanceof DataFlow::FlowStateEmpty and
      state2 instanceof DataFlow::FlowStateEmpty and
      this.isAdditionalFlowStep1(node1, node2)
    }

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps in
     * the second projection of the product dataflow graph.
     */
    predicate isAdditionalFlowStep2(DataFlow::Node node1, DataFlow::Node node2) { none() }

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps in
     * the second projection of the product dataflow graph.
     *
     * This step is only applicable in `state1` and updates the flow state to `state2`.
     */
    predicate isAdditionalFlowStep2(
      DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
      DataFlow::FlowState state2
    ) {
      state1 instanceof DataFlow::FlowStateEmpty and
      state2 instanceof DataFlow::FlowStateEmpty and
      this.isAdditionalFlowStep2(node1, node2)
    }

    /**
     * Holds if data flow into `node` is prohibited in the first projection of the product
     * dataflow graph.
     */
    predicate isBarrierIn1(DataFlow::Node node) { none() }

    /**
     * Holds if data flow into `node` is prohibited in the second projection of the product
     * dataflow graph.
     */
    predicate isBarrierIn2(DataFlow::Node node) { none() }

    predicate hasFlowPath(
      DataFlow::PathNode source1, DataFlow2::PathNode source2, DataFlow::PathNode sink1,
      DataFlow2::PathNode sink2
    ) {
      reachable(this, source1, source2, sink1, sink2)
    }
  }

  private import Internal

  module Internal {
    class Conf1 extends DataFlow::Configuration {
      Conf1() { this = "Conf1" }

      override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
        exists(Configuration conf | conf.isSourcePair(source, state, _, _))
      }

      override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
        exists(Configuration conf | conf.isSinkPair(sink, state, _, _))
      }

      override predicate isBarrier(DataFlow::Node node, DataFlow::FlowState state) {
        exists(Configuration conf | conf.isBarrier1(node, state))
      }

      override predicate isBarrierOut(DataFlow::Node node) {
        exists(Configuration conf | conf.isBarrierOut1(node))
      }

      override predicate isAdditionalFlowStep(
        DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
        DataFlow::FlowState state2
      ) {
        exists(Configuration conf | conf.isAdditionalFlowStep1(node1, state1, node2, state2))
      }

      override predicate isBarrierIn(DataFlow::Node node) {
        exists(Configuration conf | conf.isBarrierIn1(node))
      }
    }

    class Conf2 extends DataFlow2::Configuration {
      Conf2() { this = "Conf2" }

      override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
        exists(Configuration conf, DataFlow::PathNode source1 |
          conf.isSourcePair(source1.getNode(), source1.getState(), source, state) and
          any(Conf1 c).hasFlowPath(source1, _)
        )
      }

      override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
        exists(Configuration conf, DataFlow::PathNode sink1 |
          conf.isSinkPair(sink1.getNode(), sink1.getState(), sink, state) and
          any(Conf1 c).hasFlowPath(_, sink1)
        )
      }

      override predicate isBarrier(DataFlow::Node node, DataFlow::FlowState state) {
        exists(Configuration conf | conf.isBarrier2(node, state))
      }

      override predicate isBarrierOut(DataFlow::Node node) {
        exists(Configuration conf | conf.isBarrierOut2(node))
      }

      override predicate isAdditionalFlowStep(
        DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
        DataFlow::FlowState state2
      ) {
        exists(Configuration conf | conf.isAdditionalFlowStep2(node1, state1, node2, state2))
      }

      override predicate isBarrierIn(DataFlow::Node node) {
        exists(Configuration conf | conf.isBarrierIn2(node))
      }
    }
  }

  pragma[nomagic]
  private predicate reachableInterprocEntry(
    Configuration conf, DataFlow::PathNode source1, DataFlow2::PathNode source2,
    DataFlow::PathNode node1, DataFlow2::PathNode node2
  ) {
    conf.isSourcePair(node1.getNode(), node1.getState(), node2.getNode(), node2.getState()) and
    node1 = source1 and
    node2 = source2
    or
    exists(
      DataFlow::PathNode midEntry1, DataFlow2::PathNode midEntry2, DataFlow::PathNode midExit1,
      DataFlow2::PathNode midExit2
    |
      reachableInterprocEntry(conf, source1, source2, midEntry1, midEntry2) and
      interprocEdgePair(midExit1, midExit2, node1, node2) and
      localPathStep1*(midEntry1, midExit1) and
      localPathStep2*(midEntry2, midExit2)
    )
  }

  private predicate localPathStep1(DataFlow::PathNode pred, DataFlow::PathNode succ) {
    DataFlow::PathGraph::edges(pred, succ) and
    pragma[only_bind_out](pred.getNode().getEnclosingCallable()) =
      pragma[only_bind_out](succ.getNode().getEnclosingCallable())
  }

  private predicate localPathStep2(DataFlow2::PathNode pred, DataFlow2::PathNode succ) {
    DataFlow2::PathGraph::edges(pred, succ) and
    pragma[only_bind_out](pred.getNode().getEnclosingCallable()) =
      pragma[only_bind_out](succ.getNode().getEnclosingCallable())
  }

  pragma[nomagic]
  private predicate interprocEdge1(
    Declaration predDecl, Declaration succDecl, DataFlow::PathNode pred1, DataFlow::PathNode succ1
  ) {
    DataFlow::PathGraph::edges(pred1, succ1) and
    predDecl != succDecl and
    pred1.getNode().getEnclosingCallable() = predDecl and
    succ1.getNode().getEnclosingCallable() = succDecl
  }

  pragma[nomagic]
  private predicate interprocEdge2(
    Declaration predDecl, Declaration succDecl, DataFlow2::PathNode pred2, DataFlow2::PathNode succ2
  ) {
    DataFlow2::PathGraph::edges(pred2, succ2) and
    predDecl != succDecl and
    pred2.getNode().getEnclosingCallable() = predDecl and
    succ2.getNode().getEnclosingCallable() = succDecl
  }

  private predicate interprocEdgePair(
    DataFlow::PathNode pred1, DataFlow2::PathNode pred2, DataFlow::PathNode succ1,
    DataFlow2::PathNode succ2
  ) {
    exists(Declaration predDecl, Declaration succDecl |
      interprocEdge1(predDecl, succDecl, pred1, succ1) and
      interprocEdge2(predDecl, succDecl, pred2, succ2)
    )
  }

  private predicate reachable(
    Configuration conf, DataFlow::PathNode source1, DataFlow2::PathNode source2,
    DataFlow::PathNode sink1, DataFlow2::PathNode sink2
  ) {
    exists(DataFlow::PathNode mid1, DataFlow2::PathNode mid2 |
      reachableInterprocEntry(conf, source1, source2, mid1, mid2) and
      conf.isSinkPair(sink1.getNode(), sink1.getState(), sink2.getNode(), sink2.getState()) and
      localPathStep1*(mid1, sink1) and
      localPathStep2*(mid2, sink2)
    )
  }
}
