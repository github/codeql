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
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "BuildArtifactLeak" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel lbl) {
    source.(CleartextLogging::Source).getLabel() = lbl
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel lbl) {
    sink.(Sink).getLabel() = lbl
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof CleartextLogging::Barrier }

  override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
    CleartextLogging::isSanitizerEdge(pred, succ)
  }

  override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node trg) {
    CleartextLogging::isAdditionalTaintStep(src, trg)
  }
}
