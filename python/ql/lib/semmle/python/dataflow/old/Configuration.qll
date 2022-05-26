import python
import semmle.python.dataflow.TaintTracking
private import semmle.python.objects.ObjectInternal
private import semmle.python.dataflow.Implementation

module TaintTracking {
  class Source = TaintSource;

  class Sink = TaintSink;

  class Extension = DataFlowExtension::DataFlowNode;

  class PathSource = TaintTrackingNode;

  class PathSink = TaintTrackingNode;

  abstract class Configuration extends string {
    /* Required to prevent compiler warning */
    bindingset[this]
    Configuration() { this = this }

    /* Old implementation API */
    predicate isSource(Source src) { none() }

    predicate isSink(Sink sink) { none() }

    predicate isSanitizer(Sanitizer sanitizer) { none() }

    predicate isExtension(Extension extension) { none() }

    /* New implementation API */
    /**
     * Holds if `src` is a source of taint of `kind` that is relevant
     * for this configuration.
     */
    predicate isSource(DataFlow::Node src, TaintKind kind) {
      exists(TaintSource taintSrc |
        this.isSource(taintSrc) and
        src.asCfgNode() = taintSrc and
        taintSrc.isSourceOf(kind)
      )
    }

    /**
     * Holds if `sink` is a sink of taint of `kind` that is relevant
     * for this configuration.
     */
    predicate isSink(DataFlow::Node sink, TaintKind kind) {
      exists(TaintSink taintSink |
        this.isSink(taintSink) and
        sink.asCfgNode() = taintSink and
        taintSink.sinks(kind)
      )
    }

    /**
     * Holds if `src -> dest` should be considered as a flow edge
     * in addition to standard data flow edges.
     */
    predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node dest) { none() }

    /**
     * Holds if `src -> dest` is a flow edge converting taint from `srckind` to `destkind`.
     */
    predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node dest, TaintKind srckind, TaintKind destkind
    ) {
      none()
    }

    /**
     * Holds if `node` should be considered as a barrier to flow of any kind.
     */
    predicate isBarrier(DataFlow::Node node) { none() }

    /**
     * Holds if `node` should be considered as a barrier to flow of `kind`.
     */
    predicate isBarrier(DataFlow::Node node, TaintKind kind) {
      exists(Sanitizer sanitizer | this.isSanitizer(sanitizer) |
        sanitizer.sanitizingNode(kind, node.asCfgNode())
        or
        sanitizer.sanitizingEdge(kind, node.asVariable())
        or
        sanitizer.sanitizingSingleEdge(kind, node.asVariable())
        or
        sanitizer.sanitizingDefinition(kind, node.asVariable())
        or
        exists(MethodCallsiteRefinement call, FunctionObject callee |
          call = node.asVariable().getDefinition() and
          callee.getACall() = call.getCall() and
          sanitizer.sanitizingCall(kind, callee)
        )
      )
    }

    /**
     * Holds if flow from `src` to `dest` is prohibited.
     */
    predicate isBarrierEdge(DataFlow::Node src, DataFlow::Node dest) { none() }

    /**
     * Holds if control flow from `test` along the `isTrue` edge is prohibited.
     */
    predicate isBarrierTest(ControlFlowNode test, boolean isTrue) { none() }

    /**
     * Holds if flow from `src` to `dest` is prohibited when the incoming taint is `srckind` and the outgoing taint is `destkind`.
     * Note that `srckind` and `destkind` can be the same.
     */
    predicate isBarrierEdge(
      DataFlow::Node src, DataFlow::Node dest, TaintKind srckind, TaintKind destkind
    ) {
      none()
    }

    /* Common query API */
    predicate hasFlowPath(PathSource src, PathSink sink) {
      this.(TaintTrackingImplementation).hasFlowPath(src, sink)
    }

    /* New query API */
    predicate hasSimpleFlow(DataFlow::Node src, DataFlow::Node sink) {
      exists(PathSource psrc, PathSink psink |
        this.hasFlowPath(psrc, psink) and
        src = psrc.getNode() and
        sink = psink.getNode()
      )
    }
  }
}
