import semmle.code.cpp.ir.dataflow.DataFlow
private import codeql.util.Unit

module ProductFlow {
  signature module ConfigSig {
    /**
     * Holds if `(source1, source2)` is a relevant data flow source.
     *
     * `source1` and `source2` must belong to the same callable.
     */
    predicate isSourcePair(DataFlow::Node source1, DataFlow::Node source2);

    /**
     * Holds if `(sink1, sink2)` is a relevant data flow sink.
     *
     * `sink1` and `sink2` must belong to the same callable.
     */
    predicate isSinkPair(DataFlow::Node sink1, DataFlow::Node sink2);

    /**
     * Holds if data flow through `node` is prohibited through the first projection of the product
     * dataflow graph.
     */
    default predicate isBarrier1(DataFlow::Node node) { none() }

    /**
     * Holds if data flow through `node` is prohibited through the second projection of the product
     * dataflow graph.
     */
    default predicate isBarrier2(DataFlow::Node node) { none() }

    /**
     * Holds if data flow out of `node` is prohibited in the first projection of the product
     * dataflow graph.
     */
    default predicate isBarrierOut1(DataFlow::Node node) { none() }

    /**
     * Holds if data flow out of `node` is prohibited in the second projection of the product
     * dataflow graph.
     */
    default predicate isBarrierOut2(DataFlow::Node node) { none() }

    /*
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps in
     * the first projection of the product dataflow graph.
     */

    default predicate isAdditionalFlowStep1(DataFlow::Node node1, DataFlow::Node node2) { none() }

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps in
     * the second projection of the product dataflow graph.
     */
    default predicate isAdditionalFlowStep2(DataFlow::Node node1, DataFlow::Node node2) { none() }

    /**
     * Holds if data flow into `node` is prohibited in the first projection of the product
     * dataflow graph.
     */
    default predicate isBarrierIn1(DataFlow::Node node) { none() }

    /**
     * Holds if data flow into `node` is prohibited in the second projection of the product
     * dataflow graph.
     */
    default predicate isBarrierIn2(DataFlow::Node node) { none() }
  }

  module Global<ConfigSig Config> {
    private module StateConfig implements StateConfigSig {
      class FlowState1 = Unit;

      class FlowState2 = Unit;

      predicate isSourcePair(
        DataFlow::Node source1, FlowState1 state1, DataFlow::Node source2, FlowState2 state2
      ) {
        exists(state1) and
        exists(state2) and
        Config::isSourcePair(source1, source2)
      }

      predicate isSinkPair(
        DataFlow::Node sink1, FlowState1 state1, DataFlow::Node sink2, FlowState2 state2
      ) {
        exists(state1) and
        exists(state2) and
        Config::isSinkPair(sink1, sink2)
      }

      predicate isBarrier1(DataFlow::Node node, FlowState1 state) {
        exists(state) and
        Config::isBarrier1(node)
      }

      predicate isBarrier2(DataFlow::Node node, FlowState2 state) {
        exists(state) and
        Config::isBarrier2(node)
      }

      predicate isBarrier1 = Config::isBarrier1/1;

      predicate isBarrier2 = Config::isBarrier2/1;

      predicate isBarrierOut1 = Config::isBarrierOut1/1;

      predicate isBarrierOut2 = Config::isBarrierOut2/1;

      predicate isAdditionalFlowStep1 = Config::isAdditionalFlowStep1/2;

      predicate isAdditionalFlowStep1(
        DataFlow::Node node1, FlowState1 state1, DataFlow::Node node2, FlowState1 state2
      ) {
        exists(state1) and
        exists(state2) and
        Config::isAdditionalFlowStep1(node1, node2)
      }

      predicate isAdditionalFlowStep2 = Config::isAdditionalFlowStep2/2;

      predicate isAdditionalFlowStep2(
        DataFlow::Node node1, FlowState2 state1, DataFlow::Node node2, FlowState2 state2
      ) {
        exists(state1) and
        exists(state2) and
        Config::isAdditionalFlowStep2(node1, node2)
      }

      predicate isBarrierIn1 = Config::isBarrierIn1/1;

      predicate isBarrierIn2 = Config::isBarrierIn2/1;
    }

    import GlobalWithState<StateConfig>
  }

