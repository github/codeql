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
    abstract predicate isSourcePair(DataFlow::Node source1, DataFlow::Node source2);

    /**
     * Holds if `(sink1, sink2)` is a relevant data flow sink.
     *
     * `sink1` and `sink2` must belong to the same callable.
     */
    abstract predicate isSinkPair(DataFlow::Node sink1, DataFlow::Node sink2);

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

      override predicate isSource(DataFlow::Node source) {
        exists(Configuration conf | conf.isSourcePair(source, _))
      }

      override predicate isSink(DataFlow::Node sink) {
        exists(Configuration conf | conf.isSinkPair(sink, _))
      }
    }

    class Conf2 extends DataFlow2::Configuration {
      Conf2() { this = "Conf2" }

      override predicate isSource(DataFlow::Node source) {
        exists(Configuration conf, DataFlow::Node source1 |
          conf.isSourcePair(source1, source) and
          any(Conf1 c).hasFlow(source1, _)
        )
      }

      override predicate isSink(DataFlow::Node sink) {
        exists(Configuration conf, DataFlow::Node sink1 |
          conf.isSinkPair(sink1, sink) and any(Conf1 c).hasFlow(_, sink1)
        )
      }
    }
  }

  private predicate reachableInterprocEntry(
    Configuration conf, DataFlow::PathNode source1, DataFlow2::PathNode source2,
    DataFlow::PathNode node1, DataFlow2::PathNode node2
  ) {
    conf.isSourcePair(node1.getNode(), node2.getNode()) and
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
      conf.isSinkPair(sink1.getNode(), sink2.getNode()) and
      localPathStep1*(mid1, sink1) and
      localPathStep2*(mid2, sink2)
    )
  }
}
