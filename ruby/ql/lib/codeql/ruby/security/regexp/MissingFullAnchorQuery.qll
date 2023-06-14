/**
 * Provides a taint tracking configuration for reasoning about
 * missing full-anchored regular expressions.
 *
 * Note, for performance reasons: only import this file if
 * `MissingFullAnchor::Configuration` is needed, otherwise
 * `MissingFullAnchorCustomizations` should be imported instead.
 */

import ruby
import codeql.ruby.TaintTracking
import MissingFullAnchorCustomizations::MissingFullAnchor

/**
 * A taint tracking configuration for reasoning about
 * missing full-anchored regular expressions.
 */
module ConfigurationInst = TaintTracking::Global<ConfigurationImpl>;

private module ConfigurationImpl implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}
