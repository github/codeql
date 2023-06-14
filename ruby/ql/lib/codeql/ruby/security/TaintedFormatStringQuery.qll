/**
 * Provides a taint-tracking configuration for reasoning about format
 * injections.
 *
 *
 * Note, for performance reasons: only import this file if
 * `TaintedFormatString::Configuration` is needed, otherwise
 * `TaintedFormatStringCustomizations` should be imported instead.
 */

private import TaintedFormatStringCustomizations::TaintedFormatString

/**
 * A taint-tracking configuration for format injections.
 */
module ConfigurationInst = TaintTracking::Global<ConfigurationImpl>;

private module ConfigurationImpl implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}
