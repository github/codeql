import python
import semmle.python.security.TaintTracking
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

        predicate isSource(Source source) { none() }

        predicate isSink(Sink sink) { none() }

        predicate isSanitizer(Sanitizer sanitizer) { none() }

        predicate isExtension(Extension extension) { none() }

        /* New implementation API */

        /**
         * Holds if `source` is a source of taint of `kind` that is relevant
         * for this configuration.
         */
        predicate isSource(DataFlow::Node node, TaintKind kind) {
            exists(TaintSource source |
                this.isSource(source) and
                node.asCfgNode() = source and
                source.isSourceOf(kind)
            )
        }

        /**
         * Holds if `sink` is a sink of taint of `kind` that is relevant
         * for this configuration.
         */
        predicate isSink(DataFlow::Node node, TaintKind kind) {
            exists(TaintSink sink |
                this.isSink(sink) and
                node.asCfgNode() = sink and
                sink.sinks(kind)
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
        predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node dest, TaintKind srckind, TaintKind destkind) {
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
            exists(Sanitizer sanitizer |
                this.isSanitizer(sanitizer)
                |
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
        predicate isBarrierEdge(DataFlow::Node src, DataFlow::Node dest, TaintKind srckind, TaintKind destkind) { none() }

        /* Common query API */

        predicate hasFlowPath(PathSource source, PathSink sink) {
            this.(TaintTrackingImplementation).hasFlowPath(source, sink)
        }

        /* Old query API */

        /* deprecated */
        predicate hasFlow(Source source, Sink sink) {
            exists(PathSource psource, PathSink psink |
                this.hasFlowPath(psource, psink) and
                source = psource.getNode().asCfgNode() and
                sink = psink.getNode().asCfgNode()
            )
        }

        /* New query API */

        predicate hasSimpleFlow(DataFlow::Node source, DataFlow::Node sink) {
            exists(PathSource psource, PathSink psink |
                this.hasFlowPath(psource, psink) and
                source = psource.getNode() and
                sink = psink.getNode()
            )
        }

    }

}
