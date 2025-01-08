/**
 * Provides a taint-tracking configuration for detecting "XML External Entity (XXE)" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `Configuration` is needed, otherwise
 * `XxeCustomizations` should be imported instead.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import XxeCustomizations::Xxe

private module XxeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/** Global taint-tracking for detecting "XML External Entity (XXE)" vulnerabilities. */
module XxeFlow = TaintTracking::Global<XxeConfig>;
