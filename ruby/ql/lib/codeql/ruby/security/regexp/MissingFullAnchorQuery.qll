/**
 * Provides a taint tracking configuration for reasoning about
 * missing full-anchored regular expressions.
 *
 * Note, for performance reasons: only import this file if
 * `MissingFullAnchorFlow` is needed, otherwise
 * `MissingFullAnchorCustomizations` should be imported instead.
 */

import ruby
import codeql.ruby.TaintTracking
import MissingFullAnchorCustomizations::MissingFullAnchor

private module MissingFullAnchorConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * Taint-tracking for reasoning about missing full-anchored regular expressions.
 */
module MissingFullAnchorFlow = TaintTracking::Global<MissingFullAnchorConfig>;