  signature module StateConfigSig {
    bindingset[this]
    class FlowState1;

    bindingset[this]
    class FlowState2;

    /**
     * Holds if `(source1, source2)` is a relevant data flow source with initial states `state1`
     * and `state2`, respectively.
     *
     * `source1` and `source2` must belong to the same callable.
     */
    predicate isSourcePair(
      DataFlow::Node source1, FlowState1 state1, DataFlow::Node source2, FlowState2 state2
    );

    /**
     * Holds if `(sink1, sink2)` is a relevant data flow sink with final states `state1`
     * and `state2`, respectively.
     *
     * `sink1` and `sink2` must belong to the same callable.
     */
    predicate isSinkPair(
      DataFlow::Node sink1, FlowState1 state1, DataFlow::Node sink2, FlowState2 state2
    );

    /**
     * Holds if data flow through `node` is prohibited through the first projection of the product
     * dataflow graph when the flow state is `state`.
     */
    predicate isBarrier1(DataFlow::Node node, FlowState1 state);

    /**
     * Holds if data flow through `node` is prohibited through the second projection of the product
     * dataflow graph when the flow state is `state`.
     */
    predicate isBarrier2(DataFlow::Node node, FlowState2 state);

    /**
     * Holds if data flow through `node` is prohibited through the first projection of the product
     * dataflow graph.
     */
    default predicate isBarrier1(DataFlow::Node node) { none() }

    /**
     * Holds if data flow through `node` is prohibited through the second projection of the product
     * dataflow graph.
     */
    default predicate isBarrier2(DataFlow::Node node) { none() }

    /**
     * Holds if data flow out of `node` is prohibited in the first projection of the product
     * dataflow graph.
     */
    default predicate isBarrierOut1(DataFlow::Node node) { none() }

    /**
     * Holds if data flow out of `node` is prohibited in the second projection of the product
     * dataflow graph.
     */
    default predicate isBarrierOut2(DataFlow::Node node) { none() }

    /*
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps in
     * the first projection of the product dataflow graph.
     */

    default predicate isAdditionalFlowStep1(DataFlow::Node node1, DataFlow::Node node2) { none() }

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps in
     * the first projection of the product dataflow graph.
     *
     * This step is only applicable in `state1` and updates the flow state to `state2`.
     */
    predicate isAdditionalFlowStep1(
      DataFlow::Node node1, FlowState1 state1, DataFlow::Node node2, FlowState1 state2
    );

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps in
     * the second projection of the product dataflow graph.
     */
    default predicate isAdditionalFlowStep2(DataFlow::Node node1, DataFlow::Node node2) { none() }

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps in
     * the second projection of the product dataflow graph.
     *
     * This step is only applicable in `state1` and updates the flow state to `state2`.
     */
    predicate isAdditionalFlowStep2(
      DataFlow::Node node1, FlowState2 state1, DataFlow::Node node2, FlowState2 state2
    );

    /**
     * Holds if data flow into `node` is prohibited in the first projection of the product
     * dataflow graph.
     */
    default predicate isBarrierIn1(DataFlow::Node node) { none() }

    /**
     * Holds if data flow into `node` is prohibited in the second projection of the product
     * dataflow graph.
     */
    default predicate isBarrierIn2(DataFlow::Node node) { none() }
  }

  module GlobalWithState<StateConfigSig Config> {
    class PathNode1 = Flow1::PathNode;

    class PathNode2 = Flow2::PathNode;

    module PathGraph1 = Flow1::PathGraph;

    module PathGraph2 = Flow2::PathGraph;

    class FlowState1 = Config::FlowState1;

    class FlowState2 = Config::FlowState2;

    predicate flowPath(
      Flow1::PathNode source1, Flow2::PathNode source2, Flow1::PathNode sink1, Flow2::PathNode sink2
    ) {
      reachable(source1, source2, sink1, sink2)
    }

    private module Config1 implements DataFlow::StateConfigSig {
      class FlowState = FlowState1;

      predicate isSource(DataFlow::Node source, FlowState state) {
        Config::isSourcePair(source, state, _, _)
      }

      predicate isSink(DataFlow::Node sink, FlowState state) {
        Config::isSinkPair(sink, state, _, _)
      }

      predicate isBarrier(DataFlow::Node node, FlowState state) { Config::isBarrier1(node, state) }

      predicate isBarrierOut(DataFlow::Node node) { Config::isBarrierOut1(node) }

      predicate isAdditionalFlowStep(
        DataFlow::Node node1, FlowState1 state1, DataFlow::Node node2, FlowState state2
      ) {
        Config::isAdditionalFlowStep1(node1, state1, node2, state2)
      }

      predicate isBarrierIn(DataFlow::Node node) { Config::isBarrierIn1(node) }
    }

