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
      isSinkPair(sink1.getNode(), sink2.getNode()) and
      reachablePair2(this, source1, source2, sink1, sink2)
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
        exists(Configuration conf | conf.isSinkPair(_, sink))
      }
    }
  }

  private predicate reachablePair1(
    Configuration conf, DataFlow::PathNode source1, DataFlow2::PathNode source2,
    DataFlow::PathNode node1, DataFlow2::PathNode node2
  ) {
    reachablePair(conf, source1, source2, node1, node2)
    or
    exists(DataFlow::PathNode mid1 |
      reachablePair1(conf, source1, source2, mid1, node2) and
      mid1.getASuccessor() = node1 and
      mid1.getNode().getEnclosingCallable() = node1.getNode().getEnclosingCallable()
    )
  }

  private predicate reachablePair2(
    Configuration conf, DataFlow::PathNode source1, DataFlow2::PathNode source2,
    DataFlow::PathNode node1, DataFlow2::PathNode node2
  ) {
    reachablePair1(conf, source1, source2, node1, node2) // TODO: restrict more
    or
    exists(DataFlow2::PathNode mid2 |
      reachablePair2(conf, source1, source2, node1, mid2) and
      mid2.getASuccessor() = node2 and
      mid2.getNode().getEnclosingCallable() = node2.getNode().getEnclosingCallable()
    )
  }

  private predicate interprocStep(
    Configuration conf, DataFlow::PathNode source1, DataFlow2::PathNode source2,
    DataFlow::PathNode node1, DataFlow2::PathNode node2
  ) {
    exists(DataFlow::PathNode mid1, DataFlow2::PathNode mid2, Function funcMid, Function func |
      reachablePair2(conf, source1, source2, mid1, mid2) and
      mid1.getASuccessor() = node1 and
      mid2.getASuccessor() = node2 and
      mid1.getNode().getEnclosingCallable() = funcMid and // TODO: recursive function weirdness?
      mid2.getNode().getEnclosingCallable() = funcMid and
      node1.getNode().getEnclosingCallable() = func and
      node2.getNode().getEnclosingCallable() = func and
      funcMid != func
    )
  }

  private predicate reachablePair(
    Configuration conf, DataFlow::PathNode source1, DataFlow2::PathNode source2,
    DataFlow::PathNode node1, DataFlow2::PathNode node2
  ) {
    conf.isSourcePair(node1.getNode(), node2.getNode()) and
    node1.isSource() and
    node2.isSource() and
    source1 = node1 and
    source2 = node2
    or
    interprocStep(conf, source1, source2, node1, node2)
  }
}
