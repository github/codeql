/**
 * Provides a taint-tracking configuration for reasoning about hard-coded data
 * being interpreted as code.
 *
 * Note, for performance reasons: only import this file if
 * `HardcodedDataInterpretedAsCode::Configuration` is needed,
 * otherwise `HardcodedDataInterpretedAsCodeCustomizations` should be
 * imported instead.
 */

import javascript
import HardcodedDataInterpretedAsCodeCustomizations::HardcodedDataInterpretedAsCode

/**
 * A taint-tracking configuration for reasoning about hard-coded data
 * being interpreted as code
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "HardcodedDataInterpretedAsCode" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel lbl) {
    source.(Source).getLabel() = lbl
  }

  override predicate isSink(DataFlow::Node nd, DataFlow::FlowLabel lbl) {
    nd.(Sink).getLabel() = lbl
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}