    module Flow1 = DataFlow::GlobalWithState<Config1>;

    module Config2 implements DataFlow::StateConfigSig {
      class FlowState = FlowState2;

      predicate isSource(DataFlow::Node source, FlowState state) {
        exists(Flow1::PathNode source1 |
          Config::isSourcePair(source1.getNode(), source1.getState(), source, state) and
          Flow1::flowPath(source1, _)
        )
      }

      predicate isSink(DataFlow::Node sink, FlowState state) {
        exists(Flow1::PathNode sink1 |
          Config::isSinkPair(sink1.getNode(), sink1.getState(), sink, state) and
          Flow1::flowPath(_, sink1)
        )
      }

      predicate isBarrier(DataFlow::Node node, FlowState state) { Config::isBarrier2(node, state) }

      predicate isBarrierOut(DataFlow::Node node) { Config::isBarrierOut2(node) }

      predicate isAdditionalFlowStep(
        DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
      ) {
        Config::isAdditionalFlowStep2(node1, state1, node2, state2)
      }

      predicate isBarrierIn(DataFlow::Node node) { Config::isBarrierIn2(node) }
    }

    module Flow2 = DataFlow::GlobalWithState<Config2>;

    pragma[nomagic]
    private predicate reachableInterprocEntry(
      Flow1::PathNode source1, Flow2::PathNode source2, Flow1::PathNode node1, Flow2::PathNode node2
    ) {
      Config::isSourcePair(node1.getNode(), node1.getState(), node2.getNode(), node2.getState()) and
      node1 = source1 and
      node2 = source2
      or
      exists(
        Flow1::PathNode midEntry1, Flow2::PathNode midEntry2, Flow1::PathNode midExit1,
        Flow2::PathNode midExit2
      |
        reachableInterprocEntry(source1, source2, midEntry1, midEntry2) and
        interprocEdgePair(midExit1, midExit2, node1, node2) and
        localPathStep1*(midEntry1, midExit1) and
        localPathStep2*(midEntry2, midExit2)
      )
    }

    private predicate localPathStep1(Flow1::PathNode pred, Flow1::PathNode succ) {
      Flow1::PathGraph::edges(pred, succ) and
      pragma[only_bind_out](pred.getNode().getEnclosingCallable()) =
        pragma[only_bind_out](succ.getNode().getEnclosingCallable())
    }

    private predicate localPathStep2(Flow2::PathNode pred, Flow2::PathNode succ) {
      Flow2::PathGraph::edges(pred, succ) and
      pragma[only_bind_out](pred.getNode().getEnclosingCallable()) =
        pragma[only_bind_out](succ.getNode().getEnclosingCallable())
    }

    pragma[nomagic]
    private predicate interprocEdge1(
      Declaration predDecl, Declaration succDecl, Flow1::PathNode pred1, Flow1::PathNode succ1
    ) {
      Flow1::PathGraph::edges(pred1, succ1) and
      predDecl != succDecl and
      pred1.getNode().getEnclosingCallable() = predDecl and
      succ1.getNode().getEnclosingCallable() = succDecl
    }

    pragma[nomagic]
    private predicate interprocEdge2(
      Declaration predDecl, Declaration succDecl, Flow2::PathNode pred2, Flow2::PathNode succ2
    ) {
      Flow2::PathGraph::edges(pred2, succ2) and
      predDecl != succDecl and
      pred2.getNode().getEnclosingCallable() = predDecl and
      succ2.getNode().getEnclosingCallable() = succDecl
    }

    private predicate interprocEdgePair(
      Flow1::PathNode pred1, Flow2::PathNode pred2, Flow1::PathNode succ1, Flow2::PathNode succ2
    ) {
      exists(Declaration predDecl, Declaration succDecl |
        interprocEdge1(predDecl, succDecl, pred1, succ1) and
        interprocEdge2(predDecl, succDecl, pred2, succ2)
      )
    }

    private predicate reachable(
      Flow1::PathNode source1, Flow2::PathNode source2, Flow1::PathNode sink1, Flow2::PathNode sink2
    ) {
      exists(Flow1::PathNode mid1, Flow2::PathNode mid2 |
        reachableInterprocEntry(source1, source2, mid1, mid2) and
        Config::isSinkPair(sink1.getNode(), sink1.getState(), sink2.getNode(), sink2.getState()) and
        localPathStep1*(mid1, sink1) and
        localPathStep2*(mid2, sink2)
      )
    }
  }
}
