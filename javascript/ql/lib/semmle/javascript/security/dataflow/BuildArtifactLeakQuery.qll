/**
 * Provides a dataflow tracking configuration for reasoning about
 * storage of sensitive information in build artifact.
 *
 * Note, for performance reasons: only import this file if
 * `CleartextLogging::Configuration` is needed, otherwise
 * `CleartextLoggingCustomizations` should be imported instead.
 */

import javascript
import BuildArtifactLeakCustomizations::BuildArtifactLeak
import CleartextLoggingCustomizations::CleartextLogging as CleartextLogging

/**
 * A taint tracking configuration for storage of sensitive information in build artifact.
 */
module BuildArtifactLeakConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof CleartextLogging::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof CleartextLogging::Barrier }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    CleartextLogging::isAdditionalTaintStep(node1, node2)
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet contents) {
    // All properties of a leaked object are themselves leaked.
    contents = DataFlow::ContentSet::anyProperty() and
    isSink(node)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint tracking flow for storage of sensitive information in build artifact.
 */
module BuildArtifactLeakFlow = TaintTracking::Global<BuildArtifactLeakConfig>;
